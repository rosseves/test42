const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[]; let confirmed=false;
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline'));
   w.confirm=()=>{ confirmed=true; return false; };   // the user says "no, don't close"
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});
setTimeout(async ()=>{
  const w=dom.window, d=w.document, $=s=>d.querySelector(s);
  const say=(a,b)=>console.log(String(a).padEnd(50)+': '+b);
  w.eval(`LIB_FOODS=[{id:'z',name:'Tuna, tinned in spring water (drained)',
    protein_100g:25,carbs_100g:0,fat_100g:0.6,kcal_100g:108,default_unit:'g'}];
    CNFood.setUserFoods(LIB_FOODS); CNLib.sbSearchFoods=async()=>LIB_FOODS;`);
  w.eval('openCustomModal()'); await new Promise(r=>setTimeout(r,300));

  $('#cmName').value='Tuna Mayo Sandwich';
  $('#cmIngs').value='100g tuna, tinned in spring water (drained)\n2 slices wholemeal bread';
  $('#cmMethod').value='Mix it';

  // a mis-click on the dimmed area
  const ev=new w.MouseEvent('click',{bubbles:true});
  Object.defineProperty(ev,'target',{value:$('#customModal')});
  $('#customModal').dispatchEvent(ev);
  await new Promise(r=>setTimeout(r,250));
  say('a stray click asks first', confirmed ? 'yes' : 'NO — it just closed');
  say('  and the screen stayed open', $('#customModal').style.display!=='none' ? 'yes':'NO');
  say('  the typing is still there', $('#cmName').value || '(gone)');

  // now close it deliberately and reopen
  w.eval('closeCustomModal()'); await new Promise(r=>setTimeout(r,250));
  say('closed deliberately', $('#customModal').style.display==='none' ? 'yes':'no');
  say('  a draft was kept', w.eval('JSON.stringify(Object.keys((S.drafts||{})))'));
  w.eval('openCustomModal()'); await new Promise(r=>setTimeout(r,350));
  say('reopening restores the name', $('#cmName').value || 'LOST');
  say('  and the ingredients', ($('#cmIngs').value||'LOST').split('\n')[0]);
  say('  and the method', $('#cmMethod').value || 'LOST');

  // the search race: click the only result immediately
  const cs=$('#cmSearch');
  cs.value='tuna'; cs.dispatchEvent(new w.Event('input',{bubbles:true}));
  await new Promise(r=>setTimeout(r,400));
  const hits=[...d.querySelectorAll('#cmResults .cmres')];
  say('search found', hits.length + ' result(s)');
  if(hits.length){
    const before=w.eval('CM_PICKED.length');
    hits[0].dispatchEvent(new w.MouseEvent('mousedown',{bubbles:true}));
    await new Promise(r=>setTimeout(r,300));
    say('  picking the only result works', w.eval('CM_PICKED.length') > before ? 'yes' : 'NO');
    say('  what was picked', w.eval('JSON.stringify((CM_PICKED[CM_PICKED.length-1]||{}).name)'));
  }
  say('errors', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(0);
},2500);
