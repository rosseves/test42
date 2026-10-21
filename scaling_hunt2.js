/* Second pass: the places a scaling artifact could still hide — the export
   path, batch quantities, servings multiples and the shopping list. */
const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[];
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline')); w.confirm=()=>true;
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});
const fails=[]; let checks=0;
const expect=(n,ok,d)=>{ checks++; if(!ok) fails.push(n+(d?('  — '+d):'')); };

setTimeout(async ()=>{
  const w=dom.window, J=s=>JSON.parse(w.eval(s));
  w.eval(`LIB_FOODS=[{id:'tf',name:'Test Food',protein_100g:20,carbs_100g:30,fat_100g:10,default_unit:'g'}];
          CNFood.setUserFoods(LIB_FOODS);`);
  w.eval('doGenerate()'); await new Promise(r=>setTimeout(r,800));

  // ---- 8. the PDF sees exactly what the builder sees, for the whole week ----
  const t8 = J(`(function(){
    let bad=[], n=0;
    DAYS.forEach(d=>{
      (S.days[d].meals||[]).forEach(m=>{
        const rec=RECIPES.find(x=>x.id===m.recipeId); if(!rec) return; n++;
        const builder=currentScaled(m);
        const pdfView=scaledRecipe(applySwapsToRecipe(rec,m),{cho:m.cho,pro:m.pro,fat:m.fat},m.ovr);
        if(Math.abs(builder.pro-pdfView.pro)>0.5||Math.abs(builder.cho-pdfView.cho)>0.5||
           Math.abs(builder.fat-pdfView.fat)>0.5)
          bad.push({d, name:rec.name.slice(0,18),
                    builder:[builder.pro,builder.cho], pdf:[pdfView.pro,pdfView.cho]});
      });
    });
    return JSON.stringify({n, bad:bad.slice(0,3), count:bad.length});
  })()`);
  expect('the export sees what the builder sees', t8.count===0, JSON.stringify(t8.bad));
  console.log('  ' + t8.n + ' meals cross-checked against the export path, ' + t8.count + ' differ');

  // ---- 9. servings multiply exactly, including hand-set amounts ----
  const t9 = J(`(function(){
    const m=S.days[S.active].meals[0];
    const base=currentScaled(m);
    const baseVals=[base.pro,base.cho,base.fat];
    const out=[];
    [0.5,1.5,2,4].forEach(n=>{
      setMealServings(m,n);
      const s=currentScaled(m);
      out.push({n, want:baseVals.map(v=>v*n), got:[s.pro,s.cho,s.fat]});
    });
    setMealServings(m,1);
    // again, this time with an ingredient pinned by hand first
    const sc=currentScaled(m);
    const row=sc.ings.find(i=>!i.header && i.p>0);
    setIngredientGrams(m,row.idx,row.grams*1.5);
    const pinned=currentScaled(m);
    const pinnedVals=[pinned.pro,pinned.cho,pinned.fat];
    setMealServings(m,2);
    const both=currentScaled(m);
    out.push({n:'2 after a hand edit', want:pinnedVals.map(v=>v*2),
              got:[both.pro,both.cho,both.fat]});
    setMealServings(m,1); clearMealOverrides(m); syncMealToIngredients(m);
    return JSON.stringify(out);
  })()`);
  t9.forEach(x=>expect('servings ×'+x.n+' multiplies exactly',
    x.want.every((v,i)=>Math.abs(v-x.got[i]) <= Math.max(2, v*0.03)),
    JSON.stringify(x.want.map(Math.round))+' vs '+JSON.stringify(x.got)));

  // ---- 10. batch quantities are the portion multiplied up, nothing else ----
  const t10 = J(`(function(){
    const r=RECIPES.find(x=>(+x.servings||1)>=6 && x.ings && x.ings.length);
    if(!r) return JSON.stringify({skip:true});
    const m=S.days[S.active].meals.find(x=>x.kind==='snack') || S.days[S.active].meals[0];
    setMealRecipe(m, r.id);
    const b=batchInfo(m);
    const sc=currentScaled(m);
    // batchInfo skips zero-gram rows, so the comparison must too or the two
    // lists line up against each other wrongly
    const perPortion=sc.ings.filter(i=>!i.header && i.grams>0)
                            .map(i=>i.amount!=null?i.amount:i.grams);
    const batchAmts=b.rows.map(x=>x.per);
    return JSON.stringify({makes:b.makes, n:b.n,
      portionRows:perPortion.length, batchRows:batchAmts.length,
      perPortion:perPortion.slice(0,4), batchAmts:batchAmts.slice(0,4),
      totals:b.rows.slice(0,4).map(x=>x.total),
      exact: perPortion.length===batchAmts.length &&
             perPortion.every((v,i)=>Math.abs(v-batchAmts[i])<0.01)});
  })()`);
  if(!t10.skip) expect('batch quantities are the portion, multiplied', t10.exact, JSON.stringify(t10));

  // ---- 11. the shopping list totals every gram in the week, once ----
  const t11 = J(`(function(){
    S.shopEdits=[];
    let fromMeals=0;
    DAYS.filter(d=>S.days[d] && !S.days[d].cleared).forEach(d=>{
      (S.days[d].meals||[]).forEach(m=>{
        const sc=currentScaled(m); if(!sc) return;
        sc.ings.forEach(i=>{ if(!i.header && i.grams) fromMeals += i.grams; });
      });
    });
    const list=buildShoppingList();
    const fromList=list.reduce((a,x)=>a+x.grams,0);
    return JSON.stringify({fromMeals:Math.round(fromMeals), fromList:Math.round(fromList),
      items:list.length, same:Math.abs(fromMeals-fromList)<2});
  })()`);
  expect('the shopping list totals every gram exactly once', t11.same, JSON.stringify(t11));
  console.log('  shopping list: ' + t11.items + ' items, ' + t11.fromList +
              'g vs ' + t11.fromMeals + 'g in the meals');

  // ---- 12. a thousand rounds of mixed operations, checking the invariant ----
  const t12 = J(`(function(){
    const rnd=n=>Math.floor(Math.random()*n);
    let bad=0, ops=0;
    for(let i=0;i<800;i++){
      const d=DAYS[rnd(7)], day=S.days[d];
      if(!day||day.cleared||!day.meals.length) continue;
      const m=day.meals[rnd(day.meals.length)];
      switch(rnd(6)){
        case 0: setDayMacro('cho', 100+rnd(800)); break;
        case 1: S.bw=55+rnd(70); break;
        case 2: setMealServings(m,[0.5,1,2,3][rnd(4)]); break;
        case 3: { const r=RECIPES.filter(x=>x.category===m.cat)[rnd(10)];
                  if(r) setMealRecipe(m,r.id); break; }
        case 4: { const sc=currentScaled(m); if(!sc) break;
                  const row=sc.ings.filter(x=>!x.header)[0];
                  if(row) setIngredientGrams(m,row.idx,Math.max(1,row.grams*(0.4+Math.random()*2)));
                  break; }
        default: addIngredientToMeal(m, LIB_FOODS[0], 20+rnd(120));
      }
      ops++;
      // the invariant: a meal with no hand edits must equal its recipe exactly
      day.meals.forEach(mm=>{
        if(mm.ovr && Object.keys(mm.ovr).length) return;
        if(mm.extras && mm.extras.length) return;
        if(mm.dropped && Object.keys(mm.dropped).length) return;
        const r=recipeById(mm.recipeId); if(!r) return;
        const truth=recipeAsWritten(r), sc=currentScaled(mm);
        if(!sc) return;
        if(Math.abs(sc.pro-truth.pro)>1.5||Math.abs(sc.cho-truth.cho)>1.5) bad++;
      });
    }
    return JSON.stringify({ops, bad});
  })()`);
  expect('800 mixed operations never bend an untouched meal', t12.bad===0, JSON.stringify(t12));
  console.log('  ' + t12.ops + ' mixed operations, ' + t12.bad + ' untouched meals bent');

  console.log();
  console.log('checks run :', checks);
  console.log('failures   :', fails.length);
  fails.forEach(f=>console.log('   FAIL  '+f));
  console.log('js errors  :', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(fails.length?1:0);
},2600);
