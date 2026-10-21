/* ============ IN-BROWSER FOOD ENGINE ============
   Mirrors the Python build script so recipes added to the Google Sheet are costed
   live in the app: ingredient text -> grams + true per-gram macros (McCance 2021). */
const FR = window.__FOOD_RULES__;
const FRAC_J = {'½':0.5,'¼':0.25,'¾':0.75,'⅓':1/3,'⅔':2/3,'⅛':0.125,'⅜':0.375,'⅝':0.625,'⅞':0.875};
const NOISE_J = new Set(FR.noise);
const NEG_RE = new RegExp(FR.negligible, 'i');
const SECTION_RE_J = new RegExp(FR.sectionRe, 'i');
const STALKY_J = new RegExp(FR.stalky, 'i');

function deacc(s){ return s.normalize('NFKD').replace(/[\u0300-\u036f]/g,''); }
function singJ(t){
  if(t.length>4 && t.endsWith('ies')) return t.slice(0,-3)+'i';
  if(t.length>3 && t.endsWith('y'))   return t.slice(0,-1)+'i';
  if(t.length>4 && t.endsWith('es') && !t.endsWith('ses')) return t.slice(0,-2);
  if(t.length>3 && t.endsWith('s') && !t.endsWith('ss')) return t.slice(0,-1);
  return t;
}
function toksJ(s){
  s=deacc(String(s).toLowerCase()).replace(/\([^)]*\)/g,' ').replace(/[^a-z ]/g,' ');
  return s.split(/\s+/).filter(t=>t && t.length>1 && !NOISE_J.has(t)).map(singJ);
}
// --- McCance table: "name|p|c|f" per line, parsed once ---
let MCC=null;
function mcc(){
  if(MCC) return MCC;
  MCC=[];
  const lines=(window.__FOOD_TABLE__||'').split('\n');
  for(const ln of lines){
    if(!ln) continue;
    const p=ln.split('|'); if(p.length<4) continue;
    const t=toksJ(p[0]); if(!t.length) continue;
    MCC.push({name:p[0], tokens:new Set(t), first:t[0], n:t.length,
              p:+p[1], c:+p[2], f:+p[3]});
  }
  return MCC;
}
function mccLookup(name){
  const q=toksJ(name); if(!q.length) return null;
  const qs=new Set(q), head=q[0], tail=q[q.length-1];
  const low=deacc(String(name).toLowerCase());
  let best=null, bestS=-1e9;
  for(const food of mcc()){
    if(!qs.has(food.first)) continue;              // principal noun must be named
    let inter=0; for(const t of food.tokens) if(qs.has(t)) inter++;
    if(!inter) continue;
    let s=inter*3;
    if(food.first===tail) s+=6; else if(food.first===head) s+=3;
    if(food.tokens.has(tail)) s+=3;
    s-=Math.max(0,food.n-inter)*0.9;
    s-=Math.abs(food.n-q.length)*0.3;
    const fl=food.name.toLowerCase();
    for(const w of FR.formWords) if(fl.includes(w) && !low.includes(w)) s-=7;
    if(fl.includes('raw')||fl.includes('fresh')) s+=2;
    if(s>bestS){ bestS=s; best=food; }
  }
  if(best && bestS>=5) return {p:best.p/100,c:best.c/100,f:best.f/100,src:'mccance:'+best.name};
  return null;
}
// --- curated layers ---
function wbJ(k){ return new RegExp('(?:^|[^a-z])'+k.replace(/[.*+?^${}()|[\]\\]/g,'\\$&')+'(?:e?s)?(?![a-z])','i'); }
const WB_CACHE={};
function wbTest(k,low){ (WB_CACHE[k]=WB_CACHE[k]||wbJ(k)); return WB_CACHE[k].test(low); }
function matchFoodJ(name){
  const low=deacc(String(name).toLowerCase());
  for(const [pat,m] of FR.overrides){ if(new RegExp(pat,'i').test(low)) return [m,pat]; }
  let best=null, bestKey=null, bestPos=1e9, bestLen=0;
  for(const [keys,m] of FR.foods){
    for(const k of keys){
      const re=(WB_CACHE[k]=WB_CACHE[k]||wbJ(k));
      const mm=re.exec(low);
      if(mm){
        const pos=mm.index;
        if(pos<bestPos || (pos===bestPos && k.length>bestLen)){ best=m; bestKey=k; bestPos=pos; bestLen=k.length; }
      }
    }
  }
  return best? [best,bestKey] : [null,null];
}
function isFixedJ(name){
  const low=deacc(String(name).toLowerCase());
  for(const w of FR.fixedWords) if(wbTest(w,low)) return true;
  return false;
}
function pieceGramsJ(name){
  const low=deacc(String(name).toLowerCase());
  if(STALKY_J.test(low)){
    if(low.includes('asparagus')) return 16;
    if(low.includes('celery')) return 40;
    if(low.includes('broccoli')||low.includes('tenderstem')) return 16;
    if(low.includes('lemongrass')) return 20;
    return 15;
  }
  let best=null;
  for(const k in FR.piece) if(low.includes(deacc(k)) && (!best||k.length>best[0])) best=[k.length,FR.piece[k]];
  return best? best[1] : null;
}
function spoonGramsJ(name,kind){
  const low=deacc(String(name).toLowerCase());
  for(const k in FR.spoon) if(low.includes(deacc(k))) return kind==='tbsp'? FR.spoon[k] : FR.spoon[k]/3;
  return kind==='tbsp'? FR.const.tbsp : FR.const.tsp;
}
function defaultGramsJ(name){
  const low=deacc(String(name).toLowerCase());
  if(/(rosemary|thyme|basil|parsley|coriander|mint|dill|oregano|sage|chive|flakes?|spice|powder|paprika|cumin|cinnamon|nutmeg|seasoning|herbs?)/.test(low)) return 2;
  if(/(leaf|leaves|salad|rocket|spinach|watercress)/.test(low)) return 30;
  if(/(sauce|puree|paste|dressing|marinade|jus|glaze|syrup|honey|oil)/.test(low)) return 15;
  const pg=pieceGramsJ(low); return pg!=null? pg : 40;
}
function juiceFromJ(text){
  const low=deacc(String(text).toLowerCase());
  if(!low.includes('juice')) return null;
  const m=low.match(/(\d+(?:\.\d+)?|½|¼|¾)\s*(?:large|medium|small)?\s*(orange|lemon|lime|grapefruit)/);
  if(!m) return null;
  const q=FRAC_J[m[1]]!=null? FRAC_J[m[1]] : parseFloat(m[1]);
  return q*FR.juiceYield[m[2]];
}
function parseAmountJ(text){
  const orig=String(text).trim();
  let t=deacc(orig).replace(/[\u2013\u2014\u2212]/g,'-').replace(/^~\s*/,'').trim();
  let val=null, m;
  if((m=t.match(/^(\d+(?:\.\d+)?)\s*-\s*(\d+(?:\.\d+)?)\s*(.*)$/))){ val=(+m[1]+ +m[2])/2; t=m[3]; }
  if(val==null && (m=orig.match(/^(\d+)\s*([½¼¾⅓⅔⅛])\s*(.*)$/))){ val=+m[1]+FRAC_J[m[2]]; t=m[3]; }
  if(val==null && (m=orig.match(/^([½¼¾⅓⅔⅛])\s*(.*)$/))){ val=FRAC_J[m[1]]; t=m[2]; }
  if(val==null && (m=t.match(/^(\d+)\s*\/\s*(\d+)\s*(.*)$/))){ val=(+m[1])/(+m[2]); t=m[3]; }
  if(val==null && (m=t.match(/^(\d+(?:\.\d+)?)\s*(.*)$/))){ val=+m[1]; t=m[2]; }
  if(val==null) return [null,null,orig];
  t=t.trim();
  if((m=t.match(/^(kg|g|ml|l)(?![a-z])\s*(.*)$/i))){
    let u=m[1].toLowerCase(), rest=m[2];
    if(u==='kg'){ val*=1000; u='g'; }
    if(u==='l'){ val*=1000; u='ml'; }
    return [val,u,rest];
  }
  let low=t.toLowerCase();
  if(/^x(?![a-z])/.test(low)){ t=t.slice(1).trim(); low=t.toLowerCase(); }
  const units=[[/^(tablespoons?|tbsps?|tbs)(?![a-z])/,'tbsp'],[/^(teaspoons?|tsps?)(?![a-z])/,'tsp'],
    [/^cups?(?![a-z])/,'cup'],[/^handfuls?(?![a-z])/,'handful'],[/^pinch(es)?(?![a-z])/,'pinch'],
    [/^(cans?|tins?)(?![a-z])/,'can'],[/^scoops?(?![a-z])/,'scoop']];
  for(const [re,u] of units){ const mm=re.exec(low); if(mm) return [val,u,t.slice(mm[0].length).trim()]; }
  return [val,'piece',t];
}
function gramsForJ(val,unit,name,macro){
  if(val==null) return [0,'none'];
  const low=deacc(String(name).toLowerCase());
  if(unit==='g'||unit==='ml') return [val,unit];
  if(unit==='tbsp') return [val*(macro? macro.tbsp : spoonGramsJ(name,'tbsp')),unit];
  if(unit==='tsp')  return [val*(macro? macro.tsp  : spoonGramsJ(name,'tsp')),unit];
  if(unit==='cup')  return [val*(macro? macro.cup  : FR.const.cup),unit];
  if(unit==='handful') return [val*FR.const.handful,unit];
  if(unit==='pinch')   return [val*FR.const.pinch,unit];
  if(unit==='can')  return [val*(macro? macro.each : FR.const.can),unit];
  if(unit==='scoop')return [val*30,unit];
  let each=null; const pg=pieceGramsJ(name);
  if(low.includes('banana')) each= low.includes('large')?120 : (low.includes('small')?80:100);
  else if(low.includes('egg') && !low.includes('noodle')) each= low.includes('small')?45:50;
  else if(pg!=null) each=pg;
  else if(macro) each=macro.each;
  else each=80;
  if(low.includes('small')) each*=0.8; else if(low.includes('large')) each*=1.25;
  return [val*each,'each'];
}
// ingredient line -> structured object (same shape the app already uses)
const LIQ_DENS_J=[[/\b(?:olive|coconut|sesame|vegetable|rapeseed|sunflower|groundnut|avocado)\s+oil\b/,0.91],
 [/\boil\b/,0.91],[/\bcoconut\s+milk\b/,0.98],[/\b(?:almond|oat|soya|soy|rice)\s+milk\b/,1.03],
 [/\bmilk\b/,1.03],[/\bcream\b/,1.01],[/\b(?:stock|broth|bouillon)\b/,1.0],[/\bjuice\b/,1.04],
 [/\b(?:soy|fish|oyster|worcestershire)\s+sauce\b/,1.15],[/\bvinegar\b/,1.01],
 [/\b(?:wine|sake|mirin|beer|cider)\b/,0.99],[/\bpassata\b/,1.05],[/\bwater\b/,1.0]];
