const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const errs=[];
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('offline')); w.confirm=()=>true;
   w.alert=()=>{}; w.scrollTo=()=>{}; w.addEventListener('error',e=>errs.push(e.message)); }});
setTimeout(async ()=>{
  const w=dom.window, d=w.document;
  const say=(a,b)=>console.log(String(a).padEnd(38)+': '+b);
  const ids=['managePlayers','openRecipeDb','openSuppDb','exportBtn','exportPhoneBtn',
             'exportPlayerBtn','chefNotesBtn','recEditModal','recipeDbModal','suppModal',
             'playerModal','bkReplace','reArchive','rdbExportR','rdbExportF',
             'shopModal','shopBtn','addMealModal','addMealBtn'];
  const missing=ids.filter(i=>!d.getElementById(i));
  say('key controls present', missing.length? 'MISSING: '+missing.join(', ') : 'all '+ids.length);
  w.eval('doGenerate()'); await new Promise(r=>setTimeout(r,800));
  say('plan generates', w.eval('S.generated')?'yes':'NO');
  say('meals rendered', d.querySelectorAll('#meals .meal').length);
  say('method boxes', d.querySelectorAll('#meals .methodbox').length);
  say('copy buttons', d.querySelectorAll('#meals .copybtn').length);
  say('errors', errs.length? errs.slice(0,4).join(' | ') : 'none');
  process.exit(0);
},2500);
