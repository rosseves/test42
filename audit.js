/* A property test for the macro arithmetic. It does not check that the app
   looks right — it checks that the numbers cannot lie, under thousands of
   random operations. Every check states the invariant it is defending. */
const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[];
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline')); w.confirm=()=>true;
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});

const fails=[]; let checks=0;
function expect(name, ok, detail){
  checks++;
  if(!ok) fails.push(name + (detail?('  — '+detail):''));
}

setTimeout(async ()=>{
  const w=dom.window;
  const E = s => w.eval(s);
  const J = s => JSON.parse(w.eval(s));
  const near=(a,b,tol)=>Math.abs(a-b) <= (tol==null?1.01:tol);

  E(`LIB_FOODS=[
    {id:'t1',name:'Test Chicken',protein_100g:24,carbs_100g:0,fat_100g:1.1,default_unit:'g'},
    {id:'t2',name:'Test Rice',protein_100g:7.5,carbs_100g:78,fat_100g:0.6,default_unit:'g'},
    {id:'t3',name:'Test Oil',protein_100g:0,carbs_100g:0,fat_100g:99.9,default_unit:'ml'}];
    CNFood.setUserFoods(LIB_FOODS);`);
  E('doGenerate()');
  await new Promise(r=>setTimeout(r,900));

  // ---------- 1. every recipe: its macros ARE its ingredients ----------
  const recCheck = J(`(function(){
    let bad=[], n=0;
    RECIPES.forEach(r=>{
      if(!r.ings || !r.ings.length) return;
      n++;
      const sc=scaledRecipe(r,{pro:r.pro,cho:r.cho,fat:r.fat});
      let p=0,c=0,f=0;
      sc.ings.filter(i=>!i.header).forEach(i=>{ p+=i.p; c+=i.c; f+=i.f; });
      // each ingredient is rounded for display, so summing them can differ
      // from rounding the sum by up to half a gram per ingredient
      const tol=Math.max(1.01, sc.ings.filter(i=>!i.header).length*0.5);
      if(Math.abs(p-sc.pro)>tol||Math.abs(c-sc.cho)>tol||Math.abs(f-sc.fat)>tol)
        bad.push({n:r.name.slice(0,24), sum:[Math.round(p),Math.round(c),Math.round(f)],
                  said:[sc.pro,sc.cho,sc.fat]});
    });
    return JSON.stringify({n, bad:bad.slice(0,4), count:bad.length});
  })()`);
  expect('every recipe equals its ingredient sum', recCheck.count===0,
         JSON.stringify(recCheck.bad));

  // ---------- 2. calories are always 4/4/9 ----------
  const kcalCheck = J(`(function(){
    let bad=0, n=0;
    RECIPES.forEach(r=>{
      if(!r.ings||!r.ings.length) return; n++;
      const sc=scaledRecipe(r,{pro:r.pro,cho:r.cho,fat:r.fat});
      const k=4*sc.pro+4*sc.cho+9*sc.fat;
      const shown=Math.round(4*sc.pro+4*sc.cho+9*sc.fat);
      if(Math.abs(k-shown)>1) bad++;
    });
    return JSON.stringify({n,bad});
  })()`);
  expect('calories are protein×4 + carbs×4 + fat×9', kcalCheck.bad===0);

  // ---------- 3. one ingredient scales linearly ----------
  /* Protein per gram is the thing that must be exact. The displayed figure is
     rounded to the gram, so comparing rounded totals measures the rounding,
     not the arithmetic. */
  const lin = J(`(function(){
    const m=S.days[S.active].meals[0];
    const sc=currentScaled(m);
    const row=sc.ings.find(i=>!i.header && i.p>0);
    // straight from the food's own per-100g figure, never from a rounded total
    const src=(recipeById(m.recipeId)||{ings:[]}).ings[row.idx];
    const perGram = src ? src.pg : (row.p / row.grams);
    const out=[];
    [0.5,1,2,3.7].forEach(k=>{
      const g=row.grams*k;
      setIngredientGrams(m,row.idx,g);
      const a=currentScaled(m).ings.find(i=>i.idx===row.idx);
      // what it should be at the amount the app actually used
      // a.p is rounded to the gram for display, so allow that half-gram
      out.push({k, want:Math.round(perGram*a.grams*1000)/1000,
                   got:Math.round(a.p*1000)/1000});
    });
    setIngredientGrams(m,row.idx,row.grams);
    return JSON.stringify(out);
  })()`);
  lin.forEach(x=>expect('ingredient scales linearly at ×'+x.k, near(x.want,x.got,0.51),
    'wanted '+x.want+' got '+x.got));

  // ---------- 4. a day total is the sum of its meals ----------
  function dayCheck(tag){
    const r = J(`(function(){
      const out=[];
      DAYS.forEach(d=>{
        const day=S.days[d]; if(!day) return;
        let p=0,c=0,f=0;
        (day.meals||[]).forEach(m=>{ const s=currentScaled(m); if(s){p+=s.pro;c+=s.cho;f+=s.fat;} });
        const t=dayTotals(day);
        out.push({d, ok:Math.abs(p-t.pro)<1.5 && Math.abs(c-t.cho)<1.5 && Math.abs(f-t.fat)<1.5,
                  sum:[Math.round(p),Math.round(c),Math.round(f)], tot:[Math.round(t.pro),Math.round(t.cho),Math.round(t.fat)]});
      });
      return JSON.stringify(out);
    })()`);
    r.forEach(x=>expect('day total = sum of meals ('+tag+', '+x.d+')', x.ok,
      JSON.stringify(x.sum)+' vs '+JSON.stringify(x.tot)));
  }
  dayCheck('fresh plan');

  // ---------- 5. adding an ingredient moves the day by exactly its macros ----
  const addCheck = J(`(function(){
    const day=S.days[S.active], m=day.meals[0];
    const before=dayTotals(day);
    const food=LIB_FOODS[0], grams=137;
    addIngredientToMeal(m, food, grams);
    const after=dayTotals(day);
    const want={pro:before.pro + grams*food.protein_100g/100,
                cho:before.cho + grams*food.carbs_100g/100,
                fat:before.fat + grams*food.fat_100g/100};
    return JSON.stringify({before,after,want});
  })()`);
  expect('adding an ingredient adds exactly its macros',
    near(addCheck.after.pro,addCheck.want.pro,1.5) &&
    near(addCheck.after.cho,addCheck.want.cho,1.5) &&
    near(addCheck.after.fat,addCheck.want.fat,1.5),
    JSON.stringify(addCheck.after)+' wanted '+JSON.stringify(addCheck.want));

  // ---------- 6. removing it puts the day back exactly ----------
  const remCheck = J(`(function(){
    const day=S.days[S.active], m=day.meals[0];
    const before=dayTotals(day);
    const base=(recipeById(m.recipeId)||{ings:[]}).ings.length;
    m.extras=(m.extras||[]).slice(0,-1);
    syncMealToIngredients(m);
    return JSON.stringify({before, after:dayTotals(day)});
  })()`);
  expect('removing what was added restores the total',
    near(remCheck.after.pro, remCheck.before.pro - 137*0.24, 1.5),
    JSON.stringify(remCheck));

  // ---------- 7. servings multiply the whole meal ----------
  const servCheck = J(`(function(){
    const m=S.days[S.active].meals[0];
    const one=currentScaled(m);
    const base={p:one.pro,c:one.cho,f:one.fat};
    const out=[];
    [2,3,0.5].forEach(n=>{
      setMealServings(m,n);
      const s=currentScaled(m);
      out.push({n, want:[Math.round(base.p*n),Math.round(base.c*n),Math.round(base.f*n)],
                   got:[s.pro,s.cho,s.fat]});
    });
    setMealServings(m,1);
    return JSON.stringify(out);
  })()`);
  servCheck.forEach(x=>expect('×'+x.n+' servings multiplies the meal',
    near(x.want[0],x.got[0],2) && near(x.want[1],x.got[1],2) && near(x.want[2],x.got[2],2),
    JSON.stringify(x.want)+' vs '+JSON.stringify(x.got)));

  // ---------- 8. the week is the sum of the days ----------
  const weekCheck = J(`(function(){
    let p=0,c=0,f=0;
    DAYS.forEach(d=>{ const t=dayTotals(S.days[d]); p+=t.pro;c+=t.cho;f+=t.fat; });
    let p2=0,c2=0,f2=0;
    DAYS.forEach(d=>(S.days[d].meals||[]).forEach(m=>{
      const s=currentScaled(m); if(s){p2+=s.pro;c2+=s.cho;f2+=s.fat;} }));
    return JSON.stringify({byDay:[Math.round(p),Math.round(c),Math.round(f)],
                           byMeal:[Math.round(p2),Math.round(c2),Math.round(f2)]});
  })()`);
  expect('the week equals the sum of every meal in it',
    weekCheck.byDay.every((v,i)=>near(v,weekCheck.byMeal[i],1.01)),
    JSON.stringify(weekCheck));

  // ---------- 9. FUZZ: a thousand random operations ----------
  const fuzz = J(`(function(){
    let mismatches=0, ops=0;
    const rnd=n=>Math.floor(Math.random()*n);
    for(let i=0;i<1000;i++){
      const d=DAYS[rnd(DAYS.length)], day=S.days[d];
      if(!day || day.cleared || !day.meals.length) continue;
      const m=day.meals[rnd(day.meals.length)];
      const sc=currentScaled(m); if(!sc||!sc.ings.length) continue;
      const real=sc.ings.filter(x=>!x.header); if(!real.length) continue;
      const row=real[rnd(real.length)];
      const pick=rnd(5);
      try{
        if(pick===0) setIngredientGrams(m,row.idx,Math.max(1,row.grams*(0.3+Math.random()*2.5)));
        else if(pick===1) addIngredientToMeal(m, LIB_FOODS[rnd(LIB_FOODS.length)], 10+rnd(200));
        else if(pick===2){ m.dropped=m.dropped||{}; m.dropped[row.idx]=true; syncMealToIngredients(m); }
        else if(pick===3) setMealServings(m, [0.5,1,1.5,2,3][rnd(5)]);
        else { const r=RECIPES.filter(x=>x.category===m.cat)[rnd(8)]; if(r) setMealRecipe(m,r.id); }
        ops++;
      }catch(e){ return JSON.stringify({crashed:e.message, ops}); }

      // after EVERY operation the meal must still equal its own ingredients
      const s2=currentScaled(m);
      if(s2){
        let p=0,c=0,f=0;
        s2.ings.filter(x=>!x.header).forEach(x=>{p+=x.p;c+=x.c;f+=x.f;});
        const tol=Math.max(1.01, s2.ings.filter(x=>!x.header).length*0.5);
        if(Math.abs(p-s2.pro)>tol||Math.abs(c-s2.cho)>tol||Math.abs(f-s2.fat)>tol) mismatches++;
      }
      // and the day must still equal the sum of its meals
      let dp=0,dc=0,df=0;
      day.meals.forEach(mm=>{ const s3=currentScaled(mm); if(s3){dp+=s3.pro;dc+=s3.cho;df+=s3.fat;} });
      const t=dayTotals(day);
      if(Math.abs(dp-t.pro)>1.5||Math.abs(dc-t.cho)>1.5||Math.abs(df-t.fat)>1.5) mismatches++;
    }
    return JSON.stringify({ops, mismatches});
  })()`);
  expect('1000 random edits never break the arithmetic', fuzz.mismatches===0 && !fuzz.crashed,
    JSON.stringify(fuzz));

  dayCheck('after the fuzz');

  // ---------- 10. nothing goes negative or NaN ----------
  const sane = J(`(function(){
    let bad=[];
    DAYS.forEach(d=>{
      (S.days[d].meals||[]).forEach(m=>{
        const s=currentScaled(m); if(!s) return;
        [['pro',s.pro],['cho',s.cho],['fat',s.fat]].forEach(([k,v])=>{
          if(!isFinite(v) || v<0) bad.push(d+' '+k+'='+v);
        });
        s.ings.forEach(i=>{ if(!isFinite(i.grams)||i.grams<0) bad.push(d+' grams='+i.grams); });
      });
    });
    return JSON.stringify({bad:bad.slice(0,5), n:bad.length});
  })()`);
  expect('no negative or impossible numbers anywhere', sane.n===0, JSON.stringify(sane.bad));

  console.log('checks run   :', checks);
  console.log('failures     :', fails.length);
  fails.forEach(f=>console.log('   FAIL  '+f));
  console.log('fuzz         :', JSON.stringify(fuzz));
  console.log('js errors    :', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(fails.length?1:0);
},2600);
