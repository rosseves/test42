const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[];
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline')); w.confirm=()=>true;
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});
setTimeout(async ()=>{
  const w=dom.window, d=w.document, $=s=>d.querySelector(s);
  const say=(a,b)=>console.log(String(a).padEnd(50)+': '+b);
  w.eval('doGenerate()'); await new Promise(r=>setTimeout(r,700));

  const check = async (label, id, openFn, fill, readBack) => {
    w.eval(`S.drafts={}; save();`);
    w.eval(openFn); await new Promise(r=>setTimeout(r,300));
    w.eval(fill);
    // switch away, as if to another tab
    Object.defineProperty(d,'visibilityState',{value:'hidden',configurable:true});
    d.dispatchEvent(new w.Event('visibilitychange'));
    await new Promise(r=>setTimeout(r,200));
    const kept = w.eval(`!!(S.drafts||{})['${id}']`);
    // close it and reopen
    w.eval(`document.getElementById('${id}').style.display='none';`);
    w.eval(openFn); await new Promise(r=>setTimeout(r,350));
    const back = w.eval(readBack);
    say(label, (kept?'kept':'NOT KEPT') + ', restored: ' + (back || 'LOST'));
  };

  await check('the recipe builder', 'customModal', 'openCustomModal()',
    `document.getElementById('cmName').value='Half written';
     document.getElementById('cmIngs').value='200g chicken';`,
    `document.getElementById('cmName').value`);
  w.eval('closeCustomModal()');

  await check('adding a food', 'foodModal', 'openFoodModal()',
    `document.getElementById('fmName').value='Zanzibar Blend';
     document.getElementById('fmP').value='12';`,
    `document.getElementById('fmName').value`);
  w.eval('closeFoodModal()');

  await check('notes for the chef', 'chefNotesModal',
    `document.getElementById('chefNotesBtn').click()`,
    `document.getElementById('chefNotes').value='No shellfish at all';`,
    `document.getElementById('chefNotes').value`);
  w.eval(`document.getElementById('chefNotesModal').style.display='none';`);

  // nothing kept when nothing typed
  w.eval(`S.drafts={}; save(); openFoodModal();`);
  await new Promise(r=>setTimeout(r,250));
  w.eval('captureAllDrafts()');
  say('an untouched screen leaves no draft', w.eval('Object.keys(S.drafts||{}).length') === 0 ? 'yes' : 'NO');

  // saving clears it
  w.eval(`S.drafts={foodModal:{fmName:'x'}}; save();
          if(S.drafts) { delete S.drafts.foodModal; save(); }`);
  say('saving clears the draft', w.eval('!!(S.drafts||{}).foodModal') ? 'NO' : 'yes');
  say('errors', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(0);
},2500);
