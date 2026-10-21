const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[];
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline')); w.confirm=()=>true;
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});
setTimeout(async ()=>{
  const w=dom.window, d=w.document, $=s=>d.querySelector(s);
  const say=(a,b)=>console.log(String(a).padEnd(50)+': '+b);
  w.eval('doGenerate()'); await new Promise(r=>setTimeout(r,800));
  $('#shopBtn').click(); await new Promise(r=>setTimeout(r,500));
  say('screen opens', $('#shopModal').style.display!=='none' ? 'yes':'NO');
  const rows=[...d.querySelectorAll('.shrow')];
  say('items listed', rows.length);
  say('grouped by aisle', [...d.querySelectorAll('.shhead')].map(x=>x.textContent).join(' | '));
  // duplicates?
  const names=rows.map(r=>r.querySelector('.shn').childNodes[0].textContent.trim().toLowerCase());
  const dupes=names.filter((n,i)=>names.indexOf(n)!==i);
  say('duplicate lines', dupes.length ? dupes.join(', ') : 'none');
  say('a sample row', rows[0].querySelector('.shn').textContent.replace(/\s+/g,' ').slice(0,52));

  // edit a quantity
  const inp=rows[0].querySelector('input');
  const was=inp.value;
  inp.value='1234'; inp.dispatchEvent(new w.Event('change',{bubbles:true}));
  await new Promise(r=>setTimeout(r,400));
  const after=[...d.querySelectorAll('.shrow')][0];
  say('editing an amount sticks', after.querySelector('input').value + '  (was ' + was + ')');
  say('  and is marked as edited', after.classList.contains('edited') ? 'yes':'no');

  // add something
  $('#shAddName').value='Tin foil'; $('#shAddQty').value='1';
  $('#shAdd').click(); await new Promise(r=>setTimeout(r,400));
  say('adding an item', [...d.querySelectorAll('.shrow .shn')].some(x=>/Tin foil/.test(x.textContent))?'yes':'NO');

  // remove one
  const before=d.querySelectorAll('.shrow').length;
  d.querySelector('.shrow .shx').click(); await new Promise(r=>setTimeout(r,400));
  say('removing one', before + ' -> ' + d.querySelectorAll('.shrow').length);

  // a cleared day contributes nothing
  w.eval(`clearDay('Tue')`); await new Promise(r=>setTimeout(r,400));
  w.eval('renderShopping()'); await new Promise(r=>setTimeout(r,300));
  say('after clearing Tuesday', d.querySelectorAll('.shrow').length + ' items');

  $('#shReset').click(); await new Promise(r=>setTimeout(r,400));
  say('rebuild clears the edits', w.eval('(S.shopEdits||[]).length') + ' edits left');
  say('errors', errs.length?errs.slice(0,3).join(' | '):'none');
  process.exit(0);
},2500);