function liquidDensJ(name){
  const low=deacc(String(name).toLowerCase());
  if(/\b(honey|syrup|yoghurt|yogurt|butter|paste|puree|pesto|jam|mayonnaise|tahini|miso)\b/.test(low)) return null;
  for(const [re,d] of LIQ_DENS_J) if(re.test(low)) return d;
  return null;
}
/* Foods added to the shared database were never consulted here — the parser
   only knew its built-in tables and McCance. So adding "Passata" to the food
   library had no effect on an import that mentions passata. */
let USER_FOODS=[];
function setUserFoods(list){
  USER_FOODS=(list||[]).map(f=>({
    key: String(f.name||'').toLowerCase().replace(/[^a-z0-9]+/g,' ').trim(),
    name: f.name,
    p: +f.protein_100g||0, c: +f.carbs_100g||0, f: +f.fat_100g||0,
    unit: f.default_unit||'g', piece: +f.piece_grams||0
  })).filter(x=>x.key);
}
function matchUserFood(txt){
  if(!USER_FOODS.length) return null;
  const q=String(txt||'').toLowerCase().replace(/[^a-z0-9]+/g,' ').trim();
  if(!q) return null;
  let best=null, bestLen=0;
  for(const f of USER_FOODS){
    // the ingredient text usually carries extra words — "40g light mozzarella,
    // torn" — so a food name contained in it counts, longest name winning
    const hit = q === f.key ||
                q.indexOf(' '+f.key+' ')>=0 ||
                q.startsWith(f.key+' ') || q.endsWith(' '+f.key) ||
                (f.key.length>4 && q.indexOf(f.key)>=0);
    if(hit && f.key.length>bestLen){ best=f; bestLen=f.key.length; }
  }
  if(best){ best = Object.assign({}, best, {loose:false}); return best; }
  // word order differs more often than you would think — "light mozzarella"
  // against a food called "Mozzarella light". Every word of the food name has
  // to be present, and two words minimum, so this cannot match loosely.
  const words=q.split(' ').filter(Boolean);
  for(const f of USER_FOODS){
    const fw=f.key.split(' ').filter(Boolean);
    if(fw.length<2) continue;
    if(fw.every(t=>words.indexOf(t)>=0) && f.key.length>bestLen){ best=f; bestLen=f.key.length; }
  }
  if(best){ best = Object.assign({}, best, {loose:false}); return best; }
  // And the other way round: the food name is often longer than the recipe
  // text — "Chicken Breast, skinless" against "chicken breast". Every word of
  // the ingredient has to appear in the food name, two words minimum.
  if(words.length>=2){
    for(const f of USER_FOODS){
      const fw=f.key.split(' ').filter(Boolean);
      if(words.every(t=>fw.indexOf(t)>=0)){
        // the closest in length wins, so "chicken breast" prefers
        // "Chicken Breast, skinless" over "Chicken Breast Mince, lean"
        const d=Math.abs(f.key.length-q.length);
        // a match found only this way is a guess, not a certainty
        if(best===null || d<bestLen){ best=Object.assign({},f,{loose:true}); bestLen=d; }
      }
    }
  }
  return best;
}

