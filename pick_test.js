const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[];
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline')); w.confirm=()=>true;
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});
setTimeout(async ()=>{
  const w=dom.window, d=w.document, $=s=>d.querySelector(s);
  const say=(a,b)=>console.log(String(a).padEnd(50)+': '+b);
  // one food only, so every search returns exactly one result
  w.eval(`LIB_FOODS=[{id:'uniq',name:'Zanzibar Spice Blend',protein_100g:10,carbs_100g:40,
            fat_100g:12,kcal_100g:308,default_unit:'g'}];
          CNFood.setUserFoods(LIB_FOODS);
          CNLib.sbSearchFoods=async q=>LIB_FOODS.filter(f=>f.name.toLowerCase().includes(q.toLowerCase()));`);
  w.eval('doGenerate()'); await new Promise(r=>setTimeout(r,800));

  const pick = async (label, openFn, inputSel, listSel, check) => {
    w.eval(openFn); await new Promise(r=>setTimeout(r,350));
    const inp=$(inputSel);
    if(!inp){ say(label, 'INPUT MISSING'); return; }
    inp.value='zanzibar';
    inp.dispatchEvent(new w.Event('input',{bubbles:true}));
    await new Promise(r=>setTimeout(r,350));
    const items=[...d.querySelectorAll(listSel)];
    if(!items.length){ say(label, 'no results'); return; }
    // click the ONE result immediately, the case that was failing
    items[0].dispatchEvent(new w.MouseEvent('mousedown',{bubbles:true}));
    await new Promise(r=>setTimeout(r,350));
    say(label, items.length + ' result -> ' + (w.eval(check) ? 'selected' : 'NOT SELECTED'));
  };

  await pick('recipe builder', "openCustomModal()", '#cmSearch', '#cmResults .cmres',
             'CM_PICKED.length > 0');
  w.eval('closeCustomModal()');
  await pick('add an ingredient to a meal',
             "openAddIngredient(S.days[S.active].meals[0], document.querySelector('#meals .addingbtn'))",
             '.swapmenu .imsearch input', '.swapmenu .imopts .swapopt',
             '!!document.querySelector(".swapconfirm")');
  d.querySelectorAll('.swapmenu').forEach(x=>x.remove());

  say('errors', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(0);
},2500);
