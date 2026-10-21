const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[];
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline')); w.confirm=()=>true;
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});
setTimeout(async ()=>{
  const w=dom.window, d=w.document, $=s=>d.querySelector(s);
  const say=(a,b)=>console.log(String(a).padEnd(52)+': '+b);
  w.eval('openCustomModal()'); await new Promise(r=>setTimeout(r,300));
  $('#cmName').value='Half Written Recipe';
  $('#cmIngs').value='200g chicken breast\n100g rice';
  $('#cmMethod').value='Started writing this';

  // 1. just typing, then waiting — no close, no switch
  ['cmName','cmIngs','cmMethod'].forEach(f=>
    $('#'+f).dispatchEvent(new w.Event('input',{bubbles:true})));
  await new Promise(r=>setTimeout(r,900));
  say('typing alone writes a draft', w.eval('!!(S.drafts||{}).customModal') ? 'yes' : 'NO');

  // 2. switching tabs
  w.eval(`S.drafts={}; save();`);
  Object.defineProperty(d,'visibilityState',{value:'hidden',configurable:true});
  d.dispatchEvent(new w.Event('visibilitychange'));
  await new Promise(r=>setTimeout(r,200));
  say('switching tabs writes a draft', w.eval('!!(S.drafts||{}).customModal') ? 'yes' : 'NO');

  // 3. switching to another program
  w.eval(`S.drafts={}; save();`);
  w.dispatchEvent(new w.Event('blur'));
  await new Promise(r=>setTimeout(r,200));
  say('switching program writes a draft', w.eval('!!(S.drafts||{}).customModal') ? 'yes' : 'NO');

  // 4. the tab being closed outright
  w.eval(`S.drafts={}; save();`);
  w.dispatchEvent(new w.Event('pagehide'));
  await new Promise(r=>setTimeout(r,200));
  say('closing the tab writes a draft', w.eval('!!(S.drafts||{}).customModal') ? 'yes' : 'NO');

  // 5. and it all comes back
  say('  what was kept', w.eval(`JSON.stringify((S.drafts.customModal||{}).cmName)`));
  w.eval(`document.getElementById('customModal').style.display='none';`);
  w.eval('openCustomModal()'); await new Promise(r=>setTimeout(r,350));
  say('reopening restores the name', $('#cmName').value || 'LOST');
  say('  and the ingredients', ($('#cmIngs').value||'LOST').split('\n')[0]);
  say('  and the method', $('#cmMethod').value || 'LOST');

  // 6. nothing is kept when there is nothing to keep
  // wait out any debounce still pending from the restore above
  await new Promise(r=>setTimeout(r,800));
  w.eval(`['cmName','cmIngs','cmMethod'].forEach(f=>document.getElementById(f).value='');
          CM_PICKED=[]; captureCustomDraft();`);
  await new Promise(r=>setTimeout(r,200));
  say('an empty screen leaves no draft', w.eval('!!(S.drafts||{}).customModal') ? 'NO' : 'yes');

  // 7. a closed screen is not captured over
  w.eval(`openCustomModal(); document.getElementById('cmName').value='Keep me';
          captureCustomDraft();
          document.getElementById('customModal').style.display='none';
          document.getElementById('cmName').value='';
          captureCustomDraft();`);
  say('a closed screen does not wipe the draft',
      w.eval(`((S.drafts||{}).customModal||{}).cmName === 'Keep me'`) ? 'yes' : 'NO');
  say('errors', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(0);
},2500);