function resolveIngredient(raw){
  const txt=String(raw).trim().replace(/^~\s*/,'').trim();
  const letters=(txt.match(/[a-z]/gi)||[]);
  const allcaps = letters.length>=3 && letters.every(c=>c===c.toUpperCase()) && !/^\s*[\d~½¼¾⅓⅔⅛]/.test(txt);
  if(!txt || SECTION_RE_J.test(txt) || txt.endsWith(':') || allcaps)
    return {raw:raw,name:txt,grams:0,unit:'none',qty:null,unitGrams:0,pg:0,cg:0,fg:0,
            scalable:false,header:true,src:null,negligible:false};
  const [val,unit,rest]=parseAmountJ(txt);
  const name=(rest&&rest.trim())? rest.trim() : txt;
  /* The "no real calories" test used to run here, before anything looked the
     ingredient up. It matches \bwater\b, so "Tuna, tinned in spring water" and
     "Sweetcorn, canned in water, drained" were zeroed — as would be salted
     peanuts, lemon zest cake and anything else carrying one of those words in
     its name. The test now runs only if nothing in the food tables matched,
     which is the case it was written for. */
  const NEG_FALLBACK = () => ({raw:raw,name:name,grams:0,unit:'none',qty:val,unitGrams:0,
    pg:0,cg:0,fg:0,scalable:false,header:false,src:'negligible',negligible:true});

  // The shared library goes first. It is what the team has actually curated
  // and what an import will reference — checking the built-in tables ahead of
  // it meant "chicken breast" matched a built-in and then looked like a food
  // the import needed to create, even though it was sitting in the database.
  /* Order matters here, and getting it wrong is how "tuna in spring water"
     ended up with no calories:
       1. a real food in the shared library always wins
       2. then the seasoning test, for salt, water and the like
       3. then the reference tables
     The seasoning test used to run first, so any food with "water", "salt" or
     "zest" in its NAME was dismissed before anything looked it up. */
  let pg=0,cg=0,fg=0,src=null;
  const uf=matchUserFood(rest? name : txt) || matchUserFood(txt);
  // "Lemon zest" should not become "Lemon zest cake" just because every word
  // of it appears in that name. A loose match loses to the seasoning test.
  if(uf && !(uf.loose && NEG_RE.test(name))){
    pg=uf.p/100; cg=uf.c/100; fg=uf.f/100; src='library:'+String(uf.name).slice(0,40);
  }

  if(!src && NEG_RE.test(name)) return NEG_FALLBACK();

  let macro=null, key=null;
  if(!src){
    const m=matchFoodJ(rest? name : txt); macro=m[0]; key=m[1];
    if(macro){ pg=macro.p/100; cg=macro.c/100; fg=macro.f/100; src='curated:'+String(key).slice(0,28); }
    else {
      const mc=mccLookup(name)||mccLookup(txt);
      if(mc){ pg=mc.p; cg=mc.c; fg=mc.f; src=mc.src; }
    }
  }
  let [grams,unit2]=gramsForJ(val,unit,name,macro);
  if(grams<=0){
    const j=juiceFromJ(txt);
    if(j){ grams=j; unit2='ml'; }
    else if(val==null && (pg+cg+fg)>0){ grams=defaultGramsJ(name); unit2='g'; }
  }
  const unitGrams=(val!=null && val!==0)? grams/val : 0;
  const fixed=isFixedJ(name);
  const dens=liquidDensJ(name);
  return {raw:raw,name:name,grams:Math.round(grams*100)/100,unit:(dens?'ml':unit2),qty:val,
          unitGrams:Math.round(unitGrams*1000)/1000,pg:pg,cg:cg,fg:fg,
          scalable:(!fixed && grams>0 && (pg+cg+fg)>0),header:false,src:src,negligible:false,
          dens:(dens||1), dunit:(dens?'ml':'g')};
}
// build a full recipe object from one sheet row
function buildRecipeFromRow(row, idx){
  const num=v=>{ const n=parseFloat(String(v==null?'':v).replace(/[^0-9.\-]/g,'')); return isNaN(n)?null:n; };
  const name=String(row.name||'').trim();
  if(!name) return null;
  let cho=num(row.cho), fat=num(row.fat), pro=num(row.pro);
  let kcal=num(row.kcal);
  // macros are optional: if they're blank we work them out from the ingredients
  const statedMacros = (cho!=null && fat!=null && pro!=null);
  const ingLines=String(row.ingredients||'').split(/\r?\n|;/).map(s=>s.trim()).filter(Boolean)
    .map(l=>{ // collapse a leading count range "6-8 slices" -> "7 slices"
      const m=l.match(/^(~?)(\d+)\s*[-–]\s*(\d+)(\s*)(.*)$/);
      if(m && !/^(g|ml|kg|l)\b/i.test(m[5])) return (m[1]+Math.round((+m[2]+ +m[3])/2)+' '+m[5]).trim();
      return l;
    });
  if(!ingLines.length) return null;
  const dirs=String(row.method||'').split(/\r?\n/).map(s=>s.replace(/^\s*\d+[.)]\s*/,'').trim()).filter(Boolean);
  const servings=Math.max(1, Math.round(num(row.servings)||1));
  const parsed=ingLines.map(resolveIngredient);
  if(!statedMacros){
    const sum=k=>parsed.reduce((a,i)=>a+i.grams*i[k],0);
    const sv=Math.max(1, Math.round(num(row.servings)||1));
    pro=Math.round(sum('pg')/sv); cho=Math.round(sum('cg')/sv); fat=Math.round(sum('fg')/sv);
    kcal=Math.round(4*pro+4*cho+9*fat);
  }
  if(kcal==null) kcal=Math.round(4*pro+4*cho+9*fat);
  if(servings>1) parsed.forEach(i=>{
    if(i.grams) i.grams=Math.round(i.grams/servings*100)/100;
    if(i.qty) i.qty=i.qty/servings;
    if(!i.header && i.scalable && i.grams){
      const nm=i.name.replace(/\s*\([^)]*\)\s*$/,'').replace(/\b(large|medium|small)\b/gi,'').trim();
      const u=i.dunit||'g'; const dn=(i.dens&&i.dens>0)?i.dens:1;
      const amt=i.grams/dn;
      i.raw=(amt>=1? Math.round(amt):Math.round(amt*10)/10)+u+' '+nm;
      i.unit=(u==='ml')?'ml':'g';
    }
  });
  const sum=k=>parsed.reduce((a,i)=>a+i.grams*i[k],0);
  const res={p:+(pro-sum('pg')).toFixed(2), c:+(cho-sum('cg')).toFixed(2), f:+(fat-sum('fg')).toFixed(2)};
  parsed.forEach(i=>{
    if(!i.scalable){ i.group='fixed'; return; }
    const p=i.grams*i.pg, c=i.grams*i.cg, f=i.grams*i.fg, mx=Math.max(p,c,f);
    i.group = mx===p?'P' : (mx===c?'C':'F');
  });
  const catRaw=String(row.category||'').toUpperCase();
  const lowName=name.toLowerCase();
  // What the sheet says wins. BREAKFAST used to be missing from this list, so
  // a row marked Breakfast only landed as one if its NAME happened to contain
  // porridge, pancake or the like — otherwise it became lunch or dinner.
  let cat=null;
  if(catRaw.includes('BREAKFAST')) cat='breakfast';
  else if(catRaw.includes('SMOOTH')) cat='smoothie';
  else if(catRaw.includes('SNACK')) cat='snack';
  else if(catRaw.includes('LUNCH') || catRaw.includes('DINNER')) cat='lunchdinner';
  // only guess from the name when the sheet did not say
  if(!cat){
    cat = /(porridge|overnight oats|french toast|pancake|granola|muesli|bircher|scrambled egg|breakfast|banana bread|oat muffin|muffins)/.test(lowName)
      ? 'breakfast' : 'lunchdinner';
  }
  const blob=(name+' '+ingLines.join(' ')).toLowerCase();
  const PK=[['Chicken',['chicken']],['Beef',['beef','steak','sirloin','mince']],['Salmon',['salmon']],
    ['Prawn',['prawn','shrimp']],['Cod',['cod','sea bass','fish']],['Lamb',['lamb']],['Pork',['pork']],
    ['Turkey',['turkey']],['Whey',['whey','casein','protein']],['Egg',['egg']],['Tofu',['tofu','chickpea','vegetable']]];
  let prot='Mixed';
  for(const [tag,keys] of PK) if(keys.some(k=>blob.includes(k))){ prot=tag; break; }
  return {id:'s'+idx, name:name, category:cat,
    tier: cho<40?'low':(cho<=70?'medium':'high'),
    cho:Math.round(cho), pro:Math.round(pro), fat:Math.round(fat), kcal:Math.round(kcal),
    servings:servings, sheetCategory:row.category||'', ingredients:ingLines, directions:dirs,
    protein:prot, ings:parsed, res:res, scan:(name+' | '+ingLines.join(' | ')).toLowerCase()};
}
/* ---- CSV parsing (handles quoted cells with newlines/commas) ---- */
/* Copying rows out of Excel puts TAB-separated text on the clipboard, not
   commas. This only ever split on commas, so a pasted sheet came through as
   one column — the whole row read as a single ingredient, which is how foods
   called "M. BBQ cheek<tab>MEDIUM CHO...<tab>155g beef cheek" got created.
   The separator is now worked out from the header line. */
