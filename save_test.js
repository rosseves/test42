const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[];
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline')); w.confirm=()=>true;
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});
setTimeout(async ()=>{
  const w=dom.window, d=w.document, $=s=>d.querySelector(s);
  const say=(a,b)=>console.log(String(a).padEnd(52)+': '+b);
  w.eval('doGenerate()'); await new Promise(r=>setTimeout(r,800));
  const mealsBefore = w.eval('S.days[S.active].meals.length');
  const macrosBefore = w.eval('JSON.stringify(S.days[S.active].meals.map(m=>[m.pro,m.cho,m.fat]))');
  say('meals before', mealsBefore);

  // THE REPORTED SEQUENCE: build a meal by hand, save it
  w.eval(`
    document.getElementById('cmName').value='Hand Built Meal';
    document.getElementById('cmIngs').value='150g chicken breast\\n75g basmati rice\\n80g broccoli';
    document.getElementById('cmMethod').value='Cook it';
    document.getElementById('cmCat').value='lunchdinner';
    saveCustomMeal();
  `);
  await new Promise(r=>setTimeout(r,600));
  say('meals after saving a hand-built one', w.eval('S.days[S.active].meals.length') +
      '  (was ' + mealsBefore + ')');
  say('  nothing was wiped', w.eval('S.days[S.active].meals.length') > mealsBefore ? 'yes' : 'MEALS LOST');
  say('  the new one is there', w.eval(`S.days[S.active].meals.some(m=>/Hand Built/.test(m.name))`)?'yes':'NO');
  const after = w.eval('JSON.stringify(S.days[S.active].meals.map(m=>[m.pro,m.cho,m.fat]))');
  say('  existing meals kept their macros',
      JSON.parse(after).slice(0,mealsBefore).every((x,i)=>x[0]>0||x[1]>0) ? 'yes' : 'ZEROED OUT');
  say('  macros equal the ingredients', w.eval(`
    S.days[S.active].meals.every(m=>{ const s=currentScaled(m); if(!s) return true;
      return Math.abs(s.pro-m.pro)<2 && Math.abs(s.cho-m.cho)<2; })`) ? 'yes':'NO');

  // storage full
  // jsdom keeps setItem on the Storage prototype, so it has to be replaced there
  w.eval(`window.__realSet = Object.getPrototypeOf(localStorage).setItem;
          Object.getPrototypeOf(localStorage).setItem = function(k,v){
            if(/closeNutritionPlan/.test(k)){ const e=new Error('QuotaExceededError');
              e.name='QuotaExceededError'; throw e; }
            return window.__realSet.call(this,k,v); };`);
  const ok = w.eval('save()');
  await new Promise(r=>setTimeout(r,300));
  say('a failed save reports false', ok===false ? 'yes' : 'NO — it claimed success');
  say('  and tells the user', /not being saved/.test($('#toast').textContent) ? 'yes' : 'NO');
  w.eval('Object.getPrototypeOf(localStorage).setItem = window.__realSet;');

  // a corrupt main copy falls back to the spare
  w.eval(`save();
          const good = localStorage.getItem('${''}'+LSKEY);
          localStorage.setItem(LSKEY, '{"broken":');`);
  const loaded = w.eval('(function(){ const s=load(); return s ? (s.days ? Object.keys(s.days).length : 0) : -1; })()');
  say('a corrupt save falls back to the backup', loaded > 0 ? 'yes, ' + loaded + ' days recovered' : 'NO — everything lost');
  say('errors', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(0);
},2500);
