/* Hunts for any remaining scaling. The principle under test: a recipe in a
   plan must deliver exactly what its ingredients say, no matter what target
   it is placed against, what the player weighs, or what day type it sits in.
   If anything still scales, these will catch it. */
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

  // ---- 1. the same recipe against wildly different targets ----
  const t1 = J(`(function(){
    const r=RECIPES.find(x=>x.ings && x.ings.length>3);
    const truth=recipeAsWritten(r);
    const out=[];
    [[10,10,5],[180,540,110],[400,900,200],[1,1,1],[0,0,0]].forEach(t=>{
      const sc=scaledRecipe(r,{pro:t[0],cho:t[1],fat:t[2]});
      out.push({target:t, got:[sc.pro,sc.cho,sc.fat]});
    });
    return JSON.stringify({name:r.name, truth:[truth.pro,truth.cho,truth.fat], out});
  })()`);
  const allSame = t1.out.every(o=>o.got.every((v,i)=>Math.abs(v-t1.truth[i])<=1.5));
  expect('a recipe ignores the target it is placed against', allSame,
         JSON.stringify(t1.out.map(o=>o.got)));
  console.log('  ' + t1.name.slice(0,34) + '  truth ' + JSON.stringify(t1.truth));
  t1.out.forEach(o=>console.log('     target ' + JSON.stringify(o.target).padEnd(18) +
    ' -> ' + JSON.stringify(o.got)));

  // ---- 2. every recipe, every slot target ----
  const t2 = J(`(function(){
    let bad=[], n=0;
    RECIPES.filter(r=>r.ings && r.ings.length).forEach(r=>{
      const truth=recipeAsWritten(r);
      [[20,30,10],[60,140,30],[200,600,120]].forEach(t=>{
        n++;
        const sc=scaledRecipe(r,{pro:t[0],cho:t[1],fat:t[2]});
        if(Math.abs(sc.pro-truth.pro)>1.5||Math.abs(sc.cho-truth.cho)>1.5||Math.abs(sc.fat-truth.fat)>1.5)
          bad.push({r:r.name.slice(0,22), t, truth:[truth.pro,truth.cho,truth.fat],
                    got:[sc.pro,sc.cho,sc.fat]});
      });
    });
    return JSON.stringify({n, bad:bad.slice(0,3), count:bad.length});
  })()`);
  expect('every recipe at every target is unchanged', t2.count===0, JSON.stringify(t2.bad));
  console.log('  ' + t2.n + ' recipe/target combinations checked, ' + t2.count + ' moved');

  // ---- 3. changing a day target must not move a single meal ----
  w.eval('doGenerate()'); await new Promise(r=>setTimeout(r,800));
  const t3 = J(`(function(){
    const before=S.days[S.active].meals.map(m=>{const s=currentScaled(m);return [s.pro,s.cho,s.fat];});
    setDayMacro('cho', 900);
    setDayMacro('pro', 50);
    setDayMacro('fat', 200);
    const after=S.days[S.active].meals.map(m=>{const s=currentScaled(m);return [s.pro,s.cho,s.fat];});
    return JSON.stringify({before, after,
      same:before.every((b,i)=>b.every((v,k)=>Math.abs(v-after[i][k])<=1.5))});
  })()`);
  expect('moving the day target leaves the meals alone', t3.same,
         JSON.stringify(t3.before[0]) + ' -> ' + JSON.stringify(t3.after[0]));

  // ---- 4. changing bodyweight must not move a meal ----
  const t4 = J(`(function(){
    const before=S.days[S.active].meals.map(m=>{const s=currentScaled(m);return s.cho;});
    S.bw=140; renderMeals();
    const after=S.days[S.active].meals.map(m=>{const s=currentScaled(m);return s.cho;});
    S.bw=92;
    return JSON.stringify({same:before.every((b,i)=>Math.abs(b-after[i])<=1.5), before, after});
  })()`);
  expect('changing bodyweight leaves the meals alone', t4.same, JSON.stringify(t4));

  // ---- 5. switching day type must not move existing meals ----
  const t5 = J(`(function(){
    const d=S.active;
    const before=S.days[d].meals.map(m=>{const s=currentScaled(m);return [s.pro,s.cho];});
    S.dayTypes[d]='Game Day';
    S.days[d].type='Game Day';
    renderMeals();
    const after=S.days[d].meals.map(m=>{const s=currentScaled(m);return [s.pro,s.cho];});
    return JSON.stringify({same:before.every((b,i)=>b.every((v,k)=>Math.abs(v-after[i][k])<=1.5))});
  })()`);
  expect('switching day type leaves existing meals alone', t5.same);

  // ---- 6. a freshly generated plan: every meal equals its recipe ----
  const t6 = J(`(function(){
    let bad=[], n=0;
    for(let round=0; round<25; round++){
      S.global={pro:60+Math.floor(Math.random()*250),
                cho:150+Math.floor(Math.random()*600),
                fat:40+Math.floor(Math.random()*140)};
      S.bw=60+Math.floor(Math.random()*60);
      S.dayTargets={}; DAYS.forEach(d=>S.dayTargets[d]={pro:0,cho:0,fat:0});
      doGenerate();
      DAYS.forEach(d=>{
        (S.days[d].meals||[]).forEach(m=>{
          const r=recipeById(m.recipeId); if(!r) return;
          n++;
          const truth=recipeAsWritten(r);
          const sc=currentScaled(m);
          if(Math.abs(sc.pro-truth.pro)>1.5||Math.abs(sc.cho-truth.cho)>1.5||Math.abs(sc.fat-truth.fat)>1.5)
            bad.push({d, r:r.name.slice(0,20), truth:[truth.pro,truth.cho,truth.fat],
                      got:[sc.pro,sc.cho,sc.fat]});
        });
      });
    }
    return JSON.stringify({n, bad:bad.slice(0,3), count:bad.length});
  })()`);
  expect('25 plans at random targets: no meal was altered', t6.count===0,
         JSON.stringify(t6.bad));
  console.log('  ' + t6.n + ' meals across 25 generated plans, ' + t6.count + ' altered');

  // ---- 7. extremes ----
  const t7 = J(`(function(){
    let bad=0, n=0;
    [[1,1,1],[5,5,2],[600,1500,300],[0,0,0]].forEach(t=>{
      S.global={pro:t[0],cho:t[1],fat:t[2]};
      S.dayTargets={}; DAYS.forEach(d=>S.dayTargets[d]={pro:0,cho:0,fat:0});
      doGenerate();
      DAYS.forEach(d=>(S.days[d].meals||[]).forEach(m=>{
        const r=recipeById(m.recipeId); if(!r) return; n++;
        const truth=recipeAsWritten(r), sc=currentScaled(m);
        if(Math.abs(sc.cho-truth.cho)>1.5) bad++;
      }));
    });
    return JSON.stringify({n,bad});
  })()`);
  expect('absurd targets do not bend anything', t7.bad===0, JSON.stringify(t7));
  console.log('  ' + t7.n + ' meals at extreme targets, ' + t7.bad + ' altered');

  console.log();
  console.log('checks run :', checks);
  console.log('failures   :', fails.length);
  fails.forEach(f=>console.log('   FAIL  '+f));
  console.log('js errors  :', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(fails.length?1:0);
},2600);