function sniffDelimiter(text){
  const first = String(text||'').split(/\r?\n/)[0] || '';
  // count only separators outside quotes
  let tabs=0, commas=0, q=false;
  for(const ch of first){
    if(ch==='"'){ q=!q; continue; }
    if(q) continue;
    if(ch==='\t') tabs++;
    else if(ch===',') commas++;
  }
  return tabs > commas ? '\t' : ',';
}

function parseCSV(text, delim){
  const D = delim || sniffDelimiter(text);
  const rows=[]; let row=[], cell='', q=false;
  for(let i=0;i<text.length;i++){
    const ch=text[i];
    if(q){
      if(ch==='"'){ if(text[i+1]==='"'){ cell+='"'; i++; } else q=false; }
      else cell+=ch;
    } else {
      if(ch==='"') q=true;
      else if(ch===D){ row.push(cell); cell=''; }
      else if(ch==='\n'){ row.push(cell); rows.push(row); row=[]; cell=''; }
      else if(ch!=='\r') cell+=ch;
    }
  }
  if(cell.length||row.length){ row.push(cell); rows.push(row); }
  return rows.filter(r=>r.some(c=>String(c).trim()!==''));
}
// map the sheet's header names to the fields we need (tolerant of wording)
function mapSheetRows(rows){
  if(!rows.length) return [];
  const hdr=rows[0].map(h=>String(h).toLowerCase().trim());
  const find=(...alts)=>{
    for(const a of alts){ const i=hdr.findIndex(h=>h.includes(a)); if(i>=0) return i; }
    return -1;
  };
  const ix={ name:find('recipe name','recipe','name'), category:find('category','section','type'),
    servings:find('serving'), kcal:find('kcal','calorie','energy'), cho:find('carb','cho'),
    fat:find('fat'), pro:find('protein','pro'), ingredients:find('ingredient'), method:find('method','direction','instruction') };
  if(ix.name<0 || ix.ingredients<0) return [];
  const get=(r,i)=> i>=0 && i<r.length? r[i] : '';
  return rows.slice(1).map(r=>({ name:get(r,ix.name), category:get(r,ix.category),
    servings:get(r,ix.servings), kcal:get(r,ix.kcal), cho:get(r,ix.cho), fat:get(r,ix.fat),
    pro:get(r,ix.pro), ingredients:get(r,ix.ingredients), method:get(r,ix.method) }));
}
// turn a Google Sheets URL into its published CSV endpoint where possible
function sheetCsvUrl(u){
  u=String(u||'').trim(); if(!u) return '';
  if(/output=csv|\/pub\?|format=csv/.test(u)) return u;
  const m=u.match(/\/spreadsheets\/d\/([a-zA-Z0-9-_]+)/);
  if(m){
    const gid=(u.match(/[#&?]gid=(\d+)/)||[])[1] || '0';
    return 'https://docs.google.com/spreadsheets/d/'+m[1]+'/gviz/tq?tqx=out:csv&gid='+gid;
  }
  return u;
}
async function loadRecipesFromSheet(url){
  const csvUrl=sheetCsvUrl(url);
  if(!csvUrl) throw new Error('No sheet URL');
  const resp=await fetch(csvUrl, {cache:'no-store'});
  if(!resp.ok) throw new Error('Sheet fetch failed ('+resp.status+')');
  const text=await resp.text();
  if(/^\s*</.test(text)) throw new Error('That link returned a web page, not data — use File → Share → Publish to web → CSV');
  const mapped=mapSheetRows(parseCSV(text));
  if(!mapped.length) throw new Error('Could not find "Recipe Name" and "Ingredients" columns');
  const recipes=[]; let skipped=0; const unknown=[];
  mapped.forEach((row,i)=>{
    const r=buildRecipeFromRow(row,i+1);
    if(!r){ if(String(row.name||'').trim()) skipped++; return; }
    r.ings.forEach(ig=>{ if(!ig.header && !ig.negligible && (ig.pg+ig.cg+ig.fg)<=0) unknown.push(r.name+': '+ig.raw); });
    recipes.push(r);
  });
  return {recipes, skipped, unknown};
}
// build a recipe from ingredients typed by hand — macros come from the food tables
function buildCustomRecipe(o){
  const lines=String(o.ingredients||'').split(/\r?\n/).map(x=>x.trim()).filter(Boolean);
  if(!lines.length) return null;
  const parsed=lines.map(resolveIngredient);
  const sum=k=>parsed.reduce((a,i)=>a+i.grams*i[k],0);
  const pro=Math.round(sum('pg')), cho=Math.round(sum('cg')), fat=Math.round(sum('fg'));
  parsed.forEach(i=>{
    if(!i.scalable){ i.group='fixed'; return; }
    const p=i.grams*i.pg, c=i.grams*i.cg, f=i.grams*i.fg, mx=Math.max(p,c,f);
    i.group = mx===p?'P' : (mx===c?'C':'F');
  });
  const dirs=String(o.method||'').split(/\r?\n/).map(x=>x.replace(/^\s*\d+[.)]\s*/,'').trim()).filter(Boolean);
  const name=String(o.name||'').trim()||'Custom meal';
  const unknown=parsed.filter(i=>!i.header&&!i.negligible&&(i.pg+i.cg+i.fg)<=0).map(i=>i.raw);
  return {recipe:{
    id:o.id||('c'+Date.now().toString(36)),
    name:name, category:o.category||'lunchdinner',
    tier: cho<40?'low':(cho<=70?'medium':'high'),
    cho:cho, pro:pro, fat:fat, kcal:Math.round(4*pro+4*cho+9*fat),
    servings:1, sheetCategory:'CUSTOM', custom:true,
    ingredients:lines, directions:dirs, protein:'Custom',
    ings:parsed, res:{p:0,c:0,f:0},
    scan:(name+' | '+lines.join(' | ')).toLowerCase()
  }, unknown};
}
// search the food database (curated names + full McCance list) for the picker
function searchFoods(q, limit){
  q=String(q||'').trim(); if(q.length<2) return [];
  const qt=toksJ(q); if(!qt.length) return [];
  const qs=new Set(qt), low=deacc(q.toLowerCase());
  const out=[];
  // curated entries first — these are the accurate, common performance foods
  for(const [keys,m] of FR.foods){
    let bestK=null;
    for(const k of keys){
      const kk=deacc(k.toLowerCase());
      if(kk.length<3) continue;
      // whole-word match in either direction, so "pea" never matches "peanut butter"
      const inQuery=new RegExp('(?:^|[^a-z])'+kk.replace(/[.*+?^${}()|[\]\\]/g,'\\$&')+'(?:e?s)?(?![a-z])').test(low);
      const queryIn=kk.startsWith(low);
      if(inQuery||queryIn){ if(!bestK||kk.length>bestK.length) bestK=kk; }
    }
    if(!bestK) continue;
    // label: the most descriptive key in the group
    const label=keys.slice().sort((a,b)=>b.length-a.length)[0];
    out.push({label:label.replace(/\b[a-z]/,c=>c.toUpperCase()),
              p:m.p, c:m.c, f:m.f, kcal:Math.round(4*m.p+4*m.c+9*m.f),
              src:'Curated', score:120+bestK.length*2+(bestK===low?30:0)});
  }
  // then the McCance dataset
  for(const food of mcc()){
    let inter=0; for(const t of food.tokens) if(qs.has(t)) inter++;
    if(!inter) continue;
    const fl=deacc(food.name.toLowerCase());
    let sc=inter*10 - Math.max(0,food.n-inter)*2;
    if(fl.startsWith(low)) sc+=25;
    if(qs.has(food.first)) sc+=8;
    for(const w of FR.formWords) if(fl.includes(w) && !low.includes(w)) sc-=6;
    if(fl.includes('raw')||fl.includes('fresh')) sc+=3;
    out.push({label:food.name, p:food.p, c:food.c, f:food.f,
              kcal:Math.round(4*food.p+4*food.c+9*food.f), src:'McCance', score:sc});
  }
  const seen=new Set(); const res=[];
  out.sort((a,b)=>b.score-a.score);
  for(const o of out){
    const k=o.label.toLowerCase(); if(seen.has(k)) continue; seen.add(k);
    res.push(o); if(res.length>=(limit||14)) break;
  }
  return res;
}
// plain food names for the ingredient autocomplete
function commonFoodNames(){
  const out=new Set();
  for(const [keys] of FR.foods) for(const k of keys) if(k.length>2) out.add(k);
  for(const k in FR.piece) if(k.length>2) out.add(k);
  return [...out].sort();
}
window.CNFood={loadRecipesFromSheet, buildRecipeFromRow, resolveIngredient, sheetCsvUrl,
               buildCustomRecipe, commonFoodNames, searchFoods, __parseCSV:parseCSV, __mapRows:mapSheetRows, setUserFoods, __sniff:sniffDelimiter};
