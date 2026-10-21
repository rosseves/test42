/* ============ DATA (injected) ============ */
let RECIPES=window.__RECIPES__;
const BUILTIN_RECIPES=window.__RECIPES__;
const CHEF_INTRO_DEFAULT = 'This plan uses a carb-coding system. Each meal is coloured by its carbohydrate content so the kitchen can prepare portions at a glance. Adjust starch/carb sources to hit the stated CHO value for each meal.';
const CHEF_REFS_DEFAULT = '30g oats ~ 20g CHO\n200g cooked rice ~ 56g CHO\n200g sweet potato wedges ~ 53g CHO\n250g cooked spaghetti ~ 77g CHO';
const LOGO_WHITE = window.__LOGO_WHITE__;
const LOGO_BLACK = window.__LOGO_BLACK__;
document.getElementById('brandlogo').src = LOGO_BLACK;

/* ============ CONSTANTS ============ */
const DAYS = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
const DAYFULL = {Mon:'Monday',Tue:'Tuesday',Wed:'Wednesday',Thu:'Thursday',Fri:'Friday',Sat:'Saturday',Sun:'Sunday'};
// Off is a rest day with its own targets — usually fewer carbs than Normal.
// It behaves like any other type: meals are still planned to its numbers.
const DAYTYPES = ['Normal','Game Day','Game Day -1','Game Day +1','Off'];
// A carb multiplier per day type used to live here. Nothing calls it: the
// targets come from the player's own g/kg for each day type, which is a
// figure Graeme sets rather than one the app invents.

// meal template per day type: {name, kind, cat, time, choFrac, proFrac, fatFrac}
function template(type){
  if(type==='Game Day') return [
    {name:'Breakfast (Hotel)',kind:'meal',cat:'breakfast',time:'08:30',f:[.24,.24,.24]},
    {name:'Pre-Match Fuel',kind:'snack',cat:'smoothie',time:'11:00',f:[.20,.10,.08]},
    {name:'Lunch (Hotel)',kind:'meal',cat:'lunchdinner',time:'13:00',f:[.20,.24,.24]},
    {name:'Post-Match Recovery',kind:'snack',cat:'smoothie',time:'FT',f:[.12,.14,.06]},
    {name:'Post-Match Meal',kind:'meal',cat:'lunchdinner',time:'21:30',f:[.24,.28,.38]},
  ];
  if(type==='Game Day -1') return [
    {name:'Breakfast',kind:'meal',cat:'breakfast',time:'08:30',f:[.25,.24,.22]},
    {name:'AM Snack',kind:'snack',cat:'snack',time:'11:00',f:[.10,.10,.10]},
    {name:'Lunch',kind:'meal',cat:'lunchdinner',time:'13:00',f:[.30,.30,.30]},
    {name:'PM Snack',kind:'snack',cat:'snack',time:'16:00',f:[.10,.10,.10]},
    {name:'Dinner',kind:'meal',cat:'lunchdinner',time:'19:30',f:[.25,.26,.28]},
  ];
  if(type==='Game Day +1') return [
    {name:'Recovery Breakfast',kind:'meal',cat:'breakfast',time:'09:00',f:[.25,.26,.24]},
    {name:'Recovery Shake',kind:'snack',cat:'smoothie',time:'11:00',f:[.10,.12,.08]},
    {name:'Lunch',kind:'meal',cat:'lunchdinner',time:'13:00',f:[.28,.28,.30]},
    {name:'Snack',kind:'snack',cat:'snack',time:'16:30',f:[.12,.10,.10]},
    {name:'Dinner',kind:'meal',cat:'lunchdinner',time:'19:30',f:[.25,.24,.28]},
  ];
  if(type==='Off') return [   // rest day: later start, no training feeds
    {name:'Breakfast',kind:'meal',cat:'breakfast',time:'09:30',f:[.26,.26,.26]},
    {name:'Lunch',kind:'meal',cat:'lunchdinner',time:'13:30',f:[.28,.28,.28]},
    {name:'Afternoon Snack',kind:'snack',cat:'snack',time:'16:30',f:[.14,.16,.14]},
    {name:'Dinner',kind:'meal',cat:'lunchdinner',time:'19:30',f:[.32,.30,.32]}
  ];
  return [ // Normal / training
    {name:'Breakfast',kind:'meal',cat:'breakfast',time:'08:00',f:[.25,.25,.24]},
    {name:'Pre-Training Snack',kind:'snack',cat:'snack',time:'10:30',f:[.10,.08,.08]},
    {name:'Lunch',kind:'meal',cat:'lunchdinner',time:'13:00',f:[.30,.30,.30]},
    {name:'Post-Training Snack',kind:'snack',cat:'snack',time:'16:00',f:[.10,.12,.10]},
    {name:'Dinner',kind:'meal',cat:'lunchdinner',time:'19:30',f:[.25,.25,.28]},
  ];
}

const EXCLUSIONS = ['Tomatoes','Onion','Garlic','Mushrooms','Avocado','Egg','Yoghurt','Cheese','Feta',
 'Nuts','Peanut','Prawns','Salmon','Fish','Beef','Pork','Lamb','Chicken','Turkey','Coconut','Banana',
 'Honey','Chilli','Bread/Gluten','Chickpeas','Beans','Pineapple','Mango','Olives','Tofu','Sesame'];
const EX_KEYS = {'Bread/Gluten':['bread','sourdough','pitta','tortilla','brioche','pasta','spaghetti','noodle','gnocchi','couscous','flour','panko','oats','granola'],
 'Fish':['salmon','cod','sea bass','fish'],'Nuts':['almond','walnut','pecan','cashew','pine nut','nut butter'],
 'Prawns':['prawn','shrimp'],'Yoghurt':['yoghurt','yogurt','skyr'],'Egg':['egg']};
function exKeys(e){ return EX_KEYS[e] || [e.toLowerCase()]; }

/* ============ STATE ============ */
let S = null;
const LSKEY='closeNutritionPlan_v4';

function defaultMacros(bw){
  // sensible football default: 6 g/kg CHO, 2 g/kg PRO, 1.2 g/kg FAT
  const cho=Math.round(6*bw), pro=Math.round(2*bw), fat=Math.round(1.2*bw);
  return {cho,pro,fat};
}
function kcalOf(m){ return Math.round(4*m.pro + 4*m.cho + 9*m.fat); }

// blank state — no targets, no plan, until the user generates
function newState(){
  const dayTargets={}, dayTypes={};
  DAYS.forEach(d=>{ dayTargets[d]={pro:0,cho:0,fat:0}; dayTypes[d]='Normal'; });
  return {player:'', bw:90, global:{pro:0,cho:0,fat:0}, dayTargets, dayTypes,
          excl:[], active:'Mon', days:{}, generated:false};
}
// build the full week from the per-day targets (called by Generate)
function generatePlan(){
  if(!S.bw || S.bw<=0) S.bw=90;
  const def=defaultMacros(S.bw), g=S.global;
  // fallback used for any day/macro left blank: sidebar default, else g/kg default
  const fb={pro:(g.pro>0?g.pro:def.pro), cho:(g.cho>0?g.cho:def.cho), fat:(g.fat>0?g.fat:def.fat)};
  S.days={};
  let usedPlayer = 0;
  DAYS.forEach(d=>{
    const t=S.dayTargets[d]||{pro:0,cho:0,fat:0};
    // The player's own g/kg for this day type sits between a figure typed into
    // the day and the sidebar default. Without this, setting Game Day to 6 g/kg
    // on the profile did nothing until you re-picked the day type by hand.
    const dt = S.dayTypes[d] || 'Normal';
    const fromPlayer = targetsForDayType(dt);
    if(fromPlayer) usedPlayer++;
    const base = fromPlayer || fb;
    const m={pro:(t.pro>0?t.pro:base.pro), cho:(t.cho>0?t.cho:base.cho),
             fat:(t.fat>0?t.fat:base.fat)};
    S.days[d]=buildDay(dt, m);
    S.dayTargets[d]={pro:m.pro, cho:m.cho, fat:m.fat};
  });
  if(usedPlayer) S.usedPlayerTargets = usedPlayer;
  S.active='Mon';
  S.generated=true;
  applySupplementProtocol();
}
// Build one day. The slot targets are a guide for choosing recipes, not
// something the recipes are bent to meet — each one goes in as written and the
// day's real total is whatever those recipes add up to.
function buildDay(type,dayM){
  const dcho=Math.round(dayM.cho), dpro=Math.round(dayM.pro), dfat=Math.round(dayM.fat);
  const tmpl=template(type);
  const meals=tmpl.map((t,i)=>({
    id:'m'+Date.now()+'_'+i+'_'+Math.random().toString(36).slice(2,6),
    name:t.name, kind:t.kind, cat:t.cat, time:t.time,
    cho:Math.round(dcho*t.f[0]), pro:Math.round(dpro*t.f[1]), fat:Math.round(dfat*t.f[2]),
    recipeId:null, showDirs:false
  }));
  const day={type, cho:dcho, pro:dpro, fat:dfat, meals};
  chooseRecipesForDay(day);
  return day;
}

/* Pick a recipe for every slot so the DAY lands as close to target as the
   library allows. Each slot used to be matched on its own share and then
   scaled to fit; now nothing is scaled, so the choices have to work together —
   a heavy breakfast means a lighter lunch rather than a shrunken one. */
function chooseRecipesForDay(day){
  const target={pro:day.pro, cho:day.cho, fat:day.fat};
  const running={pro:0, cho:0, fat:0};
  const used=new Set();
  const left = i => day.meals.length - i;

  day.meals.forEach((m,i)=>{
    // what is still needed, shared across the slots that remain
    const need={
      pro:(target.pro-running.pro)/left(i),
      cho:(target.cho-running.cho)/left(i),
      fat:(target.fat-running.fat)/left(i)
    };
    const cands=bestMatch(m.cat, need, S.excl) || [];
    // prefer something not already on the plate today
    let pick=cands.find(c=>!used.has(c.r.id)) || cands[0];
    if(!pick){ return; }
    m.recipeId=pick.r.id;
    used.add(pick.r.id);
    const got=recipeAsWritten(pick.r);
    m.pro=got.pro; m.cho=got.cho; m.fat=got.fat;   // what it actually delivers
    running.pro+=got.pro; running.cho+=got.cho; running.fat+=got.fat;
  });
}

/* A recipe's own macros, one serving, nothing adjusted — worked out from its
   ingredients, which is what the app now counts. Using the book's stated
   figure here meant the carb filter and the carb shown on the card could
   disagree, so asking for a medium-carb meal could hand back a high one. */
const RAW_CACHE = new Map();
function recipeAsWritten(r){
  if(!r) return {pro:0,cho:0,fat:0,kcal:0};
  if(RAW_CACHE.has(r.id)) return RAW_CACHE.get(r.id);
  let out;
  if(r.ings && r.ings.length){
    let p=0,c=0,f=0;
    r.ings.forEach(i=>{
      if(i.header) return;
      const g=+i.grams||0;
      p += g*(+i.pg||0); c += g*(+i.cg||0); f += g*(+i.fg||0);
    });
    out={pro:Math.round(p), cho:Math.round(c), fat:Math.round(f),
         kcal:Math.round(4*p+4*c+9*f)};
  }else{
    out={pro:+r.pro||0, cho:+r.cho||0, fat:+r.fat||0, kcal:+r.kcal||0};
  }
  RAW_CACHE.set(r.id, out);
  return out;
}
function clearRawCache(){ RAW_CACHE.clear(); }

/* Saving used to swallow every error, so a full browser store meant the work
   simply stopped being written and nobody knew until it disappeared. It now
   says so, and keeps the last good copy under a second key to fall back on. */
let SAVE_WARNED = false;
function save(){
  let json;
  try{ json = JSON.stringify(S); }
  catch(e){ console.error('could not serialise the plan', e); return false; }
  try{
    localStorage.setItem(LSKEY, json);
    // a rolling spare, written only when the main one succeeded
    try{ localStorage.setItem(LSKEY + '_backup', json); }catch(e){}
    SAVE_WARNED = false;
    return true;
  }catch(e){
    // out of room: drop the spare and try once more
    try{ localStorage.removeItem(LSKEY + '_backup'); }catch(e2){}
    try{ localStorage.setItem(LSKEY, json); SAVE_WARNED = false; return true; }
    catch(e3){
      if(!SAVE_WARNED){
        SAVE_WARNED = true;
        try{ toast('This plan is not being saved — the browser is out of storage. ' +
                   'Export it now, then clear some space.', 12000); }catch(e4){}
      }
      console.error('save failed', e3 && e3.message);
      return false;
    }
  }
}
function validState(s){
  if(!s || typeof s!=='object' || !s.dayTargets || !s.dayTypes || !s.global) return false;
  if(s.generated){
    if(!s.days) return false;
    for(const d of DAYS){ const day=s.days[d]; if(!day || !Array.isArray(day.meals)) return false; }
  }
  return true;
}
function load(){
  // the main copy, then the spare. Never silently start from nothing when
  // there is something recoverable.
  for(const key of [LSKEY, LSKEY + '_backup']){
    try{
      const r = localStorage.getItem(key);
      if(!r) continue;
      const s = JSON.parse(r);
      if(validState(s)){
        if(key !== LSKEY) console.warn('the main plan was unreadable; using the backup');
        return s;
      }
      console.warn('stored plan failed its checks', key);
    }catch(e){ console.warn('could not read', key, e && e.message); }
  }
  return null;
}

/* ============ RECIPE MATCHING & SCALING ============ */
function sameSlot(rc, mc){
  if(mc==='breakfast') return rc==='breakfast';
  if(mc==='snack'||mc==='smoothie') return rc==='snack'||rc==='smoothie';
  return rc==='lunchdinner';
}
function candidatesFor(cat, excl){
  let cats;
  if(cat==='breakfast') cats=['breakfast'];
  else if(cat==='smoothie') cats=['smoothie','snack'];
  else if(cat==='snack') cats=['snack','smoothie'];
  else cats=['lunchdinner'];
  // Anything this player cannot eat is dealt with here, so every route into the
  // plan goes through it. Recipes that can be adapted come back adapted;
  // those built around something they avoid do not come back at all.
  const pool = RECIPES.filter(r=>cats.includes(r.category) && !isExcluded(r,excl));
  if(!PLAYER_AVOIDS.length) return pool;
  const out = [];
  pool.forEach(r=>{
    const a = assessRecipe(r);
    if(a.status === 'blocked'){ ADAPTED.delete(r.id); return; }
    if(a.status === 'adjusted'){
      const adapted = adaptRecipe(r, a);
      ADAPTED.set(r.id, adapted);
      out.push(adapted);
    }else{
      ADAPTED.delete(r.id);
      out.push(r);
    }
  });
  return out;
}
function isExcluded(r,excl){
  for(const e of excl){ for(const k of exKeys(e)){ if(r.scan.includes(k)) return true; } }
  return false;
}
function bestMatch(cat, target, excl, avoidId){
  const cands=candidatesFor(cat,excl);
  if(!cands.length) return [];
  const scored=cands.map(r=>{
    // what it really delivers, unscaled
    const d=scaledDelivered(r);
    let s=Math.abs(d.cho-target.cho)*1.0 + Math.abs(d.pro-target.pro)*0.9 + Math.abs(d.fat-target.fat)*0.9;
    // small tie-breaker toward recipes whose base profile already sits near the target
    s += (Math.abs(r.cho-target.cho)+Math.abs(r.pro-target.pro)+Math.abs(r.fat-target.fat))*0.05;
    if(r.id===avoidId) s+=1000;
    // A favourite gets a discount, not a free pass: it comes up more often but
    // the week does not collapse into the same four meals.
    if(r.dbId && PLAYER_FAVS.has(r.dbId)) s *= 0.7;
    return {r,s};
  }).sort((a,b)=>a.s-b.s);
  return scored;
}
/* What a recipe delivers — as written, from its ingredients. This used to run
   the scaling engine and report what the recipe could be stretched to, which
   made a 300 kcal snack look like a fit for a 900 kcal slot. Nothing is
   stretched now, so the honest figure is the only one worth scoring on. */
function scaledDelivered(r){
  return recipeAsWritten(r);
}
const DISCRETE_J=['egg','slice','bun','pitta','wrap','tortilla','bagel','crumpet','waffle',
 'rasher','sausage','skewer','fillet','breast','thigh','steak','burger','baguette','roll',
 'pancake','stock cube','sheet','bay leaf','cinnamon stick'];
const DIVISIBLE_J=['banana','avocado','tomato','onion','pepper','courgette','cucumber',
 'aubergine','mango','melon','lemon','lime','orange','apple','pear','cabbage','lettuce',
 'cauliflower','broccoli'];
// Whether a countable ingredient can sensibly be halved. Nothing to do with
// scaling — it stops the app asking for half an egg.
function unitStyle(i){
  const low=(i.raw||'').toLowerCase();
  if(!['each','slice','cube','scoop','can'].includes(i.unit)) return 'free';
  for(const w of DIVISIBLE_J) if(low.includes(w)) return 'half';
  for(const w of DISCRETE_J) if(low.includes(w)) return 'whole';
  return 'whole';
}

/* The per-ingredient scaling engine lived here: it solved for one multiplier
   per macro group so a recipe would hit a target, then rewrote every quantity.
   It has been taken out rather than left dormant. Recipes are what Graeme
   wrote; the app reports what they deliver and he adjusts. Nothing calls it
   any more, and nothing should. */

function snapGrams(i, g){
  // weighed / poured amounts: snap to the same figure we print, so the label,
  // the amount box and the macros all agree on one number
  if(i.unit==='g' || i.unit==='ml'){
    const dens=(i.dens&&i.dens>0)? i.dens : 1;
    const disp=g/dens;
    const rounded = disp>=20? Math.round(disp/5)*5 : Math.max(1, Math.round(disp));
    return rounded*dens;
  }
  const st=unitStyle(i);
  if(st==='free' || !(i.unitGrams>0)) return g;
  const step = st==='half' ? 0.5 : 1;
  let units = Math.round((g/i.unitGrams)/step)*step;
  if(units < step) units = step;
  return units*i.unitGrams;
}
function fmtQty(n){
  if(Math.abs(n-Math.round(n))<0.05) return String(Math.round(n));
  return (Math.round(n*2)/2).toString();
}
function rescaleIngredientText(i, s){
  if(i.header || !i.scalable || Math.abs(s-1)<0.03) return i.raw;
  if(i.unit==='g' || i.unit==='ml'){
    const dens=(i.dens&&i.dens>0)? i.dens : 1;
    const du=i.dunit||((i.unit==='ml')?'ml':'g');
    const exact=(i.grams*s)/dens;                    // ml for pourables, g otherwise
    const g=exact>=20? Math.round(exact/5)*5 : Math.max(1, Math.round(exact));
    // keep any leading "~" and replace the gram figure (also handles ranges)
    let out=i.raw.replace(/^(\s*~?\s*)\d+(?:\.\d+)?(?:\s*[-–]\s*\d+(?:\.\d+)?)?\s*(?:g|ml)?/,
                          (mm,pre)=>pre+g+du);
    // scale the kitchen measure in a trailing parenthetical too, e.g. "(2 tsp)" -> "(1.5 tsp)"
    out=out.replace(/\(([^)]*)\)\s*$/, (mm, inner)=>{
      const m2=inner.match(/^(\d+(?:\.\d+)?|[½¼¾⅓⅔⅛])\s*(.*)$/);
      if(!m2) return mm;
      const base=({'½':0.5,'¼':0.25,'¾':0.75,'⅓':1/3,'⅔':2/3,'⅛':0.125})[m2[1]] || parseFloat(m2[1]);
      if(!base) return mm;
      const nv=Math.max(0.25, Math.round(base*s*4)/4);
      return '('+fmtQty(nv)+(m2[2]?' '+m2[2]:'')+')';
    });
    return out;
  }
  const st=unitStyle(i);
  const q=(i.qty!=null? i.qty : 1)*s;
  const nq = st==='whole' ? Math.max(1,Math.round(q))
           : (st==='half' ? Math.max(0.5, Math.round(q*2)/2)
                          : Math.max(0.5, Math.round(q*2)/2));
  return i.raw.replace(/^\s*(\d+(?:\.\d+)?|[½¼¾⅓⅔⅛])/, fmtQty(nq));
}
// returns {name, base, cho,pro,fat,kcal, ings:[{text,scaled,grams,p,c,f,kcal,header}], note, s}
// `manual` (optional) maps ingredient index -> hand-set grams. When present the
// solver is bypassed for those amounts and the macros are read straight off the
// ingredients, so the meal reports (and is coloured by) what it actually delivers.
function scaledRecipe(r, target, manual){
  if(!r.ings || !r.ings.length){
    return {name:r.name, base:r, cho:r.cho, pro:r.pro, fat:r.fat, kcal:r.kcal,
            ings:(r.ingredients||[]).map(t=>({text:t,scaled:false,header:false,p:0,c:0,f:0,kcal:0,grams:0})), note:'Closest available match', s:{P:1,C:1,F:1}};
  }
  const hasManual = !!(manual && Object.keys(manual).length);
  // The recipe is what Graeme wrote. The app no longer bends it to hit a
  // target — it stopped being the same dish. Every ingredient stays at its
  // written amount unless someone changes it by hand.
  const s = {P:1, C:1, F:1};
  const delivered = {pro:r.pro, cho:r.cho, fat:r.fat};
  const res=r.res||{p:0,c:0,f:0};
  // per-ingredient amounts: hand-set value wins, else the solver's scaled amount
  // a whole-recipe multiple, only ever set by hand ("make it two portions")
  const mult = (manual && manual.__servings > 0) ? +manual.__servings : 1;
  const rows=r.ings.map((i,idx)=>{
    if(i.__dropped) return {i, idx, sg:1, g:0, manual:false, p:0, c:0, f:0, dropped:true};
    const sg = mult;
    /* A hand-set amount is for one serving. Asking for two servings has to
       double it as well, or the multiplier silently does nothing the moment
       anything has been edited by hand. */
    const mvRaw = hasManual && manual[idx]!=null ? Math.max(0, +manual[idx]) : null;
    const mv = mvRaw != null ? mvRaw * mult : null;
    // At one serving with nothing changed, the amount is exactly what the
    // recipe says. Rounding it to a "sensible" number was shifting amounts on
    // a plan nobody had touched, and putting change arrows on untouched meals.
    const g = mv!=null ? mv
            : (sg === 1 ? i.grams : snapGrams(i, i.grams*sg));
    const eff = (i.grams>0) ? g/i.grams : sg;      // effective factor for the label
    return {i, idx, sg:eff, g, manual:mv!=null, p:g*i.pg, c:g*i.cg, f:g*i.fg};
  });
  const out={name:r.name, base:r, s, manual:hasManual};
  /* The ingredients are the truth, always. This used to use the book's stated
     macros for an untouched meal and the ingredient sum once anything was
     edited — and those two disagree on about a third of the library, so
     changing one gram could move a meal 15% for no visible reason. One source
     of truth, and the book's figure becomes what it should always have been:
     a cross-check that flags a recipe for review. */
  /* No fudge factor. Recipes carried a "residual" — the gap between the book's
     stated macros and what its ingredients actually add up to — which was
     added on to make the two agree. That hid the disagreement instead of
     showing it. The ingredients are the number; the gap is reported. */
  out.pro=Math.round(rows.reduce((a,x)=>a+x.p,0));
  out.cho=Math.round(rows.reduce((a,x)=>a+x.c,0));
  out.fat=Math.round(rows.reduce((a,x)=>a+x.f,0));
  out.mult = mult;

  // how far the ingredients sit from what the book claims, for the card
  const bookKcal = (+r.kcal||0) * mult;
  out.bookKcal = bookKcal || null;
  out.bookMacros = {pro:(+r.pro||0)*mult, cho:(+r.cho||0)*mult, fat:(+r.fat||0)*mult};
  out.bookGap  = bookKcal ? Math.round(4*out.pro+4*out.cho+9*out.fat) - bookKcal : 0;
  out.kcal=Math.round(4*out.pro + 4*out.cho + 9*out.fat);
  // each ingredient keeps its TRUE food-composition values (no smearing), so the
  // nutritionist breakdown is accurate per line
  out.ings=rows.filter(x=>!x.dropped).filter(x=>!x.i.header || x.i.raw.trim()).map(x=>({
    idx: x.idx,
    text: rescaleIngredientText(x.i, x.sg),
    scaled: x.i.scalable && Math.abs(x.sg-1)>0.04,
    // which way the amount moved, and what the recipe originally said, so the
    // list can show it rather than relying on the colour alone
    scaleUp: x.sg > 1,
    scalePct: Math.round(Math.abs(x.sg-1)*100),
    // countable things are shown as pieces, so the original should be too —
    // "1.5 Medium Banana" next to "recipe says 100g" reads as a mismatch
    baseAmount: (x.i.unit === 'g' || x.i.unit === 'ml')
      ? Math.round(x.i.grams / ((x.i.dens && x.i.dens>0) ? x.i.dens : 1))
      : (Math.round((x.i.qty||0)*100)/100),
    baseUnit: (x.i.unit === 'g' || x.i.unit === 'ml')
      ? (x.i.dunit || 'g')
      : '',
    edited: x.manual,
    editable: !x.i.header && !x.i.negligible && (x.i.pg+x.i.cg+x.i.fg)>0,
    header: !!x.i.header,
    negligible: !!x.i.negligible,
    src: x.i.src||'',
    // carried through so the swap control knows what this ingredient is and
    // what it could be exchanged for
    name: x.i.name || '',
    foodId: x.i.foodId || null,
    swapGroup: x.i.swapGroup || null,
    swappedFrom: x.i.swappedFrom || null,
    addedByHand: !!x.i.addedByHand,
    pg: x.i.pg, cg: x.i.cg, fg: x.i.fg,
    grams: Math.round(x.g),
    dens: (x.i.dens&&x.i.dens>0)? x.i.dens : 1,
    dunit: x.i.dunit || 'g',
    amount: Math.round(x.g/((x.i.dens&&x.i.dens>0)? x.i.dens : 1)),
    p:Math.round(x.p), c:Math.round(x.c), f:Math.round(x.f),
    kcal:Math.round(4*x.p+4*x.c+9*x.f)
  }));
  // the gap between the summed ingredients and the recipe book's stated macros
  // (marinades not fully consumed, cooking losses, unmodelled minor items)
  out.res={p:Math.round(res.p||0), c:Math.round(res.c||0), f:Math.round(res.f||0)};
  out.res.kcal=Math.round(4*(res.p||0)+4*(res.c||0)+9*(res.f||0));
  if(hasManual){ out.note='Amounts set by hand'; return out; }
  const near=Math.abs(out.cho-target.cho)<=4 && Math.abs(out.pro-target.pro)<=5 && Math.abs(out.fat-target.fat)<=6;
  // Nothing is scaled, so a note about fitting macros would be untrue. What
  // matters now is whether a person has changed it.
  out.note = hasManual ? 'Adjusted by hand' : 'As written';
  return out;
}
function carbStatus(cho){ return cho<40?'low':(cho<=70?'medium':'high'); }
const STATUS_COLOR={low:'#ef6d00',medium:'#d99a00',high:'#3f9e2b'};
const STATUS_LABEL={low:'Low Carb',medium:'Medium Carb',high:'High Carb'};
// representative carb grams for each tier (used by the per-meal Low/Med/High toggle)
// most a single meal or snack should carry, before we query it
const MEAL_CAP={pro:60, cho:160, fat:25};
// realistic single-portion ceilings, so a macro tweak can't produce a daft dish
const PORTION_MAX=[
  [/\b(dry|uncooked)?\s*(basmati|jasmine|white|brown|long grain)?\s*rice\b/i, 150, 'dry rice'],
  [/\b(pasta|spaghetti|tagliatelle|penne|fusilli|noodles?|macaroni)\b/i, 150, 'dry pasta/noodles'],
  [/\b(oats|porridge|granola|muesli|couscous|bulgur|quinoa)\b/i, 150, 'dry cereal/grain'],
  [/\boil\b/i, 40, 'oil'],
  [/\b(butter|ghee|lard)\b/i, 60, 'butter'],
  [/\b(peanut|almond|cashew|nut)\s*butter\b/i, 80, 'nut butter'],
  [/\bhoney|syrup|jam\b/i, 80, 'honey/syrup'],
  [/\b(chicken|beef|pork|lamb|turkey|salmon|cod|tuna|prawn|steak|mince|fillet|breast|thigh)\b/i, 400, 'meat/fish'],
  [/\b(cheese|feta|parmesan|halloumi)\b/i, 150, 'cheese'],
  [/\b(yoghurt|yogurt|skyr|quark)\b/i, 500, 'yoghurt'],
  [/\b(milk|cream)\b/i, 700, 'milk'],
  [/\b(bread|toast|pitta|wrap|tortilla|bagel|bun)\b/i, 250, 'bread'],
  [/\b(nuts?|seeds?|almonds?|walnuts?|cashews?|pecans?)\b/i, 80, 'nuts/seeds'],
  [/\b(sugar|chocolate|biscoff)\b/i, 80, 'sugar/chocolate']
];
function portionWarnings(scaled){
  if(!scaled || !scaled.ings) return [];
  const out=[];
  scaled.ings.forEach(i=>{
    if(i.header || !i.grams) return;
    for(const [re,max,label] of PORTION_MAX){
      if(re.test(i.text)){
        if(i.grams>max) out.push(i.text.replace(/\s*\(.*$/,'')+' — that\u2019s a lot for '+label);
        break;
      }
    }
  });
  return out;
}
function capWarnings(m){
  const out=[];
  if(m.cho>MEAL_CAP.cho) out.push('Carbs '+m.cho+'g (over the '+MEAL_CAP.cho+'g guide)');
  if(m.pro>MEAL_CAP.pro) out.push('Protein '+m.pro+'g (over the '+MEAL_CAP.pro+'g guide)');
  if(m.fat>MEAL_CAP.fat) out.push('Fat '+m.fat+'g (over the '+MEAL_CAP.fat+'g guide)');
  return out;
}
// ask before letting a single meal exceed the guide
function checkCap(m, key, value){
  const cap=MEAL_CAP[key];
  if(!cap || value<=cap || m.capOK) return value;
  const lbl={pro:'protein', cho:'carbs', fat:'fat'}[key];
  if(confirm(value+'g of '+lbl+' in one meal is above the '+cap+'g guide.\n\nKeep it anyway?')){
    m.capOK=true; return value;
  }
  return cap;
}
// A carb number per tier, used when the tier buttons aimed at a target and the
// recipe was scaled to meet it. The buttons now pick a recipe that genuinely
// IS that tier, so nothing aims at these.

/* ============ MACRO SYNC (sidebar) ============ */
// trim trailing zeros: 0.70 -> "0.7", 2.00 -> "2", accepts up to 2 dp
function fmtGkg(x){ return (Math.round(x*100)/100).toString(); }

function renderMacroEditor(){
  const bw=S.bw||90;
  const blank=!S.generated;   // before generation show empty fields, not zeros
  const defs=[['pro','Protein','#007934'],['cho','Carbohydrate','#c98a00'],['fat','Fat','#ef6d00']];
  const host=document.getElementById('macroEditor'); host.innerHTML='';
  defs.forEach(([key,label,col])=>{
    const g=S.global[key]||0;
    const gShow=(blank && g===0)?'':g;
    const gkgShow=(g>0)?fmtGkg(g/bw):'';
    const el=document.createElement('div'); el.className='macro';
    el.innerHTML=`
      <div class="top">
        <div class="nm"><span class="dot" style="background:${col}"></span>${label}</div>
        <div class="kcal" data-kcal="${key}">${Math.round(g*(key==='fat'?9:4))} kcal</div>
      </div>
      <div class="mini">
        <div class="g"><small>grams</small><input data-k="${key}" data-t="g" type="number" inputmode="decimal" step="1" min="0" value="${gShow}" placeholder="0"></div>
        <div class="eq">=</div>
        <div class="k"><small>g / kg BW</small><input data-k="${key}" data-t="gkg" type="number" inputmode="decimal" step="0.05" min="0" value="${gkgShow}" placeholder="0"></div>
      </div>`;
    host.appendChild(el);
  });
  // Live update WITHOUT rebuilding the field being typed in (so decimals like 0.7 can be entered).
  host.querySelectorAll('input').forEach(inp=>{
    inp.addEventListener('input',onMacroInput);
    // on blur, tidy only this field's display (no full rebuild — avoids DOM churn)
    inp.addEventListener('change',()=>{
      const bw2=S.bw||90, k=inp.dataset.k, t=inp.dataset.t, gv=S.global[k]||0;
      inp.value = (t==='g') ? (gv>0?gv:'') : (gv>0?fmtGkg(gv/bw2):'');
      updateKcalTotal();
    });
  });
  updateKcalTotal();
}
function updateKcalTotal(){
  const el=document.getElementById('kcalTotal'); if(el) el.textContent=kcalOf(S.global)+' kcal';
}
function onMacroInput(e){
  const inp=e.target;
  const k=inp.dataset.k, t=inp.dataset.t;
  const bw=S.bw||90;
  const raw=inp.value.trim();
  if(raw===''){ S.global[k]=0; }
  else if(raw==='.'){ return; }
  else {
    const v=parseFloat(raw); if(isNaN(v)) return;
    S.global[k] = (t==='g') ? Math.max(0,Math.round(v)) : Math.max(0,Math.round(v*bw));
  }
  const g=S.global[k];
  const row=inp.closest('.macro');
  const gInp=row.querySelector('input[data-t="g"]');
  const kInp=row.querySelector('input[data-t="gkg"]');
  // Update ONLY the partner field, never the one being typed in
  if(t==='g'){ if(document.activeElement!==kInp) kInp.value = g>0? fmtGkg(g/bw):''; }
  else       { if(document.activeElement!==gInp) gInp.value = g>0? g:''; }
  const kc=row.querySelector('[data-kcal]');
  if(kc) kc.textContent=Math.round(g*(k==='fat'?9:4))+' kcal';
  updateKcalTotal();
  if(!S.generated) renderDayTargets();
  save();
}
function onBodyweight(){
  const v=parseFloat(document.getElementById('bodyweight').value)||0;
  S.bw=v; renderMacroEditor();
  if(!S.generated) renderDayTargets(); else renderDayEditor();
  save(); // grams stay, g/kg recomputes
}

/* ============ EXCLUSIONS ============ */
function renderExclusions(){
  const host=document.getElementById('exclusions'); host.innerHTML='';

  // Anything already recorded against the selected player shows here too, so
  // you can see at a glance why a meal was changed or left out. These are not
  // toggleable — they belong to the player, and are edited on their profile.
  if(PLAYER_AVOIDS.length){
    const note=document.createElement('div'); note.className='exfrom';
    note.textContent = 'From ' + (S.player || 'this player') + "'s profile:";
    host.appendChild(note);
    const wrap=document.createElement('div'); wrap.className='extags';
    PLAYER_AVOIDS.forEach(a=>{
      const what = a.foods ? a.foods.name
                 : a.swap_group ? (PM_GROUP_LABELS[a.swap_group] || a.swap_group)
                 : a.allergen;
      const t=document.createElement('span');
      t.className='extag frmplayer '+(a.severity||'dislike');
      t.title = a.severity==='allergy' ? 'Allergy — never included'
              : a.severity==='intolerance' ? 'Intolerance — swapped out'
              : 'Dislike — swapped or removed';
      t.textContent=what;
      wrap.appendChild(t);
    });
    host.appendChild(wrap);
    const hr=document.createElement('div'); hr.className='exfrom';
    hr.textContent='Extra exclusions for this week only:';
    host.appendChild(hr);
  }

  const wrap=document.createElement('div'); wrap.className='extags';
  EXCLUSIONS.forEach(e=>{
    const on=S.excl.includes(e);
    const b=document.createElement('button');
    b.className='extag'+(on?' on':'');
    b.innerHTML=esc(e)+(on?'<span class="x">✕</span>':'');
    b.onclick=()=>{ if(on) S.excl=S.excl.filter(x=>x!==e); else S.excl.push(e);
      refreshAllMatches(); renderExclusions(); renderMeals(); save(); };
    wrap.appendChild(b);
  });
  host.appendChild(wrap);
}

/* ============ DAY TABS & HEADER ============ */
function renderDayTabs(){
  const host=document.getElementById('dayTabs'); host.innerHTML='';
  DAYS.forEach(d=>{
    const dd=S.days[d]; const b=document.createElement('button');
    b.className='daytab'+(d===S.active?' active':''); b.textContent=DAYFULL[d].slice(0,3);
    if(dd.type!=='Normal'){ const t=document.createElement('span'); t.className='gd';
      t.textContent=dd.type==='Game Day'?'GD':dd.type.replace('Game Day ','GD'); b.appendChild(t); }
    b.onclick=()=>{ S.active=d; render(); save(); };
    host.appendChild(b);
  });
}
function renderDayTypeChips(){
  const host=document.getElementById('dayTypeChips'); host.innerHTML='';
  const day=S.days[S.active];
  DAYTYPES.forEach(t=>{
    const on=day.type===t; const b=document.createElement('button');
    b.className='chip'+(on?(t==='Normal'?' on':' on amber'):''); b.textContent=t;
    b.onclick=()=>{ changeDayType(t); };
    host.appendChild(b);
  });
}
function changeDayType(t){
  const day=S.days[S.active];
  if(day.type===t) return;
  // if this player has their own g/kg for this day type, use it as the starting
  // point. It is only a starting point — the day's targets stay editable.
  const fromPlayer=targetsForDayType(t);
  const base = fromPlayer || {cho:day.cho, pro:day.pro, fat:day.fat};
  S.days[S.active]=buildDay(t, base);
  S.dayTargets[S.active]={pro:base.pro, cho:base.cho, fat:base.fat};
  S.dayTypes[S.active]=t;
  refreshDayMatches(S.active);
  render(); save();
  if(fromPlayer) toast(S.player+"'s "+t+' targets applied — edit them if this day is different');
}


/* ============ FOODS A PLAYER AVOIDS ============
   A dislike is no use sitting in the database. Every recipe considered for this
   player is checked against the list: seasoning is dropped, the thing the dish
   is built around is swapped, and if neither is possible the recipe is set aside. */
let PLAYER_AVOIDS = [];
// Adapting a recipe makes a copy. Without somewhere to keep it, every later
// lookup by id finds the untouched original — and the ingredient the player
// avoids reappears in the meal card, the scaling and the PDF.
let ADAPTED = new Map();
function recipeById(id){ return ADAPTED.get(id) || RECIPES.find(x=>x.id===id); }

async function loadPlayerAvoids(id){
  PLAYER_AVOIDS = []; ADAPTED = new Map();
  if(!id) return;
  try{ PLAYER_AVOIDS = await window.CNLib.sbAvoids(id); }
  catch(e){ console.warn('avoids load failed', e.message); }
}

// The fourteen things that actually appear in an allergens column. Treating a
// blank column as unsafe only makes sense for these — for free text like
// "onion" it would match every food that has nothing recorded, which is most
// of them, and quietly empty the whole plan.
const REAL_ALLERGENS = ['gluten','wheat','milk','dairy','egg','fish','crustacean',
  'mollusc','peanut','nut','soy','soya','sesame','celery','mustard','lupin','sulphite'];

// does this ingredient fall foul of the list?
function avoidHit(ing){
  for(const a of PLAYER_AVOIDS){
    if(a.food_id && ing.foodId === a.food_id) return a;
    // a category rules out everything in it, so "no pork" also rules out ham
    if(a.swap_group && ing.swapGroup === a.swap_group) return a;
    if(a.allergen){
      const term = String(a.allergen).toLowerCase().trim();
      const dec = (ing.allergens||'').toLowerCase();
      const known = REAL_ALLERGENS.some(x=>term.includes(x));
      if(dec && dec.includes(term)) return a;
      // free text is matched against the food's name, so typing "onion"
      // still catches onion even though it is not an allergen
      if(!known && String(ing.name||'').toLowerCase().includes(term)) return a;
      /* A blank allergen field used to mean "assume unsafe" — which silently
         pulled garlic, passata and oregano out of a bolognese because nobody
         had filled their allergen column in. Removing them does not make the
         dish safe; it just makes the plan wrong while the method still says to
         use them. The meal is flagged instead, so a person decides. */
      if(known && !dec && a.severity === 'allergy'){
        ing.allergenUnknown = ing.allergenUnknown || [];
        if(ing.allergenUnknown.indexOf(term) < 0) ing.allergenUnknown.push(term);
      }
    }
  }
  return null;
}

// where to look next when nothing in a food's own group will do. Pork to
// poultry, rice to other grains: what someone who knows food would reach for.
const SWAP_FAMILY = {
  poultry:['pork','white_fish','red_meat','plant_protein'],
  pork:['poultry','red_meat','white_fish'],
  red_meat:['poultry','pork','plant_protein'],
  white_fish:['oily_fish','shellfish','poultry'],
  oily_fish:['white_fish','shellfish','poultry'],
  shellfish:['white_fish','poultry','oily_fish'],
  plant_protein:['legume','poultry','egg'],
  legume:['plant_protein','poultry'], egg:['poultry','plant_protein'],
  yoghurt:['cream_dairy','protein_powder'], protein_powder:['yoghurt'],
  rice:['other_grain','pasta','potato','noodle'], pasta:['noodle','rice','other_grain'],
  noodle:['pasta','rice'], potato:['rice','other_grain'], bread:['potato','rice'],
  oats:['other_grain'], other_grain:['rice','pasta','potato'],
  leafy_green:['brassica','other_veg'], brassica:['leafy_green','other_veg'],
  root_veg:['squash','other_veg'], squash:['root_veg','other_veg'],
  allium:['other_veg'], pepper_chilli:['other_veg'], tomato:['other_veg'],
  mushroom:['other_veg'], other_veg:['brassica','leafy_green'],
  berry:['orchard_fruit','tropical_fruit'], tropical_fruit:['orchard_fruit','berry'],
  orchard_fruit:['berry','tropical_fruit'], citrus:['orchard_fruit'],
  nut_butter:['nut_seed'], nut_seed:['nut_butter'],
  cheese:['yoghurt','cream_dairy'], cream_dairy:['yoghurt','oil'],
  // fat sources: another oil first, then butter and the like
  oil:['cream_dairy','nut_butter'],
  sweetener:['orchard_fruit'], sauce:['spice_herb']
};
// the nearest sensible stand-in: own group first, then the family
function findSwap(ing){
  if(!ing.swapGroup || !LIB_FOODS.length) return null;
  const d = f => Math.abs(f.protein_100g - ing.pg*100)
               + Math.abs(f.carbs_100g   - ing.cg*100)
               + Math.abs(f.fat_100g     - ing.fg*100);
  const groups = [ing.swapGroup].concat(SWAP_FAMILY[ing.swapGroup] || []);
  for(const g of groups){
    const pool = LIB_FOODS.filter(f =>
      f.swap_group === g && f.id !== ing.foodId &&
      !avoidHit({foodId:f.id, swapGroup:f.swap_group, allergens:f.allergens}));
    if(pool.length){ pool.sort((a,b)=>d(a)-d(b)); return pool[0]; }
  }
  return null;
}

/* What would this recipe need for this player?
   drops:  seasoning and side vegetables that can simply come out
   swaps:  the anchor or carbohydrate exchanged for something similar
   blocked: no way to make it work, so it is kept out of the plan          */
function assessRecipe(r){
  const out = {status:'ok', drops:[], swaps:[], worst:'dislike'};
  if(!PLAYER_AVOIDS.length || !r.ings) return out;
  for(const ing of r.ings){
    if(ing.header) continue;
    const hit = avoidHit(ing);
    if(!hit) continue;
    if(hit.severity === 'allergy') out.worst = 'allergy';
    else if(hit.severity === 'intolerance' && out.worst !== 'allergy') out.worst = 'intolerance';

    const role = ing.role || (ing.negligible ? 'flavouring' : 'supporting');
    if(role === 'flavouring' || (role === 'supporting' && ing.grams < 60)){
      out.drops.push({ing, sev:hit.severity});
      out.status = 'adjusted';
      continue;
    }
    const alt = findSwap(ing);
    if(alt){
      out.swaps.push({ing, to:alt, sev:hit.severity});
      out.status = 'adjusted';
    }else{
      // the dish is built on it and there is nothing to put in its place
      out.status = 'blocked';
      out.blockedBy = ing.name;
      return out;
    }
  }
  return out;
}

// returns a copy of the recipe with the changes made, leaving the original alone
function adaptRecipe(r, assessment){
  if(!assessment || assessment.status !== 'adjusted') return r;
  const copy = Object.assign({}, r);
  const dropped = new Set(assessment.drops.map(d=>d.ing));
  const swapMap = new Map(assessment.swaps.map(s=>[s.ing, s.to]));
  copy.ings = r.ings.filter(i=>!dropped.has(i)).map(i=>{
    const to = swapMap.get(i);
    if(!to) return i;
    return Object.assign({}, i, {
      name: to.name, foodId: to.id, swapGroup: to.swap_group,
      allergens: to.allergens,
      pg: (+to.protein_100g)/100, cg: (+to.carbs_100g)/100, fg: (+to.fat_100g)/100,
      raw: i.raw.replace(i.name, to.name),
      swappedFrom: i.name
    });
  });
  copy.ingredients = copy.ings.map(i=>i.raw);
  copy.adapted = assessment;
  return copy;
}

// one line a human can read, for the screen and the PDF
// what has been taken out by hand, for the card and the PDF
function droppedNote(m){
  const r = recipeById(m.recipeId);
  if(!r || !m.dropped) return '';
  const names = Object.keys(m.dropped)
    .map(i=>(r.ings[+i]||{}).name).filter(Boolean);
  return names.length ? 'Made without ' + names.join(', ').toLowerCase() : '';
}

function adaptationNote(a){
  if(!a || a.status === 'ok') return '';
  if(a.status === 'blocked') return 'Left out — built around ' + a.blockedBy;
  const bits = [];
  if(a.drops.length) bits.push('without ' + a.drops.map(d=>d.ing.name.toLowerCase()).join(', '));
  a.swaps.forEach(s=>bits.push(s.ing.name.toLowerCase() + ' swapped for ' + s.to.name.toLowerCase()));
  return bits.join(' · ');
}


/* ============ RECIPE DATABASE ============ */
let RDB_REVIEW = [];

async function openRecipeDb(){
  document.getElementById('recipeDbModal').style.display='';
  document.getElementById('rdbSearch').value='';
  document.getElementById('rdbSlot').value='';
  document.getElementById('rdbView').value='active';
  try{ RDB_REVIEW = await window.CNLib.sbNeedsReview(); }catch(e){ RDB_REVIEW=[]; }
  renderRecipeDb();
}
function closeRecipeDb(){ document.getElementById('recipeDbModal').style.display='none'; }

async function renderRecipeDb(){
  const host=document.getElementById('rdbList');
  const q=(document.getElementById('rdbSearch').value||'').toLowerCase().trim();
  const slot=document.getElementById('rdbSlot').value;
  const view=document.getElementById('rdbView').value;
  host.innerHTML='<div class="libempty">Loading…</div>';

  if(view==='validate'){
    if(!RDB_VALIDATION.length) await loadValidation();
    host.innerHTML='';
    renderValidation(host);
    document.getElementById('rdbCount').textContent =
      RDB_VALIDATION.length ? RDB_VALIDATION.length + ' checked against their ingredients' : '';
    return;
  }

  if(view==='archived'){
    let rows=[];
    try{ rows=await window.CNLib.sbArchivedRecipes(); }
    catch(e){ host.innerHTML='<div class="libempty">Could not load: '+esc(e.message)+'</div>'; return; }
    rows=rows.filter(r=>!q || r.name.toLowerCase().includes(q));
    document.getElementById('rdbCount').textContent=rows.length+' archived';
    if(!rows.length){ host.innerHTML='<div class="libempty">Nothing archived.</div>'; return; }
    host.innerHTML='';
    rows.forEach(r=>{
      const row=document.createElement('div'); row.className='rdbrow';
      const left = r.days_left==null
        ? 'kept indefinitely (from the book)'
        : (r.days_left+' day'+(r.days_left===1?'':'s')+' before it is cleared');
      row.innerHTML='<div><div class="rn">'+esc(r.name)+'</div><div class="rs">'+esc(r.slot||'')+
        '</div></div><div class="rm">'+r.ingredients+' ingredients</div><div class="rm">'+esc(left)+'</div>';
      const act=document.createElement('div'); act.className='ra';
      const un=document.createElement('button'); un.textContent='Restore';
      un.onclick=async()=>{ try{ await window.CNLib.sbRestoreRecipe(r.id);
        toast('"'+r.name+'" restored'); await loadLibrary(true); renderLibList(); renderRecipeDb(); }
        catch(e){ toast('Could not restore: '+e.message); } };
      act.appendChild(un); row.appendChild(act); host.appendChild(row);
    });
    return;
  }

  const flagged=new Map(RDB_REVIEW.filter(x=>x.kind==='recipe').map(x=>[x.id,x]));
  let rows=LIB_RECIPES.slice();
  if(view==='review') rows=rows.filter(r=>flagged.has(r.dbId));
  if(slot) rows=rows.filter(r=>r.category===slot);
  if(q) rows=rows.filter(r=>r.name.toLowerCase().includes(q));
  rows.sort((a,b)=>a.name.localeCompare(b.name));

  document.getElementById('rdbCount').textContent =
    rows.length+' of '+LIB_RECIPES.length + (view==='review' ? ' needing a look' : '');
  if(!rows.length){ host.innerHTML='<div class="libempty">Nothing matches.</div>'; return; }

  host.innerHTML='';
  rows.forEach(r=>{
    const row=document.createElement('div'); row.className='rdbrow';
    const f=flagged.get(r.dbId);
    row.innerHTML='<div><div class="rn">'+esc(r.name)+
      (r.source==='master'?'<span class="rdbtag">book</span>':'')+'</div>'+
      '<div class="rs">'+esc(r.category||'')+'</div>'+
      (f&&f.note?'<div class="rdbflag">'+esc(f.note)+'</div>':'')+'</div>'+
      '<div class="rm">'+(r.servings||1)+' serving'+((r.servings||1)===1?'':'s')+'</div>'+
      '<div class="rm">'+r.pro+'P · '+r.cho+'C · '+r.fat+'F · '+r.kcal+'kcal</div>';
    const act=document.createElement('div'); act.className='ra';

    const ed=document.createElement('button'); ed.textContent='Edit';
    ed.onclick=e=>{ e.stopPropagation(); openRecipeEditor(r.dbId); };
    act.appendChild(ed);
    // clicking the row is what people reach for before finding the button
    row.style.cursor='pointer';
    row.onclick=e=>{ if(e.target.closest('button')) return; openRecipeEditor(r.dbId); };

    if(f){
      const ok=document.createElement('button'); ok.textContent='Mark checked';
      ok.onclick=async()=>{ try{ await window.CNLib.sbClearReview(r.dbId, S.player||null);
        RDB_REVIEW=RDB_REVIEW.filter(x=>x.id!==r.dbId); renderRecipeDb(); toast('Cleared'); }
        catch(e){ toast('Could not clear: '+e.message); } };
      act.appendChild(ok);
    }

    const ar=document.createElement('button'); ar.className='danger'; ar.textContent='Archive';
    ar.onclick=async()=>{
      const isBook = r.source==='master';
      if(!confirm('Archive "'+r.name+'"?\n\nIt comes out of the plan builder for everyone, but '+
        (isBook ? 'it is kept indefinitely and can be restored at any time.'
                : 'it can be restored for the next 30 days.'))) return;
      try{ await window.CNLib.sbArchiveRecipe(r.dbId, S.player||null);
        toast('"'+r.name+'" archived — restore it from the Archived list');
        await loadLibrary(true); renderLibList(); renderRecipeDb(); }
      catch(e){ toast('Could not archive: '+e.message); }
    };
    act.appendChild(ar);
    row.appendChild(act); host.appendChild(row);
  });
}

/* ============ SUPPLEMENTS ============ */
let SUPPS = [], DAY_SLOTS = [];

async function openSupplements(){
  document.getElementById('suppModal').style.display='';
  spClearForm();
  try{
    if(!DAY_SLOTS.length) DAY_SLOTS = await window.CNLib.sbDaySlots();
  }catch(e){ DAY_SLOTS=[]; }
  const sel=document.getElementById('spSlot');
  sel.innerHTML='<option value="">—</option>' + DAY_SLOTS.map(s=>
    '<option value="'+esc(s.slot)+'">'+esc(s.label)+'</option>').join('');
  await renderSupplements();
}
function closeSupplements(){ document.getElementById('suppModal').style.display='none'; }
function spClearForm(){
  ['spId','spName','spBrand','spDose','spNotes'].forEach(i=>{
    const el=document.getElementById(i); if(el) el.value='';
  });
  document.getElementById('spFormTitle').textContent='Add a supplement';
}
async function renderSupplements(){
  const host=document.getElementById('spList');
  host.innerHTML='<div class="libempty">Loading…</div>';
  try{ SUPPS = await window.CNLib.sbSupplements(); }
  catch(e){ host.innerHTML='<div class="libempty">Could not load: '+esc(e.message)+'</div>'; return; }
  if(!SUPPS.length){ host.innerHTML='<div class="libempty">None yet.</div>'; return; }
  const label=sl=>{ const s=DAY_SLOTS.find(x=>x.slot===sl); return s?s.label:(sl||'—'); };
  host.innerHTML='';
  SUPPS.forEach(x=>{
    const row=document.createElement('div'); row.className='rdbrow';
    row.innerHTML='<div><div class="rn">'+esc(x.name)+
      (x.source==='master'?'<span class="rdbtag">standard</span>':'')+'</div>'+
      (x.brand?'<div class="rs">'+esc(x.brand)+'</div>':'')+
      (x.notes?'<div class="rdbflag">'+esc(x.notes)+'</div>':'')+'</div>'+
      '<div class="rm">'+(x.dose_amount!=null? (+x.dose_amount)+' '+esc(x.dose_unit||'') : '—')+'</div>'+
      '<div class="rm">'+esc(label(x.default_slot))+'</div>';
    const act=document.createElement('div'); act.className='ra';
    const ed=document.createElement('button'); ed.textContent='Edit';
    ed.onclick=()=>{
      document.getElementById('spId').value=x.id;
      document.getElementById('spName').value=x.name||'';
      document.getElementById('spBrand').value=x.brand||'';
      document.getElementById('spDose').value=x.dose_amount!=null?x.dose_amount:'';
      document.getElementById('spUnit').value=x.dose_unit||'g';
      document.getElementById('spSlot').value=x.default_slot||'';
      document.getElementById('spNotes').value=x.notes||'';
      document.getElementById('spFormTitle').textContent='Editing '+x.name;
    };
    const rm=document.createElement('button'); rm.className='danger'; rm.textContent='Remove';
    rm.onclick=async()=>{
      if(!confirm('Remove "'+x.name+'" from the supplement list?')) return;
      try{ await window.CNLib.sbDeleteSupplement(x.id); await renderSupplements(); toast('Removed'); }
      catch(e){ toast('Could not remove: '+e.message); }
    };
    act.appendChild(ed); act.appendChild(rm); row.appendChild(act); host.appendChild(row);
  });
}
async function saveSupplement(){
  const name=document.getElementById('spName').value.trim();
  if(!name){ toast('Give it a name first'); return; }
  const dose=parseFloat(document.getElementById('spDose').value);
  try{
    await window.CNLib.sbSaveSupplement({
      id:document.getElementById('spId').value||null, name:name,
      brand:document.getElementById('spBrand').value.trim()||null,
      dose_amount:isNaN(dose)?null:dose,
      dose_unit:document.getElementById('spUnit').value||null,
      default_slot:document.getElementById('spSlot').value||null,
      notes:document.getElementById('spNotes').value.trim()||null});
    spClearForm(); await renderSupplements(); toast('Saved');
  }catch(e){ toast(/duplicate|unique/i.test(e.message)?'That supplement is already in the list':'Could not save: '+e.message); }
}


/* ============ SUPPLEMENTS IN THE PLAN ============
   The player's standing protocol drops onto every day. Changing one on a single
   day changes only that day; the protocol itself is untouched. */

// how the non-meal slots sit against the meals in a day
const SLOT_ORDER = {waking:10, breakfast:20, pre_training:30, post_training:40,
                    snack:50, lunchdinner:60, smoothie:70, bed:80};
const SLOT_LABEL = {waking:'On waking', pre_training:'Pre-training',
                    post_training:'Post-training', bed:'Before bed',
                    breakfast:'With breakfast', snack:'With a snack',
                    lunchdinner:'With lunch or dinner', smoothie:'With a smoothie'};
// roughly when each slot happens, so supplements slot in among the meals
const SLOT_TIME = {waking:'07:00', breakfast:'08:00', pre_training:'11:00',
                   post_training:'15:00', snack:'16:00', lunchdinner:'13:00',
                   smoothie:'11:30', bed:'22:00'};

// put the player's protocol onto every day that has not been touched
function applySupplementProtocol(){
  if(!S.days) return;
  DAYS.forEach(d=>{
    const day=S.days[d]; if(!day) return;
    if(day.suppsEdited) return;      // this day has been changed by hand, leave it
    day.supps = (PLAYER_SUPPS||[]).map(x=>({
      id: 'sp_'+x.id+'_'+d,
      protocolId: x.id,
      name: (x.supplements && x.supplements.name) || 'Supplement',
      dose: x.dose_amount, unit: x.dose_unit || '',
      slot: x.slot || 'breakfast'
    }));
  });
}
let PLAYER_SUPPS = [];
async function loadPlayerSupps(id){
  PLAYER_SUPPS = [];
  if(!id) return;
  try{ PLAYER_SUPPS = await window.CNLib.sbPlayerSupplements(id); }
  catch(e){ console.warn('supplement protocol load failed', e.message); }
  applySupplementProtocol();
}

function suppCard(sp, day){
  const el=document.createElement('div'); el.className='supp';
  el.innerHTML =
    '<div class="sptime">'+esc(SLOT_LABEL[sp.slot]||sp.slot||'')+'</div>'+
    '<div class="spname">'+esc(sp.name)+'</div>'+
    '<div class="spdose">'+
      '<input class="inp" type="number" step="0.5" min="0" value="'+(sp.dose!=null?sp.dose:'')+'" aria-label="dose">'+
      '<span class="spu">'+esc(sp.unit||'')+'</span>'+
    '</div>'+
    '<select class="inp spslot">'+
      Object.keys(SLOT_ORDER).map(k=>'<option value="'+k+'"'+(k===sp.slot?' selected':'')+'>'+
        esc(SLOT_LABEL[k]||k)+'</option>').join('')+
    '</select>'+
    '<button class="spdel" title="Remove from this day">✕</button>';

  const markEdited=()=>{ day.suppsEdited=true; save(); };
  el.querySelector('input').addEventListener('change', e=>{
    const v=parseFloat(e.target.value); sp.dose=isNaN(v)?null:v; markEdited();
    // redraw so the "this day differs" note and the reset button show up
    // straight away rather than waiting for something else to trigger it.
    // change fires on blur, so nothing is typing when this runs.
    renderMeals();
  });
  el.querySelector('.spslot').addEventListener('change', e=>{
    sp.slot=e.target.value; markEdited(); renderMeals();
  });
  el.querySelector('.spdel').onclick=()=>{
    day.supps=day.supps.filter(x=>x!==sp); markEdited(); renderMeals();
    toast('Removed from this day only — the player\'s protocol is unchanged');
  };
  return el;
}

// add one to just this day
async function addSuppToDay(){
  const day=S.days[S.active]; if(!day) return;
  try{ if(!SUPPS.length) SUPPS = await window.CNLib.sbSupplements(); }catch(e){}
  if(!SUPPS.length){ toast('No supplements in the list yet — add some under Supplements'); return; }
  const names=SUPPS.map((x,i)=>(i+1)+'. '+x.name).join('\n');
  const pick=prompt('Add to '+DAYFULL[S.active]+' only.\n\n'+names+'\n\nType a number:');
  const i=parseInt(pick,10)-1;
  if(isNaN(i) || !SUPPS[i]) return;
  const x=SUPPS[i];
  day.supps=(day.supps||[]).concat([{id:'sp_ad_'+Date.now(), name:x.name,
    dose:x.dose_amount, unit:x.dose_unit||'', slot:x.default_slot||'breakfast'}]);
  day.suppsEdited=true; save(); renderMeals();
}
// put this day back to the player's standing protocol
function resetDaySupps(){
  const day=S.days[S.active]; if(!day) return;
  day.suppsEdited=false; applySupplementProtocol(); save(); renderMeals();
  toast('Back to '+(S.player||'the player')+"'s usual protocol for this day");
}


/* ============ SWAPPING AN INGREDIENT BY HAND ============
   Click the arrows on any ingredient to use something else instead. The swap
   is remembered against that meal only — the recipe in the library is not
   touched — and the scaler re-solves afterwards, so the meal still lands on
   its targets whatever went in. */

// alternatives for an ingredient: its own group first, then the family
function swapOptions(ing){
  if(!ing || !ing.swapGroup) return [];
  const groups=[ing.swapGroup].concat(SWAP_FAMILY[ing.swapGroup]||[]);
  const d=f=>Math.abs(f.protein_100g-ing.pg*100)+Math.abs(f.carbs_100g-ing.cg*100)
            +Math.abs(f.fat_100g-ing.fg*100);
  const out=[];
  groups.forEach(g=>{
    LIB_FOODS.filter(f=>f.swap_group===g && f.id!==ing.foodId)
      .sort((a,b)=>d(a)-d(b))
      .forEach(f=>{ if(out.length<14 && !out.some(x=>x.id===f.id)) out.push(f); });
  });
  return out;
}

function openSwapMenu(m, idx, anchor){
  const scaled=currentScaled(m);
  const ing=scaled && scaled.ings && scaled.ings.find(x=>x.idx===idx);
  if(!ing){ return; }
  document.querySelectorAll('.swapmenu').forEach(x=>x.remove());
  const menu=document.createElement('div'); menu.className='swapmenu';

  // ---- change how much of it ----
  const amtWrap=document.createElement('div'); amtWrap.className='imamt';
  amtWrap.innerHTML='<div class="swaphd"><b>'+esc(ing.name)+'</b></div>'+
    '<div class="scamt"><label>Amount</label>'+
    '<input class="inp" type="number" min="0" step="5" value="'+ing.amount+'">'+
    '<span class="scu">'+esc(ing.dunit||'g')+'</span>'+
    '<button class="btn small" type="button">Update</button></div>'+
    '<div class="imdiff"></div>';
  menu.appendChild(amtWrap);

  const inp=amtWrap.querySelector('input');
  const diff=amtWrap.querySelector('.imdiff');
  const showDiff=()=>{
    const v=parseFloat(inp.value);
    if(isNaN(v) || v<0){ diff.innerHTML=''; return; }
    const grams=Math.round(v*((ing.dens&&ing.dens>0)?ing.dens:1));
    const pv=previewAmount(m, idx, grams);
    if(!pv){ diff.innerHTML=''; return; }
    diff.innerHTML=diffTable(pv);
  };
  inp.addEventListener('input', showDiff);
  amtWrap.querySelector('button').onclick=()=>{
    const v=parseFloat(inp.value);
    if(isNaN(v) || v<0){ return; }
    setIngredientGrams(m, idx, v*((ing.dens&&ing.dens>0)?ing.dens:1));
    renderMeals(); save(); menu.remove();
  };
  showDiff();

  // ---- or use something else ----
  const hd=document.createElement('div'); hd.className='swaphd sep';
  hd.textContent='Or use something else instead';
  menu.appendChild(hd);

  // anything in the food library, not only the suggestions
  const srch=document.createElement('div'); srch.className='imsearch';
  srch.innerHTML='<input class="inp" placeholder="Search all '+LIB_FOODS.length+
    ' foods…" autocomplete="off">';
  menu.appendChild(srch);

  const list=document.createElement('div'); list.className='imopts';
  menu.appendChild(list);

  const optRow=(f, suggested)=>{
    const b=document.createElement('button'); b.className='swapopt';
    const sameGroup = f.swap_group===ing.swapGroup;
    b.innerHTML='<span class="sn">'+esc(f.name)+'</span>'+
      '<span class="sm">'+Math.round(f.protein_100g)+'P · '+Math.round(f.carbs_100g)+
      'C · '+Math.round(f.fat_100g)+'F per 100'+(f.default_unit==='ml'?'ml':'g')+'</span>'+
      (sameGroup ? '' :
        '<span class="sg'+(suggested?'':' far')+'">'+
        esc(String(f.swap_group||'other').replace(/_/g,' '))+'</span>');
    b.onclick=()=>{ confirmSwap(m, idx, f, menu); };
    return b;
  };
  const drawOpts=(q)=>{
    list.innerHTML='';
    if(q && q.length>=2){
      const hits=LIB_FOODS.filter(f=>f.id!==ing.foodId &&
        String(f.name).toLowerCase().includes(q)).slice(0,25);
      if(!hits.length){ list.innerHTML='<div class="swapempty">Nothing matching “'+esc(q)+'”.</div>'; return; }
      hits.forEach(f=>list.appendChild(optRow(f,false)));
    }else{
      const opts=swapOptions(ing);
      if(!opts.length){
        list.innerHTML='<div class="swapempty">'+
          (ing.swapGroup ? 'No close matches in the library.'
                         : 'This ingredient has no swap group set, so there are no '+
                           'suggestions — search above for anything in the library.')+
          '</div>';
        return;
      }
      opts.forEach(f=>list.appendChild(optRow(f,true)));
    }
  };
  drawOpts('');
  const si=srch.querySelector('input');
  si.addEventListener('input', ()=>drawOpts(si.value.trim().toLowerCase()));
  if(false){
    const rm=document.createElement('button'); rm.className='swapopt remove';
    rm.textContent='✕ Take this out of the meal';
    rm.onclick=()=>{
      // the dish is built around its anchor — taking that out leaves the
      // solver to find the protein somewhere else, which is rarely wanted
      const role = ing.role;
      const lost = Math.round((ing.pg||0) * (ing.grams||0));
      if(role === 'anchor' || role === 'base'){
        const what = role === 'anchor' ? 'the main protein' : 'the main carbohydrate';
        if(!confirm('"' + ing.name + '" is ' + what + ' in this dish.\n\n' +
          'Taking it out leaves ' + lost + 'g of protein to find elsewhere, and the ' +
          'other ingredients will be scaled up to compensate.\n\nTake it out anyway?')) return;
      }
      m.dropped = m.dropped || {};
      m.dropped[idx] = true;
      if(m.ovr) delete m.ovr[idx];
      if(m.touch) delete m.touch[idx];
      syncMealToIngredients(m); refreshOneMeal(m); menu.remove();
      toast('Taken out of this meal — the recipe in the library is unchanged');
    };
    menu.appendChild(rm);
  }
  if((m.dropped||{})[idx]){
    const put=document.createElement('button'); put.className='swapopt undo';
    put.textContent='↩ Put it back';
    put.onclick=()=>{ delete m.dropped[idx];
      syncMealToIngredients(m); refreshOneMeal(m); menu.remove(); };
    menu.appendChild(put);
  }
  if(ing.addedByHand){
    const rm=document.createElement('button'); rm.className='swapopt remove';
    rm.textContent='✕ Remove this ingredient';
    rm.onclick=()=>{
      // extras sit after the recipe's own ingredients, in the order added
      const base=(recipeById(m.recipeId)||{ings:[]}).ings.length;
      m.extras=(m.extras||[]).filter((x,i)=>i !== (idx-base));
      if(m.ovr) delete m.ovr[idx];
      if(m.touch) delete m.touch[idx];
      syncMealToIngredients(m); refreshOneMeal(m); menu.remove();
      toast('Removed from this meal');
    };
    menu.appendChild(rm);
  }
  if(m.swaps && m.swaps[idx]){
    const u=document.createElement('button'); u.className='swapopt undo';
    u.textContent='↩ Put the original ingredient back';
    u.onclick=()=>{ delete m.swaps[idx]; if(m.ovr) delete m.ovr[idx];
      syncMealToIngredients(m); refreshOneMeal(m); menu.remove(); };
    menu.appendChild(u);
  }
  anchor.parentElement.appendChild(menu);
  const off=e=>{ if(!menu.contains(e.target)){ menu.remove(); document.removeEventListener('click',off,true);} };
  setTimeout(()=>document.addEventListener('click',off,true),0);
}

/* ---- taking an ingredient out, from the list itself ---- */
function confirmDropIngredient(m, idx, anchor){
  document.querySelectorAll('.dropconfirm').forEach(x=>x.remove());
  const scaled = currentScaled(m);
  const ing = scaled && scaled.ings && scaled.ings.find(x=>x.idx===idx);
  if(!ing) return;

  // already out? put it back without asking
  if((m.dropped||{})[idx]){
    delete m.dropped[idx];
    syncMealToIngredients(m); refreshOneMeal(m);
    return;
  }

  /* Something added by hand is not part of the recipe, so marking it dropped
     did nothing — the dropped list only covers the recipe's own ingredients.
     It comes straight back out of the extras instead. */
  if(ing.addedByHand){
    const base = (recipeById(m.recipeId)||{ings:[]}).ings.length;
    const at = idx - base;
    const name = ing.name || ing.text;
    if(at >= 0 && m.extras && m.extras[at]){
      m.extras.splice(at, 1);
      if(m.ovr) delete m.ovr[idx];
      if(m.touch) delete m.touch[idx];
      syncMealToIngredients(m); refreshOneMeal(m);
      toast(name + ' removed');
      return;
    }
  }

  // what it would cost, worked out before anything changes
  const r = recipeById(m.recipeId);
  const trial = Object.assign({}, m, {dropped: Object.assign({}, m.dropped||{}, {[idx]:true})});
  const after = r ? scaledRecipe(applySwapsToRecipe(r, trial),
                      {cho:m.cho, pro:m.pro, fat:m.fat}, null) : null;

  const box = document.createElement('div'); box.className = 'dropconfirm';
  const role = ing.role;
  const warn = (role === 'anchor') ? 'This is the main protein in the dish.'
             : (role === 'base')   ? 'This is the main carbohydrate in the dish.' : '';
  box.innerHTML =
    '<div class="dch">Take <b>' + esc(ing.name || ing.text) + '</b> out of this meal?</div>' +
    (warn ? '<div class="dcw">' + warn + '</div>' : '') +
    (after ? '<div class="dcm">The meal becomes <b>' + Math.round(after.pro) + 'g protein · ' +
             Math.round(after.cho) + 'g carbs · ' + Math.round(after.fat) + 'g fat</b>, and the ' +
             'other ingredients are re-worked to make up the difference.</div>' : '') +
    '<div class="dcb"><button class="btn small ghost" data-no>Cancel</button>' +
    '<button class="btn small" data-yes>Take it out</button></div>';

  box.querySelector('[data-no]').onclick = e => { e.stopPropagation(); box.remove(); };
  box.querySelector('[data-yes]').onclick = e => {
    e.stopPropagation();
    m.dropped = m.dropped || {};
    m.dropped[idx] = true;
    if(m.ovr) delete m.ovr[idx];
    if(m.touch) delete m.touch[idx];
    syncMealToIngredients(m);
    box.remove();
    refreshOneMeal(m);
    toast('Taken out of this meal — the recipe in the library is unchanged');
  };

  anchor.parentElement.appendChild(box);
  const off = e => { if(!box.contains(e.target)){ box.remove();
    document.removeEventListener('click', off, true); } };
  setTimeout(()=>document.addEventListener('click', off, true), 0);
}

/* ---- adding an ingredient to one meal ---- */
function openAddIngredient(m, anchor){
  document.querySelectorAll('.swapmenu').forEach(x=>x.remove());
  const menu=document.createElement('div'); menu.className='swapmenu';
  menu.innerHTML='<div class="swaphd">Add to this meal</div>'+
    '<div class="imsearch"><input class="inp" placeholder="Search all '+LIB_FOODS.length+
    ' foods…" autocomplete="off"></div><div class="imopts"></div>';
  const list=menu.querySelector('.imopts');
  const si=menu.querySelector('input');
  const draw=q=>{
    list.innerHTML='';
    if(!q || q.length<2){
      list.innerHTML='<div class="swapempty">Start typing — bread, yoghurt, banana…</div>'; return;
    }
    const hits=LIB_FOODS.filter(f=>String(f.name).toLowerCase().includes(q)).slice(0,25);
    if(!hits.length){ list.innerHTML='<div class="swapempty">Nothing matching.</div>'; return; }
    hits.forEach(f=>{
      const b=document.createElement('button'); b.className='swapopt';
      b.innerHTML='<span class="sn">'+esc(f.name)+'</span><span class="sm">'+
        Math.round(f.protein_100g)+'P · '+Math.round(f.carbs_100g)+'C · '+
        Math.round(f.fat_100g)+'F per 100'+(f.default_unit==='ml'?'ml':'g')+'</span>';
      b.onmousedown=e=>{ e.preventDefault(); askAmountThenAdd(m, f, menu); };
      list.appendChild(b);
    });
  };
  draw('');
  si.addEventListener('input', ()=>draw(si.value.trim().toLowerCase()));
  anchor.parentElement.appendChild(menu);
  setTimeout(()=>si.focus(),0);
  const off=e=>{ if(!menu.contains(e.target)){ menu.remove(); document.removeEventListener('click',off,true);} };
  setTimeout(()=>document.addEventListener('click',off,true),0);
}

function askAmountThenAdd(m, food, menu){
  let grams=100;
  const draw=()=>{
    const pv=previewAddition(m, food, grams);
    menu.innerHTML='';
    const box=document.createElement('div'); box.className='swapconfirm';
    box.innerHTML='<div class="schd">Adding <b>'+esc(food.name)+'</b></div>'+
      '<div class="scamt"><label>Amount</label>'+
      '<input class="inp" type="number" min="0" step="5" value="'+grams+'">'+
      '<span class="scu">'+(food.default_unit==='ml'?'ml':'g')+'</span></div>'+
      (pv ? diffTable(pv) : '') +
      // The solver keeps the meal on its targets, so adding something usually
      // shrinks whatever else is in there rather than pushing the macros up.
      // Say so, or "no change to the macros" reads like nothing happened.
      '<div class="imnote">The other ingredients are re-worked so the meal still '+
      'hits its targets — expect the amounts around it to come down.</div>';
    const btns=document.createElement('div'); btns.className='scbtns';
    const no=document.createElement('button'); no.className='btn small ghost'; no.textContent='Cancel';
    no.onclick=()=>menu.remove();
    const yes=document.createElement('button'); yes.className='btn small'; yes.textContent='Add it';
    yes.onclick=()=>{ addIngredientToMeal(m, food, grams); menu.remove(); };
    btns.appendChild(no); btns.appendChild(yes); box.appendChild(btns);
    menu.appendChild(box);
    const inp=box.querySelector('.scamt input');
    inp.addEventListener('change', ()=>{
      const v=parseFloat(inp.value); if(!isNaN(v) && v>0){ grams=v; draw();
        const a=menu.querySelector('.scamt input'); if(a){ a.focus(); a.select(); } }
    });
  };
  draw();
}

// extras live on the meal, so the library recipe is untouched
function previewAddition(m, food, grams){
  const r=recipeById(m.recipeId); if(!r) return null;
  const before=currentScaled(m);
  const trial=Object.assign({}, m, {extras:(m.extras||[]).concat([{
    foodId:food.id, name:food.name, grams:grams, swapGroup:food.swap_group,
    pg:(+food.protein_100g)/100, cg:(+food.carbs_100g)/100, fg:(+food.fat_100g)/100,
    dunit:(food.default_unit==='ml'?'ml':'g')}])});
  const after=scaledRecipe(applySwapsToRecipe(r,trial), {cho:m.cho,pro:m.pro,fat:m.fat}, m.ovr);
  return {before, after, target:{pro:m.pro, cho:m.cho, fat:m.fat}};
}
function addIngredientToMeal(m, food, grams){
  m.extras=(m.extras||[]).concat([{
    foodId:food.id, name:food.name, grams:grams, swapGroup:food.swap_group,
    pg:(+food.protein_100g)/100, cg:(+food.carbs_100g)/100, fg:(+food.fat_100g)/100,
    dunit:(food.default_unit==='ml'?'ml':'g')}]);
  syncMealToIngredients(m);
  refreshOneMeal(m);
  toast(food.name+' added to this meal only');
}

// what changing just the amount would do, without changing anything
function previewAmount(m, idx, grams){
  const r=recipeById(m.recipeId); if(!r) return null;
  const now=currentScaled(m);
  const ovr = m.ovr && Object.keys(m.ovr).length ? Object.assign({}, m.ovr) : (()=>{
    // match what setIngredientGrams does: the first hand-edit pins everything else
    const o={}; if(now) now.ings.forEach(ig=>{ if(!ig.header && ig.idx!=null) o[ig.idx]=ig.grams; });
    return o;
  })();
  ovr[idx]=Math.max(0, Math.round(grams));
  const after=scaledRecipe(applySwapsToRecipe(r,m), {cho:m.cho,pro:m.pro,fat:m.fat}, ovr);
  return {before:now, after, target:{pro:m.pro, cho:m.cho, fat:m.fat}};
}

// the shared before/after block
function diffTable(pv){
  const rows=[['Protein','pro'],['Carbs','cho'],['Fat','fat']].map(([lbl,k])=>{
    const b=Math.round(pv.before[k]), a=Math.round(pv.after[k]), t=Math.round(pv.target[k]);
    return {lbl,b,a,t,gap:a-t,moved:a-b};
  });
  if(!rows.some(x=>x.moved)) return '<div class="imnochange">No change to the macros.</div>';
  return '<table class="sctab"><thead><tr><th></th><th>Now</th><th>After</th><th>Target</th></tr></thead><tbody>'+
    rows.map(x=>{
      const cls=Math.abs(x.gap)<=5?'ok':(Math.abs(x.gap)<=15?'near':'off');
      const mv=x.moved? '<span class="imv">'+(x.moved>0?'+':'')+x.moved+'</span>':'';
      return '<tr><td>'+x.lbl+'</td><td>'+x.b+'g</td><td class="'+cls+'">'+x.a+'g'+mv+'</td><td>'+x.t+'g</td></tr>';
    }).join('')+'</tbody></table>';
}

// work out what the meal WOULD look like, without changing anything
function previewSwap(m, idx, food, grams){
  const r=recipeById(m.recipeId); if(!r) return null;
  const trial=Object.assign({}, m, {swaps: Object.assign({}, m.swaps||{}, {
    [idx]: {foodId:food.id, name:food.name, swapGroup:food.swap_group,
            allergens:food.allergens||null,
            pg:(+food.protein_100g)/100, cg:(+food.carbs_100g)/100, fg:(+food.fat_100g)/100}
  })});
  // the old ingredient's hand-set amount means nothing once it is a different
  // food, so it goes — unless an amount has been typed into the dialog.
  const ovr = m.ovr ? Object.assign({}, m.ovr) : {};
  delete ovr[idx];
  if(grams != null && grams > 0) ovr[idx] = grams;
  const before = scaledRecipe(applySwapsToRecipe(r,m), {cho:m.cho,pro:m.pro,fat:m.fat}, m.ovr);
  const after  = scaledRecipe(applySwapsToRecipe(r,trial), {cho:m.cho,pro:m.pro,fat:m.fat},
                              Object.keys(ovr).length?ovr:null);
  const row = after.ings.find(x=>x.idx===idx);
  return {before, after, target:{pro:m.pro, cho:m.cho, fat:m.fat},
          suggested: row ? row.grams : null, unit: row ? row.dunit : 'g'};
}

// show what it would do and let you decide. Only asks when something really
// moves — a swap that lands in the same place applies without interrupting.
function confirmSwap(m, idx, food, menu){
  const fromName=(currentScaled(m).ings[idx]||{}).name||'';
  let chosen=null;                       // null = let the solver decide the amount

  const draw=()=>{
    const pv=previewSwap(m, idx, food, chosen);
    if(!pv){ applyManualSwap(m, idx, food); menu.remove(); return; }
    // first pass: if the solver's own answer barely moves anything, don't interrupt
    if(chosen==null){
      const worst=Math.max.apply(null, [['pro'],['cho'],['fat']].map(([k])=>
        Math.abs(Math.round(pv.after[k])-Math.round(pv.before[k]))));
      if(worst < 4){ applyManualSwap(m, idx, food); menu.remove(); return; }
    }
    const rows=[['Protein','pro'],['Carbs','cho'],['Fat','fat']].map(([lbl,k])=>{
      const b=Math.round(pv.before[k]), a=Math.round(pv.after[k]), t=Math.round(pv.target[k]);
      return {lbl, b, a, t, gap:a-t};
    });

    menu.innerHTML='';
    const box=document.createElement('div'); box.className='swapconfirm';
    box.innerHTML='<div class="schd"><b>'+esc(food.name)+'</b> instead of <b>'+esc(fromName)+'</b></div>';

    // how much of the new ingredient. Chicken is not beef, so the amount that
    // makes sense on the plate is often not the amount the solver lands on.
    const amt=document.createElement('div'); amt.className='scamt';
    amt.innerHTML='<label>Amount</label>'+
      '<input class="inp" type="number" min="0" step="5" value="'+(pv.suggested||0)+'">'+
      '<span class="scu">'+esc(pv.unit||'g')+'</span>'+
      (chosen==null ? '<span class="scauto">worked out for you</span>'
                    : '<button class="screset" type="button">use the worked-out amount</button>');
    box.appendChild(amt);

    const tab=document.createElement('table'); tab.className='sctab';
    tab.innerHTML='<thead><tr><th></th><th>Now</th><th>After</th><th>Target</th></tr></thead><tbody>'+
      rows.map(x=>{
        const cls = Math.abs(x.gap) <= 5 ? 'ok' : (Math.abs(x.gap) <= 15 ? 'near' : 'off');
        return '<tr><td>'+x.lbl+'</td><td>'+x.b+'g</td><td class="'+cls+'">'+x.a+'g</td><td>'+x.t+'g</td></tr>';
      }).join('')+'</tbody>';
    box.appendChild(tab);

    const off=rows.filter(x=>Math.abs(x.gap)>15);
    if(off.length){
      const warn=document.createElement('div'); warn.className='scwarn';
      warn.textContent=off.map(x=>x.lbl.toLowerCase()+' would be '+
        Math.abs(Math.round(x.gap))+'g '+(x.gap<0?'short of':'over')+' target').join(', ')+'.';
      box.appendChild(warn);
    }

    const btns=document.createElement('div'); btns.className='scbtns';
    const no=document.createElement('button'); no.className='btn small ghost'; no.textContent='Cancel';
    no.onclick=()=>menu.remove();
    const yes=document.createElement('button'); yes.className='btn small'; yes.textContent='Make the change';
    yes.onclick=()=>{ applyManualSwap(m, idx, food, chosen); menu.remove(); };
    btns.appendChild(no); btns.appendChild(yes);
    box.appendChild(btns);
    menu.appendChild(box);

    // typing a new amount redraws the table, so you can see the effect as you go
    const inp=amt.querySelector('input');
    inp.addEventListener('change', ()=>{
      const v=parseFloat(inp.value);
      chosen = (isNaN(v) || v<=0) ? null : v;
      draw();
      const again=menu.querySelector('.scamt input'); if(again){ again.focus(); again.select(); }
    });
    const rst=amt.querySelector('.screset');
    if(rst) rst.onclick=()=>{ chosen=null; draw(); };
  };
  draw();
}

function applyManualSwap(m, idx, food, grams){
  m.swaps = m.swaps || {};
  m.swaps[idx] = {
    foodId: food.id, name: food.name, swapGroup: food.swap_group,
    allergens: food.allergens || null,
    pg: (+food.protein_100g)/100, cg: (+food.carbs_100g)/100, fg: (+food.fat_100g)/100
  };
  // a hand-set amount no longer means anything once the ingredient changes,
  // unless one was typed into the dialog
  if(m.touch) delete m.touch[idx];
  if(m.ovr) delete m.ovr[idx];
  if(grams != null && grams > 0){
    m.ovr = m.ovr || {};
    m.ovr[idx] = grams;
    m.touch = m.touch || {};
    m.touch[idx] = true;
  }
  // the meal's own macros have to follow the ingredients, or the card and the
  // day total keep reporting the recipe as it was before the swap
  syncMealToIngredients(m);
  refreshOneMeal(m);
  renderDaySummary();
  toast(food.name + ' instead — the amounts have been re-worked to keep the macros');
}

function refreshOneMeal(m){ save(); renderMeals(); renderDaySummary(); }

// fold any hand-made swaps into the recipe before it is scaled
function applySwapsToRecipe(r, m){
  const hasSwaps = m && m.swaps && Object.keys(m.swaps).length;
  const hasExtras = m && m.extras && m.extras.length;
  const hasDrops = m && m.dropped && Object.keys(m.dropped).length;
  if((!hasSwaps && !hasExtras && !hasDrops) || !r || !r.ings) return r;
  const copy=Object.assign({}, r);
  copy.ings=r.ings.map((ing,i)=>{
    const sw=(m.swaps||{})[i];
    if(!sw) return ing;
    return Object.assign({}, ing, {
      name: sw.name, foodId: sw.foodId, swapGroup: sw.swapGroup,
      allergens: sw.allergens, pg: sw.pg, cg: sw.cg, fg: sw.fg,
      raw: ing.raw.replace(ing.name, sw.name),
      swappedFrom: ing.swappedFrom || ing.name
    });
  });
  /* Taking an ingredient out used to remove it from the array, which shifted
     every index after it — and the removals, swaps and hand-set amounts are
     all keyed by index. So removing one ingredient silently remapped the rest,
     and the next change brought the removed one back. Mark it instead; the
     positions never move. */
  if(m && m.dropped && Object.keys(m.dropped).length){
    copy.ings = copy.ings.map((ing,i)=>
      m.dropped[i] ? Object.assign({}, ing, {__dropped:true}) : ing);
  }
  // anything added by hand goes on the end, fixed at the amount that was set
  (m.extras||[]).forEach(x=>{
    copy.ings=copy.ings.concat([{
      name:x.name, foodId:x.foodId, swapGroup:x.swapGroup,
      grams:x.grams, qty:x.grams, unitGrams:1, unit:x.dunit||'g',
      pg:x.pg, cg:x.cg, fg:x.fg, raw:x.grams+(x.dunit||'g')+' '+x.name,
      header:false, negligible:false, scalable:false, group:'fixed',
      dens:1, dunit:x.dunit||'g', addedByHand:true
    }]);
  });
  copy.ingredients=copy.ings.map(i=>i.raw);
  return copy;
}


/* ============ BATCH COOKING ============
   Some recipes are made as one mass and cut up — loaves, brownies, energy
   balls. The plan still works in single portions so the macros stay simple;
   this just multiplies the portion up so the kitchen knows what to actually
   make. Nothing here changes a single macro figure. */
// What one portion is called. Inferred from the recipe name, which is right
// most of the time; anything unrecognised falls back to "portion".
function portionWord(name, n){
  const t = String(name||'').toLowerCase();
  const pick = (one, many) => (n === 1 ? one : many);
  if(/\bballs?\b|bites?\b|truffles?/.test(t))      return pick('ball','balls');
  if(/\bbars?\b|flapjack|brownie|blondie/.test(t))  return pick('piece','pieces');
  if(/\bloaf\b|bread\b|banana bread|cake\b/.test(t)) return pick('slice','slices');
  if(/muffins?|cupcakes?/.test(t))                   return pick('muffin','muffins');
  if(/pancakes?|waffles?/.test(t))                   return pick('pancake','pancakes');
  if(/cookies?|biscuits?/.test(t))                   return pick('cookie','cookies');
  if(/burgers?|patt(y|ies)|fritters?/.test(t))       return pick('patty','patties');
  if(/wraps?|burritos?/.test(t))                     return pick('wrap','wraps');
  return pick('portion','portions');
}

// how many of them this serving works out as
function portionCount(m){
  const r = recipeById(m.recipeId);
  if(!r) return null;
  const makes = Math.max(1, Math.round(+r.servings || 1));
  if(makes < 2) return null;
  const sc = currentScaled(m);
  if(!sc || !sc.ings) return null;
  const servingG = sc.ings.reduce((t,i)=>t + (i.header?0:(i.grams||0)), 0);
  if(!servingG) return null;
  // one portion as the recipe writes it, before any scaling
  const baseG = (r.ings||[]).reduce((t,i)=>t + (i.header?0:(i.grams||0)), 0);
  if(!baseG) return null;
  const each = baseG;                       // r.ings are already per serving
  const n = servingG / each;
  // halves are useful for a loaf, not for a ball
  const word0 = portionWord(r.name, 2);
  const rounded = /slice|piece/.test(word0) ? Math.round(n*2)/2 : Math.round(n);
  if(!rounded) return null;
  return {count: rounded, word: portionWord(r.name, rounded),
          grams: Math.round(servingG), each: Math.round(each)};
}

function batchInfo(m){
  const r = recipeById(m.recipeId);
  if(!r) return null;
  const makes = Math.max(1, Math.round(+r.servings || 1));
  if(makes < 2) return null;
  const n = (m.batchN != null) ? Math.max(1, Math.round(m.batchN)) : makes;
  const sc = currentScaled(m);
  if(!sc || !sc.ings) return null;
  const rows = sc.ings.filter(i=>!i.header && i.grams > 0).map(i=>{
    const per = i.amount != null ? i.amount : i.grams;
    const total = per * n;
    // built-in recipes carry no unit field, so weight is the safe default —
    // without this every line came out as "800 × undefined"
    const countable = i.unit && i.unit !== 'g' && i.unit !== 'ml';
    const u = i.dunit || 'g';
    return {
      name: (i.name || i.text || '').replace(/^[~\d.,/\s]*(g|ml|kg|tsp|tbsp)?\s*/i,'') || i.name,
      per: per,
      total: countable
        ? (Math.round(total*100)/100) + ' × ' + (i.unit === 'each' ? '' : i.unit)
        : (total >= 1000 ? (Math.round(total/10)/100) + ' kg' : Math.round(total) + u)
    };
  });
  const portionG = Math.round(sc.ings.reduce((t,i)=>t + (i.header?0:(i.grams||0)), 0));
  return {makes, n, rows, portionG, name:r.name};
}

function batchPanel(m){
  const b = batchInfo(m);
  if(!b) return null;
  const wrap=document.createElement('details'); wrap.className='batch';
  if(m.batchOpen) wrap.open = true;
  wrap.addEventListener('toggle', ()=>{ m.batchOpen = wrap.open; save(); });

  const sum=document.createElement('summary');
  sum.innerHTML = '<span class="bt">Batch cook</span>' +
    '<span class="bmeta">makes ' + b.n + ' · about ' + b.portionG + 'g a portion</span>';
  wrap.appendChild(sum);

  const body=document.createElement('div'); body.className='batchbody';
  const ctl=document.createElement('div'); ctl.className='batchctl';
  ctl.innerHTML = '<label>Make</label>' +
    '<input class="inp" type="number" min="1" max="200" step="1" value="' + b.n + '">' +
    '<span class="bu">portions</span>' +
    (b.n !== b.makes ? '<button class="breset" type="button">back to ' + b.makes + '</button>' : '');
  body.appendChild(ctl);

  const ul=document.createElement('ul'); ul.className='batchlist';
  b.rows.forEach(r=>{
    const li=document.createElement('li');
    li.innerHTML = '<span class="bq">' + esc(r.total) + '</span> ' + esc(r.name);
    ul.appendChild(li);
  });
  body.appendChild(ul);

  const note=document.createElement('div'); note.className='batchnote';
  note.textContent = 'Make the lot, then weigh out ' + b.portionG + 'g a portion. ' +
    'The plan counts one portion.';
  body.appendChild(note);
  wrap.appendChild(body);

  ctl.querySelector('input').addEventListener('change', e=>{
    const v = parseInt(e.target.value, 10);
    m.batchN = (isNaN(v) || v < 1) ? null : v;
    m.batchOpen = true; save(); renderMeals();
  });
  const rst = ctl.querySelector('.breset');
  if(rst) rst.onclick = ()=>{ m.batchN = null; m.batchOpen = true; save(); renderMeals(); };
  return wrap;
}


/* ============ EDITING A RECIPE ============
   Changes the recipe in the shared library for everyone. Keeps the written
   text on each ingredient, so the specific herb and the "for soaking" note
   survive a save. */
let RE_LINES = [];
let RE_ID = null;

async function openRecipeEditor(dbId){
  RE_ID = dbId; RE_LINES = [];
  document.getElementById('recEditModal').style.display='';
  document.getElementById('reTitle').textContent='Loading…';
  document.getElementById('reIngs').innerHTML='';
  try{
    const {recipe, lines} = await window.CNLib.sbLoadRecipeForEdit(dbId);
    if(!recipe){ toast('Could not load that recipe'); closeRecipeEditor(); return; }
    document.getElementById('reId').value = dbId;
    // show why it is flagged while you work, so the gap can be watched closing
    const flag = (RDB_REVIEW||[]).find(z=>z.id===dbId && z.kind==='recipe');
    const fl = document.getElementById('reFlag');
    if(fl){
      fl.style.display = flag ? '' : 'none';
      fl.textContent = flag ? (flag.note || 'Flagged for checking') : '';
    }
    const mk = document.getElementById('reSaveCheck');
    if(mk) mk.style.display = flag ? '' : 'none';
    document.getElementById('reTitle').textContent = 'Editing ' + recipe.name;
    document.getElementById('reName').value = recipe.name || '';
    document.getElementById('reSlot').value = recipe.slot || 'lunchdinner';
    document.getElementById('reServ').value = recipe.servings || 1;
    document.getElementById('reMethod').value = (recipe.method || '').replace(/\|/g, '\n');
    RE_LINES = lines.map(l=>({
      food_id: l.food_id, food: l.food, qty: +l.qty, unit: l.unit,
      display_text: l.display_text, min_qty: l.min_qty, max_qty: l.max_qty,
      macro_role: l.macro_role, role: l.role
    }));
    renderRecipeEditor();
  }catch(e){
    toast('Could not load: ' + e.message); closeRecipeEditor();
  }
}
function closeRecipeEditor(){
  document.getElementById('recEditModal').style.display='none';
  RE_LINES=[]; RE_ID=null;
}

function renderRecipeEditor(){
  const host=document.getElementById('reIngs'); host.innerHTML='';
  if(!RE_LINES.length){
    host.innerHTML='<div class="libempty">No ingredients. Add one below.</div>';
  }
  RE_LINES.forEach((l, i)=>{
    const row=document.createElement('div'); row.className='reing';
    const f=l.food;
    const noNutrition = f && ((+f.protein_100g||0)+(+f.carbs_100g||0)+(+f.fat_100g||0)) === 0;
    const nm = (f && f.name) || 'Not in the food library';
    row.innerHTML =
      '<div class="rn'+((!f||noNutrition)?' bad':'')+'">'+esc(nm)+
        ((!f||noNutrition)?'<span class="renote">counts as zero</span>':'')+
        (l.display_text ? '<small>'+esc(l.display_text)+'</small>' : '')+'</div>'+
      '<input class="inp" type="number" min="0" step="any" value="'+(l.qty!=null?l.qty:'')+'">'+
      '<select class="inp">'+
        ['g','ml','each','tbsp','tsp','handful','slice'].map(u=>
          '<option value="'+u+'"'+(u===l.unit?' selected':'')+'>'+u+'</option>').join('')+
      '</select>'+
      '<button class="rx" type="button" title="Remove">✕</button>';
    row.querySelector('input').addEventListener('change', e=>{
      const v=parseFloat(e.target.value);
      l.qty = isNaN(v) ? 0 : v;
      // the written text no longer matches the amount, so it is dropped
      if(l.display_text && !/^[a-z]/i.test(l.display_text)) l.display_text = null;
      renderEditorMacros();
    });
    row.querySelector('select').addEventListener('change', e=>{ l.unit=e.target.value; renderEditorMacros(); });
    row.querySelector('.rx').onclick=()=>{ RE_LINES.splice(i,1); renderRecipeEditor(); };
    host.appendChild(row);
  });
  renderEditorMacros();
}

// what the recipe delivers per serving, from the ingredients as they stand
function renderEditorMacros(){
  const el=document.getElementById('reMacros');
  const serv=Math.max(1, parseInt(document.getElementById('reServ').value,10)||1);
  let P=0,C=0,F=0, unknown=0;
  RE_LINES.forEach(l=>{
    const f=l.food; if(!f){ unknown++; return; }
    let g=+l.qty||0;
    if(l.unit==='each' || l.unit==='slice') g *= (+f.piece_grams || 100);
    else if(l.unit==='tbsp') g *= 15;
    else if(l.unit==='tsp') g *= 5;
    else if(l.unit==='handful') g *= 30;
    P += (+f.protein_100g||0)*g/100;
    C += (+f.carbs_100g||0)*g/100;
    F += (+f.fat_100g||0)*g/100;
  });
  const k=Math.round((4*P+4*C+9*F)/serv);
  el.innerHTML = '<span>Per serving: <b>'+k+' kcal</b></span>'+
    '<span>Protein <b>'+Math.round(P/serv)+'g</b></span>'+
    '<span>Carbs <b>'+Math.round(C/serv)+'g</b></span>'+
    '<span>Fat <b>'+Math.round(F/serv)+'g</b></span>'+
    '<span>'+RE_LINES.length+' ingredient'+(RE_LINES.length===1?'':'s')+'</span>'+
    (unknown?'<span style="color:#b3261e">'+unknown+' not recognised</span>':'');
}

function reAddSuggest(){
  const q=document.getElementById('reAddSearch').value.trim().toLowerCase();
  const box=document.getElementById('reAddAC');
  if(q.length<2){ box.style.display='none'; return; }
  const hits=(LIB_FOODS||[]).filter(f=>String(f.name).toLowerCase().includes(q)).slice(0,12);
  if(!hits.length){ box.style.display='none'; return; }
  box.innerHTML=''; box.style.display='';
  hits.forEach(f=>{
    const b=document.createElement('button'); b.type='button'; b.className='acitem';
    b.innerHTML=esc(f.name)+'<span class="acsub">'+Math.round(f.protein_100g)+'P · '+
      Math.round(f.carbs_100g)+'C · '+Math.round(f.fat_100g)+'F</span>';
    b.onmousedown=e=>{ e.preventDefault();
      RE_LINES.push({food_id:f.id, food:f, qty:100,
        unit:(f.default_unit==='ml'?'ml':'g'), display_text:null});
      document.getElementById('reAddSearch').value=''; box.style.display='none';
      renderRecipeEditor();
    };
    box.appendChild(b);
  });
}

// Archiving from inside the editor: someone checking a recipe often only
// realises it is wrong once they have opened it, and closing to go and find
// the Archive button on the row is a silly detour.
async function archiveFromEditor(){
  if(!RE_ID) return;
  const name=document.getElementById('reName').value.trim() || 'this recipe';
  const rec=LIB_RECIPES.find(x=>x.dbId===RE_ID);
  const isBook = rec && rec.source==='master';
  if(!confirm('Archive "'+name+'"?\n\nIt comes out of the plan builder for everyone, but '+
    (isBook ? 'it is kept indefinitely and can be restored at any time.'
            : 'it can be restored for the next 30 days.'))) return;
  const btn=document.getElementById('reArchive'); btn.disabled=true; btn.textContent='Archiving…';
  try{
    await window.CNLib.sbArchiveRecipe(RE_ID, S.player||null);
    toast('"'+name+'" archived — restore it from the Archived list');
    closeRecipeEditor();
    await loadLibrary(true); renderLibList();
    if(document.getElementById('recipeDbModal').style.display !== 'none') renderRecipeDb();
    if(S.generated){ refreshAllMatches(); render(); }
  }catch(e){
    toast('Could not archive: '+e.message);
  }finally{
    btn.disabled=false; btn.textContent='Archive';
  }
}

async function saveRecipeEdits(alsoCheck){
  const name=document.getElementById('reName').value.trim();
  if(!name){ toast('Give it a name'); return; }
  if(!RE_LINES.length){ toast('A recipe needs at least one ingredient'); return; }
  const btn=document.getElementById('reSave'); btn.disabled=true; btn.textContent='Saving…';
  try{
    await window.CNLib.sbUpdateRecipe(RE_ID, {
      name: name,
      slot: document.getElementById('reSlot').value,
      servings: Math.max(1, parseInt(document.getElementById('reServ').value,10)||1),
      method: document.getElementById('reMethod').value.trim() || null,
      items: RE_LINES.map(l=>({
        food_id: l.food_id, food: l.food, qty: l.qty, unit: l.unit,
        display_text: l.display_text, min_qty: l.min_qty, max_qty: l.max_qty,
        macro_role: l.macro_role, role: l.role
      }))
    });
    if(alsoCheck){
      // "I have looked at this" — the calorie comparison cannot be switched
      // off by fixing anything, so it has to be said explicitly
      try{ await window.CNLib.sbClearReview(RE_ID, S.player||null);
           RDB_REVIEW = (RDB_REVIEW||[]).filter(z=>z.id!==RE_ID); }
      catch(e){ console.warn('could not mark checked', e.message); }
    }
    toast('"'+name+'" saved' + (alsoCheck ? ' and marked as checked' : ' — everyone sees the change'));
    closeRecipeEditor();
    await loadLibrary(true);
    renderLibList();
    if(document.getElementById('recipeDbModal').style.display !== 'none') renderRecipeDb();
    if(S.generated){ refreshAllMatches(); render(); }
  }catch(e){
    toast('Could not save: '+e.message);
  }finally{
    btn.disabled=false; btn.textContent='Save changes';
  }
}


/* ============ EXPORTING THE LIBRARY ============
   A plain CSV of whatever is in the database right now, in the same shape as
   the import templates — so a backup can be read in a spreadsheet and, if it
   ever comes to it, imported straight back. */
function csvCell(v){
  const t = (v == null) ? '' : String(v);
  return /[",\n\r]/.test(t) ? '"' + t.replace(/"/g,'""') + '"' : t;
}
function csvDownload(rows, filename){
  const body = rows.map(r=>r.map(csvCell).join(',')).join('\r\n');
  // the BOM makes Excel open it as UTF-8 rather than mangling the accents
  const blob = new Blob(['\ufeff' + body], {type:'text/csv;charset=utf-8;'});
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = filename;
  document.body.appendChild(a); a.click();
  setTimeout(()=>{ URL.revokeObjectURL(a.href); a.remove(); }, 500);
}
function stamp(){
  const d = new Date();
  const p = n => String(n).padStart(2,'0');
  return d.getFullYear() + '-' + p(d.getMonth()+1) + '-' + p(d.getDate());
}

function exportRecipesCsv(){
  if(!LIB_RECIPES.length){ toast('Nothing in the library to export'); return; }
  const rows = [['Recipe Name','Meal type','Servings','Ingredients','Method',
                 'Calories per serving','Protein','Carbs','Fat','Source']];
  LIB_RECIPES.slice()
    .sort((a,b)=>a.name.localeCompare(b.name))
    .forEach(r=>{
      rows.push([
        r.name,
        ({breakfast:'Breakfast', smoothie:'Smoothie', snack:'Snack',
          lunchdinner:'Lunch or dinner'})[r.category] || r.category || '',
        r.servings || 1,
        (r.ingredients || []).join('\n'),
        (r.directions || []).join('\n'),
        r.kcal || '', r.pro || '', r.cho || '', r.fat || '',
        r.source === 'master' ? 'Book' : 'Added in the app'
      ]);
    });
  csvDownload(rows, 'close-nutrition-recipes-' + stamp() + '.csv');
  toast(LIB_RECIPES.length + ' recipes exported');
}

function exportFoodsCsv(){
  if(!LIB_FOODS.length){ toast('Nothing in the food list to export'); return; }
  const rows = [['Food Name','Brand','Measured in','Protein per 100','Carbs per 100',
                 'Fat per 100','Calories per 100','Weight of one piece (g)','Piece name',
                 'Portioning','Allergens','Swap group','Notes']];
  LIB_FOODS.slice()
    .sort((a,b)=>String(a.name).localeCompare(String(b.name)))
    .forEach(f=>{
      rows.push([f.name, f.brand || '', f.default_unit || 'g',
        f.protein_100g, f.carbs_100g, f.fat_100g, f.kcal_100g,
        f.piece_grams || '', f.piece_name || '', f.portioning || 'free',
        f.allergens || '', f.swap_group || '', f.source_note || '']);
    });
  csvDownload(rows, 'close-nutrition-foods-' + stamp() + '.csv');
  toast(LIB_FOODS.length + ' foods exported');
}

/* ============ THE RUNNING TOTALS BAR ============
   Shown only once the full day panel has scrolled out of sight, so there is
   never a duplicate of it on screen at the same time. */
(function totalsBar(){
  function wire(){
    const bar = document.getElementById('stickyTotals');
    const panel = document.getElementById('daySummary');
    if(!bar || !panel) return;
    // Always on screen. Appearing partway down a scroll made it feel jerky,
    // and the figures are worth seeing wherever you are on the page.
    bar.classList.add('show');
  }
  if(document.readyState === 'loading')
    document.addEventListener('DOMContentLoaded', wire);
  else wire();
})();

/* ============ STACKING SCREENS ============
   Every screen shares one z-index, so whichever sits last in the page wins —
   which meant a screen opened from another one could appear behind it, and
   you had to close the first to see what you had just opened. Rather than
   tagging each pair by hand, this watches for a screen becoming visible and
   lifts it above whatever is already open. */
(function stackModals(){
  const BASE = 60;
  let top = BASE;
  let busy = false;                    // our own writes must not retrigger this
  const shown = el => el && el.style.display !== 'none';

  function lift(el){
    if(busy) return;
    const others = [...document.querySelectorAll('.modalwrap')]
      .filter(x => x !== el && shown(x));
    busy = true;
    try{
      if(!others.length){ top = BASE; el.style.zIndex = BASE; }
      else{
        top = Math.max(BASE, ...others.map(x => parseInt(x.style.zIndex,10) || BASE)) + 5;
        el.style.zIndex = top;
      }
    } finally { busy = false; }
  }

  function watch(){
    document.querySelectorAll('.modalwrap').forEach(el=>{
      if(el.__stacked) return;
      el.__stacked = true;
      el.__wasShown = shown(el);
      new MutationObserver(()=>{
        if(busy) return;
        const now = shown(el);
        if(now === el.__wasShown) return;   // only react to opening or closing
        el.__wasShown = now;
        if(now) lift(el);
      }).observe(el, {attributes:true, attributeFilter:['style']});
    });
  }
  if(document.readyState === 'loading')
    document.addEventListener('DOMContentLoaded', watch);
  else watch();
})();


/* ============ A DAY WITH NOTHING PLANNED ============ */
function clearDay(d){
  const day=S.days[d]; if(!day) return;
  day.meals=[]; day.supps=[]; day.cleared=true;
  save(); render();
}
function restoreDay(d){
  const day=S.days[d]; if(!day) return;
  day.cleared=false;
  const t={pro:day.pro, cho:day.cho, fat:day.fat};
  const rebuilt=buildDay(day.type||'Normal', t);
  day.meals=rebuilt.meals;
  applySupplementProtocol();
  save(); render();
}

/* ============ A SECOND HELPING IN THE SAME SLOT ============
   A rugby player wanting more protein at breakfast gets another item beside
   it, rather than the porridge being inflated by 60%. */
function addMealToSlot(afterMeal){
  const day=S.days[S.active];
  const i=day.meals.indexOf(afterMeal);
  if(i<0) return;
  const extra={
    id:'m'+Date.now()+'_x'+Math.random().toString(36).slice(2,6),
    name:afterMeal.name, kind:afterMeal.kind, cat:afterMeal.cat, time:afterMeal.time,
    // a guide for choosing, not something anything gets scaled to
    cho:0, pro:0, fat:0, recipeId:null, showDirs:false, alongside:true
  };
  // something that fits what the day is still short of
  const short={
    pro:Math.max(0, day.pro - dayTotals(day).pro),
    cho:Math.max(0, day.cho - dayTotals(day).cho),
    fat:Math.max(0, day.fat - dayTotals(day).fat)
  };
  const cands=bestMatch(extra.cat, short, S.excl)||[];
  if(cands.length) extra.recipeId=cands[0].r.id;
  day.meals.splice(i+1, 0, extra);
  save(); render();
  toast('Added alongside — pick a different recipe for it if you need to');
}

function dayTotals(day){
  let p=0,c=0,f=0;
  (day.meals||[]).forEach(m=>{ const s=currentScaled(m); if(s){p+=s.pro;c+=s.cho;f+=s.fat;} });
  return {pro:p, cho:c, fat:f, kcal:Math.round(4*p+4*c+9*f)};
}

/* ============ HOW MANY SERVINGS OF IT ============ */
function setMealServings(m, n){
  const v=Math.max(0.25, Math.min(6, +n||1));
  m.ovr=m.ovr||{};
  if(v===1) delete m.ovr.__servings; else m.ovr.__servings=v;
  syncMealToIngredients(m);
  save(); renderMeals(); renderDaySummary();
}


/* ============ IS THIS MEAL'S ARITHMETIC SOUND? ============
   Every ingredient should resolve to a food in the shared library, carry
   real nutrition, and scale from a per-100g figure. Anything that does not
   is counting as zero and quietly dragging the meal's macros down. */
function mealIntegrity(m){
  const sc = currentScaled(m);
  if(!sc || !sc.ings) return null;
  const real = sc.ings.filter(i=>!i.header);
  const counted = [], noNutrition = [], notInLibrary = [], seasoning = [];
  real.forEach(i=>{
    const hasMacros = (i.p + i.c + i.f) > 0 || (i.pg + i.cg + i.fg) > 0;
    if(i.negligible || /^(left out)$/.test(i.src||'')){ seasoning.push(i); return; }
    if(!hasMacros){ noNutrition.push(i); return; }
    if(!libFoodFor(i)) notInLibrary.push(i);
    counted.push(i);
  });
  const fromIngredients = Math.round(
    4*real.reduce((a,i)=>a+(i.p||0),0) +
    4*real.reduce((a,i)=>a+(i.c||0),0) +
    9*real.reduce((a,i)=>a+(i.f||0),0));
  return {
    total: real.length,
    counted: counted.length,
    noNutrition, notInLibrary, seasoning,
    kcal: fromIngredients,
    bookKcal: sc.bookKcal || null,
    bookGap: sc.bookGap || 0,
    sound: noNutrition.length === 0
  };
}

function integrityLine(m){
  const q = mealIntegrity(m);
  if(!q) return '';
  const bits = [];
  // ingredients nobody has recorded allergen information for, where the player
  // has a genuine allergy. Not removed — flagged, so a person decides.
  const sc0 = currentScaled(m);
  const unknown = (sc0 && sc0.ings ? sc0.ings : [])
    .filter(i=>i.allergenUnknown && i.allergenUnknown.length);
  if(unknown.length){
    const terms = [...new Set(unknown.flatMap(i=>i.allergenUnknown))];
    bits.push('<span class="iqbad">Allergen check needed for ' +
      terms.join(', ') + ': no allergen information on ' +
      esc(unknown.map(i=>i.name||i.text).slice(0,4).join(', ')) +
      (unknown.length>4 ? ' and ' + (unknown.length-4) + ' more' : '') + '</span>');
  }
  if(q.noNutrition.length){
    bits.push('<span class="iqbad">' + q.noNutrition.length +
      ' ingredient' + (q.noNutrition.length===1?'':'s') +
      ' counting as zero: ' + esc(q.noNutrition.map(i=>i.name||i.text).join(', ')) +
      '</span>');
  }
  if(q.bookKcal && Math.abs(q.bookGap) > Math.max(40, q.bookKcal*0.1)){
    bits.push('<span class="iqnote">Ingredients come to ' + q.kcal +
      ' kcal; the book says ' + Math.round(q.bookKcal) +
      '. The ingredients are what counts.</span>');
  }
  if(!bits.length){
    bits.push('<span class="iqok">' + q.counted + ' ingredient' +
      (q.counted===1?'':'s') + ' priced from the library' +
      (q.seasoning.length ? ', ' + q.seasoning.length + ' seasoning' : '') + '</span>');
  }
  return '<div class="integrity">' + bits.join('') + '</div>';
}


/* ============ CHECKING THE NUMBERS ============
   A recipe's macros are what its ingredients add up to. Where that disagrees
   with the figure printed in the book, somebody has to decide which is right.
   This is where that happens, and the decision is recorded so it is only made
   once. */
let RDB_VALIDATION = [];

async function loadValidation(){
  try{ RDB_VALIDATION = await window.CNLib.sbValidation(); }
  catch(e){ RDB_VALIDATION = []; console.warn('validation unavailable', e.message); }
}

function renderValidation(host){
  const rows = RDB_VALIDATION.filter(v=>v.macro_source === 'unchecked' || RDB_SHOW_DONE);
  if(!RDB_VALIDATION.length){
    host.innerHTML = '<div class="libempty">Run 15_validation.sql in Supabase to use this.</div>';
    return;
  }
  const bad = RDB_VALIDATION.filter(v=>Math.abs(v.pct_out||0) > 15).length;
  const zero = RDB_VALIDATION.filter(v=>v.lines_counting_as_zero > 0).length;
  const done = RDB_VALIDATION.filter(v=>v.macro_source !== 'unchecked').length;

  const head = document.createElement('div'); head.className='valhead';
  head.innerHTML =
    '<div class="vhsum"><b>' + RDB_VALIDATION.length + ' recipes.</b> ' +
      done + ' decided · ' + bad + ' more than 15% out' +
      (zero ? ' · ' + zero + ' with an ingredient counting as zero' : '') + '</div>' +
    '<label class="vhtoggle"><input type="checkbox" ' + (RDB_SHOW_DONE?'checked':'') + '> ' +
      'Show ones already decided</label>';
  head.querySelector('input').onchange = e => { RDB_SHOW_DONE = e.target.checked; renderRecipeDb(); };

  // the ones already within 5% need no judgement — accept them together
  const close = RDB_VALIDATION.filter(v=>v.macro_source === 'unchecked' &&
                                         v.pct_out != null && Math.abs(v.pct_out) <= 5);
  if(close.length){
    const b = document.createElement('button'); b.className='btn small';
    b.textContent = 'Accept the ' + close.length + ' already within 5%';
    b.title = 'Their ingredients already agree with the book. Nothing to decide.';
    b.onclick = async () => {
      if(!confirm('Accept ' + close.length + ' recipes whose ingredients already agree ' +
         'with the book, to within 5%?\n\nThis only records that they have been ' +
         'checked — no macros change.')) return;
      b.disabled = true; b.textContent = 'Accepting…';
      let done = 0;
      for(const v of close){
        try{ await window.CNLib.sbValidateRecipe(v.id, 'ingredients', S.player||null);
             v.macro_source = 'ingredients'; done++; }
        catch(e){ /* carry on; the rest can still go through */ }
        b.textContent = 'Accepting ' + done + ' of ' + close.length + '…';
      }
      toast(done + ' accepted — ' + (close.length-done ? (close.length-done) + ' failed' : 'all of them'));
      renderRecipeDb();
    };
    head.appendChild(b);
  }
  host.appendChild(head);

  if(!rows.length){
    const e=document.createElement('div'); e.className='libempty';
    e.textContent='Every recipe has been checked.';
    host.appendChild(e); return;
  }

  rows.slice(0, 200).forEach(v=>{
    const pct = v.pct_out;
    const sev = pct == null ? 'none' : (Math.abs(pct) <= 5 ? 'ok'
              : Math.abs(pct) <= 15 ? 'near' : 'off');
    const row = document.createElement('div'); row.className = 'valrow ' + sev;
    row.innerHTML =
      '<div class="vn"><b>' + esc(v.name) + '</b>' +
        (v.macro_source !== 'unchecked'
          ? '<span class="vdone">' + esc(v.macro_source) + '</span>' : '') +
        (v.lines_counting_as_zero > 0
          ? '<span class="vzero">' + v.lines_counting_as_zero +
            ' ingredient' + (v.lines_counting_as_zero===1?'':'s') + ' counting as zero</span>' : '') +
      '</div>' +
      '<div class="vnum"><span class="vl">Book</span>' +
        (v.book_kcal != null ? Math.round(v.book_kcal) + ' kcal' : '—') + '</div>' +
      '<div class="vnum"><span class="vl">Ingredients</span>' +
        (v.ingredient_kcal != null ? Math.round(v.ingredient_kcal) + ' kcal' : '—') + '</div>' +
      '<div class="vgap ' + sev + '">' +
        (pct == null ? '' : (pct > 0 ? '+' : '') + pct + '%') + '</div>';

    const act = document.createElement('div'); act.className = 'vact';
    const open = document.createElement('button'); open.className='btn small ghost';
    open.textContent='Open';
    open.onclick = () => openRecipeEditor(v.id);
    act.appendChild(open);

    const useIng = document.createElement('button'); useIng.className='btn small';
    useIng.textContent='Ingredients are right';
    useIng.title='Bring the book figures into line with what the ingredients add up to';
    useIng.onclick = async () => {
      useIng.disabled = true;
      try{
        await window.CNLib.sbValidateRecipe(v.id, 'ingredients', S.player||null);
        v.macro_source = 'ingredients';
        v.book_kcal = v.ingredient_kcal; v.pct_out = 0;
        renderRecipeDb();
      }catch(e){ toast('Could not save that: ' + e.message); useIng.disabled = false; }
    };
    act.appendChild(useIng);

    const useBook = document.createElement('button'); useBook.className='btn small ghost';
    useBook.textContent='Book is right';
    useBook.title='Leave the book figure alone — the ingredient list needs work';
    useBook.onclick = async () => {
      useBook.disabled = true;
      try{
        await window.CNLib.sbValidateRecipe(v.id, 'book', S.player||null);
        v.macro_source = 'book';
        renderRecipeDb();
      }catch(e){ toast('Could not save that: ' + e.message); useBook.disabled = false; }
    };
    act.appendChild(useBook);

    row.appendChild(act);
    host.appendChild(row);
  });
}
let RDB_SHOW_DONE = false;


/* ============ ADDING A MEAL WHERE YOU WANT IT ============
   "Add snack (auto-matched)" put something in without asking, and "Add your
   own meal" meant building a recipe from scratch, which is a different job.
   This is one picker: say where it goes, then choose from the library. */
let AM_AFTER = null;        // the meal it goes after, or null for the end

function openAddMeal(afterMeal, preset){
  AM_AFTER = afterMeal || null;
  const day = S.days[S.active];
  const mo = document.getElementById('addMealModal');
  mo.style.display='';

  // where it sits — pre-filled from the gap it was opened in
  const nameI = document.getElementById('amName');
  const timeI = document.getElementById('amTime');
  const catI  = document.getElementById('amCat');
  if(afterMeal){
    const idx = day.meals.indexOf(afterMeal);
    const next = day.meals[idx+1];
    nameI.value = preset === 'alongside' ? afterMeal.name : '';
    timeI.value = preset === 'alongside' ? (afterMeal.time||'')
                : midwayTime(afterMeal.time, next && next.time);
    catI.value  = preset === 'alongside' ? (afterMeal.cat||'lunchdinner') : 'snack';
  }else{
    nameI.value=''; timeI.value=''; catI.value='snack';
  }
  document.getElementById('amAlongside').checked = preset === 'alongside';
  document.getElementById('amSearch').value='';
  document.getElementById('amPicked').value='';
  AM_LAST_Q = null;      // the library may have gained a recipe since last time
  renderAddMealList('', true);
  setTimeout(()=>document.getElementById('amSearch').focus(), 60);
}
function closeAddMeal(){ document.getElementById('addMealModal').style.display='none'; AM_AFTER=null; }

// a sensible time between two meals, for something slotted in between
function midwayTime(a, b){
  const mins = t => { const m=/^(\d{1,2})[:.](\d{2})/.exec(String(t||'')); 
                      return m ? (+m[1])*60+(+m[2]) : null; };
  const x=mins(a), y=mins(b);
  if(x==null) return '';
  const mid = y==null ? x+120 : Math.round((x+y)/2);
  const hh=String(Math.floor(mid/60)%24).padStart(2,'0');
  const mm=String(mid%60).padStart(2,'0');
  return hh+':'+mm;
}

let AM_LAST_Q = null;
function renderAddMealList(q, force){
  const host=document.getElementById('amList');
  const picked=document.getElementById('amPicked').value;
  // Rebuilding the list on every keystroke threw away the selection, so the
  // first click never took and you had to pick something else and come back.
  const key = String(q||'') + '|' + document.getElementById('amCat').value;
  if(!force && key === AM_LAST_Q) return;
  AM_LAST_Q = key;
  const cat=document.getElementById('amCat').value;
  const term=String(q||'').trim().toLowerCase();
  const words=term?term.split(/\s+/):[];
  let pool=(LIB_RECIPES.length?LIB_RECIPES:BUILTIN_RECIPES)
    .filter(r=>!term ? (r.category===cat) : true)
    .filter(r=>!words.length || words.every(w=>
      String(r.name||'').toLowerCase().includes(w) ||
      String(r.scan||'').toLowerCase().includes(w)));

  // what the day is still short of, so the closest fits sit at the top
  const day=S.days[S.active], got=dayTotals(day);
  const short={pro:day.pro-got.pro, cho:day.cho-got.cho, fat:day.fat-got.fat};
  const g=r=>recipeAsWritten(r);
  pool=pool.map(r=>({r, d:Math.abs(g(r).pro-short.pro)+Math.abs(g(r).cho-short.cho)
                        +Math.abs(g(r).fat-short.fat)*2}))
           .sort((a,b)=>a.d-b.d).slice(0,60);

  host.innerHTML='';
  if(!pool.length){ host.innerHTML='<div class="libempty">Nothing matching.</div>'; return; }
  // this player's favourites at the top here as well
  const isFav = r => r.dbId && PLAYER_FAVS.has(r.dbId);
  pool.sort((a,b)=>(isFav(b.r)?1:0)-(isFav(a.r)?1:0));
  let keptSelection = false, favHeaderDone = false, plainHeaderDone = false;
  pool.forEach(({r})=>{
    if(isFav(r) && !favHeaderDone){
      const h=document.createElement('div'); h.className='amhead';
      h.textContent='★  ' + (S.player ? S.player + "'s favourites" : 'Favourites');
      host.appendChild(h); favHeaderDone=true;
    }
    if(!isFav(r) && favHeaderDone && !plainHeaderDone){
      const h=document.createElement('div'); h.className='amhead';
      h.textContent='Everything else';
      host.appendChild(h); plainHeaderDone=true;
    }
    const b=document.createElement('button'); b.type='button'; b.className='amitem';
    if(r.id === picked){ b.classList.add('on'); keptSelection = true; }
    const st=carbStatus(r.cho);
    b.innerHTML='<span class="amn">'+(isFav(r)?'\u2605 ':'')+esc(r.name)+'</span>'+
      '<span class="amm"><b class="cs-'+st+'">'+Math.round(r.kcal||0)+' kcal</b>'+
      '  ·  '+Math.round(r.pro||0)+'P  '+Math.round(r.cho||0)+'C  '+Math.round(r.fat||0)+'F</span>';
    b.onmousedown=e=>{ e.preventDefault();
      [...host.querySelectorAll('.amitem')].forEach(x=>x.classList.remove('on'));
      b.classList.add('on');
      document.getElementById('amPicked').value=r.id;
      if(!document.getElementById('amName').value)
        document.getElementById('amName').value = ({breakfast:'Breakfast', smoothie:'Smoothie',
          snack:'Snack', lunchdinner:'Lunch'})[r.category] || 'Meal';
    };
    host.appendChild(b);
  });
  // the chosen one has dropped out of the results, so the choice goes with it
  if(picked && !keptSelection) document.getElementById('amPicked').value='';
}

function confirmAddMeal(){
  const id=document.getElementById('amPicked').value;
  if(!id){ toast('Pick something from the list first'); return; }
  const day=S.days[S.active];
  const alongside=document.getElementById('amAlongside').checked;
  const m={
    id:'m'+Date.now()+'_'+Math.random().toString(36).slice(2,6),
    name: document.getElementById('amName').value.trim() || 'Meal',
    kind: document.getElementById('amCat').value==='snack' ? 'snack' : 'meal',
    cat:  document.getElementById('amCat').value,
    time: document.getElementById('amTime').value.trim(),
    cho:0, pro:0, fat:0, recipeId:id, showDirs:false, alongside:alongside
  };
  syncMealToIngredients(m);          // its macros are the recipe's, from the off
  const at = AM_AFTER ? day.meals.indexOf(AM_AFTER)+1 : day.meals.length;
  day.meals.splice(at, 0, m);
  day.meals.sort((a,b)=>{
    const t=x=>{ const z=/^(\d{1,2})[:.](\d{2})/.exec(String(x.time||'')); 
                 return z ? (+z[1])*60+(+z[2]) : 9999; };
    return t(a)-t(b);
  });
  closeAddMeal(); save(); render();
  toast('Added to ' + DAYFULL[S.active]);
}


/* ============ THE SAME MEAL ON OTHER DAYS ============
   Picking porridge for Monday and then repeating it on Tuesday and Wednesday
   meant going into each day and choosing it again. */
function openCopyMeal(m, anchor){
  document.querySelectorAll('.copymenu').forEach(x=>x.remove());
  const from = S.active;
  const menu = document.createElement('div'); menu.className='copymenu';
  const rec = recipeById(m.recipeId);
  const title = m.alias || (rec ? rec.name : m.name);

  menu.innerHTML =
    '<div class="cmhd">Put <b>' + esc(title) + '</b> on these days</div>' +
    '<div class="cmdays"></div>' +
    '<div class="cmnote">It replaces whatever is at ' + esc(m.name || 'this sitting') +
      ' on those days. Any changes you have made to this meal come with it.</div>' +
    '<div class="cmbtns">' +
      '<button class="btn small ghost" data-all type="button">All other days</button>' +
      '<button class="btn small" data-go type="button">Copy it</button>' +
    '</div>';

  const host = menu.querySelector('.cmdays');
  const boxes = {};
  DAYS.forEach(d=>{
    if(d === from) return;
    const day = S.days[d];
    const lab = document.createElement('label');
    lab.className = 'cmday' + (day && day.cleared ? ' off' : '');
    const has = day && !day.cleared
      ? (day.meals||[]).find(x=>x.name === m.name)
      : null;
    lab.innerHTML = '<input type="checkbox"' + (day && day.cleared ? ' disabled' : '') + '>' +
      '<span class="cmd">' + esc(DAYFULL[d]) + '</span>' +
      '<span class="cmw">' + (day && day.cleared ? 'nothing planned'
        : has ? esc(((x)=>{ const r=recipeById(x.recipeId);
                            return x.alias || (r?r.name:x.name); })(has)).slice(0,30)
              : 'no ' + esc(m.name || 'meal') + ' yet') + '</span>';
    boxes[d] = lab.querySelector('input');
    host.appendChild(lab);
  });

  menu.querySelector('[data-all]').onclick = () => {
    const anyOff = Object.values(boxes).some(b=>!b.disabled && !b.checked);
    Object.values(boxes).forEach(b=>{ if(!b.disabled) b.checked = anyOff; });
  };
  menu.querySelector('[data-go]').onclick = () => {
    const picked = DAYS.filter(d=>boxes[d] && boxes[d].checked);
    if(!picked.length){ toast('Tick the days you want it on'); return; }
    let done = 0;
    picked.forEach(d=>{
      const day = S.days[d];
      if(!day || day.cleared) return;
      // everything that makes this meal what it is, carried across
      const copy = {
        id:'m'+Date.now()+'_'+d+'_'+Math.random().toString(36).slice(2,5),
        name:m.name, kind:m.kind, cat:m.cat, time:m.time,
        recipeId:m.recipeId, alias:m.alias || null, showDirs:false,
        alongside:!!m.alongside,
        swaps:m.swaps ? JSON.parse(JSON.stringify(m.swaps)) : undefined,
        extras:m.extras ? JSON.parse(JSON.stringify(m.extras)) : undefined,
        dropped:m.dropped ? JSON.parse(JSON.stringify(m.dropped)) : undefined,
        ovr:m.ovr ? JSON.parse(JSON.stringify(m.ovr)) : undefined,
        touch:m.touch ? JSON.parse(JSON.stringify(m.touch)) : undefined,
        pro:0, cho:0, fat:0
      };
      syncMealToIngredients(copy);
      const at = (day.meals||[]).findIndex(x=>x.name === m.name && !x.alongside);
      if(at >= 0) day.meals.splice(at, 1, copy);
      else {
        day.meals.push(copy);
        day.meals.sort((a,b)=>{
          const t=x=>{ const z=/^(\d{1,2})[:.](\d{2})/.exec(String(x.time||''));
                       return z ? (+z[1])*60+(+z[2]) : 9999; };
          return t(a)-t(b);
        });
      }
      done++;
    });
    menu.remove(); save(); render();
    toast('Copied to ' + done + ' day' + (done===1?'':'s'));
  };

  anchor.parentElement.appendChild(menu);
  const off = e => { if(!menu.contains(e.target)){ menu.remove();
    document.removeEventListener('click', off, true); } };
  setTimeout(()=>document.addEventListener('click', off, true), 0);
}


// Changing which recipe a meal uses clears everything that was done to the old
// one. An ingredient added to the porridge has no business following you into
// the omelette, and the indices would not line up anyway.
function setMealRecipe(m, id){
  if(m.recipeId === id) return;
  m.recipeId = id;
  delete m.swaps; delete m.extras; delete m.dropped;
  delete m.ovr;   delete m.touch;
  syncMealToIngredients(m);
}


/* ============ THE SHOPPING LIST, BEFORE IT IS EXPORTED ============
   Built from the plan the same way the PDF builds it, so what you see here is
   what gets printed. Amounts can be corrected and extra items added. */
const SHOP_AISLES = [
  ['Meat & poultry',   ['poultry','red_meat','pork']],
  ['Fish',             ['white_fish','oily_fish','shellfish']],
  ['Dairy & eggs',     ['egg','yoghurt','cheese','cream_dairy']],
  ['Fruit & veg',      ['leafy_green','brassica','root_veg','squash','allium',
                        'pepper_chilli','tomato','mushroom','other_veg',
                        'berry','tropical_fruit','orchard_fruit','citrus']],
  ['Rice, pasta & bread',['rice','pasta','noodle','potato','bread','oats','other_grain']],
  ['Tins, pulses & jars',['legume','plant_protein','sauce']],
  ['Store cupboard',   ['oil','nut_seed','nut_butter','sweetener','spice_herb',
                        'protein_powder','other','free']]
];
function shopAisle(g, name){
  for(const [a, groups] of SHOP_AISLES) if(groups.indexOf(g) >= 0) return a;

  /* No swap group on the ingredient, so work it out from the name. Order
     matters more than anything here: "peanut butter" must be caught before
     "butter", "black pepper" before "pepper", and "eggplant" must never be
     read as an egg. First match wins, so the exceptions come first. */
  const n = ' ' + String(name||'').toLowerCase().replace(/[^a-z0-9 ]/g,' ')
                      .replace(/\s+/g,' ').trim() + ' ';
  const RULES = [
    // --- caught first, or a broader rule below would claim them ---
    ['Store cupboard', /\b(peanut|almond|cashew|nut|seed|tahini) butter|\btahini/],
    ['Seasoning',      /\b(black|white|cayenne|chilli|chili) pepper|\bpeppercorn/],
    ['Fruit & veg',    /\b(bell|red|green|yellow|romano|sweet|mixed) pepper|\bpeppers\b/],
    ['Fruit & veg',    /\baubergine|\beggplant/],
    ['Tins, pulses & jars', /\b(black|kidney|butter|baked|cannellini|borlotti|haricot) beans?\b/],
    ['Tins, pulses & jars', /\bchickpea|\blentil|\btinned|\btin of|\bpassata|\bchopped tomato|\bpuree|\bpurée|\bstock\b|\bbouillon/],
    ['Store cupboard', /\bcoconut (oil|milk|cream)|\boil\b|\bvinegar|\bhoney|\bsyrup|\bjam\b/],
    ['Rice, pasta & bread', /\bbreadcrumb|\bpanko/],
    // a sauce is a jar however it is flavoured — "sweet chilli sauce" was
    // being read as a vegetable
    ['Tins, pulses & jars', /\bsauce\b|\bketchup|\bmayo|\bmustard|\bpesto|\bsalsa|\bchutney|\bmiso\b/],

    // --- the ordinary cases. No trailing boundary, so plurals and
    //     compounds ("blueberries", "prawns") match as you would expect. ---
    ['Meat & poultry', /\b(chicken|turkey|beef|lamb|pork|mince|steak|bacon|sausage|ham\b|duck|goat|brisket|ribeye|sirloin|shin\b|cheek|chorizo|pancetta|nduja|venison)/],
    ['Fish',           /\b(salmon|cod\b|haddock|tuna|prawn|shrimp|fish|mussel|clam|crab|lobster|monkfish|anchov|mackerel|sardine|sea bass|squid)/],
    ['Dairy & eggs',   /\b(milk|yoghurt|yogurt|cheese|cheddar|mozzarella|feta|halloumi|parmesan|ricotta|cream|butter|egg|skyr|quark|creme fraiche)/],
    ['Fruit & veg',    /\b(berry|berries|blueberr|strawberr|raspberr|blackberr|banana|apple|pear\b|orange|melon|mango|kiwi|papaya|pineapple|grape|peach|plum|cherr|avocado|spinach|lettuce|rocket|kale|cabbage|broccoli|cauliflower|carrot|onion|shallot|leek|tomato|courgette|cucumber|mushroom|potato|salad|greens|pea\b|peas|sweetcorn|lemon|lime|garlic|ginger|chilli|coriander|parsley|basil|mint\b|celery|beetroot|squash|pumpkin|asparagus|mangetout|green bean)/],
    ['Rice, pasta & bread', /\b(rice|pasta|spaghetti|penne|linguine|tagliatelle|noodle|udon|soba|vermicelli|orzo|couscous|quinoa|bulgur|bread|loaf|bagel|tortilla|wrap|pitta|roll\b|bun\b|brioche|sourdough|focaccia|oat|porridge|granola|muesli|gnocchi|lasagne|naan)/],
    ['Tins, pulses & jars', /\b(bean|sauce|ketchup|mayo|mustard|pesto|salsa|chutney|miso|soy\b|jar\b)/],
    ['Store cupboard', /\b(protein|whey|casein|flour|sugar|cocoa|chocolate|nuts|almond|cashew|walnut|pecan|pistachio|raisin|date|oil|spray)/],
    ['Seasoning',      /\b(salt|season|herb|spice|paprika|cumin|turmeric|oregano|thyme|rosemary|cinnamon|nutmeg|saffron|vanilla)/]
  ];
  for(const [aisle, re] of RULES) if(re.test(n)) return aisle;
  return 'Store cupboard';
}

// the same tidy-up the PDF uses, so both lists agree
function shopKey(name){
  return String(name||'').toLowerCase()
    .replace(/\s*—.*$/, '')
    .replace(/\([^)]*\)/g, '')
    .replace(/\b(raw|dry|dried|fresh|cooked|skinless|lean|trimmed|chopped|diced|sliced|grated)\b/g,'')
    .replace(/[^a-z0-9 ]/g, ' ')
    .replace(/\s+/g, ' ').trim();
}

function buildShoppingList(){
  const tally = {};
  DAYS.filter(d=>S.days[d] && !S.days[d].cleared).forEach(d=>{
    (S.days[d].meals||[]).forEach(m=>{
      const sc = currentScaled(m);
      if(!sc || !sc.ings) return;
      sc.ings.forEach(i=>{
        if(i.header || !i.grams) return;
        const raw = (i.name || i.text || '').trim();
        if(!raw) return;
        const k = shopKey(raw);
        if(!k) return;
        if(!tally[k]) tally[k] = {key:k, name:raw.replace(/\s*—.*$/, ''), grams:0,
                                  aisle:shopAisle(i.swapGroup, raw),
                                  negligible:i.negligible, unit:i.dunit||'g'};
        tally[k].grams += i.grams;
      });
    });
  });
  // corrections and extra items, kept against the week
  (S.shopEdits||[]).forEach(e=>{
    if(e.removed){ delete tally[e.key]; return; }
    if(!tally[e.key]) tally[e.key] = {key:e.key, name:e.name, grams:0,
                                      aisle:e.aisle||shopAisle(null, e.name),
                                      unit:e.unit||'g'};
    if(e.grams != null) tally[e.key].grams = e.grams;
    tally[e.key].edited = true;
  });
  return Object.values(tally).filter(x=>x.grams > 0 || x.edited);
}

function openShopping(){
  document.getElementById('shopModal').style.display='';
  renderShopping();
}
function closeShopping(){ document.getElementById('shopModal').style.display='none'; }

function renderShopping(){
  const host=document.getElementById('shopList');
  const items=buildShoppingList();
  host.innerHTML='';
  if(!items.length){
    host.innerHTML='<div class="libempty">Nothing in the plan yet.</div>'; return;
  }
  const main=items.filter(x=>!x.negligible && x.grams>=15);
  const cup =items.filter(x=>x.negligible || x.grams<15);
  const amount = it => it.grams>=1000 ? (Math.round(it.grams/100)/10)+' kg'
                     : Math.round(it.grams)+' '+(it.unit==='ml'?'ml':'g');

  SHOP_AISLES.map(a=>a[0]).concat(['Seasoning']).forEach(aisle=>{
    const list = aisle==='Seasoning' ? cup : main.filter(i=>i.aisle===aisle);
    if(!list.length) return;
    list.sort((a,b)=>a.name.localeCompare(b.name));
    const h=document.createElement('div'); h.className='shhead'; h.textContent=aisle;
    host.appendChild(h);
    list.forEach(it=>{
      const row=document.createElement('div'); row.className='shrow'+(it.edited?' edited':'');
      row.innerHTML='<div class="shn">'+esc(it.name)+
        (it.edited?'<span class="shtag">edited</span>':'')+'</div>'+
        '<div class="shq">'+(aisle==='Seasoning' ? '<span class="shtaste">to taste</span>'
          : '<input class="inp" type="number" min="0" step="5" value="'+Math.round(it.grams)+'">'
            +'<span class="shu">'+(it.unit==='ml'?'ml':'g')+'</span>')+'</div>'+
        '<button class="shx" type="button" title="Take it off the list">✕</button>';
      const inp=row.querySelector('input');
      if(inp) inp.addEventListener('change', ()=>{
        S.shopEdits=(S.shopEdits||[]).filter(e=>e.key!==it.key);
        S.shopEdits.push({key:it.key, name:it.name, grams:parseFloat(inp.value)||0,
                          aisle:it.aisle, unit:it.unit});
        save(); renderShopping();
      });
      row.querySelector('.shx').onclick=()=>{
        S.shopEdits=(S.shopEdits||[]).filter(e=>e.key!==it.key);
        S.shopEdits.push({key:it.key, removed:true});
        save(); renderShopping();
      };
      host.appendChild(row);
    });
  });
}

function addShopItem(){
  const n=document.getElementById('shAddName').value.trim();
  const g=parseFloat(document.getElementById('shAddQty').value);
  if(!n){ toast('Give it a name'); return; }
  const k=shopKey(n) || n.toLowerCase();
  S.shopEdits=(S.shopEdits||[]).filter(e=>e.key!==k);
  S.shopEdits.push({key:k, name:n, grams:isNaN(g)?100:g, aisle:shopAisle(null, n), unit:'g'});
  document.getElementById('shAddName').value='';
  document.getElementById('shAddQty').value='';
  save(); renderShopping();
}
function resetShopEdits(){
  if(!(S.shopEdits||[]).length){ toast('Nothing has been changed'); return; }
  if(!confirm('Undo every change to the shopping list and rebuild it from the plan?')) return;
  S.shopEdits=[]; save(); renderShopping();
  toast('Rebuilt from the plan');
}


/* ============ NOT LOSING WORK ============
   Clicking the dimmed area behind a screen used to close it instantly, so a
   mis-click halfway through writing a recipe threw the lot away. Now a screen
   with something in it asks first, and whatever was typed is kept so it comes
   back when the screen is reopened. */
function screenHasWork(id){
  const el=document.getElementById(id);
  if(!el) return false;
  return [...el.querySelectorAll('input[type=text], input:not([type]), input[type=number], textarea')]
    .some(x=>String(x.value||'').trim() !== '' && !x.dataset.ignoreWork);
}
function guardedClose(id, closer){
  if(!screenHasWork(id)) { closer(); return; }
  if(confirm('Close this and lose what you have typed?\n\n' +
             'Nothing has been saved yet.')) closer();
}
// keep what has been typed, so an accidental close is recoverable
function stashDraft(id, fields){
  const d={};
  fields.forEach(f=>{ const el=document.getElementById(f); if(el) d[f]=el.value; });
  S.drafts = S.drafts || {};
  if(Object.values(d).some(v=>String(v||'').trim()!=='')) S.drafts[id]=d;
  else delete S.drafts[id];
  save();
}
function restoreDraft(id, fields){
  const d=(S.drafts||{})[id];
  if(!d) return false;
  let any=false;
  fields.forEach(f=>{ const el=document.getElementById(f);
    if(el && d[f] != null && String(d[f]).trim()!==''){ el.value=d[f]; any=true; } });
  return any;
}
function clearDraft(id){ if(S.drafts) { delete S.drafts[id]; save(); } }

const CUSTOM_FIELDS=['cmName','cmIngs','cmMethod','cmServings'];

/* Every screen worth not losing work from. `fields` is everything to keep;
   `real` is the subset that decides whether anything has actually been typed,
   so a box holding a default (servings "1") does not make an untouched screen
   look half-finished. */
const DRAFT_SCREENS = {
  customModal:    {fields:CUSTOM_FIELDS, real:['cmName','cmIngs','cmMethod']},
  foodModal:      {fields:['fmName','fmBrand','fmP','fmC','fmF','fmK','fmPieceName','fmPerServ'],
                   real:['fmName','fmBrand','fmP','fmC','fmF','fmK']},
  chefNotesModal: {fields:['chefNotes','chefIntro','chefRefs'], real:['chefNotes']},
  addMealModal:   {fields:['amName','amTime','amCat','amSearch'], real:['amName','amSearch']}
};


/* ============ KEEPING WORK THROUGH ANYTHING ============
   The draft used to be written only when a screen was closed deliberately.
   Switch tabs and never come back, close the window, let the browser discard
   the page, lose power — and whatever was half-written went with it. It is
   now written as you type, and again whenever the page is hidden or unloaded,
   which covers tab switches, app switches and a phone being locked. */
function captureScreenDraft(id){
  const spec = DRAFT_SCREENS[id];
  const el = document.getElementById(id);
  if(!spec || !el || el.style.display === 'none') return;   // nothing open to save
  const d = {};
  spec.fields.forEach(f=>{ const x=document.getElementById(f); if(x) d[f]=x.value; });
  if(id === 'customModal')
    d.__picked = JSON.stringify((typeof CM_PICKED!=='undefined' && CM_PICKED) || []);
  const anything = spec.real.some(f=>String(d[f]||'').trim()!=='')
                   || (d.__picked ? JSON.parse(d.__picked).length : 0);
  S.drafts = S.drafts || {};
  if(anything) S.drafts[id] = d; else delete S.drafts[id];
  save();
}
// every open screen at once, for when the page is about to go away
function captureAllDrafts(){ Object.keys(DRAFT_SCREENS).forEach(captureScreenDraft); }
function captureCustomDraft(){ captureScreenDraft('customModal'); }

// put a screen back the way it was left
function restoreScreenDraft(id){
  const spec = DRAFT_SCREENS[id], d = (S.drafts||{})[id];
  if(!spec || !d) return false;
  let any=false;
  spec.fields.forEach(f=>{ const el=document.getElementById(f);
    if(el && d[f] != null && String(d[f]).trim()!==''){ el.value=d[f]; any=true; } });
  return any;
}

(function keepDrafts(){
  function wire(){
    // as you type, but not on every keystroke
    Object.keys(DRAFT_SCREENS).forEach(id=>{
      let t=null;
      const mark = () => { clearTimeout(t); t=setTimeout(()=>captureScreenDraft(id), 600); };
      DRAFT_SCREENS[id].fields.forEach(f=>{
        const el=document.getElementById(f);
        if(el) el.addEventListener('input', mark);
      });
    });
    // and immediately when the page goes away for any reason
    document.addEventListener('visibilitychange', ()=>{
      if(document.visibilityState === 'hidden') captureAllDrafts();
    });
    window.addEventListener('pagehide', captureAllDrafts);
    window.addEventListener('beforeunload', captureAllDrafts);
    window.addEventListener('blur', captureAllDrafts);
  }
  if(document.readyState === 'loading')
    document.addEventListener('DOMContentLoaded', wire);
  else wire();
})();

/* ============ MEALS ============ */
function refreshDayMatches(dk){
  const day=S.days[dk];
  if(!day||!day.meals) return;
  day.meals.forEach(m=>{
    if(m.recipeId){ // verify still valid vs exclusions
      const r=recipeById(m.recipeId);
      if(!r || isExcluded(r,S.excl)) m.recipeId=null;
    }
    if(!m.recipeId){
      const sc=bestMatch(m.cat,{cho:m.cho,pro:m.pro,fat:m.fat},S.excl);
      m.recipeId = sc&&sc.length? sc[0].r.id : null;
    }
  });
}
function refreshAllMatches(){ DAYS.forEach(refreshDayMatches); }

// editable day-target editor (shown after generation) — grams + g/kg per macro
function renderDayEditor(){
  const host=document.getElementById('dayEditor'); if(!host) return;
  const day=S.days[S.active]; if(!day) return;
  const bw=S.bw||90;
  const cell=(k,label,col)=>{
    const g=day[k]||0;
    return `<div class="demac">
      <div class="l"><span class="dot" style="background:${col}"></span>${label}</div>
      <div class="ins">
        <input class="g" data-k="${k}" data-t="g" type="number" min="0" inputmode="numeric" value="${g}">
        <span class="x">=</span>
        <input class="kg" data-k="${k}" data-t="gkg" type="number" min="0" step="0.05" inputmode="decimal" value="${g>0?fmtGkg(g/bw):''}"><span class="u">g/kg</span>
      </div></div>`;
  };
  host.innerHTML=`<div class="dewrap">
    <div class="detitle">Day targets</div>
    ${cell('pro','Protein','#007934')}
    ${cell('cho','Carb','#c98a00')}
    ${cell('fat','Fat','#ef6d00')}
    <div class="dekcal"><div class="v">${kcalOf({pro:day.pro,cho:day.cho,fat:day.fat})}</div><div class="l">kcal target</div></div>
  </div>`;
  host.querySelectorAll('input').forEach(inp=>{
    inp.addEventListener('input',()=>{
      const k=inp.dataset.k, t=inp.dataset.t, raw=inp.value.trim();
      if(raw===''||raw==='.') return;   // don't zero the day while the field is being cleared/typed
      const v=parseFloat(raw); if(isNaN(v)) return;
      const g=(t==='g')?Math.round(v):Math.round(v*bw);
      setDayMacro(k, Math.max(0,g), inp);
    });
    inp.addEventListener('change',()=>{
      const k=inp.dataset.k, t=inp.dataset.t, g=S.days[S.active][k]||0;
      inp.value=(t==='g')?(g>0?g:'0'):(g>0?fmtGkg(g/(S.bw||90)):'');
    });
  });
}
/* Change a day's target. It used to spread the change across the meals,
   rewriting each one's figures — which were targets then and are delivered
   macros now. Moving the target changes what you are aiming at, not what the
   food on the plate contains. */
function setDayMacro(k, grams, srcInp){
  const day=S.days[S.active];
  day[k]=grams;
  day.meals.forEach(m=>{ if(!m.recipeId) maybeRematch(m); });
  const bw=S.bw||90;
  if(srcInp){ const wrap=srcInp.closest('.demac'); const gI=wrap.querySelector('input.g'), kI=wrap.querySelector('input.kg');
    if(srcInp.dataset.t==='g'){ if(document.activeElement!==kI) kI.value=grams>0?fmtGkg(grams/bw):''; }
    else { if(document.activeElement!==gI) gI.value=grams>0?grams:0; } }
  const kcEl=document.querySelector('#dayEditor .dekcal .v');
  if(kcEl) kcEl.textContent=kcalOf({pro:day.pro,cho:day.cho,fat:day.fat});
  renderMeals(); save();
}
function renderDaySummary(){
  const day=S.days[S.active];
  let tc=0,tp=0,tf=0;
  day.meals.forEach(m=>{ const s=currentScaled(m); if(s){tc+=s.cho;tp+=s.pro;tf+=s.fat;} });
  const kc=Math.round(4*tp+4*tc+9*tf);
  const tgtKc=kcalOf({cho:day.cho,pro:day.pro,fat:day.fat});
  // a condensed copy that sticks to the top once the real one scrolls away —
  // changing a meal halfway down a long day meant scrolling back up to see
  // what it had done to the totals
  const bar=document.getElementById('stickyTotals');
  if(bar){
    const near=(a,b)=>Math.abs(a-b) <= Math.max(5, b*0.03);
    const cls=(a,b)=> near(a,b) ? 'on' : (a>b ? 'over' : 'under');
    // A bar you can read at a glance, and words for how far off it is —
    // "92g of carbs short" lands harder than two numbers to subtract.
    const gapWord = (got, want, unit) => {
      const d = Math.round(got - want);
      if(Math.abs(d) <= Math.max(5, want*0.03)) return 'on target';
      return Math.abs(d) + (unit||'') + (d < 0 ? ' short' : ' over');
    };
    const fig = (lbl, got, want, unit) => {
      const pct = want > 0 ? Math.min(140, (got/want)*100) : 0;
      return '<span class="st-m '+cls(got,want)+'">' +
        '<span class="st-lbl">'+lbl+'</span>' +
        '<span class="st-num">'+Math.round(got)+' <i>/ '+Math.round(want)+(unit||'')+'</i></span>' +
        '<span class="st-bar"><b style="width:'+Math.min(100,pct)+'%"></b>' +
          (pct > 100 ? '<u style="width:'+Math.min(40,pct-100)+'%"></u>' : '') + '</span>' +
        '<span class="st-gap">'+gapWord(got, want, unit)+'</span></span>';
    };
    bar.innerHTML =
      '<span class="st-day">'+esc(DAYFULL[S.active])+'</span>'+
      fig('Calories', kc, tgtKc, '') +
      fig('Protein',  tp, day.pro, 'g') +
      fig('Carbs',    tc, day.cho, 'g') +
      fig('Fat',      tf, day.fat, 'g');
  }

  const host=document.getElementById('daySummary');
  host.innerHTML=`
    <div class="sumcard"><div class="v">${kc}</div><div class="l">kcal planned</div></div>
    <div class="sumcard"><div class="v">${tc}<span style="font-size:11px;color:var(--faint)"> / ${day.cho}</span></div><div class="l">Carbs g</div></div>
    <div class="sumcard"><div class="v">${tp}<span style="font-size:11px;color:var(--faint)"> / ${day.pro}</span></div><div class="l">Protein g</div></div>
    <div class="sumcard"><div class="v">${tf}<span style="font-size:11px;color:var(--faint)"> / ${day.fat}</span></div><div class="l">Fat g</div></div>
    <div class="sumcard match"><div class="v" style="color:${Math.abs(kc-tgtKc)<250?'var(--teal)':'var(--amber)'}">${tgtKc} kcal</div><div class="l">Day target</div></div>`;
}
function parseTime(t){
  const mm=String(t||'').match(/^(\d{1,2}):(\d{2})$/);
  if(!mm) return null;
  return {h:Math.min(23,+mm[1]), m:Math.min(59,+mm[2])};
}
function timeVal(t){ const p=parseTime(t); return p? p.h*60+p.m : 1e9; }
// keep the day's meals in time order (a re-timed snack slots into the right place)
function sortDayByTime(day){
  if(!day||!day.meals) return;
  day.meals=day.meals
    .map((m,i)=>({m,i}))
    .sort((a,b)=>{ const d=timeVal(a.m.time)-timeVal(b.m.time); return d!==0? d : a.i-b.i; })
    .map(x=>x.m);
}
function currentScaled(m){
  const r=recipeById(m.recipeId); if(!r) return null;
  return scaledRecipe(applySwapsToRecipe(r,m),{cho:m.cho,pro:m.pro,fat:m.fat}, m.ovr);
}
/* ---- manual per-ingredient editing ---- */
// hand-set one ingredient's grams; the meal's macros (and its carb status) follow
function setIngredientGrams(m, idx, grams){
  // First hand-edit freezes every amount in this meal at its current value, so
  // changing the rice only changes the rice — nothing else drifts underneath you.
  if(!m.ovr || !Object.keys(m.ovr).length){
    const sc=currentScaled(m); m.ovr={};
    if(sc) sc.ings.forEach(ig=>{ if(!ig.header && ig.idx!=null) m.ovr[ig.idx]=ig.grams; });
  }
  m.ovr[idx] = Math.max(0, Math.round(grams));
  m.touch = m.touch || {}; m.touch[idx] = true;   // for highlighting the rows you set
  syncMealToIngredients(m);
}
function clearMealOverrides(m, quiet){
  if(m.ovr && Object.keys(m.ovr).length){
    delete m.ovr; delete m.touch;
    if(!quiet) toast('Re-scaled '+m.name+' back to its targets');
  }
}
// recompute the meal's P/C/F from whatever the ingredients now deliver
// A meal's stored macros are simply what it delivers. They used to be a
// target the recipe was scaled towards; nothing is scaled now, so a meal added
// with zeros showed blank boxes until something was edited.
function syncMealToIngredients(m){
  const sc=currentScaled(m);
  if(!sc) return;
  m.pro=sc.pro; m.cho=sc.cho; m.fat=sc.fat;
}

function renderMeals(){
  const day=S.days[S.active];
  if(!day||!day.meals) return;
  const host=document.getElementById('meals'); host.innerHTML='';

  // a day someone has deliberately emptied
  if(day.cleared){
    const e=document.createElement('div'); e.className='dayempty';
    e.innerHTML='<div class="deicon">\u2014</div>'+
      '<div class="deh">Nothing planned on this day</div>'+
      '<div class="ded">This day shows on the plan with no meals, and nothing from it '+
      'goes into the shopping list. Use it when the player is off, or the club is '+
      'feeding them.</div>'+
      '<button class="btn primary" type="button">Plan meals for this day after all</button>';
    e.querySelector('button').onclick=()=>restoreDay(S.active);
    host.appendChild(e);
    return;
  }

  // meals and supplements share one timeline, so a pre-training shake sits
  // where it actually happens rather than in a list of its own
  const mins = t => { const m=/^(\d{1,2})[:.](\d{2})/.exec(String(t||'')); 
                      return m ? (+m[1])*60+(+m[2]) : 9999; };
  // Supplements go at the top of every day rather than being slotted in by
  // their timing. Same place every day is easier to build a habit around than
  // hunting for them among the meals.
  const items = (day.supps||[]).map(sp=>({kind:'supp', at:-1, sp}))
    .concat(day.meals.map((m,idx)=>({kind:'meal', at:mins(m.time), m, idx})));
  items.sort((a,b)=>a.at-b.at);

  items.forEach((it,n)=>{
    host.appendChild(it.kind==='meal' ? mealCard(it.m,it.idx,day) : suppCard(it.sp,day));
    // somewhere to slot a meal in between two others, where you are looking
    if(it.kind==='meal'){
      const gap=document.createElement('div'); gap.className='insertgap';
      const b=document.createElement('button'); b.type='button';
      const nxt=items[n+1];
      b.textContent = nxt && nxt.kind==='meal'
        ? '+ add something between these'
        : '+ add something after this';
      b.onclick=()=>openAddMeal(it.m);
      gap.appendChild(b);
      host.appendChild(gap);
    }
  });

  // controls for this day's supplements
  const bar=document.createElement('div'); bar.className='suppbar';
  const add=document.createElement('button'); add.className='btn small';
  add.textContent='+ Supplement for this day'; add.onclick=addSuppToDay;
  bar.appendChild(add);
  if(day.suppsEdited){
    const rs=document.createElement('button'); rs.className='btn small ghost';
    rs.textContent='Back to usual protocol'; rs.onclick=resetDaySupps;
    bar.appendChild(rs);
    const note=document.createElement('span'); note.className='suppnote';
    note.textContent='This day differs from the player\'s protocol';
    bar.appendChild(note);
  }
  host.appendChild(bar);

  renderDaySummary();
}

function mealCard(m,idx,day){
  const scaled=currentScaled(m);
  const st=carbStatus(scaled?scaled.cho:m.cho);
  const el=document.createElement('div'); el.className='meal '+st;
  const snackCount=day.meals.filter(x=>x.kind==='snack').length;
  const isSnack=m.kind==='snack';

  const el_hd=document.createElement('div'); el_hd.className='mhd';
  el_hd.innerHTML=`<div class="statusbar" style="background:${STATUS_COLOR[st]}"></div>`;
  // name (editable)
  const nameIn=document.createElement('input'); nameIn.className='mname'; nameIn.value=m.name;
  nameIn.oninput=()=>{ m.name=nameIn.value; save(); };
  el_hd.appendChild(nameIn);
  // time
  const timeWrap=document.createElement('div'); timeWrap.className='time';
  timeWrap.innerHTML='<span>🕐</span>';
  // hour / minute / AM-PM pickers (stored internally as 24h "HH:MM")
  const t24=parseTime(m.time);
  const hSel=document.createElement('select'); hSel.className='tsel';
  for(let h=1;h<=12;h++){ const o=document.createElement('option'); o.value=h; o.textContent=h; hSel.appendChild(o); }
  const mSel=document.createElement('select'); mSel.className='tsel';
  for(let mi=0;mi<60;mi+=5){ const o=document.createElement('option'); o.value=mi;
    o.textContent=String(mi).padStart(2,'0'); mSel.appendChild(o); }
  const pSel=document.createElement('select'); pSel.className='tsel ampm';
  ['AM','PM'].forEach(x=>{ const o=document.createElement('option'); o.value=x; o.textContent=x; pSel.appendChild(o); });
  if(t24){
    const h12=(t24.h%12)||12;
    hSel.value=h12; mSel.value=String(Math.round(t24.m/5)*5%60); pSel.value=t24.h<12?'AM':'PM';
  } else { hSel.value=8; mSel.value=0; pSel.value='AM'; }
  const applyTime=()=>{
    let h=parseInt(hSel.value)%12; if(pSel.value==='PM') h+=12;
    m.time=String(h).padStart(2,'0')+':'+String(parseInt(mSel.value)).padStart(2,'0');
    sortDayByTime(day);            // snap the day back into chronological order
    renderMeals(); save();
  };
  [hSel,mSel,pSel].forEach(x=>x.onchange=applyTime);
  timeWrap.appendChild(hSel);
  const colon=document.createElement('span'); colon.className='tcolon'; colon.textContent=':';
  timeWrap.appendChild(colon); timeWrap.appendChild(mSel); timeWrap.appendChild(pSel);
  el_hd.appendChild(timeWrap);
  // carb tag
  const tag=document.createElement('span'); tag.className='carbtag '+st; tag.textContent=STATUS_LABEL[st];
  el_hd.appendChild(tag);
  // tools
  const tools=document.createElement('div'); tools.className='mtools';
  const mkBtn=(txt,title,fn,dis)=>{ const b=document.createElement('button'); b.className='icb'; b.innerHTML=txt; b.title=title; b.disabled=!!dis; b.onclick=fn; return b; };

  // Favourite. Sits with the other card tools rather than hidden beside the
  // recipe name, because it is something you reach for, not something you read.
  const favRec = recipeById(m.recipeId);
  if(favRec && favRec.dbId){
    const on = PLAYER_FAVS.has(favRec.dbId);
    const fb = document.createElement('button');
    fb.className = 'icb favbtn' + (on ? ' on' : '');
    fb.innerHTML = (on ? '★' : '☆') + '<span>' + (on ? 'Favourite' : 'Favourite') + '</span>';
    fb.title = S.playerId
      ? (on ? 'Remove from ' + (S.player||'this player') + "'s favourites"
            : 'Save to ' + (S.player||'this player') + "'s favourites")
      : 'Choose a player first — favourites are saved against them';
    fb.onclick = () => toggleFavourite(m.recipeId);
    tools.appendChild(fb);
  }
  if(isSnack){
    tools.appendChild(mkBtn('↑','Move up',()=>moveMeal(idx,-1),idx===0));
    tools.appendChild(mkBtn('↓','Move down',()=>moveMeal(idx,1),idx===day.meals.length-1));
  }
  tools.appendChild(mkBtn('⇄','Swap for next best',()=>swapMeal(m)));
  if(day.meals.length>1) tools.appendChild(mkBtn('✕','Delete this meal',()=>removeMeal(idx)));
  el_hd.appendChild(tools);
  el.appendChild(el_hd);

  const bd=document.createElement('div'); bd.className='mbd';
  if(!scaled){
    bd.innerHTML='<div style="color:var(--faint);font-size:13px;padding:8px 0">No matching recipe (check exclusions).</div>';
    el.appendChild(bd); return el;
  }
  const top=document.createElement('div'); top.className='mealtop';

  // recipe block
  const rb=document.createElement('div'); rb.className='recipeblock';
  const meta=scaled.base;
  // Any ingredient with a swap group can be exchanged from here — the protein,
  // the carbohydrate, the fat source, whatever the dish is built from. This is
  // the list people actually read, so the control lives here.
  let ingHtml=scaled.ings.map(i=>{
    const label = i.scaled ? '<b>'+esc(i.text)+'</b>' : esc(i.text);
    const arrow = i.scaled
      ? `<span class="scaled ${i.scaleUp?'up':'down'}" title="Recipe says ${i.baseAmount}${
          i.baseUnit ? esc(i.baseUnit) : ''} — ${i.scaleUp?'increased':'reduced'} by ${i.scalePct}% to hit the target">${
          i.scaleUp?'\u25B2':'\u25BC'} ${i.scalePct}%</span>`
      : '';
    // An ingredient with no nutrition attached contributes nothing. Without a
    // marker it is indistinguishable from salt and pepper, which genuinely are
    // zero — so a mis-typed chicken breast would sit there counting as nothing.
    const unmatched = !i.header && !i.negligible && !i.src &&
                      ((i.p||0)+(i.c||0)+(i.f||0)) === 0;
    const mark  = unmatched
      ? `<span class="swapped nomatch" title="Not in the food library — this ingredient is counting as zero. Click to pick a real food.">no match</span>`
      : (i.addedByHand
        ? `<span class="swapped added" title="Added to this meal">added</span>`
        : (i.swappedFrom
          ? `<span class="swapped" title="Swapped from ${esc(i.swappedFrom)}">swapped</span>` : ''));
    const canChange = !i.header && !i.negligible;
    const btn = canChange
      ? `<button class="swapbtn" data-swap="${i.idx}" title="Change the amount, or use something else">⇄ change</button>` +
        `<button class="dropbtn" data-drop="${i.idx}" title="Take this out of the meal" aria-label="Take out ${esc(i.name||'')}">✕</button>`
      : '';
    return `<li class="${i.scaled?'anchor':''}${canChange?' swappable':''}">${label}${arrow}${mark}${btn}</li>`;
  }).join('');
  // per-meal carb tier toggle
  const tierBtns=['low','medium','high'].map(t=>`<button class="${t} ${st===t?'on '+t:''}" data-tier="${t}">${t==='medium'?'Med':cap(t)}</button>`).join('');
  // nutritionist cross-reference: per-ingredient macros + kcal at the scaled gram amount
  const brk=scaled.ings.filter(i=>!i.header);
  const R=scaled.res||{p:0,c:0,f:0,kcal:0};
  const bT={p:R.p||0,c:R.c||0,f:R.f||0,kcal:R.kcal||0};
  brk.forEach(i=>{bT.p+=i.p;bT.c+=i.c;bT.f+=i.f;bT.kcal+=i.kcal;});
  let macroRows=brk.map(i=>{
    const srcT=i.src? ' title="'+esc(String(i.src).replace(/^curated:.*/,'Curated food table').replace(/^mccance:/,'McCance & Widdowson: ').replace(/^negligible$/,'Energy-free / trace ingredient'))+'"':'';
    if(i.negligible) return `<tr class="negrow"><td class="in"${srcT}>${esc(i.text)}</td><td class="am">–</td><td>–</td><td>–</td><td>–</td><td class="kc">–</td></tr>`;
    // editable gram amount — type here to set the portion by hand
    const amt=i.editable
      ? `<input class="gedit" type="number" min="0" step="1" value="${i.amount}" data-idx="${i.idx}" data-dens="${i.dens}" aria-label="amount"><span class="gu">${i.dunit}</span>`
      : `${i.amount}${i.dunit}`;
    // anything with a swap group can be exchanged here. The scaler re-solves
    // afterwards, so the meal still hits its targets on the new ingredient.
    const swappedMark = i.swappedFrom
      ? `<span class="swapped" title="Swapped from ${esc(i.swappedFrom)}">swapped</span>` : '';
    return `<tr class="${(m.touch&&m.touch[i.idx])?'editedrow':''}"><td class="in"${srcT}>${esc(i.text)}${swappedMark}</td><td class="am">${amt}</td><td>${i.p}</td><td>${i.c}</td><td>${i.f}</td><td class="kc">${i.kcal}</td></tr>`;
  }).join('');
  const hasRes=Math.abs(R.p)+Math.abs(R.c)+Math.abs(R.f) >= 2;
  if(hasRes) macroRows+=`<tr class="resrow"><td class="in">Recipe adjustment <span class="q" title="Difference between the summed ingredients and the recipe book's stated per-serving macros — e.g. marinade not fully consumed, cooking losses, or minor unmodelled items.">?</span></td><td class="am">–</td><td>${R.p}</td><td>${R.c}</td><td>${R.f}</td><td class="kc">${R.kcal}</td></tr>`;
  const macroTable=`<div class="ingmacros">
    <table><thead><tr><th class="in">Ingredient</th><th class="am">Amount</th><th>P</th><th>C</th><th>F</th><th class="kc">kcal</th></tr></thead>
    <tbody>${macroRows}</tbody>
    <tfoot><tr><td class="in">Total</td><td class="am"></td><td>${Math.round(bT.p)}</td><td>${Math.round(bT.c)}</td><td>${Math.round(bT.f)}</td><td class="kc">${Math.round(bT.kcal)}</td></tr></tfoot></table>
    <div class="imnote"><b>Type in the Amount column to set any portion by hand</b> — the meal's macros, calories and carb status update to match. Every ingredient is costed from McCance &amp; Widdowson (2021). Rows marked “–” are energy-free (salt, pepper, water, ice, extracts). Hover an ingredient to see its data source. Reference only — not shown in the PDF.</div></div>`;
  rb.innerHTML=`
    <div class="rtitle"><span class="rname" title="Click to rename it for this plan only">${
        esc(m.alias || scaled.name)}</span>${
      m.alias ? `<span class="aliastag" title="Renamed for this plan — the library still says ${
        esc(scaled.name)}">renamed</span>` : ''}${
      meta.dbId && PLAYER_FAVS.has(meta.dbId)
        ? `<span class="favtag" title="One of ${esc(S.player||'this player')}'s favourites">★ Favourite</span>`
        : ''}</div>
    ${m.alias ? `<div class="aliasreal">${esc(scaled.name)}</div>` : ''}
    ${(()=>{ const pc = portionCount(m);
        return pc ? `<div class="portions">${pc.count} ${esc(pc.word)} · ${pc.grams}g</div>` : ''; })()}
    <div class="rmeta">${cap(meta.category)} · ${esc(meta.protein)} · ${scaled.note}</div>
    ${meta.adapted ? `<div class="adapted ${meta.adapted.worst}">${esc(adaptationNote(meta.adapted))}</div>` : ''}
    ${(()=>{ const dn = droppedNote(m);
        return dn ? `<div class="adapted dropped">${esc(dn)}</div>` : ''; })()}
    <div class="tierwrap"><span class="tl">Carb</span><div class="tiertoggle">${tierBtns}</div>
      ${scaled.manual?'<span class="manbadge">Adjusted by hand</span><button class="rescalebtn" title="Put every amount back to what the recipe says">↺ Back to the recipe</button>':''}</div>
    <ul class="ings">${ingHtml}</ul>
    <button class="addingbtn" type="button">+ Add an ingredient</button>
    ${integrityLine(m)}
    <div class="mealfoot">
      <label class="servings">Servings
        <input class="inp servnum" type="number" min="0.25" max="6" step="0.25"
               value="${(m.ovr&&m.ovr.__servings)||1}">
      </label>
      <button class="alongbtn" type="button"
        title="Another dish at this sitting, shown as one meal">+ Add something alongside</button>
      <button class="copybtn" type="button"
        title="Put this same meal on other days">⧉ Copy to other days</button>
      <label class="methodtick" title="Only for dishes the kitchen may not know">
        <input type="checkbox" class="methodbox"${m.printMethod?' checked':''}>
        Print the method</label>
    </div>
    <div class="reftoggles">
      ${meta.directions&&meta.directions.length?`<button class="dirtoggle">${m.showDirs?'▾ Hide method':'▸ Show method'}</button>`:''}
      <button class="macrotoggle">${m.showMacros?'▾ Hide ingredient macros':'▸ Ingredient macros (reference)'}</button>
    </div>
    ${m.showDirs&&meta.directions.length?`<ol class="dirs">${meta.directions.map(d=>'<li>'+esc(d)+'</li>').join('')}</ol>`:''}
    ${m.showMacros?macroTable:''}`;
  const dt=rb.querySelector('.dirtoggle');
  if(dt) dt.onclick=()=>{ m.showDirs=!m.showDirs; renderMeals(); save(); };
  const mt=rb.querySelector('.macrotoggle');
  if(mt) mt.onclick=()=>{ m.showMacros=!m.showMacros; renderMeals(); save(); };
  const rsb=rb.querySelector('.rescalebtn');
  if(rsb) rsb.onclick=()=>{ clearMealOverrides(m); syncMealToIngredients(m); renderMeals(); save(); };
  // hand-editable ingredient amounts
  rb.querySelectorAll('.swapbtn').forEach(b=>{
    b.onclick=e=>{ e.stopPropagation(); openSwapMenu(m, +b.dataset.swap, b); };
  });
  rb.querySelectorAll('.dropbtn').forEach(b=>{
    b.onclick=e=>{ e.stopPropagation(); confirmDropIngredient(m, +b.dataset.drop, b); };
  });
  // the picker, not an automatic guess — choosing what goes alongside is
  // exactly the decision the old "auto-matched" behaviour took away
  const alongBtn=rb.querySelector('.alongbtn');
  if(alongBtn) alongBtn.onclick=e=>{ e.stopPropagation(); openAddMeal(m, 'alongside'); };
  const mbx=rb.querySelector('.methodbox');
  if(mbx) mbx.onchange=()=>{ m.printMethod=mbx.checked; save();
    toast(mbx.checked ? 'The method will print for this meal'
                      : 'The method will be left off this meal'); };
  const copyBtn=rb.querySelector('.copybtn');
  if(copyBtn) copyBtn.onclick=e=>{ e.stopPropagation(); openCopyMeal(m, copyBtn); };
  const servInp=rb.querySelector('.servnum');
  if(servInp) servInp.addEventListener('change', ()=>setMealServings(m, servInp.value));
  const addBtn=rb.querySelector('.addingbtn');
  if(addBtn) addBtn.onclick=e=>{ e.stopPropagation(); openAddIngredient(m, addBtn); };
  const bp=batchPanel(m);
  if(bp && addBtn) addBtn.insertAdjacentElement('afterend', bp);
  // the whole line is clickable, since that is what people try first
  rb.querySelectorAll('.ings li.swappable').forEach(li=>{
    li.onclick=e=>{
      if(e.target.closest('.swapmenu')) return;
      const b=li.querySelector('.swapbtn'); if(!b) return;
      e.stopPropagation(); openSwapMenu(m, +b.dataset.swap, b);
    };
  });
  rb.querySelectorAll('.gedit').forEach(inp=>{
    inp.addEventListener('change',()=>{
      const v=parseFloat(inp.value);
      if(isNaN(v)||v<0){ renderMeals(); return; }
      const dens=parseFloat(inp.dataset.dens)||1;
      setIngredientGrams(m, +inp.dataset.idx, v*dens);   // typed ml -> grams internally
      m.showMacros=true;
      renderMeals(); save();
    });
    inp.addEventListener('keydown',e=>{ if(e.key==='Enter') inp.blur(); });
  });
  rb.querySelectorAll('.tiertoggle button').forEach(b=>{
    b.onclick=()=>{ setMealTier(m, b.dataset.tier); toast('Set '+m.name+' to '+cap(b.dataset.tier)+' carb'); };
  });
  const nameEl=rb.querySelector('.rname');
  if(nameEl) nameEl.onclick=()=>{
    const now = m.alias || (currentScaled(m)||{}).name || m.name || '';
    const nu = prompt('Name for this meal in this plan only.\n' +
      'The recipe in the library keeps its own name.\n\n' +
      'Clear the box to go back to the recipe name.', now);
    if(nu === null) return;
    const t = nu.trim();
    const real = (currentScaled(m)||{}).name || '';
    m.alias = (!t || t === real) ? null : t;
    save(); renderMeals();
  };
  const star=rb.querySelector('.favstar');
  if(star) star.onclick=e=>{ e.stopPropagation(); toggleFavourite(m.recipeId); };
  top.appendChild(rb);

  // macro box (editable targets) — always Protein, Carb, Fat order.
  // each macro can be set in grams OR g/kg body weight, kept in sync.
  /* These were editable targets the recipe got scaled towards. Nothing is
     scaled now, so an editable number here would be a wish rather than a fact.
     What the meal delivers is simply what its ingredients come to. */
  const mb=document.createElement('div'); mb.className='macbox static';
  [['pro','Protein','#007934'],['cho','Carb','#c98a00'],['fat','Fat','#ef6d00']].forEach(([k,lab,col])=>{
    const row=document.createElement('div'); row.className='macrow';
    row.innerHTML=
      `<div class="ml"><span class="dot" style="background:${col}"></span>${lab}</div>` +
      `<div class="mval">${Math.round(scaled[k])}<span class="u">g</span></div>`;
    mb.appendChild(row);
  });

  const ach=document.createElement('div'); ach.className='achieved';
  ach.innerHTML=`Recipe delivers <b>${scaled.pro}P</b> / <b>${scaled.cho}C</b> / <b>${scaled.fat}F</b> · <b>${scaled.kcal} kcal</b>`;
  mb.appendChild(ach);
  top.appendChild(mb);
  bd.appendChild(top);

  // change-recipe dropdown: every recipe in the library, grouped and coloured by
  // carb status (High → Med → Low), best fits for this slot first within each band
  const tgt={cho:m.cho,pro:m.pro,fat:m.fat};
  const pool=RECIPES.filter(r=>!isExcluded(r,S.excl))
    .map(r=>{
      const d=scaledDelivered(r);
      let sc=Math.abs(d.cho-tgt.cho)+Math.abs(d.pro-tgt.pro)*0.9+Math.abs(d.fat-tgt.fat)*0.9;
      if(!sameSlot(r.category,m.cat)) sc+=60;      // other-course options rank lower
      return {r, sc};
    })
    .sort((a,b)=>a.sc-b.sc);
  if(pool.length){
    const ab=document.createElement('div'); ab.className='altbar';
    ab.innerHTML='<div class="lab">Change recipe</div>';
    // With a few hundred recipes, scrolling a dropdown is no way to find a
    // lasagne. Type a word and the list narrows to the ones that match.
    const find=document.createElement('input');
    find.className='recfind'; find.type='search'; find.placeholder='Search — chicken, lasagne, oats…';
    find.autocomplete='off';
    ab.appendChild(find);
    const sel=document.createElement('select');
    const curId=scaled.base? scaled.base.id : null;
    // Colour on an <option> is ignored by Safari and on iOS, so the carb status
    // is spelled out in the text as well. A coloured dot is just a character,
    // so it renders everywhere a dropdown does.
    const DOT={high:'\u25CF',medium:'\u25CF',low:'\u25CF'};
    const SHORT={high:'HIGH CARB',medium:'MED CARB',low:'LOW CARB'};
    const GROUPS=[['high','\u25CF  HIGH CARB  —  over 70g'],
                  ['medium','\u25CF  MEDIUM CARB  —  40 to 70g'],
                  ['low','\u25CF  LOW CARB  —  under 40g']];
    const buildOptions=(q)=>{
    sel.innerHTML='';
    const term=(q||'').trim().toLowerCase();
    const words=term? term.split(/\s+/) : [];
    // every word has to appear somewhere in the name or its ingredients, so
    // "chicken rice" finds the ones with both rather than either
    const matches = r => !words.length || words.every(wd =>
      String(r.name||'').toLowerCase().includes(wd) ||
      String(r.scan||'').toLowerCase().includes(wd));
    const shown = pool.filter(x=>matches(x.r));
    if(!shown.length){
      const og=document.createElement('optgroup'); og.label='Nothing matching \u201C'+q+'\u201D';
      sel.appendChild(og);
      return 0;
    }
    // this player's favourites first, so they are not hunted for among 300
    const favs = shown.filter(x=>x.r.dbId && PLAYER_FAVS.has(x.r.dbId));
    // and the carb bands below leave them out, so no recipe is listed twice
    if(favs.length){
      const og=document.createElement('optgroup');
      og.label='\u2605  ' + (S.player ? S.player + "'s favourites" : 'Favourites')
               + '   (' + favs.length + ')';
      og.className='og-fav';
      favs.forEach(({r})=>{
        const o=document.createElement('option'); o.value=r.id;
        const st=carbStatus(r.cho);
        o.textContent='\u2605  '+r.name
          +'  ('+r.pro+'P · '+r.cho+'C · '+r.fat+'F · '+r.kcal+'kcal)'
          +(r.id===curId?'   \u2190 current':'')
          +'   \u2014   '+SHORT[st];
        if(r.id===curId) o.selected=true;
        og.appendChild(o);
      });
      sel.appendChild(og);
    }

    const favIds=new Set(favs.map(x=>x.r.id));
    GROUPS.forEach(([st,label])=>{
      const inGroup=shown.filter(x=>carbStatus(x.r.cho)===st && !favIds.has(x.r.id));
      if(!inGroup.length) return;
      const og=document.createElement('optgroup');
      og.label=label+'   ('+inGroup.length+')';
      og.className='og-'+st;
      inGroup.forEach(({r})=>{
        const o=document.createElement('option'); o.value=r.id;
        // name first, then the numbers, with the carb band last so the column
        // of statuses lines up down the right of the list
        o.textContent=DOT[st]+'  '+r.name
          +'  ('+r.pro+'P · '+r.cho+'C · '+r.fat+'F · '+r.kcal+'kcal)'
          +(r.id===curId?'   ← current':'')+(r.custom?'   ★ your recipe':'')
          +'   —   '+SHORT[st];
        o.style.color=STATUS_COLOR[st];
        o.className='opt-'+st;
        if(r.id===curId) o.selected=true;
        og.appendChild(o);
      });
      sel.appendChild(og);
    });
    return shown.length;
    };
    buildOptions('');
    let findT=null;
    find.addEventListener('input', ()=>{
      clearTimeout(findT);
      findT=setTimeout(()=>{
        const n=buildOptions(find.value);
        find.classList.toggle('none', n===0);
        find.title = n ? n+' matching recipe'+(n===1?'':'s') : 'nothing matching';
      }, 120);
    });
    sel.className='altselect status-'+carbStatus(scaled.cho);
    sel.onchange=()=>{
      const r=recipeById(sel.value);
      if(!r) return;
      // a meal you built yourself is titled after its recipe — keep the two in step
      if(m.custom && r.id!==m.recipeId){
        m.name = r.name;
        m.custom = false;
      }
      setMealRecipe(m, r.id);
      renderMeals(); renderDaySummary(); save(); toast('Swapped in "'+r.name+'"');
    };
    ab.appendChild(sel); bd.appendChild(ab);
  }
  el.appendChild(bd);
  return el;
}
/* This used to swap a meal's recipe whenever the scaled result drifted from
   target. With nothing scaled, a recipe almost never hits a target exactly, so
   it would have been changing recipes underneath Graeme constantly. Choosing
   is his job now; all this does is fill an empty slot. */
function maybeRematch(m){
  if(m.recipeId) return;
  const sc=bestMatch(m.cat,{cho:m.cho,pro:m.pro,fat:m.fat},S.excl);
  if(sc.length){ m.recipeId=sc[0].r.id; syncMealToIngredients(m); }
}
// set a meal to a carb tier (Low/Med/High): move carb target into that band, re-pick recipe
/* Nothing is scaled now, so asking for "high carb" has to mean "find me a
   recipe that IS high carb" — not "aim at a high number and take whatever is
   nearest". The button used to spring back to medium because it reflects the
   recipe actually chosen, and the nearest match often was not high. */
function setMealTier(m, tier){
  const pool=(LIB_RECIPES.length?LIB_RECIPES:BUILTIN_RECIPES)
    .filter(r=>r.category===m.cat)
    .filter(r=>carbStatus(recipeAsWritten(r).cho)===tier)
    .filter(r=>!(S.excl||[]).some(x=>String(r.scan||'').includes(x)));

  if(!pool.length){
    toast('No ' + tier + ' carb ' + (m.cat==='lunchdinner'?'lunch or dinner':m.cat) +
          ' in the library. Nothing changed.', 5000);
    renderMeals();
    return;
  }
  if(m.ovr && Object.keys(m.ovr).length){
    delete m.ovr; delete m.touch;
    toast('Hand-set amounts cleared');
  }
  // of the ones that are genuinely this tier, the closest to what the day needs
  const day=S.days[S.active], got=dayTotals(day);
  const short={pro:day.pro-got.pro+ (m.pro||0), cho:day.cho-got.cho+(m.cho||0),
               fat:day.fat-got.fat+(m.fat||0)};
  const d=r=>{ const g=recipeAsWritten(r);
    return Math.abs(g.pro-short.pro)+Math.abs(g.cho-short.cho)+Math.abs(g.fat-short.fat)*2; };
  pool.sort((a,b)=>d(a)-d(b));
  const pick = pool.find(r=>r.id!==m.recipeId) || pool[0];
  setMealRecipe(m, pick.id);
  renderMeals(); renderDaySummary(); save();
  toast(pick.name + ' — ' + recipeAsWritten(pick).cho + 'g carbs');
}
function swapMeal(m){
  const sc=bestMatch(m.cat,{cho:m.cho,pro:m.pro,fat:m.fat},S.excl,m.recipeId);
  if(sc.length){
    setMealRecipe(m, sc[0].r.id);
    renderMeals(); renderDaySummary(); save();
    toast('Swapped for next best match');
  }
}
function moveMeal(idx,dir){
  const meals=S.days[S.active].meals; const j=idx+dir;
  if(j<0||j>=meals.length) return;
  [meals[idx],meals[j]]=[meals[j],meals[idx]]; renderMeals(); save();
}
function removeMeal(idx){
  const day=S.days[S.active];
  const m=day.meals[idx];
  if(!m || day.meals.length<=1) return;
  if(m.kind!=='snack' && !confirm('Delete "'+m.name+'"? Its macros will be shared across the remaining meals.')) return;
  day.meals.splice(idx,1);
  rebalanceDay(day);            // the day still lands on its target
  renderMeals(); save();
  toast('"'+m.name+'" deleted — day rebalanced');
}
// a meal whose amounts the user has set explicitly keeps them; the rest flex
function isFixedMeal(m){ return !!(m.custom || (m.ovr && Object.keys(m.ovr).length)); }
// share the day's targets across its meals so the day total always lands on target
/* This shared a day's target out across its meals, which made sense when each
   meal was then scaled to hit its share. Nothing is scaled now, and these
   fields hold what a meal actually delivers — so rewriting them replaced real
   figures with arbitrary ones. It now only fills a slot that has no recipe. */
function rebalanceDay(day){
  if(!day || !day.meals || !day.meals.length) return;
  day.meals.forEach(m=>{ if(!m.recipeId) maybeRematch(m); });
  day.meals.forEach(m=>{ if(m.recipeId) syncMealToIngredients(m); });
  return;
}
function rebalanceDay_OLD(day){
  if(!day || !day.meals || !day.meals.length) return;
  const fixed=day.meals.filter(isFixedMeal);
  const flex=day.meals.filter(m=>!isFixedMeal(m));
  if(!flex.length) return;
  ['pro','cho','fat'].forEach(k=>{
    const target=day[k]||0;
    const fixedSum=fixed.reduce((a,m)=>a+(m[k]||0),0);
    const remain=Math.max(0, target-fixedSum);
    const flexSum=flex.reduce((a,m)=>a+(m[k]||0),0);
    if(flexSum<=0){ const each=Math.round(remain/flex.length); flex.forEach(m=>m[k]=each); return; }
    flex.forEach(m=>{ m[k]=Math.max(0, Math.round(remain*((m[k]||0)/flexSum))); });
  });
  flex.forEach(m=>maybeRematch(m));
}
function addSnack(){
  const day=S.days[S.active];
  const m={id:'m'+Date.now()+Math.random().toString(36).slice(2,6),name:'Snack',kind:'snack',cat:'snack',
    time:'', cho:Math.round(day.cho*0.08),pro:Math.round(day.pro*0.08),fat:Math.round(day.fat*0.06),recipeId:null,showDirs:false};
  day.meals.push(m);
  rebalanceDay(day);            // make room within the day rather than adding on top
  const sc=bestMatch(m.cat,{cho:m.cho,pro:m.pro,fat:m.fat},S.excl); if(sc.length)m.recipeId=sc[0].r.id;
  sortDayByTime(day);
  renderMeals(); save();
  toast('Snack added — day rebalanced to stay on target');
}
function applyAllDays(){
  const src=S.days[S.active];
  DAYS.forEach(d=>{ if(d===S.active) return;
    // apply same day-type structure & this day's macro totals to every other day
    S.days[d]=buildDay(src.type, {cho:src.cho,pro:src.pro,fat:src.fat});
    // copy meal targets & names & times & recipes
    S.days[d].meals=src.meals.map(m=>({...m,id:'m'+Date.now()+Math.random().toString(36).slice(2,6)}));
    S.days[d].type=src.type;
  });
  render(); save(); toast('Applied to all 7 days');
}

/* ============ HELPERS ============ */
function esc(s){ return (s||'').replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c])); }
function cap(s){ return s? s.charAt(0).toUpperCase()+s.slice(1):''; }
function flashBtn(btn, label){
  if(!btn) return;
  const old=btn.textContent, wasBg=btn.style.background;
  btn.textContent=label||'Saved ✓';
  btn.style.background='#12904a'; btn.style.color='#fff'; btn.style.borderColor='transparent';
  setTimeout(()=>{ btn.textContent=old; btn.style.background=wasBg; btn.style.color=''; btn.style.borderColor=''; },1400);
}
let toastT;
function toast(msg, ms){ const t=document.getElementById('toast'); t.textContent=msg; t.classList.add('show');
  clearTimeout(toastT); toastT=setTimeout(()=>t.classList.remove('show'), ms||1900); }


/* ============ RECIPE LIBRARY (Google Sheet) ============ */
function setLibStatus(msg, cls){
  const el=document.getElementById('libStatus'); if(!el) return;
  el.textContent=msg; el.className='libstat'+(cls?' '+cls:'');
}
function showLibWarn(list){
  const el=document.getElementById('libWarn'); if(!el) return;
  if(!list || !list.length){ el.style.display='none'; el.innerHTML=''; return; }
  el.style.display='';
  el.innerHTML='<b>'+list.length+" ingredient(s) not recognised</b> — they're counted as 0 kcal. Try renaming them to a plainer food name:<br>"
    + list.slice(0,25).map(x=>'• '+esc(x)).join('<br>');
}
async function loadSheetRecipes(url, quiet){
  if(!url){ setLibStatus('Paste your published Sheet link first','err'); return; }
  setLibStatus('Loading recipes from your sheet…');
  try{
    const {recipes, skipped, unknown}=await window.CNFood.loadRecipesFromSheet(url);
    if(!recipes.length) throw new Error('No complete recipes found (each row needs macros + ingredients)');
    RECIPES=recipes;
    S.sheetUrl=url;
    setLibStatus(recipes.length+' recipes loaded from your sheet'+(skipped?' ('+skipped+' row(s) skipped — missing macros or ingredients)':''),'live');
    showLibWarn(unknown);
    if(S.generated){ refreshAllMatches(); }
    render(); save();
    if(!quiet) toast(recipes.length+' recipes loaded from your sheet');
  }catch(e){
    setLibStatus('Could not load sheet: '+e.message,'err');
    showLibWarn(null);
    if(!quiet) toast('Sheet load failed — check the link is published as CSV');
  }
}
function useBuiltinRecipes(){
  RECIPES=BUILTIN_RECIPES; S.sheetUrl='';
  setLibStatus('Using built-in recipes ('+RECIPES.length+')');
  showLibWarn(null);
  if(S.generated) refreshAllMatches();
  render(); save(); toast('Switched to built-in recipes');
}

/* ============ SHARED LIBRARY ============ */
let LIB_RECIPES=[], LIB_FOODS=[], LIB_READY=false;
function setLibStatusSB(msg, cls){
  const el=document.getElementById('libStatus'); if(!el) return;
  el.textContent=msg; el.className='libstat'+(cls?' '+cls:'');
}
function mergeLibrary(){
  // The shared database is the source of truth. All 74 of the original
  // built-in recipes are now in there too, so concatenating the two lists
  // would show every one of them twice. A built-in is only used if the
  // database does not already have a recipe by that name — which in
  // practice means only when the database is unreachable.
  if(!LIB_READY || !LIB_RECIPES.length){ RECIPES = BUILTIN_RECIPES.slice(); return; }
  const key = s => String(s||'').toLowerCase().replace(/[^a-z0-9]/g,'');
  const inDb = new Set(LIB_RECIPES.map(r=>key(r.name)));
  RECIPES = LIB_RECIPES.concat(BUILTIN_RECIPES.filter(r=>!inDb.has(key(r.name))));
}
async function loadLibrary(quiet){
  setLibStatusSB('Loading shared library…');
  try{
    const {foods, recipes}=await window.CNLib.sbLoadLibrary();
    LIB_FOODS=foods; LIB_RECIPES=recipes; LIB_READY=true;
    clearRawCache();
    // the ingredient parser needs these or an imported recipe will not
    // recognise anything the team has added to the food library
    try{ window.CNFood.setUserFoods(foods); }catch(e){}
    mergeLibrary();
    const extra = RECIPES.length - recipes.length;
    setLibStatusSB(RECIPES.length+' recipe'+(RECIPES.length===1?'':'s')+' · '+foods.length+' foods'
                   + (extra>0 ? ' (' + extra + ' not yet in the shared library)' : ''), 'live');
    if(S.generated) refreshAllMatches();
    render(); save();
  }catch(e){
    LIB_READY=false; mergeLibrary();
    const why=(e&&e.message)||'no connection';
    setLibStatusSB('Shared library offline ('+why+') — using the '+BUILTIN_RECIPES.length+' built-in recipes','err');
    console.warn('library load failed:', why);
  }
}
// recipes you've added, newest first, so a mistake can be removed
function renderLibList(){
  const host=document.getElementById('libList'); if(!host) return;
  if(!LIB_RECIPES.length){ host.innerHTML='<div class="libempty">No shared recipes yet — add one with “+ New recipe”.</div>'; return; }
  host.innerHTML='';
  LIB_RECIPES.slice(0,12).forEach(r=>{
    const row=document.createElement('div'); row.className='librow2';
    row.innerHTML=`<span class="ln">${esc(r.name)}</span><span class="lm">${r.pro}P · ${r.cho}C · ${r.fat}F · ${r.kcal}kcal</span>`;
    // no delete here. Removing a recipe affects everyone, so it happens in the
    // recipe database screen where you can see what you are doing — and it
    // archives rather than destroys.
    host.appendChild(row);
  });
}

/* ============ CUSTOM MEAL BUILDER ============ */
let CUSTOM_RECIPES=[];
function restoreCustomRecipes(){
  CUSTOM_RECIPES=(S.custom||[]).map(o=>{ const b=window.CNFood.buildCustomRecipe(o); return b? b.recipe:null; }).filter(Boolean);
  if(CUSTOM_RECIPES.length) RECIPES=RECIPES.concat(CUSTOM_RECIPES.filter(r=>!RECIPES.some(x=>x.id===r.id)));
}
let CM_PICKED=[];
const CM_UNITS=[['g','g'],['ml','ml'],['each','each'],['tbsp','tbsp'],['tsp','tsp'],['handful','handful'],['slice','slice']];
function cmLine(p){
  if(p.unit==='g'||p.unit==='ml') return p.qty+p.unit+' '+p.name;
  if(p.unit==='each') return p.qty+' '+p.name;
  return p.qty+' '+p.unit+' '+p.name;
}
// a sensible starting amount so nothing lands at a silly default
function cmDefaultAmount(f){
  const n=f.label.toLowerCase();
  if(/\b(egg|bun|pitta|wrap|tortilla|bagel|crumpet|waffle|rasher|sausage|skewer)\b/.test(n)) return [2,'each'];
  if(/\b(banana|apple|pear|orange|kiwi|peach|avocado|mango|tomato|onion|pepper|carrot|courgette)\b/.test(n)) return [1,'each'];
  if(/\bslice|bread\b/.test(n)) return [2,'slice'];
  if(/\b(oil|butter|ghee|lard)\b/.test(n)) return [1,'tbsp'];
  if(/\b(spice|paprika|cumin|cinnamon|turmeric|oregano|thyme|pepper corns|powder|seasoning)\b/.test(n)) return [1,'tsp'];
  if(/\b(honey|syrup|jam|mayonnaise|mustard|pesto|tahini|miso|puree|paste|sauce)\b/.test(n)) return [1,'tbsp'];
  if(/\b(milk|juice|stock|broth|water|cream|passata)\b/.test(n)) return [200,'ml'];
  if(/\b(chicken|beef|pork|lamb|turkey|salmon|cod|tuna|prawn|steak|mince|fillet|breast|thigh)\b/.test(n)) return [150,'g'];
  if(/\b(rice|pasta|noodle|couscous|bulgur|quinoa|oats|flour|granola)\b/.test(n)) return [75,'g'];
  if(/\b(yoghurt|yogurt|skyr|quark|cheese|feta)\b/.test(n)) return [100,'g'];
  if(/\b(nut|almond|walnut|cashew|pecan|seed|chia|flax)\b/.test(n)) return [20,'g'];
  if(/\b(whey|casein|protein)\b/.test(n)) return [30,'g'];
  if(f.kcal>=600) return [10,'g'];          // very energy dense
  if(f.kcal<=60)  return [80,'g'];          // watery veg / fruit
  return [100,'g'];
}
function cmRenderPicked(){
  const host=document.getElementById('cmPicked'); host.innerHTML='';
  CM_PICKED.forEach((p,i)=>{
    const line=cmLine(p);
    const r=window.CNFood.resolveIngredient(line);
    const kc=r? Math.round(r.grams*(4*r.pg+4*r.cg+9*r.fg)) : 0;
    const row=document.createElement('div'); row.className='pk';
    row.innerHTML=`<span class="pknm">${esc(p.name)}</span>`;
    const q=document.createElement('input'); q.type='number'; q.min='0'; q.value=p.qty;
    const u=document.createElement('select');
    CM_UNITS.forEach(([v,l])=>{ const o=document.createElement('option'); o.value=v; o.textContent=l;
      if(v===p.unit)o.selected=true; u.appendChild(o); });
    const kcs=document.createElement('span'); kcs.className='pkkc'; kcs.textContent=kc+' kcal';
    const x=document.createElement('button'); x.className='pkx'; x.textContent='✕';
    q.onchange=()=>{ p.qty=Math.max(0,parseFloat(q.value)||0); cmRenderPicked(); };
    u.onchange=()=>{ p.unit=u.value; cmRenderPicked(); };
    x.onclick=()=>{ CM_PICKED.splice(i,1); cmRenderPicked(); };
    row.appendChild(q); row.appendChild(u); row.appendChild(kcs); row.appendChild(x);
    host.appendChild(row);
  });
  document.getElementById('cmIngs').value=CM_PICKED.map(cmLine).join('\n');
  previewCustom();
}
let CM_SEQ = 0;
function cmRenderResults(list){
  const box=document.getElementById('cmResults');
  if(!list.length){ box.style.display=''; box.innerHTML='<div class="cmnores">No match — try a plainer name (e.g. “chicken breast”, “basmati rice”).</div>'; return; }
  box.style.display=''; box.innerHTML='';
  list.forEach(f=>{
    const d=document.createElement('div'); d.className='cmres';
    d.innerHTML=`<span class="nm">${esc(f.label)}${f.src==='Curated'?'<span class="tagc">common</span>':''}</span>`
      +`<span class="mc">${f.kcal} kcal · ${f.p}P ${f.c}C ${f.f}F /100g</span>`;
    if(f.src==='Library') d.querySelector('.nm').innerHTML+='<span class="tagc">shared</span>';
    /* mousedown, not click. The search runs against the database, so a result
       arriving a moment later rebuilt this list between the mouse going down
       and coming up — and the click never landed. mousedown fires first. */
    d.onmousedown=e=>{
      e.preventDefault();
      const [qty,unit]=cmDefaultAmount(f);
      CM_PICKED.push({name:f.label, qty:qty, unit:unit, food:f});
      document.getElementById('cmSearch').value='';
      box.style.display='none';
      CM_SEQ++;                 // ignore anything still in flight
      cmRenderPicked();
    };
    box.appendChild(d);
  });
}
function openCustomModal(){
  document.getElementById('cmName').value='';
  document.getElementById('cmIngs').value='';
  CM_PICKED=[]; cmRenderPicked();
  document.getElementById('cmSearch').value='';
  document.getElementById('cmResults').style.display='none';
  document.getElementById('cmMethod').value='';
  document.getElementById('cmWarn').style.display='none';
  document.getElementById('cmPreview').textContent='Add ingredients to see the macros';
  document.getElementById('customModal').style.display='';
  // anything typed before an accidental close comes back
  const draft=(S.drafts||{}).customModal;
  if(draft){
    // the picked foods first, because redrawing them rewrites the ingredients
    // box — restoring the text before that would wipe it
    if(draft.__picked){ try{ CM_PICKED=JSON.parse(draft.__picked); cmRenderPicked(); }catch(e){} }
    restoreDraft('customModal', CUSTOM_FIELDS);
    previewCustom();
    toast('Picked up where you left off', 4000);
  }
  document.getElementById('cmSearch').focus();
}
function closeCustomModal(){
  captureCustomDraft();          // keep the work rather than discard it
  document.getElementById('customModal').style.display='none';
}
function previewCustom(){
  const b=window.CNFood.buildCustomRecipe({
    name:document.getElementById('cmName').value,
    ingredients:document.getElementById('cmIngs').value,
    category:document.getElementById('cmCat').value});
  const pv=document.getElementById('cmPreview'), wn=document.getElementById('cmWarn');
  if(!b){ pv.textContent='Add ingredients to see the macros'; wn.style.display='none'; return; }
  const r=b.recipe;
  pv.innerHTML=`Works out to <b>${r.pro}g protein</b> · <b>${r.cho}g carbs</b> · <b>${r.fat}g fat</b> · <span class="kc">${r.kcal} kcal</span>`;
  if(b.unknown.length){
    wn.style.display=''; wn.innerHTML='<b>Not recognised</b> (counted as 0 kcal) — try a plainer name:<br>'
      + b.unknown.slice(0,8).map(x=>'• '+esc(x)).join('<br>');
  } else wn.style.display='none';
}
// turn a picked row into the food record the library needs
function cmFoodRecord(p){
  const f=p.food||{};
  if(f.dbFood) return {dbId:f.dbFood.id, name:f.dbFood.name};
  const r=window.CNFood.resolveIngredient(cmLine(p));
  const per100 = r && r.grams>0 ? {p:r.pg*100, c:r.cg*100, f:r.fg*100}
                                : {p:f.p||0, c:f.c||0, f:f.f||0};
  return {
    name: p.name,
    p: per100.p, c: per100.c, f: per100.f,
    kcal: 4*per100.p + 4*per100.c + 9*per100.f,
    default_unit: (r && r.dunit==='ml') ? 'ml' : 'g',
    density: (r && r.dens && r.dens!==1) ? r.dens : null,
    piece_grams: (r && r.unit==='each' && r.unitGrams>0) ? Math.round(r.unitGrams) : null,
    is_custom: false
  };
}
async function saveRecipeToLibrary(){
  const name=document.getElementById('cmName').value.trim();
  if(!name){ toast('Give the recipe a name'); return; }
  if(!CM_PICKED.length){ toast('Add at least one ingredient'); return; }
  const btn=document.getElementById('cmSaveLib');
  btn.disabled=true; btn.textContent='Saving…';
  try{
    await window.CNLib.sbSaveRecipe({
      name: name, slot: document.getElementById('cmCat').value,
      servings: Math.max(1, parseInt(document.getElementById('cmServings').value)||1),
      method: document.getElementById('cmMethod').value,
      items: CM_PICKED.map(p=>({food: cmFoodRecord(p), qty: p.qty, unit: p.unit}))
    });
    flashBtn(btn,'Saved ✓');
    toast('"'+name+'" saved to the shared library');
    clearDraft('customModal');
    CM_PICKED=[];
    setTimeout(()=>{ document.getElementById('customModal').style.display='none'; }, 700);
    await loadLibrary(true); renderLibList();
    if(document.getElementById('recipeDbModal').style.display !== 'none') renderRecipeDb();
  }catch(e){
    toast('Could not save: '+e.message);
  }finally{ btn.disabled=false; btn.textContent='Save to library'; }
}
function saveCustomMeal(){
  const o={name:document.getElementById('cmName').value.trim()||'Custom meal',
    ingredients:document.getElementById('cmIngs').value,
    method:document.getElementById('cmMethod').value,
    category:document.getElementById('cmCat').value,
    id:'c'+Date.now().toString(36)};
  const b=window.CNFood.buildCustomRecipe(o);
  if(!b){ toast('Add at least one ingredient'); return; }
  const r=b.recipe;
  S.custom=(S.custom||[]).concat([o]);
  RECIPES=RECIPES.concat([r]);
  const day=S.days[S.active];
  const isSnack=(o.category==='snack'||o.category==='smoothie');
  day.meals.push({id:'m'+Date.now()+Math.random().toString(36).slice(2,6),
    name:o.name, kind:isSnack?'snack':'meal', cat:o.category, time:'',
    cho:r.cho, pro:r.pro, fat:r.fat, recipeId:r.id, showDirs:false, custom:true});
  rebalanceDay(day);
  sortDayByTime(day);
  closeCustomModal(); renderMeals(); save();
  toast('"'+o.name+'" added — '+r.kcal+' kcal');
}

/* ============ SIGN IN ============ */
function showAuth(show){
  document.getElementById('authScreen').style.display = show ? '' : 'none';
}
function renderWhoami(){
  const u=window.CNLib.sbUser();
  const el=document.getElementById('whoami'); if(!el) return;
  if(u){
    el.innerHTML=esc(u.email)+' · <button class="signout" id="signOutBtn">Sign out</button>';
    const b=document.getElementById('signOutBtn');
    if(b) b.onclick=()=>{ window.CNLib.sbSignOut(); location.reload(); };
  } else el.textContent='';
}
async function doSignIn(){
  const email=document.getElementById('authEmail').value.trim();
  const pass=document.getElementById('authPass').value;
  const err=document.getElementById('authErr');
  const btn=document.getElementById('authBtn');
  if(!email||!pass){ err.style.display=''; err.textContent='Enter your email and password.'; return; }
  btn.disabled=true; btn.textContent='Signing in…'; err.style.display='none';
  try{
    await window.CNLib.sbSignIn(email,pass);
    showAuth(false); renderWhoami();
    await loadLibrary(true); renderLibList(); await loadPlayers();
    toast('Signed in');
  }catch(e){
    err.style.display='';
    err.textContent = /invalid/i.test(e.message)
      ? 'That email or password was not recognised.' : e.message;
  }finally{ btn.disabled=false; btn.textContent='Sign in'; }
}
// returns true if we already have a valid session
async function checkSession(){
  if(!window.CNLib.sbUser()) return false;
  return !!(await window.CNLib.sbRefresh());
}

/* ============ PLAYERS & SAVED WEEKS ============ */
let PLAYERS=[];
// Sign-in is BUILT but dormant while we finish building.
// Flip this to true (and run the lock-down SQL) when you're ready to go live.
const AUTH_REQUIRED=false;
function fillPlayerSelects(){
  [['playerSel', S.playerId||''],['wmPlayer','']].forEach(([id,val])=>{
    const sel=document.getElementById(id); if(!sel) return;
    const keep=sel.value;
    sel.innerHTML = id==='playerSel' ? '<option value="">— New / unsaved —</option>'
                                     : '<option value="">All players</option>';
    PLAYERS.forEach(p=>{ const o=document.createElement('option'); o.value=p.id; o.textContent=p.name; sel.appendChild(o); });
    sel.value = keep || val || '';
  });
}
async function loadPlayers(){
  try{ PLAYERS=await window.CNLib.sbPlayers(); fillPlayerSelects(); }
  catch(e){ console.warn('players load failed', e.message); }
  // A player stays selected across a reload, but nothing was fetching their
  // day-type targets, avoids, favourites or supplements again — so generating
  // after a refresh quietly fell back to the sidebar defaults.
  if(S.playerId && PLAYERS.some(p=>p.id===S.playerId)){
    await Promise.all([
      loadPlayerDayTargets(S.playerId),
      loadPlayerAvoids(S.playerId),
      loadPlayerFavs(S.playerId),
      loadPlayerSupps(S.playerId)
    ]);
    renderExclusions(); render();
  }
}
// choosing a player fills in their name, weight and default targets
function applyPlayer(id){
  S.playerId=id||'';
  const p=PLAYERS.find(x=>x.id===id);
  if(p){
    S.player=p.name;
    if(p.bodyweight) S.bw=+p.bodyweight;
    // their saved targets become the defaults, and seed any day left blank
    let got=false;
    if(p.pro_g){ S.global.pro=+p.pro_g; got=true; }
    if(p.cho_g){ S.global.cho=+p.cho_g; got=true; }
    if(p.fat_g){ S.global.fat=+p.fat_g; got=true; }
    if(got && !S.generated){
      DAYS.forEach(d=>{ S.dayTargets[d]={pro:S.global.pro, cho:S.global.cho, fat:S.global.fat}; });
      toast(p.name+"'s saved targets applied");
    } else if(got){
      toast(p.name+"'s targets loaded as the defaults");
    }
  }
  render(); save();
  loadPlayerDayTargets(id);
  loadPlayerAvoids(id).then(()=>{ if(S.generated) refreshAllMatches(); renderExclusions(); render(); });
  loadPlayerFavs(id).then(()=>render());
  loadPlayerSupps(id).then(()=>render());
}
// held so changing a day's type can fill that day's targets from the player
let PLAYER_DAYT={};
async function loadPlayerDayTargets(id){
  PLAYER_DAYT={};
  if(!id) return;
  try{ PLAYER_DAYT=await window.CNLib.sbDayTargets(id); }
  catch(e){ console.warn('day targets load failed', e.message); }
}
// g/kg for a day type, turned into grams at this player's weight
function targetsForDayType(type){
  const v=PLAYER_DAYT[type]; if(!v) return null;
  const bw=+S.bw||0; if(!bw) return null;
  if(v.pro==null && v.cho==null && v.fat==null) return null;
  return {pro: v.pro!=null?Math.round(v.pro*bw):S.global.pro,
          cho: v.cho!=null?Math.round(v.cho*bw):S.global.cho,
          fat: v.fat!=null?Math.round(v.fat*bw):S.global.fat};
}
function openPlayerModal(){
  pmClearForm(); renderPlayerList();
  document.getElementById('playerModal').style.display='';
  // if a player is already chosen, open straight onto them rather than a blank
  // form — nobody clicks "Player data" wanting to add somebody else
  const sel=document.getElementById('playerSel');
  const cur=(S.playerId||(sel&&sel.value)||'');
  const p=PLAYERS.find(x=>x.id===cur);
  if(p) pmLoadPlayer(p);
}
function closePlayerModal(){ document.getElementById('playerModal').style.display='none'; }
function pmClearForm(){
  ['pmId','pmName','pmBw','pmHt','pmBwAt','pmNotes','pmPro','pmCho','pmFat',
   'pmProKg','pmChoKg','pmFatKg','pmAvoidSearch'].forEach(i=>{
    const el=document.getElementById(i); if(el) el.value='';
  });
  PM_DAYT={}; PM_AVOIDS=[];
  pmRenderDayGrid(); pmRenderAvoids(); pmBwAge(); pmKcalLine();
  pmTab('pmTabAbout');
  document.getElementById('pmFormTitle').textContent='Add a player';
}
function renderPlayerList(){
  const host=document.getElementById('pmList'); if(!host) return;
  if(!PLAYERS.length){ host.innerHTML='<div class="libempty">No players yet — add one below.</div>'; return; }
  host.innerHTML='';
  PLAYERS.forEach(p=>{
    const row=document.createElement('div'); row.className='pmrow';
    row.innerHTML=`<span class="pn pname">${esc(p.name)}</span><span class="pd">${p.bodyweight?p.bodyweight+'kg':''}${p.height_cm?' · '+p.height_cm+'cm':''}</span>`;
    const ed=document.createElement('button'); ed.textContent='Edit';
    ed.onclick=()=>{ pmTab('pmTabAbout'); pmLoadPlayer(p); };
    // the name is clickable too — most people reach for that before the button
    const nameEl=row.querySelector('.pname');
    if(nameEl){ nameEl.onclick=()=>{ pmTab('pmTabAbout'); pmLoadPlayer(p); }; }
    const del=document.createElement('button'); del.className='del'; del.textContent='Delete';
    del.onclick=async()=>{
      if(!confirm('Delete '+p.name+'? Their saved weeks go too.')) return;
      try{ await window.CNLib.sbDeletePlayer(p.id); await loadPlayers(); renderPlayerList(); toast(p.name+' deleted'); }
      catch(e){ toast('Could not delete: '+e.message); }
    };
    row.appendChild(ed); row.appendChild(del); host.appendChild(row);
  });
}

/* ============ PLAYER PROFILE ============
   Everything known about a player in one place: who they are, what they hit on
   each day type, what they cannot or will not eat, and anything worth noting. */
let PM_AVOIDS = [];          // the avoid list for whoever is being edited
let PM_DAYT   = {};          // their g/kg by day type

function pmTab(which){
  ['pmTabAbout','pmTabTargets','pmTabAvoid','pmTabFavs','pmTabSupps',
   'pmTabWeeks','pmTabNotes'].forEach(id=>{
    const el=document.getElementById(id); if(el) el.style.display = (id===which)?'':'none';
  });
  document.querySelectorAll('.pmtab').forEach(b=>{
    b.classList.toggle('on', b.dataset.tab===which);
  });
}

/* ---- targets per day type ---- */
function pmRenderDayGrid(){
  const host=document.getElementById('pmDayGrid'); if(!host) return;
  const types=(window.CNLib && window.CNLib.CN_DAYTYPES) || DAYTYPES;
  const bw=pmBw();
  host.innerHTML='';
  const hd=document.createElement('div'); hd.className='pmdayhd';
  hd.innerHTML='<span>Day type</span><span>Protein</span><span>Carbs</span>'+
               '<span>Fat</span><span>Calories</span>';
  host.appendChild(hd);
  types.forEach(dt=>{
    const v=PM_DAYT[dt]||{};
    const row=document.createElement('div'); row.className='pmdayrow';
    const kc = (v.pro||v.cho||v.fat)&&bw
      ? Math.round(bw*(4*(v.pro||0)+4*(v.cho||0)+9*(v.fat||0)))+' kcal' : '';
    row.innerHTML =
      '<div class="pmdayname">'+esc(dt)+'</div>' +
      ['pro','cho','fat'].map(k=>
        '<div class="pmdaycell"><span class="pmk">'+
        ({pro:'Protein',cho:'Carbs',fat:'Fat'}[k])+'</span>'+
        '<input class="inp" type="number" step="0.05" min="0" ' +
        'data-dt="'+esc(dt)+'" data-k="'+k+'" value="'+(v[k]!=null?v[k]:'')+'" ' +
        'placeholder="—"><span class="pmu">g/kg</span>' +
        '<span class="pmdaygram">'+(bw&&v[k]!=null?Math.round(v[k]*bw)+'g':'')+'</span></div>').join('') +
      '<div class="pmdaykcal">'+kc+'</div>';
    host.appendChild(row);
  });
  host.querySelectorAll('input').forEach(inp=>{
    inp.addEventListener('input',()=>{
      const dt=inp.dataset.dt, k=inp.dataset.k;
      const raw=inp.value.trim();
      PM_DAYT[dt]=PM_DAYT[dt]||{};
      PM_DAYT[dt][k] = raw==='' ? null : (parseFloat(raw)||null);
      // redraw only the grams and kcal, so the caret stays where it is
      const row=inp.closest('.pmdayrow'); const bw2=pmBw();
      const cell=inp.parentElement.querySelector('.pmdaygram');
      if(cell) cell.textContent = (bw2 && PM_DAYT[dt][k]!=null) ? Math.round(PM_DAYT[dt][k]*bw2)+'g' : '';
      const v=PM_DAYT[dt];
      const kcEl=row.querySelector('.pmdaykcal');
      if(kcEl) kcEl.textContent = (bw2 && (v.pro||v.cho||v.fat))
        ? Math.round(bw2*(4*(v.pro||0)+4*(v.cho||0)+9*(v.fat||0)))+' kcal' : '';
    });
  });
}

/* ---- foods and categories to avoid ---- */
const PM_GROUP_LABELS = {
  poultry:'all poultry', pork:'all pork', red_meat:'all red meat',
  white_fish:'all white fish', oily_fish:'all oily fish', shellfish:'all shellfish',
  egg:'all eggs', plant_protein:'all tofu and meat substitutes', legume:'all beans and pulses',
  yoghurt:'all yoghurt', cheese:'all cheese', cream_dairy:'all milk and cream',
  nut_seed:'all nuts and seeds', nut_butter:'all nut butters',
  mushroom:'all mushrooms', allium:'all onion and garlic', tomato:'all tomatoes'
};
function pmRenderAvoids(){
  const host=document.getElementById('pmAvoidList'); if(!host) return;
  if(!PM_AVOIDS.length){
    host.innerHTML='<div class="libempty">Nothing recorded. Anything added here is swapped or left out of their plans.</div>';
    return;
  }
  const SEV={allergy:'Allergy', intolerance:'Intolerance', dislike:'Dislike'};
  host.innerHTML='';
  PM_AVOIDS.forEach(a=>{
    const row=document.createElement('div'); row.className='pmavoid sev-'+a.severity;
    const what = a.foods ? a.foods.name
               : a.swap_group ? (PM_GROUP_LABELS[a.swap_group]||a.swap_group)
               : ('anything containing ' + a.allergen);
    row.innerHTML='<span class="sev">'+SEV[a.severity]+'</span><span class="what">'+esc(what)+'</span>';
    const rm=document.createElement('button'); rm.className='del'; rm.textContent='Remove';
    rm.onclick=async()=>{
      try{
        if(a.id && !String(a.id).startsWith('new_')) await window.CNLib.sbRemoveAvoid(a.id);
        PM_AVOIDS=PM_AVOIDS.filter(x=>x!==a); pmRenderAvoids();
      }catch(e){ toast('Could not remove: '+e.message); }
    };
    row.appendChild(rm); host.appendChild(row);
  });
}
// suggests both single foods and whole categories, so "no pork" is one click
function pmAvoidSuggest(){
  const q=document.getElementById('pmAvoidSearch').value.trim().toLowerCase();
  const box=document.getElementById('pmAvoidAC');
  if(q.length<2){ box.style.display='none'; return; }
  const out=[];
  Object.keys(PM_GROUP_LABELS).forEach(g=>{
    if(g.replace('_',' ').includes(q) || PM_GROUP_LABELS[g].includes(q))
      out.push({kind:'group', group:g, label:PM_GROUP_LABELS[g]});
  });
  (LIB_FOODS||[]).forEach(f=>{
    if(String(f.name).toLowerCase().includes(q))
      out.push({kind:'food', id:f.id, label:f.name, group:f.swap_group});
  });
  if(!out.length){ box.style.display='none'; return; }
  box.innerHTML=''; box.style.display='';
  out.slice(0,10).forEach(o=>{
    const b=document.createElement('button'); b.type='button'; b.className='acitem';
    b.innerHTML = o.kind==='group'
      ? '<b>'+esc(o.label)+'</b> <span class="acsub">whole category</span>'
      : esc(o.label);
    b.onmousedown=e=>{ e.preventDefault();
      box.dataset.pick=JSON.stringify(o);
      document.getElementById('pmAvoidSearch').value=o.label;
      box.style.display='none';
    };
    box.appendChild(b);
  });
}
async function pmAddAvoid(){
  const box=document.getElementById('pmAvoidAC');
  const sev=document.getElementById('pmAvoidSev').value;
  let pick=null;
  try{ pick=JSON.parse(box.dataset.pick||'null'); }catch(e){}
  const typed=document.getElementById('pmAvoidSearch').value.trim();
  if(!pick && !typed){ toast('Type a food or category first'); return; }
  const row = pick && pick.kind==='group' ? {swap_group:pick.group, severity:sev}
            : pick && pick.kind==='food'  ? {food_id:pick.id, severity:sev}
            : {allergen:typed, severity:sev};       // free text falls back to an allergen
  const pid=document.getElementById('pmId').value;
  try{
    if(pid){
      const saved=await window.CNLib.sbAddAvoid(pid, row);
      PM_AVOIDS.push(Object.assign({}, row, saved && saved[0] ? saved[0] : {},
        pick && pick.kind==='food' ? {foods:{name:pick.label}} : {}));
    }else{
      // player not saved yet — hold it and write it when they are
      PM_AVOIDS.push(Object.assign({id:'new_'+Math.random().toString(36).slice(2)}, row,
        pick && pick.kind==='food' ? {foods:{name:pick.label}} : {}));
    }
    document.getElementById('pmAvoidSearch').value=''; delete box.dataset.pick;
    pmRenderAvoids();
  }catch(e){ toast('Could not add: '+e.message); }
}

/* ---- every week saved against this player ---- */
async function pmRenderWeeks(){
  const host=document.getElementById('pmWeekList'); if(!host) return;
  const pid=document.getElementById('pmId').value;
  if(!pid){
    host.innerHTML='<div class="libempty">Save the player first and their weeks will appear here.</div>';
    return;
  }
  host.innerHTML='<div class="libempty">Loading…</div>';
  try{
    const plans=await window.CNLib.sbPlans(pid);
    if(!plans.length){
      host.innerHTML='<div class="libempty">No weeks saved for this player yet.</div>'; return;
    }
    host.innerHTML='';
    plans.forEach(pl=>{
      const row=document.createElement('div'); row.className='pmweek';
      const macs=(pl.avg_pro!=null)? pl.avg_pro+'P · '+pl.avg_cho+'C · '+pl.avg_fat+'F' : '';
      row.innerHTML='<span class="wk">w/c '+esc(fmtWeek(pl.week_start))+'</span>'+
        '<span class="mm">'+(pl.avg_kcal? pl.avg_kcal+' kcal/day':'')+
        (macs? '  ·  '+macs:'')+(pl.bodyweight? '  ·  '+pl.bodyweight+'kg':'')+'</span>'+
        '<span class="go">Open →</span>';
      row.onclick=async()=>{
        if(S.generated && !confirm('Open this week? The week you have open now will be replaced.')) return;
        closePlayerModal();
        await loadWeek(pl.id);
      };
      host.appendChild(row);
    });
  }catch(e){ host.innerHTML='<div class="libempty">Could not load: '+esc(e.message)+'</div>'; }
}


/* ---- favourite meals ---- */
let PM_FAVS = [];
let PLAYER_FAVS = new Set();     // recipe ids favoured by whoever is selected

async function loadPlayerFavs(id){
  PLAYER_FAVS = new Set();
  if(!id) return;
  try{
    const rows = await window.CNLib.sbFavourites(id);
    rows.forEach(r=>PLAYER_FAVS.add(r.recipe_id));
  }catch(e){ console.warn('favourites load failed', e.message); }
}
// the db keeps recipe ids; the app works in its own ids, so map through dbId
function recipeByDbId(dbId){ return LIB_RECIPES.find(r=>r.dbId===dbId); }

function pmRenderFavs(){
  const host=document.getElementById('pmFavList'); if(!host) return;
  if(!PM_FAVS.length){
    host.innerHTML='<div class="libempty">No favourites yet. Star a meal in the plan, or add one above.</div>';
    return;
  }
  const CATS=[['breakfast','Breakfast'],['smoothie','Smoothies'],
              ['snack','Snacks'],['lunchdinner','Lunch & dinner']];
  host.innerHTML='';
  CATS.forEach(([key,label])=>{
    const inCat=PM_FAVS.filter(f=>{
      const r=recipeByDbId(f.recipe_id); return r && r.category===key;
    });
    if(!inCat.length) return;
    const hd=document.createElement('div'); hd.className='pmgrouphd'; hd.textContent=label;
    host.appendChild(hd);
    inCat.forEach(f=>{
      const r=recipeByDbId(f.recipe_id);
      const row=document.createElement('div'); row.className='pmfav';
      row.innerHTML='<span class="nm">'+esc(r.name)+'</span>'+
        '<span class="dz">'+r.pro+'P · '+r.cho+'C · '+r.fat+'F</span>';
      const rm=document.createElement('button'); rm.className='del'; rm.textContent='Remove';
      rm.onclick=async()=>{
        const pid=document.getElementById('pmId').value;
        try{
          if(pid) await window.CNLib.sbRemoveFavourite(pid, f.recipe_id);
          PM_FAVS = pid ? await window.CNLib.sbFavourites(pid) : PM_FAVS.filter(x=>x!==f);
          if(pid===S.playerId) PLAYER_FAVS.delete(f.recipe_id);
          pmRenderFavs(); render();
        }catch(e){ toast('Could not remove: '+e.message); }
      };
      row.appendChild(rm); host.appendChild(row);
    });
  });
}
function pmFavSuggest(){
  const q=document.getElementById('pmFavSearch').value.trim().toLowerCase();
  const box=document.getElementById('pmFavAC');
  if(q.length<2){ box.style.display='none'; return; }
  const have=new Set(PM_FAVS.map(f=>f.recipe_id));
  const hits=LIB_RECIPES.filter(r=>r.name.toLowerCase().includes(q) && !have.has(r.dbId)).slice(0,10);
  if(!hits.length){ box.style.display='none'; return; }
  box.innerHTML=''; box.style.display='';
  hits.forEach(r=>{
    const b=document.createElement('button'); b.type='button'; b.className='acitem';
    b.innerHTML=esc(r.name)+'<span class="acsub">'+esc(r.category||'')+'</span>';
    b.onmousedown=e=>{ e.preventDefault();
      box.dataset.pick=r.dbId; document.getElementById('pmFavSearch').value=r.name;
      box.style.display='none'; };
    box.appendChild(b);
  });
}
async function pmAddFav(){
  const box=document.getElementById('pmFavAC');
  const dbId=box.dataset.pick;
  const pid=document.getElementById('pmId').value;
  if(!dbId){ toast('Pick a meal from the list first'); return; }
  if(!pid){ toast('Save the player first'); return; }
  try{
    await window.CNLib.sbAddFavourite(pid, dbId);
    // read it back rather than guessing what the database now holds
    PM_FAVS = await window.CNLib.sbFavourites(pid);
    if(pid===S.playerId) PLAYER_FAVS.add(dbId);
    document.getElementById('pmFavSearch').value=''; delete box.dataset.pick;
    pmRenderFavs(); render();
  }catch(e){ toast(/duplicate|unique/i.test(e.message)?'Already a favourite':'Could not add: '+e.message); }
}
// the star on a meal card
async function toggleFavourite(recipeId){
  if(!S.playerId){ toast('Choose a player first — favourites are saved against them'); return; }
  const r=RECIPES.find(x=>x.id===recipeId);
  const dbId=r&&r.dbId;
  if(!dbId){ toast('Only shared-library recipes can be favourited'); return; }
  try{
    if(PLAYER_FAVS.has(dbId)){
      await window.CNLib.sbRemoveFavourite(S.playerId, dbId);
      PLAYER_FAVS.delete(dbId); toast('Removed from '+S.player+"'s favourites");
    }else{
      await window.CNLib.sbAddFavourite(S.playerId, dbId);
      PLAYER_FAVS.add(dbId); toast('Saved to '+S.player+"'s favourites");
    }
    render();
  }catch(e){ toast('Could not save: '+e.message); }
}

/* ---- a player's standing supplement protocol ---- */
let PM_SUPPS = [];
async function pmRenderSupps(){
  const host=document.getElementById('pmSuppList'); if(!host) return;
  const pid=document.getElementById('pmId').value;
  if(!pid){ host.innerHTML='<div class="libempty">Save the player first.</div>'; return; }
  try{ PM_SUPPS = await window.CNLib.sbPlayerSupplements(pid); }
  catch(e){ host.innerHTML='<div class="libempty">Could not load: '+esc(e.message)+'</div>'; return; }
  if(!PM_SUPPS.length){ host.innerHTML='<div class="libempty">None set. Add one above and it appears on every day.</div>'; return; }
  const label=sl=>{ const s=DAY_SLOTS.find(x=>x.slot===sl); return s?s.label:(sl||'—'); };
  host.innerHTML='';
  PM_SUPPS.forEach(x=>{
    const row=document.createElement('div'); row.className='pmfav';
    row.innerHTML='<span class="cat">'+esc(label(x.slot))+'</span>'+
      '<span class="nm">'+esc(x.supplements?x.supplements.name:'')+'</span>'+
      '<span class="dz">'+(x.dose_amount!=null?(+x.dose_amount)+' '+esc(x.dose_unit||''):'')+'</span>';
    const rm=document.createElement('button'); rm.className='del'; rm.textContent='Remove';
    rm.onclick=async()=>{ try{ await window.CNLib.sbRemovePlayerSupplement(x.id); pmRenderSupps(); }
      catch(e){ toast('Could not remove: '+e.message); } };
    row.appendChild(rm); host.appendChild(row);
  });
}
async function pmSuppSetup(){
  try{ if(!DAY_SLOTS.length) DAY_SLOTS = await window.CNLib.sbDaySlots(); }catch(e){}
  try{ if(!SUPPS.length) SUPPS = await window.CNLib.sbSupplements(); }catch(e){}
  const pick=document.getElementById('pmSuppPick');
  pick.innerHTML=SUPPS.map(x=>'<option value="'+esc(x.id)+'">'+esc(x.name)+'</option>').join('');
  const slot=document.getElementById('pmSuppSlot');
  slot.innerHTML=DAY_SLOTS.map(s=>'<option value="'+esc(s.slot)+'">'+esc(s.label)+'</option>').join('');
  pmSuppPicked();
}
// choosing a supplement fills in its usual dose and timing
function pmSuppPicked(){
  const x=SUPPS.find(s=>s.id===document.getElementById('pmSuppPick').value);
  if(!x) return;
  document.getElementById('pmSuppDose').value = x.dose_amount!=null ? x.dose_amount : '';
  document.getElementById('pmSuppUnit').value = x.dose_unit || '';
  if(x.default_slot) document.getElementById('pmSuppSlot').value = x.default_slot;
}
async function pmAddSupp(){
  const pid=document.getElementById('pmId').value;
  if(!pid){ toast('Save the player first'); return; }
  const sid=document.getElementById('pmSuppPick').value;
  if(!sid){ toast('No supplements in the list yet — add some under Supplements'); return; }
  const dose=parseFloat(document.getElementById('pmSuppDose').value);
  try{
    await window.CNLib.sbAddPlayerSupplement(pid, {
      supplement_id:sid, dose_amount:isNaN(dose)?null:dose,
      dose_unit:document.getElementById('pmSuppUnit').value||null,
      slot:document.getElementById('pmSuppSlot').value||null});
    await pmRenderSupps();
  }catch(e){ toast(/duplicate|unique/i.test(e.message)?'Already on their list for that time':'Could not add: '+e.message); }
}

/* ---- load an existing player into the form ---- */
async function pmLoadPlayer(p){
  document.getElementById('pmId').value=p.id;
  document.getElementById('pmName').value=p.name||'';
  document.getElementById('pmBw').value=p.bodyweight||'';
  document.getElementById('pmHt').value=p.height_cm||'';
  document.getElementById('pmBwAt').value=p.bodyweight_at||'';
  document.getElementById('pmNotes').value=p.notes||'';
  document.getElementById('pmPro').value=p.pro_g||'';
  document.getElementById('pmCho').value=p.cho_g||'';
  document.getElementById('pmFat').value=p.fat_g||'';
  pmSyncFromGrams(); pmKcalLine(); pmBwAge();
  document.getElementById('pmFormTitle').textContent='Editing '+p.name;
  PM_DAYT={}; PM_AVOIDS=[];
  pmRenderDayGrid(); pmRenderAvoids();
  try{
    PM_DAYT = await window.CNLib.sbDayTargets(p.id);
    PM_AVOIDS = await window.CNLib.sbAvoids(p.id);
    PM_FAVS = await window.CNLib.sbFavourites(p.id);
  }catch(e){ console.warn('profile load failed', e.message); }
  pmRenderDayGrid(); pmRenderAvoids(); pmRenderWeeks(); pmRenderFavs();
}
// a stale body weight quietly makes every target wrong, so say so
function pmBwAge(){
  const el=document.getElementById('pmBwAge'); if(!el) return;
  const v=document.getElementById('pmBwAt').value;
  if(!v){ el.textContent='Worth recording — every target is worked out from this weight.'; el.className='cmhint'; return; }
  const days=Math.round((Date.now()-new Date(v+'T00:00:00').getTime())/86400000);
  if(days<0){ el.textContent=''; return; }
  el.textContent = days<31 ? ('Weighed '+days+' day'+(days===1?'':'s')+' ago.')
                           : ('Weighed '+days+' days ago — worth checking it is still right.');
  el.className = days<31 ? 'cmhint' : 'cmhint warn';
}

function pmBw(){ const v=parseFloat(document.getElementById('pmBw').value); return (isNaN(v)||v<=0)?0:v; }
function pmKcalLine(){
  const g=k=>{ const v=parseFloat(document.getElementById(k).value); return isNaN(v)?0:v; };
  const kc=Math.round(4*g('pmPro')+4*g('pmCho')+9*g('pmFat'));
  const el=document.getElementById('pmKcal');
  el.innerHTML = kc>0 ? ('That works out to <b>'+kc+' kcal a day</b>'+(pmBw()?' at '+pmBw()+'kg':''))
                      : 'Enter a body weight and your g/kg targets.';
}
// typing g/kg fills the grams, and vice versa
function pmSyncFromKg(){
  const bw=pmBw(); if(!bw) return;
  [['pmProKg','pmPro'],['pmChoKg','pmCho'],['pmFatKg','pmFat']].forEach(([k,gid])=>{
    const raw=document.getElementById(k).value.trim(); if(raw===''||raw==='.') return;
    const v=parseFloat(raw); if(isNaN(v)) return;
    if(document.activeElement!==document.getElementById(gid))
      document.getElementById(gid).value=Math.round(v*bw);
  });
  pmKcalLine();
}
function pmSyncFromGrams(){
  const bw=pmBw();
  [['pmProKg','pmPro'],['pmChoKg','pmCho'],['pmFatKg','pmFat']].forEach(([k,gid])=>{
    const g=parseFloat(document.getElementById(gid).value);
    const el=document.getElementById(k);
    if(document.activeElement===el) return;
    el.value = (bw && !isNaN(g) && g>0) ? fmtGkg(g/bw) : '';
  });
  pmKcalLine();
}
// changing the weight keeps the g/kg you set and re-works the grams
function pmOnBw(){
  const bw=pmBw(); if(!bw){ pmKcalLine(); return; }
  let any=false;
  [['pmProKg','pmPro'],['pmChoKg','pmCho'],['pmFatKg','pmFat']].forEach(([k,gid])=>{
    const v=parseFloat(document.getElementById(k).value);
    if(!isNaN(v) && v>0){ document.getElementById(gid).value=Math.round(v*bw); any=true; }
  });
  if(!any) pmSyncFromGrams(); else pmKcalLine();
}
async function savePlayer(){
  const name=document.getElementById('pmName').value.trim();
  if(!name){ toast('Give the player a name'); return; }
  const num=id=>{ const v=parseFloat(document.getElementById(id).value); return isNaN(v)?null:v; };
  try{
    const txt=id=>{ const el=document.getElementById(id); return el && el.value.trim() ? el.value.trim() : null; };
    await window.CNLib.sbSavePlayer({id:document.getElementById('pmId').value||null,
      name:name,
      bodyweight:num('pmBw'), pro_g:num('pmPro'), cho_g:num('pmCho'), fat_g:num('pmFat'),
      height_cm:num('pmHt'), bodyweight_at:txt('pmBwAt'), notes:txt('pmNotes')});
    const saved=await window.CNLib.sbPlayers().then(list=>list.find(x=>x.name===name));
    if(saved){
      // the targets by day type and anything they avoid belong to the player,
      // so they are written once the player row definitely exists
      try{
        await window.CNLib.sbSaveDayTargets(saved.id, PM_DAYT);
        // the plan builder keeps its own copy, so refresh it or the next
        // generate would still use the figures from before this edit
        if(saved.id === S.playerId) await loadPlayerDayTargets(saved.id);
      }catch(e){ toast('Saved, but the day-type targets did not: '+e.message); }
      const pending=PM_AVOIDS.filter(a=>String(a.id||'').startsWith('new_'));
      for(const a of pending){
        try{ await window.CNLib.sbAddAvoid(saved.id,
              {food_id:a.food_id||null, swap_group:a.swap_group||null,
               allergen:a.allergen||null, severity:a.severity}); }
        catch(e){ console.warn('avoid failed', e.message); }
      }
    }
    await loadPlayers(); renderPlayerList(); pmClearForm();
    flashBtn(document.getElementById('pmSave'), 'Saved ✓');
    if(saved){                         // select them straight away so it's obviously applied
      document.getElementById('playerSel').value=saved.id;
      applyPlayer(saved.id);
    }
    toast(name+' saved and selected');
    setTimeout(closePlayerModal, 700);
  }catch(e){ toast(/duplicate|unique/i.test(e.message)?'That player already exists':'Could not save: '+e.message); }
}
/* ---- saving and reopening a week ---- */
function fmtWeek(d){
  try{ const dt=new Date(d+'T00:00:00');
    return dt.toLocaleDateString('en-GB',{day:'numeric',month:'short',year:'numeric'});
  }catch(e){ return d; }
}
function weekAverages(){
  const ds=DAYS.map(d=>S.days[d]).filter(Boolean); if(!ds.length) return {};
  const avg=k=>Math.round(ds.reduce((a,x)=>a+(x[k]||0),0)/ds.length);
  const pro=avg('pro'), cho=avg('cho'), fat=avg('fat');
  return {avg_pro:pro, avg_cho:cho, avg_fat:fat, avg_kcal:Math.round(4*pro+4*cho+9*fat)};
}
async function saveWeek(asNew){
  if(!S.generated){ toast('Generate the plan first'); return; }
  const wk=document.getElementById('weekStart').value;
  if(!wk){ toast('Pick the week commencing date'); return; }
  if(!S.playerId){ toast('Choose a player first (⚙ to add one)'); return; }
  if(asNew && S.loadedWeekStart && wk===S.loadedWeekStart){
    toast('Change the week commencing date first'); return;
  }
  try{
    const av=weekAverages();
    const saved=await window.CNLib.sbSavePlan({
      id: asNew? null : (S.planId||null), player_id:S.playerId, week_start:wk,
      title:(PLAYERS.find(p=>p.id===S.playerId)||{}).name+' · w/c '+wk,
      bodyweight:S.bw, data:{days:S.days, dayTargets:S.dayTargets, dayTypes:S.dayTypes,
        global:S.global, excl:S.excl, player:S.player, bw:S.bw, custom:S.custom||[]},
      ...av});
    const wasUpdate = !asNew && S.planId;
    S.planId=saved.id; S.loadedWeekStart=wk; save(); updateWeekButtons();
    flashBtn(document.getElementById(asNew?'saveAsNew':'saveWeek'), 'Saved ✓');
    toast(wasUpdate? 'Saved week updated' : 'Week saved for '+fmtWeek(wk));
  }catch(e){ toast('Could not save: '+e.message); }
}
function updateWeekButtons(){
  const sw=document.getElementById('saveWeek'), sn=document.getElementById('saveAsNew');
  if(!sw||!sn) return;
  if(S.planId){ sw.textContent='💾 Update this week'; sn.style.display=''; }
  else { sw.textContent='💾 Save week'; sn.style.display='none'; }
}
async function openWeekModal(){
  document.getElementById('weekModal').style.display='';
  await renderWeekList();
}
function closeWeekModal(){ document.getElementById('weekModal').style.display='none'; }
async function renderWeekList(){
  const host=document.getElementById('wmList'); host.innerHTML='<div class="libempty">Loading…</div>';
  try{
    const pid=document.getElementById('wmPlayer').value;
    const plans=await window.CNLib.sbPlans(pid||null);
    if(!plans.length){ host.innerHTML='<div class="libempty">No saved weeks yet.</div>'; return; }
    host.innerHTML='';
    plans.forEach(pl=>{
      const who=(PLAYERS.find(p=>p.id===pl.player_id)||{}).name||'—';
      const row=document.createElement('div'); row.className='wmrow';
      const macs=(pl.avg_pro!=null)? `${pl.avg_pro}P · ${pl.avg_cho}C · ${pl.avg_fat}F` : '';
      row.innerHTML=`<div class="wmmain">
          <div class="wmtop"><span class="pn">${esc(who)}</span>
            <span class="wmdate">w/c ${fmtWeek(pl.week_start)}</span></div>
          <div class="wmsub">${pl.avg_kcal? pl.avg_kcal+' kcal/day':''}${macs? ' &nbsp;·&nbsp; '+macs:''}${pl.bodyweight? ' &nbsp;·&nbsp; '+pl.bodyweight+'kg':''}</div>
        </div>`;
      const op=document.createElement('button'); op.textContent='Open';
      op.onclick=()=>loadWeek(pl.id);
      const cp=document.createElement('button'); cp.textContent='Copy to…';
      cp.onclick=()=>copyWeekTo(pl.id);
      const del=document.createElement('button'); del.className='del'; del.textContent='Delete';
      del.onclick=async()=>{
        if(!confirm('Delete this saved week?')) return;
        try{ await window.CNLib.sbDeletePlan(pl.id); await renderWeekList(); toast('Deleted'); }
        catch(e){ toast('Could not delete: '+e.message); }
      };
      row.appendChild(op); row.appendChild(cp); row.appendChild(del); host.appendChild(row);
    });
  }catch(e){ host.innerHTML='<div class="libempty">Could not load: '+esc(e.message)+'</div>'; }
}
async function loadWeek(id){
  try{
    const pl=await window.CNLib.sbLoadPlan(id);
    const d=pl.data||{};
    S.days=d.days||{}; S.dayTargets=d.dayTargets||S.dayTargets; S.dayTypes=d.dayTypes||S.dayTypes;
    S.global=d.global||S.global; S.excl=d.excl||[]; S.player=d.player||'';
    S.bw=d.bw||S.bw; S.custom=d.custom||[]; S.playerId=pl.player_id; S.planId=pl.id;
    S.generated=true; S.active='Mon'; S.loadedWeekStart=pl.week_start;
    document.getElementById('weekStart').value=pl.week_start;
    restoreCustomRecipes(); refreshAllMatches();
    closeWeekModal(); fillPlayerSelects(); render(); save(); updateWeekButtons();
    toast('Week opened — w/c '+pl.week_start);
  }catch(e){ toast('Could not open: '+e.message); }
}
// reuse a week as a template for a different player
async function copyWeekTo(id){
  if(!PLAYERS.length){ toast('Add a player first'); return; }
  const names=PLAYERS.map((p,i)=>(i+1)+'. '+p.name).join('\n');
  const pick=prompt('Copy this week to which player?\n\n'+names+'\n\nType the number:');
  const idx=parseInt(pick)-1;
  if(isNaN(idx)||!PLAYERS[idx]) return;
  const target=PLAYERS[idx];
  const wk=prompt('Week commencing (YYYY-MM-DD):', document.getElementById('weekStart').value||new Date().toISOString().slice(0,10));
  if(!wk) return;
  try{
    const pl=await window.CNLib.sbLoadPlan(id);
    const data=JSON.parse(JSON.stringify(pl.data||{}));
    data.player=target.name;
    if(target.bodyweight) data.bw=+target.bodyweight;
    await window.CNLib.sbSavePlan({player_id:target.id, week_start:wk,
      title:target.name+' · w/c '+wk, bodyweight:data.bw, data:data,
      avg_kcal:pl.avg_kcal, avg_pro:pl.avg_pro, avg_cho:pl.avg_cho, avg_fat:pl.avg_fat});
    await renderWeekList();
    toast('Copied to '+target.name);
  }catch(e){ toast('Could not copy: '+e.message); }
}

/* ============ BULK IMPORT ============ */
let BK_ROWS=[];
let BK_MODE='recipes';
const BK_TEMPLATE={recipes:"Recipe Name,Meal type,Servings,Ingredients,Method,Calories per serving,Protein,Carbs,Fat\nChicken & Rice Bowl,Lunch or dinner,1,\"175g chicken breast\n75g basmati rice\n80g broccoli\n1 tbsp olive oil\n2 garlic cloves\nSalt & pepper\",\"Cook the rice as per the packet\nGriddle the chicken 6 minutes each side\nSteam the broccoli and combine\",,,,\nOvernight Oats,Breakfast,1,\"60g porridge oats\n200ml semi skimmed milk\n150g 0% Greek yoghurt\n1 medium banana\n1 tbsp honey\",\"Mix the oats, milk and yoghurt\nTop with the banana and honey\nChill overnight\",,,,\nEnergy Balls,Snack,12,\"200g porridge oats\n100g peanut butter\n80g honey\n50g whey protein\",\"Blend everything together\nRoll into 12 balls\nChill for 2 hours\",,,,\n", foods:"Food Name,Brand,Measured in,Protein per 100,Carbs per 100,Fat per 100,Calories per 100,Weight of one piece (g),Piece name,Portioning,Allergens,Notes\nWhey Protein Isolate,,g,86,2.5,1.2,372,30,scoop,free,milk,\nChocolate Protein Bar,,g,20,22,7,240,60,bar,whole,milk / soya / peanuts,Never split one\nRecovery Shake,,ml,6,9,0.6,66,500,bottle,whole,milk,Ready to drink\nTenderstem Broccoli,,g,0.9,3.9,0.1,20,,,free,,\n"};   // kept in step with the printed guide and with what the importer expects
// turn a parsed recipe into the {food, qty, unit} rows the library stores
// tidy an ingredient into a food name without mangling it
// ("garlic cloves" must not lose its g, "0% Greek Yoghurt" must keep its 0%)
function cleanFoodName(i){
  let nm=String(i.name || i.raw || '').replace(/\s*\([^)]*\)\s*$/,'').trim();
  const startsWithPercent=/^[~\s]*\d+\s*%/.test(nm);
  if(/^[~\s]*\d/.test(nm) && !startsWithPercent){
    nm=nm.replace(/^[~\s]*\d[\d.,\/\s-]*(g|ml|kg|l)?\s+/i,'').trim();
  }
  nm=nm.replace(/^(of|the)\s+/i,'').trim();
  return nm || String(i.raw||'').trim();
}
// Is this ingredient already a food in the shared library?
// The parser records where it got the nutrition from, so "library:Passata"
// tells us exactly which food it matched — far more reliable than comparing
// the ingredient text, where "chicken breast" would miss "Chicken Breast,
// skinless" and look like something new.
function libFoodFor(ing){
  if(!ing) return null;
  const src = String(ing.src||'');
  if(src.indexOf('library:') === 0){
    const nm = src.slice(8).trim().toLowerCase();
    const hit = (LIB_FOODS||[]).find(f=>String(f.name||'').toLowerCase().startsWith(nm));
    if(hit) return hit;
  }
  const k = n => String(n||'').toLowerCase().replace(/[^a-z0-9]+/g,' ').trim();
  const want = k(cleanFoodName(ing));
  if(!want) return null;
  return (LIB_FOODS||[]).find(f=>k(f.name)===want) || null;
}

function recipeToItems(r){
  const items=[];
  (r.ings||[]).forEach(i=>{
    if(i.header || !i.grams || (i.pg+i.cg+i.fg)<=0) return;
    const known = libFoodFor(i);
    const food={
      name: cleanFoodName(i),
      p: i.pg*100, c: i.cg*100, f: i.fg*100,
      kcal: (4*i.pg + 4*i.cg + 9*i.fg)*100,
      default_unit: i.dunit==='ml' ? 'ml' : 'g',
      density: (i.dens && i.dens!==1) ? i.dens : null,
      piece_grams: (i.unit==='each' && i.unitGrams>0) ? Math.round(i.unitGrams) : null,
      is_custom:false,
      // an id means "use this one"; without it the import would create a
      // food of its own, which is how melon ended up at 583 kcal
      dbId: known ? known.id : null
    };
    // keep "2 eggs" readable where we can, otherwise use weight
    if(i.unit==='each' && i.unitGrams>0){
      items.push({food, qty: Math.round((i.grams/i.unitGrams)*100)/100, unit:'each'});
    } else if(i.dunit==='ml'){
      items.push({food, qty: Math.round(i.grams/(i.dens||1)), unit:'ml'});
    } else {
      items.push({food, qty: Math.round(i.grams), unit:'g'});
    }
  });
  return items;
}
function bkAssess(r){
  // A row that was never split into columns shows up as a name carrying tabs,
  // or an ingredient holding the whole spreadsheet line. Neither should ever
  // reach the database, whatever the parser made of it.
  const garbled = /\t/.test(String(r.name||'')) ||
                  /\s(MEDIUM|HIGH|LOW)\s+CHO\s/i.test(String(r.name||'')) ||
                  (r.ings||[]).some(i=>/\t/.test(String(i.raw||i.name||'')));
  const items=recipeToItems(r);
  let P=0,C=0,F=0;
  (r.ings||[]).forEach(i=>{ if(i.header) return; P+=i.grams*i.pg; C+=i.grams*i.cg; F+=i.grams*i.fg; });
  const kcIng=Math.round(4*P+4*C+9*F);
  const stated=r.kcal||0;
  const gap = stated ? Math.round((kcIng-stated)/stated*100) : 0;
  // Anything with no nutrition attached contributes nothing to the recipe, so
  // name them — "3 not recognised" tells you there is a problem but not what
  // to go and fix.
  const unknownList=(r.ings||[])
    .filter(i=>!i.header && !i.negligible && (i.pg+i.cg+i.fg)<=0)
    .map(i=>String(i.name||i.raw||'').trim()).filter(Boolean);
  const unknown=unknownList.length;
  // Ingredients the parser thinks it recognises but which are not in the
  // library. These used to be created silently, guessed from reference
  // tables. Now they are shown before anything is written.
  const newFoods=(r.ings||[])
    .filter(i=>!i.header && !i.negligible && i.grams>0 && (i.pg+i.cg+i.fg)>0)
    .filter(i=>!libFoodFor(i))
    .map(i=>({ing:i, name:cleanFoodName(i),
              p:Math.round(i.pg*100), c:Math.round(i.cg*100), f:Math.round(i.fg*100),
              kcal:Math.round((4*i.pg+4*i.cg+9*i.fg)*100)}));
  let status='ok', note='Ingredients match the stated macros';
  if(garbled){
    status='bad';
    note='This row was not split into columns — the whole line has been read as one thing. ' +
         'Save the sheet as CSV, or copy the rows straight out of Excel.';
  }
  else if(!items.length){ status='bad'; note='No usable ingredients'; }
  else if(unknown){
    status='warn';
    note='Not recognised, counts as zero: ' + unknownList.slice(0,4).join(', ') +
         (unknown>4 ? ' and ' + (unknown-4) + ' more' : '');
  }
  else if(stated && Math.abs(gap)>10){
    status='warn';
    note = gap>0 ? `Ingredients total ${kcIng} kcal vs ${stated} stated (+${gap}%) — sauce/marinade may not all be eaten`
                 : `Ingredients total ${kcIng} kcal vs ${stated} stated (${gap}%) — something may be missing`;
  }
  // Is this one already in the library, and if so has anything changed?
  // Without this the import just tried to save everything and reported
  // whatever the database rejected as "skipped (already in the library?)".
  const key = n => String(n||'').toLowerCase().replace(/[^a-z0-9]/g,'');
  const existing = (LIB_RECIPES||[]).find(x=>key(x.name)===key(r.name));
  let dup = null;
  if(existing){
    const sig = rec => (rec.ingredients||[]).map(t=>String(t).toLowerCase()
      .replace(/\s+/g,' ').trim()).sort().join('|') + '#' + (rec.servings||1);
    dup = {dbId: existing.dbId, same: sig(existing) === sig(r),
           was: (existing.ingredients||[]).length,
           now: (r.ingredients||[]).length};
  }
  return {r, items, kcIng, stated, gap, status, note, unknownList, dup, newFoods};
}
function bkSetMode(mode){
  BK_MODE=mode; BK_ROWS=[];
  document.getElementById('bkTabRec').classList.toggle('on', mode==='recipes');
  document.getElementById('bkTabFood').classList.toggle('on', mode==='foods');
  document.getElementById('bkGuideRec').style.display = mode==='recipes'?'':'none';
  document.getElementById('bkGuideFood').style.display = mode==='foods'?'':'none';
  document.getElementById('bkBuiltin').style.display = mode==='recipes'?'':'none';
  document.getElementById('bkList').innerHTML='';
  document.getElementById('bkSummary').style.display='none';
  document.getElementById('bkImport').style.display='none';
}
function downloadTemplate(){
  const csv=BK_TEMPLATE[BK_MODE];
  const name='Close Nutrition - '+(BK_MODE==='recipes'?'RECIPE':'FOOD')+' import template.csv';
  const a=document.createElement('a');
  a.href='data:text/csv;charset=utf-8,'+encodeURIComponent(csv);
  a.download=name; document.body.appendChild(a); a.click(); a.remove();
  toast('Template downloaded');
}
function openBulk(){
  BK_ROWS=[]; bkSetMode('recipes'); document.getElementById('bkPaste').value='';
  document.getElementById('bkList').innerHTML='';
  document.getElementById('bkSummary').style.display='none';
  document.getElementById('bkImport').style.display='none';
  document.getElementById('bulkModal').style.display='';
}
function closeBulk(){ document.getElementById('bulkModal').style.display='none'; }

/* ---- pointing an unrecognised ingredient at a real food, before import ---- */
function bkOpenFix(idx, rowEl){
  const existing = rowEl.nextElementSibling;
  if(existing && existing.classList.contains('bkfixpanel')){ existing.remove(); return; }
  document.querySelectorAll('.bkfixpanel').forEach(p=>p.remove());

  const x = BK_ROWS[idx];
  const panel = document.createElement('div'); panel.className='bkfixpanel';
  const unmatched = (x.r.ings||[]).filter(i=>!i.header && !i.negligible && (i.pg+i.cg+i.fg)<=0);

  if(!unmatched.length){
    panel.innerHTML='<div class="libempty">All sorted.</div>';
    rowEl.insertAdjacentElement('afterend', panel);
    return;
  }

  unmatched.forEach(ing=>{
    const line=document.createElement('div'); line.className='bkfixline';
    line.innerHTML =
      '<div class="bfw"><b>'+esc(ing.raw||ing.name)+'</b>'+
        '<span>not in the food library</span></div>'+
      '<div class="bfs"><input class="inp" placeholder="Find the right food…" autocomplete="off">'+
        '<div class="acbox" style="display:none"></div></div>'+
      '<div class="bfacts">'+
        '<button class="bfnew" type="button" title="Create it in the food library">+ Add it</button>'+
        '<button class="bfskip" type="button" title="Leave it out of the recipe">Leave out</button>'+
      '</div>'+
      '<div class="bfform" style="display:none">'+
        '<input class="inp bfname" placeholder="Name">'+
        '<input class="inp" type="number" step="0.1" min="0" placeholder="Protein /100">'+
        '<input class="inp" type="number" step="0.1" min="0" placeholder="Carbs /100">'+
        '<input class="inp" type="number" step="0.1" min="0" placeholder="Fat /100">'+
        '<select class="inp"><option value="g">per 100g</option><option value="ml">per 100ml</option></select>'+
        '<button class="btn small bfsave" type="button">Save to library</button>'+
      '</div>';

    const inp=line.querySelector('input');
    const box=line.querySelector('.acbox');
    inp.addEventListener('input', ()=>{
      const q=inp.value.trim().toLowerCase();
      if(q.length<2){ box.style.display='none'; return; }
      const hits=(LIB_FOODS||[]).filter(f=>String(f.name).toLowerCase().includes(q)).slice(0,10);
      if(!hits.length){ box.style.display='none'; return; }
      box.innerHTML=''; box.style.display='';
      hits.forEach(f=>{
        const b=document.createElement('button'); b.type='button'; b.className='acitem';
        b.innerHTML=esc(f.name)+'<span class="acsub">'+Math.round(f.protein_100g)+'P · '+
          Math.round(f.carbs_100g)+'C · '+Math.round(f.fat_100g)+'F</span>';
        b.onmousedown=e=>{ e.preventDefault();
          // give the parsed line real nutrition; the amount it already read stays
          ing.pg=(+f.protein_100g||0)/100;
          ing.cg=(+f.carbs_100g||0)/100;
          ing.fg=(+f.fat_100g||0)/100;
          ing.name=f.name;
          ing.src='library:'+f.name;
          ing.dunit = (f.default_unit==='ml') ? 'ml' : 'g';
          if(!ing.grams || ing.grams<=0) ing.grams = 100;
          ing.scalable = true;
          BK_ROWS[idx]=bkAssess(x.r);
          BK_ROWS[idx].pick = x.pick !== false;
          bkRender();
        };
        box.appendChild(b);
      });
    });
    // create the food here rather than sending you off to another screen
    const form=line.querySelector('.bfform');
    line.querySelector('.bfnew').onclick=()=>{
      const open = form.style.display !== 'none';
      form.style.display = open ? 'none' : '';
      if(!open){
        const nm=form.querySelector('.bfname');
        // start from what the spreadsheet called it, minus the amount
        nm.value = String(ing.name || ing.raw || '')
          .replace(/^[~\d.,/\s]*(g|ml|kg|tsp|tbsp|tbs|cup|handful|slice|clove)?\s*/i,'').trim();
        nm.focus();
      }
    };
    form.querySelector('.bfsave').onclick=async()=>{
      const v=[...form.querySelectorAll('input')].map(i=>i.value.trim());
      const unit=form.querySelector('select').value;
      const nm=v[0];
      const p=parseFloat(v[1]), c=parseFloat(v[2]), f=parseFloat(v[3]);
      if(!nm){ toast('Give it a name'); return; }
      if([p,c,f].some(isNaN)){ toast('Fill in protein, carbs and fat per 100'); return; }
      if(p+c+f > 100.5){ toast('Protein, carbs and fat cannot add up to more than 100g per 100g'); return; }
      const btn=form.querySelector('.bfsave'); btn.disabled=true; btn.textContent='Saving…';
      try{
        const saved=await window.CNLib.sbSaveFood({
          name:nm, p:p, c:c, f:f, kcal:Math.round(4*p+4*c+9*f),
          default_unit:unit, is_custom:true});
        if(saved) LIB_FOODS.push(saved);
        ing.pg=p/100; ing.cg=c/100; ing.fg=f/100;
        ing.name=nm; ing.src='library:'+nm;
        ing.dunit = unit==='ml' ? 'ml' : 'g';
        if(!ing.grams || ing.grams<=0) ing.grams=100;
        ing.scalable=true;
        if(S.drafts) { delete S.drafts.foodModal; save(); }
      toast('"'+nm+'" added to the food library');
        BK_ROWS[idx]=bkAssess(x.r);
        BK_ROWS[idx].pick = x.pick !== false;
        bkRender();
      }catch(e){
        toast(/duplicate|unique/i.test(e.message)
          ? 'A food with that name already exists — search for it instead'
          : 'Could not save: '+e.message);
        btn.disabled=false; btn.textContent='Save to library';
      }
    };
    line.querySelector('.bfskip').onclick=()=>{
      ing.negligible = true;          // treated as seasoning, so it stops warning
      ing.src = 'left out';
      BK_ROWS[idx]=bkAssess(x.r);
      BK_ROWS[idx].pick = x.pick !== false;
      bkRender();
    };
    panel.appendChild(line);
  });
  rowEl.insertAdjacentElement('afterend', panel);
  const first=panel.querySelector('input'); if(first) first.focus();
}

let LAST_IMPORT_BATCH = null;
// a message with a button on it, for things worth being able to take back
function toastUndo(msg, label, fn){
  const t=document.getElementById('toast');
  t.innerHTML='';
  t.appendChild(document.createTextNode(msg + '  '));
  const b=document.createElement('button'); b.className='toastbtn'; b.textContent=label;
  b.onclick=()=>{ t.classList.remove('show'); fn(); };
  t.appendChild(b);
  t.classList.add('show');
  clearTimeout(toastT);
  toastT=setTimeout(()=>{ t.classList.remove('show'); t.textContent=''; }, 15000);
}


/* ---- reviewing the foods an import would create ---- */
function bkReviewNewFoods(){
  const host=document.getElementById('bkList');
  const old=document.getElementById('bknfpanel');
  if(old){ old.remove(); return; }

  // one row per distinct food, with every ingredient that resolved to it
  const byName=new Map();
  BK_ROWS.filter(x=>x.pick!==false).forEach(x=>(x.newFoods||[]).forEach(n=>{
    if(!byName.has(n.name)) byName.set(n.name, {...n, ings:[]});
    byName.get(n.name).ings.push(n.ing);
  }));
  const list=[...byName.values()].sort((a,b)=>b.ings.length-a.ings.length);
  if(!list.length) return;

  const panel=document.createElement('div'); panel.id='bknfpanel'; panel.className='bknfpanel';
  panel.innerHTML='<div class="bknfhd">These will be added to the food library. '+
    'Check the numbers — anything obviously wrong was a bad guess, and you can '+
    'correct it, point it at a food you already have, or leave it out.</div>';

  list.forEach(item=>{
    const row=document.createElement('div'); row.className='bknfrow';
    row.innerHTML =
      '<div class="nfn"><b>'+esc(item.name)+'</b><span>'+item.ings.length+
        ' ingredient line'+(item.ings.length===1?'':'s')+'</span></div>'+
      '<div class="nfm">'+
        '<input class="inp" type="number" step="0.1" min="0" value="'+item.p+'" title="Protein per 100">'+
        '<input class="inp" type="number" step="0.1" min="0" value="'+item.c+'" title="Carbs per 100">'+
        '<input class="inp" type="number" step="0.1" min="0" value="'+item.f+'" title="Fat per 100">'+
        '<span class="nfk">'+item.kcal+' kcal</span>'+
      '</div>'+
      '<div class="nfs"><input class="inp" placeholder="or use one I already have…" autocomplete="off">'+
        '<div class="acbox" style="display:none"></div></div>'+
      '<button class="nfdrop" type="button" title="Leave this ingredient out">Leave out</button>';

    const [ip,ic,iff]=row.querySelectorAll('.nfm input');
    const kc=row.querySelector('.nfk');
    const apply=()=>{
      const p=parseFloat(ip.value)||0, c=parseFloat(ic.value)||0, f=parseFloat(iff.value)||0;
      kc.textContent=Math.round(4*p+4*c+9*f)+' kcal';
      item.ings.forEach(i=>{ i.pg=p/100; i.cg=c/100; i.fg=f/100; });
      BK_ROWS=BK_ROWS.map(x=>Object.assign(bkAssess(x.r), {pick:x.pick}));
    };
    [ip,ic,iff].forEach(el=>el.addEventListener('change', apply));

    const si=row.querySelector('.nfs input'), box=row.querySelector('.acbox');
    si.addEventListener('input', ()=>{
      const q=si.value.trim().toLowerCase();
      if(q.length<2){ box.style.display='none'; return; }
      const hits=(LIB_FOODS||[]).filter(f=>String(f.name).toLowerCase().includes(q)).slice(0,10);
      if(!hits.length){ box.style.display='none'; return; }
      box.innerHTML=''; box.style.display='';
      hits.forEach(f=>{
        const b=document.createElement('button'); b.type='button'; b.className='acitem';
        b.innerHTML=esc(f.name)+'<span class="acsub">'+Math.round(f.protein_100g)+'P · '+
          Math.round(f.carbs_100g)+'C · '+Math.round(f.fat_100g)+'F</span>';
        b.onmousedown=e=>{ e.preventDefault();
          item.ings.forEach(i=>{
            i.name=f.name; i.src='library:'+f.name;
            i.pg=(+f.protein_100g||0)/100; i.cg=(+f.carbs_100g||0)/100; i.fg=(+f.fat_100g||0)/100;
          });
          BK_ROWS=BK_ROWS.map(x=>Object.assign(bkAssess(x.r), {pick:x.pick}));
          bkRender(); bkReviewNewFoods();
        };
        box.appendChild(b);
      });
    });
    row.querySelector('.nfdrop').onclick=()=>{
      item.ings.forEach(i=>{ i.negligible=true; i.src='left out'; });
      BK_ROWS=BK_ROWS.map(x=>Object.assign(bkAssess(x.r), {pick:x.pick}));
      bkRender(); bkReviewNewFoods();
    };
    panel.appendChild(row);
  });
  host.insertAdjacentElement('beforebegin', panel);
}


/* ---- what went wrong, in words ---- */
let BK_FAILED = [];
function bkPlainError(msg){
  const m = String(msg||'');
  if(/duplicate|unique/i.test(m))
    return 'A recipe with this name is already in the library.';
  if(/not in the food library/i.test(m))
    return m;                                   // already readable
  if(/mass_balance|100g per 100g/i.test(m))
    return 'One of its ingredients has impossible nutrition — the protein, carbs and fat add up to more than 100g per 100g.';
  if(/9 kcal|energy_density/i.test(m))
    return 'One of its ingredients has more than 9 kcal per gram, which is more than pure fat.';
  if(/unit/i.test(m) && /check/i.test(m))
    return 'An ingredient uses a unit the app does not accept.';
  if(/slot|meal type/i.test(m))
    return 'The meal type is not one of the four the app uses.';
  if(/violates|constraint/i.test(m))
    return 'The database refused it: ' + m;
  if(/network|fetch|failed to fetch/i.test(m))
    return 'Lost connection partway through. Trying again usually works.';
  return m || 'Unknown problem.';
}

function bkShowFailures(){
  const host=document.getElementById('bkList');
  const old=document.getElementById('bkfailpanel');
  if(old) old.remove();
  if(!BK_FAILED.length) return;

  const panel=document.createElement('div'); panel.id='bkfailpanel'; panel.className='bkfailpanel';
  panel.innerHTML='<div class="bkfailhd"><b>'+BK_FAILED.length+' did not import.</b> '+
    'Nothing else was affected. Fix what you can here, then try them again.</div>';

  BK_FAILED.forEach(f=>{
    const row=document.createElement('div'); row.className='bkfailrow';
    row.innerHTML='<div class="bfnm"><b>'+esc(f.x.r.name)+'</b><span>'+esc(f.why)+'</span></div>';
    const act=document.createElement('div'); act.className='bfact';

    // a name clash is the common one, so offer the two ways out
    if(/already in the library/i.test(f.why)){
      const rn=document.createElement('button'); rn.className='btn small ghost';
      rn.textContent='Rename it';
      rn.onclick=()=>{
        const nu=prompt('New name for this recipe:', f.x.r.name + ' (2)');
        if(nu && nu.trim()){ f.x.r.name=nu.trim(); bkShowFailures(); }
      };
      act.appendChild(rn);
      const up=document.createElement('button'); up.className='btn small ghost';
      up.textContent='Replace the one there';
      up.onclick=()=>{ f.replace=true; f.why='Will replace the existing one.'; bkShowFailures(); };
      act.appendChild(up);
    }
    const drop=document.createElement('button'); drop.className='btn small ghost';
    drop.textContent='Skip';
    drop.onclick=()=>{ BK_FAILED=BK_FAILED.filter(z=>z!==f); bkShowFailures(); };
    act.appendChild(drop);
    row.appendChild(act);
    panel.appendChild(row);
  });

  const foot=document.createElement('div'); foot.className='bkfailfoot';
  const again=document.createElement('button'); again.className='btn small';
  again.textContent='Try these '+BK_FAILED.length+' again';
  again.onclick=()=>bkRetryFailed(again);
  foot.appendChild(again);
  panel.appendChild(foot);

  host.insertAdjacentElement('beforebegin', panel);
}

async function bkRetryFailed(btn){
  if(!BK_FAILED.length) return;
  btn.disabled=true;
  const queue=BK_FAILED.slice();
  BK_FAILED=[];
  let ok=0;
  try{ window.CNLib.sbPrimeFoodCache(LIB_FOODS); }catch(e){}
  for(let i=0;i<queue.length;i++){
    const f=queue[i];
    btn.textContent='Trying '+(i+1)+' of '+queue.length+'…';
    try{
      const items=recipeToItems(f.x.r);
      if(f.replace && f.x.dup){
        await window.CNLib.sbUpdateRecipe(f.x.dup.dbId, {
          name:f.x.r.name, slot:f.x.r.category||'lunchdinner',
          servings:f.x.r.servings||1,
          method:(f.x.r.directions||[]).join('\n'), items:items});
      }else{
        await window.CNLib.sbSaveRecipe({
          name:f.x.r.name, slot:f.x.r.category||'lunchdinner',
          servings:f.x.r.servings||1,
          method:(f.x.r.directions||[]).join('\n'), items:items,
          import_batch: LAST_IMPORT_BATCH});
      }
      ok++;
    }catch(e){
      BK_FAILED.push({x:f.x, why: bkPlainError(e.message), replace:f.replace});
    }
  }
  try{ window.CNLib.sbClearFoodCache(); }catch(e){}
  btn.disabled=false;
  toast(ok + ' imported' + (BK_FAILED.length ? ', ' + BK_FAILED.length + ' still failing' : ''), 5000);
  await loadLibrary(true); renderLibList();
  if(document.getElementById('recipeDbModal').style.display !== 'none') renderRecipeDb();
  bkShowFailures();
  bkShowFailures();
}

function bkRender(){
  const host=document.getElementById('bkList'); host.innerHTML='';
  const sum=document.getElementById('bkSummary');
  const ok=BK_ROWS.filter(x=>x.status==='ok').length;
  const warn=BK_ROWS.filter(x=>x.status==='warn').length;
  const bad=BK_ROWS.filter(x=>x.status==='bad').length;
  sum.style.display='';
  const noun = BK_MODE==='foods' ? 'food' : 'recipe';
  const already = BK_ROWS.filter(x=>x.dup).length;
  const changed = BK_ROWS.filter(x=>x.dup && !x.dup.same).length;
  const unchanged = already - changed;
  sum.innerHTML=`<b>${BK_ROWS.length} ${noun}(s) read.</b> ${ok} look right`
    + (warn? `, <span style="color:#8a6000">${warn} worth checking</span>`:'')
    + (bad? `, <span style="color:#c05400">${bad} unusable</span>`:'')
    + `. Untick anything you don't want.`
    + (()=>{
        const names=new Set();
        BK_ROWS.filter(x=>x.pick!==false).forEach(x=>(x.newFoods||[])
          .forEach(n=>names.add(n.name)));
        if(!names.size) return '';
        return `<div class="bknewfoods"><b>${names.size} food(s) not in the library yet.</b> ` +
          `They will be added with the nutrition the app worked out. ` +
          `<button class="bkreview" type="button" id="bkReviewFoods">Review them</button></div>`;
      })()
    + (already ? `<div class="bkdupsum">${BK_ROWS.length-already} new` +
        (unchanged ? ` · ${unchanged} already there and unchanged` : '') +
        (changed ? ` · <b>${changed} already there and different</b>` : '') +
        `</div>` : '');

  // one decision about the ones that have actually changed, rather than a
  // question per row — and nothing is replaced unless it is asked for
  const rep = document.getElementById('bkReplace');
  if(rep){
    const wrap = rep.closest('.bkreplace');
    if(wrap) wrap.style.display = changed ? '' : 'none';
    const lbl = document.getElementById('bkReplaceLabel');
    if(lbl) lbl.textContent = changed===1
      ? 'Replace the 1 recipe that is already there and has changed'
      : 'Replace the ' + changed + ' recipes that are already there and have changed';
  }
  const rv=document.getElementById('bkReviewFoods');
  if(rv) rv.onclick=bkReviewNewFoods;
  BK_ROWS.forEach((x,idx)=>{
    const row=document.createElement('div');
    row.className='bkrow2'+(x.status==='ok'?'':' '+x.status);
    const cb=document.createElement('input'); cb.type='checkbox';
    // nothing to do for one that is already there and identical
    cb.checked = x.status!=='bad' && !(x.dup && x.dup.same);
    cb.disabled = x.status==='bad';
    cb.onchange=()=>{ x.pick=cb.checked; };
    x.pick=cb.checked;
    const nm=document.createElement('div'); nm.className='bn';
    const tag = x.dup
      ? (x.dup.same
          ? '<span class="bkdup same">already there</span>'
          : '<span class="bkdup diff">already there · changed</span>')
      : '<span class="bkdup new">new</span>';
    nm.innerHTML=`<b>${esc(x.r.name)}</b>${tag}<span class="bs">${esc(x.note)}</span>`;
    // Anything unrecognised can be pointed at a real food here, rather than
    // importing an incomplete recipe and hunting for it afterwards.
    if(x.unknownList && x.unknownList.length){
      const fix=document.createElement('button');
      fix.className='bkfix'; fix.type='button';
      fix.textContent='Fix ' + x.unknownList.length + ' ingredient' +
                      (x.unknownList.length===1?'':'s');
      fix.onclick=()=>bkOpenFix(idx, row);
      nm.appendChild(fix);
    }
    const mm=document.createElement('div'); mm.className='bm';
    mm.textContent = BK_MODE==='foods' ? '' : `${x.items.length} ingredients`;
    row.appendChild(cb); row.appendChild(nm); row.appendChild(mm);
    host.appendChild(row);
  });
  document.getElementById('bkImport').style.display = BK_ROWS.some(x=>x.pick)? '' : 'none';
}
function bkFromText(text){
  try{
    const rows=window.CNFood.__parseCSV ? window.CNFood.__parseCSV(text) : null;
    const mapped=window.CNFood.__mapRows ? window.CNFood.__mapRows(rows) : null;
    if(!mapped || !mapped.length){ toast('Could not find Recipe Name and Ingredients columns'); return; }
    BK_ROWS=mapped.map((row,i)=>window.CNFood.buildRecipeFromRow(row,i+1)).filter(Boolean).map(bkAssess);
    if(!BK_ROWS.length){ toast('No complete recipes found'); return; }
    bkRender();
  }catch(e){ toast('Could not read that: '+e.message); }
}
function bkFoodFromRow(row, hdr){
  const get=(...alts)=>{ for(const a of alts){ const i=hdr.findIndex(h=>h.includes(a)); if(i>=0) return (row[i]||'').trim(); } return ''; };
  const num=v=>{ const n=parseFloat(String(v).replace(/[^0-9.\-]/g,'')); return isNaN(n)?null:n; };
  const name=get('food name','name'); if(!name) return null;
  let p=num(get('protein')), c=num(get('carb')), f=num(get('fat')), k=num(get('calorie','kcal','energy'));
  if(p==null||c==null||f==null) return {name, bad:'missing protein, carbs or fat'};
  const per=(get('per')||'100g').toLowerCase();
  const servG=num(get('serving gram','serving weight','weight'));
  let note='';
  if(per.includes('serv')){
    if(!servG) return {name, bad:'per-serving needs a serving weight in grams'};
    const sc=100/servG; p*=sc; c*=sc; f*=sc; if(k!=null) k*=sc;
    note='per '+servG+'g serving';
  }
  if(k==null) k=4*p+4*c+9*f;
  const unit=(get('measured in','unit')||'g').toLowerCase().startsWith('ml')?'ml':'g';
  const calc=4*p+4*c+9*f;
  const mismatch = k>0 && Math.abs(calc-k)/Math.max(calc,k) > 0.18;
  return {name, brand:get('brand')||null, p, c, f, kcal:k,
    default_unit:unit, density: unit==='ml'?1:null,
    piece_grams: servG||null, piece_name:get('piece name')||null,
    portioning:(get('portioning')||'free').toLowerCase(), is_custom:true,
    note: note || 'per 100'+unit, mismatch};
}
function bkFoodsFromText(text){
  const rows=window.CNFood.__parseCSV(text);
  if(!rows.length){ toast('Nothing to read'); return; }
  const hdr=rows[0].map(h=>String(h).toLowerCase().trim());
  BK_ROWS=rows.slice(1).map(r=>bkFoodFromRow(r,hdr)).filter(Boolean).map(f=>({
    food:f, items:[1],
    status: f.bad? 'bad' : (f.mismatch? 'warn':'ok'),
    note: f.bad || (f.mismatch? 'Calories don\u2019t match the protein/carbs/fat — check the label'
                             : Math.round(f.kcal)+' kcal per 100'+(f.default_unit||'g')+' · '+f.note),
    r:{name:f.name}
  }));
  if(!BK_ROWS.length){ toast('No foods found — check the header row'); return; }
  bkRender();
}
async function bkImportFoods(){
  const picks=BK_ROWS.filter(x=>x.pick && x.food && !x.food.bad);
  if(!picks.length){ toast('Nothing selected'); return; }
  const btn=document.getElementById('bkImport'); btn.disabled=true;
  let done=0, failed=0;
  for(const x of picks){
    btn.textContent=`Importing ${done+1} of ${picks.length}…`;
    try{ await window.CNLib.sbSaveFood(x.food); done++; }catch(e){ failed++; }
  }
  btn.disabled=false; btn.textContent='Import selected';
  toast(`Imported ${done} food(s)`+(failed?`, ${failed} skipped (already there?)`:''));
  await loadLibrary(true); closeBulk();
}
async function bkImport(){
  if(BK_MODE==='foods') return bkImportFoods();
  const picks=BK_ROWS.filter(x=>x.pick && x.items.length);
  if(!picks.length){ toast('Nothing selected'); return; }
  const btn=document.getElementById('bkImport');
  btn.disabled=true;
  let done=0, failed=0;
  // one tag for this whole run, so it can be taken back in one go
  LAST_IMPORT_BATCH = 'imp_' + Date.now().toString(36) + '_' +
                      Math.random().toString(36).slice(2,6);
  const replace = !!(document.getElementById('bkReplace')||{}).checked;
  let updated=0, left=0;
  BK_FAILED = [];
  // one map of the foods already in the library, so the import does not ask
  // the database about the same ingredient hundreds of times
  try{ window.CNLib.sbPrimeFoodCache(LIB_FOODS); }catch(e){}
  const started = Date.now();
  for(const x of picks){
    const n = done+updated+left+1;
    const secs = Math.round((Date.now()-started)/1000);
    const per = n>1 ? (Date.now()-started)/(n-1) : 0;
    const leftSecs = per ? Math.round(per*(picks.length-n)/1000) : 0;
    btn.textContent = `Importing ${n} of ${picks.length}` +
      (leftSecs>5 ? ` · about ${leftSecs>90 ? Math.ceil(leftSecs/60)+' min' : leftSecs+'s'} left` : '…');
    try{
      if(x.dup){
        if(x.dup.same || !replace){ left++; continue; }
        // update the one that is there rather than failing on the name
        await window.CNLib.sbUpdateRecipe(x.dup.dbId, {
          name:x.r.name, slot:x.r.category||'lunchdinner', servings:x.r.servings||1,
          method:(x.r.directions||[]).join('\n'), items:x.items});
        updated++;
        continue;
      }
      await window.CNLib.sbSaveRecipe({
        name:x.r.name, slot:x.r.category||'lunchdinner', servings:x.r.servings||1,
        method:(x.r.directions||[]).join('\n'), items:x.items,
        import_batch: LAST_IMPORT_BATCH});
      done++;
    }catch(e){
      failed++;
      // hold on to why, and to the row itself, so it can be looked at and
      // retried rather than becoming a number with no explanation
      BK_FAILED.push({x:x, why: bkPlainError(e.message)});
    }
  }
  try{ window.CNLib.sbClearFoodCache(); }catch(e){}
  btn.disabled=false; btn.textContent='Import selected';
  if(done && LAST_IMPORT_BATCH){
    // an undo that lasts as long as the message, for the moment you realise
    // the sheet was wrong
    toastUndo(`Imported ${done} new` +
      (updated? `, updated ${updated}` : '') +
      (left? `, left ${left} alone` : '') +
      (failed? `, ${failed} failed` : ''),
      'Undo this import', async ()=>{
        try{
          const gone = await window.CNLib.sbArchiveBatch(LAST_IMPORT_BATCH);
          toast('Undone — ' + gone.length + ' recipe(s) archived');
          await loadLibrary(true); renderLibList();
          if(document.getElementById('recipeDbModal').style.display !== 'none') renderRecipeDb();
        }catch(e){ toast('Could not undo: '+e.message); }
      });
  } else {
    toast(`Imported ${done} new` + (updated? `, updated ${updated}`:'') +
          (left? `, left ${left} alone`:'') + (failed? `, ${failed} failed`:''), 6000);
  }
  await loadLibrary(true); renderLibList();
  if(document.getElementById('recipeDbModal').style.display !== 'none') renderRecipeDb();
  bkShowFailures();
  closeBulk();
}

/* ============ ADD A FOOD ============ */
let FM_PER='100';
function openFoodModal(){
  // anything half-entered before comes back
  setTimeout(()=>{ if(restoreScreenDraft('foodModal'))
    toast('Picked up where you left off', 4000); }, 30);
  ['fmName','fmBrand','fmP','fmC','fmF','fmK','fmServG','fmPieceName'].forEach(id=>document.getElementById(id).value='');
  FM_PER='100'; fmSetTab();
  document.getElementById('fmWarn').style.display='none';
  document.getElementById('fmPreview').textContent='Enter the nutrition from the label';
  document.getElementById('foodModal').style.display='';
  document.getElementById('fmName').focus();
}
function closeFoodModal(){
  captureScreenDraft('foodModal'); document.getElementById('foodModal').style.display='none'; }
function fmSetTab(){
  document.getElementById('fmPer100').classList.toggle('on', FM_PER==='100');
  document.getElementById('fmPerServ').classList.toggle('on', FM_PER==='serv');
  document.getElementById('fmServWrap').style.display = FM_PER==='serv' ? '' : 'none';
  fmPreview();
}
function fmValues(){
  const num=id=>{ const v=parseFloat(document.getElementById(id).value); return isNaN(v)?null:v; };
  let p=num('fmP'), c=num('fmC'), f=num('fmF'), k=num('fmK');
  if(p==null||c==null||f==null) return null;
  if(k==null) k=4*p+4*c+9*f;
  const servG=num('fmServG');
  if(FM_PER==='serv'){
    if(!servG || servG<=0) return {needServing:true};
    const s=100/servG;                       // convert a per-bar label to per 100g
    p*=s; c*=s; f*=s; k*=s;
  }
  return {p:p, c:c, f:f, kcal:k, servG:servG};
}
function fmPreview(){
  const pv=document.getElementById('fmPreview'), wn=document.getElementById('fmWarn');
  const v=fmValues();
  if(!v){ pv.textContent='Enter the nutrition from the label'; wn.style.display='none'; return; }
  if(v.needServing){ pv.textContent='Also tell me what one serving weighs, in grams'; wn.style.display='none'; return; }
  pv.innerHTML=`Stored as <b>${v.p.toFixed(1)}g protein</b> · <b>${v.c.toFixed(1)}g carbs</b> · <b>${v.f.toFixed(1)}g fat</b> · <span class="kc">${Math.round(v.kcal)} kcal</span> per 100${document.getElementById('fmUnit').value}`;
  // gentle sanity check: do the calories match the macros?
  const calc=4*v.p+4*v.c+9*v.f;
  if(v.kcal>0 && Math.abs(calc-v.kcal)/Math.max(calc,v.kcal) > 0.18){
    wn.style.display=''; wn.innerHTML='<b>Double-check the label.</b> The protein, carbs and fat work out to about '
      +Math.round(calc)+' kcal, but you entered '+Math.round(v.kcal)+'. You can still save it.';
  } else wn.style.display='none';
}
async function saveNewFood(){
  const name=document.getElementById('fmName').value.trim();
  if(!name){ toast('Give the food a name'); return; }
  const v=fmValues();
  if(!v || v.needServing){ toast('Enter protein, carbs and fat (and the serving weight)'); return; }
  const btn=document.getElementById('fmSave'); btn.disabled=true; btn.textContent='Saving…';
  try{
    const unit=document.getElementById('fmUnit').value;
    const saved=await window.CNLib.sbSaveFood({
      name:name, brand:document.getElementById('fmBrand').value.trim()||null,
      p:v.p, c:v.c, f:v.f, kcal:v.kcal,
      default_unit:unit, density: unit==='ml' ? 1 : null,
      piece_grams: (FM_PER==='serv' && v.servG) ? v.servG : null,
      piece_name: document.getElementById('fmPieceName').value.trim()||null,
      portioning: document.getElementById('fmPort').value, is_custom:true
    });
    flashBtn(btn,'Saved ✓');
    toast('"'+name+'" added to the food library');
    setTimeout(closeFoodModal, 700);
    await loadLibrary(true);
  }catch(e){
    toast(/duplicate|unique/i.test(e.message)? 'A food with that name already exists' : ('Could not save: '+e.message));
  }finally{ btn.disabled=false; btn.textContent='Save food'; }
}

/* ============ RENDER ============ */
// per-day target grid (shown before generation) — grams + g/kg per macro, kcal derived
function renderDayTargets(){
  const host=document.getElementById('dayTargetGrid'); if(!host) return;
  const bw=S.bw||90;
  const def=defaultMacros(bw), g=S.global;
  const ph={pro:(g.pro>0?g.pro:def.pro), cho:(g.cho>0?g.cho:def.cho), fat:(g.fat>0?g.fat:def.fat)};
  const cell=(d,k)=>{
    const t=S.dayTargets[d]||{}; const val=t[k]||0;
    return `<div class="dtcell">
      <input class="g" data-d="${d}" data-k="${k}" data-t="g" type="number" min="0" inputmode="numeric" value="${val||''}" placeholder="${ph[k]}">
      <div class="kgline"><input class="kg" data-d="${d}" data-k="${k}" data-t="gkg" type="number" min="0" step="0.05" inputmode="decimal" value="${val?fmtGkg(val/bw):''}" placeholder="${fmtGkg(ph[k]/bw)}"><span>g/kg</span></div>
    </div>`;
  };
  let html='<thead><tr><th>Day</th><th>Type</th><th>Protein</th><th>Carb</th><th>Fat</th><th>kcal</th></tr></thead><tbody>';
  DAYS.forEach(d=>{
    const t=S.dayTargets[d]||{pro:0,cho:0,fat:0};
    const opts=DAYTYPES.map(x=>`<option${S.dayTypes[d]===x?' selected':''}>${x}</option>`).join('');
    const kc=kcalOf({pro:t.pro||ph.pro,cho:t.cho||ph.cho,fat:t.fat||ph.fat});
    html+=`<tr data-d="${d}">
      <td>${DAYFULL[d]}</td>
      <td><select data-d="${d}" class="dt-type">${opts}</select></td>
      <td>${cell(d,'pro')}</td>
      <td>${cell(d,'cho')}</td>
      <td>${cell(d,'fat')}</td>
      <td class="kc" data-kc="${d}">${kc}</td></tr>`;
  });
  html+='</tbody>';
  host.innerHTML=html;
  const refreshKcal=(d)=>{ const t=S.dayTargets[d]; host.querySelector(`[data-kc="${d}"]`).textContent=
      kcalOf({pro:t.pro||ph.pro,cho:t.cho||ph.cho,fat:t.fat||ph.fat}); };
  host.querySelectorAll('.dtcell input').forEach(inp=>{
    inp.addEventListener('input',()=>{
      const d=inp.dataset.d, k=inp.dataset.k, t=inp.dataset.t;
      const raw=inp.value.trim();
      if(raw==='.'){ return; }
      if(raw==='') S.dayTargets[d][k]=0;
      else { const v=parseFloat(raw); if(isNaN(v)) return;
        S.dayTargets[d][k]= (t==='g')? Math.max(0,Math.round(v)) : Math.max(0,Math.round(v*bw)); }
      const gv=S.dayTargets[d][k];
      const c=inp.closest('.dtcell');
      const gI=c.querySelector('input.g'), kI=c.querySelector('input.kg');
      if(t==='g'){ if(document.activeElement!==kI) kI.value = gv>0? fmtGkg(gv/bw):''; }
      else       { if(document.activeElement!==gI) gI.value = gv>0? gv:''; }
      refreshKcal(d); save();
    });
    inp.addEventListener('change',()=>{
      const k=inp.dataset.k, d=inp.dataset.d, t=inp.dataset.t, gv=(S.dayTargets[d]||{})[k]||0;
      inp.value = (t==='g') ? (gv>0?gv:'') : (gv>0?fmtGkg(gv/bw):'');
    });
  });
  host.querySelectorAll('select.dt-type').forEach(sel=>{
    sel.onchange=()=>{
      const d = sel.dataset.d;
      S.dayTypes[d] = sel.value;
      // If this player has their own g/kg for the type just chosen, fill the
      // row in. Picking "Game Day" and getting the normal numbers is the whole
      // point of setting them on the profile.
      const fromPlayer = targetsForDayType(sel.value);
      if(fromPlayer){
        S.dayTargets[d] = {pro:fromPlayer.pro, cho:fromPlayer.cho, fat:fromPlayer.fat};
        save(); renderDayTargets();
        toast(S.player + "'s " + sel.value + ' targets applied to ' + DAYFULL[d], 3200);
        return;
      }
      save();
    };
  });
}
function fillAllDaysFromDefault(){
  const def=defaultMacros(S.bw||90), g=S.global;
  const v={pro:(g.pro>0?g.pro:def.pro), cho:(g.cho>0?g.cho:def.cho), fat:(g.fat>0?g.fat:def.fat)};
  DAYS.forEach(d=>{ S.dayTargets[d]={...v}; });
  renderDayTargets(); save(); toast('Filled all days from default targets');
}
function render(){
  document.getElementById('playerName').value=S.player||'';
  document.getElementById('bodyweight').value=(S.bw!=null&&S.bw!==0)?S.bw:'';
  renderMacroEditor(); renderExclusions();
  const empty=document.getElementById('emptyState');
  const plan=document.getElementById('planArea');
  const exportBtn=document.getElementById('exportBtn');
  const exportPhone=document.getElementById('exportPhoneBtn');
  if(exportPhone) exportPhone.disabled = !S.generated;
  const exportPlayer=document.getElementById('exportPlayerBtn');
  if(exportPlayer) exportPlayer.disabled = !S.generated;
  if(!S.generated || !S.days || !Object.keys(S.days).length){
    empty.style.display=''; plan.style.display='none';
    if(exportBtn) exportBtn.disabled=true;
    renderDayTargets();
    return;
  }
  empty.style.display='none'; plan.style.display='';
  if(exportBtn) exportBtn.disabled=false;
  renderDayTabs(); renderDayTypeChips();
  document.getElementById('dayTitle').textContent=DAYFULL[S.active]+' · '+S.days[S.active].type;
  renderDayEditor();
  renderMeals();
}
function doGenerate(){
  // A plan with nothing in it is never the right answer. If the avoid list has
  // ruled everything out, say which entry did it rather than returning a blank
  // page and leaving you to work it out.
  if(PLAYER_AVOIDS.length){
    const empty = ['breakfast','lunchdinner','snack','smoothie']
      .filter(c => candidatesFor(c, S.excl||[]).length === 0);
    if(empty.length){
      const culprit = whichAvoidBlocksEverything();
      toast('Cannot build a plan: nothing is left for ' + empty.join(' or ') +
            (culprit ? '. "' + culprit + '" is ruling out almost everything — '
                     + 'try making it a dislike rather than an allergy, or remove it.'
                     : '. Try removing something from the avoid list.'), 9000);
      return;
    }
  }
  generatePlan(); refreshAllMatches(); render(); save();
  const usedPT = S.usedPlayerTargets || 0;
  const adapted = DAYS.reduce((n,d)=>n + (S.days[d]?S.days[d].meals.filter(m=>{
    const r = recipeById(m.recipeId); return r && r.adapted;
  }).length:0), 0);
  toast('Plan generated' +
        (usedPT ? ' using ' + (S.player||'the player') + "'s targets on " + usedPT +
                  ' day' + (usedPT===1?'':'s') : '') +
        (adapted ? ', ' + adapted + ' meal' + (adapted===1?'':'s') +
        ' adjusted for this player' : '') + '. Fine-tune any meal below.', 5000);
}
// which single entry is doing the damage: drop each in turn and see what comes back
function whichAvoidBlocksEverything(){
  const all = PLAYER_AVOIDS;
  for(const a of all){
    PLAYER_AVOIDS = all.filter(x=>x!==a);
    const ok = candidatesFor('lunchdinner', S.excl||[]).length > 0;
    PLAYER_AVOIDS = all;
    if(ok) return a.allergen || a.swap_group || (a.foods && a.foods.name) || 'one of the entries';
  }
  return null;
}

/* ============ INIT ============ */
function init(){
  S=load()||newState();
  if(S.generated) refreshAllMatches();
  document.getElementById('playerName').oninput=e=>{S.player=e.target.value;save();};
  document.getElementById('bodyweight').oninput=onBodyweight;
  document.getElementById('shopBtn').onclick=openShopping;
  document.getElementById('shClose').onclick=closeShopping;
  document.getElementById('shDone').onclick=closeShopping;
  document.getElementById('shAdd').onclick=addShopItem;
  document.getElementById('shReset').onclick=resetShopEdits;
  document.getElementById('addMealBtn').onclick=()=>openAddMeal(null);
  document.getElementById('addSnack').onclick=()=>{
    openAddMeal(null);
    document.getElementById('amCat').value='snack';
    document.getElementById('amName').value='Snack';
    renderAddMealList('');
  };
  document.getElementById('addCustom').onclick=openCustomModal;
  document.getElementById('amClose').onclick=closeAddMeal;
  document.getElementById('amCancel').onclick=closeAddMeal;
  document.getElementById('amAdd').onclick=confirmAddMeal;
  document.getElementById('amCat').onchange=()=>renderAddMealList(
    document.getElementById('amSearch').value, true);
  let amT=null;
  document.getElementById('amSearch').addEventListener('input', e=>{
    clearTimeout(amT);
    amT=setTimeout(()=>renderAddMealList(e.target.value), 140);
  });
  // one result means there is nothing to choose between — select it
  document.getElementById('amSearch').addEventListener('keydown', e=>{
    if(e.key !== 'Enter') return;
    e.preventDefault();
    clearTimeout(amT);
    renderAddMealList(e.target.value, true);
    const only=document.querySelectorAll('#amList .amitem');
    if(only.length === 1) only[0].click();
  });
  document.getElementById('newRecipeBtn').onclick=openCustomModal;
  document.getElementById('refreshLib').onclick=async()=>{ await loadLibrary(); renderLibList(); toast('Library refreshed'); };
  document.getElementById('newFoodBtn').onclick=openFoodModal;
  document.getElementById('openRecipeDb').onclick=openRecipeDb;
  document.getElementById('exportPhoneBtn').onclick=()=>{
    try{ exportPhonePDF(); }catch(e){ toast('Could not export: '+e.message); }
  };
  document.getElementById('exportPlayerBtn').onclick=()=>{
    try{ exportPhonePDF('player'); }catch(e){ toast('Could not export: '+e.message); }
  };
  document.getElementById('chefNotesBtn').onclick=()=>{
    document.getElementById('chefNotes').value = S.chefNotes || '';
    document.getElementById('chefIntro').value = S.chefIntro || CHEF_INTRO_DEFAULT;
    document.getElementById('chefRefs').value  = S.chefRefs  || CHEF_REFS_DEFAULT;
    document.getElementById('chefNotesModal').style.display='';
    if(restoreScreenDraft('chefNotesModal')) toast('Picked up where you left off', 4000);
  };
  document.getElementById('cnClose').onclick=
  document.getElementById('cnCancel').onclick=()=>{
    captureScreenDraft('chefNotesModal');   // unsaved notes are not thrown away
    document.getElementById('chefNotesModal').style.display='none';
  };
  document.getElementById('cnReset').onclick=()=>{
    document.getElementById('chefIntro').value = CHEF_INTRO_DEFAULT;
    document.getElementById('chefRefs').value  = CHEF_REFS_DEFAULT;
  };
  document.getElementById('cnSave').onclick=()=>{
    if(S.drafts) delete S.drafts.chefNotesModal;
    S.chefNotes = document.getElementById('chefNotes').value.trim();
    S.chefIntro = document.getElementById('chefIntro').value.trim();
    S.chefRefs  = document.getElementById('chefRefs').value.trim();
    document.getElementById('chefNotesModal').style.display='none';
    save(); toast(S.chefNotes ? 'Saved — it will print on the PDF' : 'Notes cleared');
  };
  document.getElementById('openSuppDb').onclick=openSupplements;
  document.getElementById('rdbClose').onclick=closeRecipeDb;
  document.getElementById('reClose').onclick=closeRecipeEditor;
  document.getElementById('reCancel').onclick=closeRecipeEditor;
  document.getElementById('reSave').onclick=()=>saveRecipeEdits(false);
  document.getElementById('reSaveCheck').onclick=()=>saveRecipeEdits(true);
  document.getElementById('reArchive').onclick=archiveFromEditor;
  document.getElementById('reAddSearch').addEventListener('input', reAddSuggest);
  document.getElementById('rdbExportR').onclick = exportRecipesCsv;
  document.getElementById('rdbExportF').onclick = exportFoodsCsv;
  document.getElementById('reServ').addEventListener('change', renderEditorMacros);
  document.getElementById('rdbDone').onclick=closeRecipeDb;
  ['rdbSearch','rdbSlot','rdbView'].forEach(id=>{
    const el=document.getElementById(id);
    el.addEventListener(id==='rdbSearch'?'input':'change', renderRecipeDb);
  });
  document.getElementById('spClose').onclick=closeSupplements;
  document.getElementById('spCancel').onclick=spClearForm;
  document.getElementById('spSave').onclick=saveSupplement;
  document.getElementById('bulkBtn').onclick=openBulk;
  document.getElementById('bkClose').onclick=closeBulk;
  document.getElementById('bkCancel').onclick=closeBulk;
  document.getElementById('bkCheck').onclick=()=>{
    const t=document.getElementById('bkPaste').value;
    if(!t.trim()){ toast('Paste some rows first, or choose a file'); return; }
    BK_MODE==='foods' ? bkFoodsFromText(t) : bkFromText(t);
  };
  document.getElementById('bkTabRec').onclick=()=>bkSetMode('recipes');
  document.getElementById('bkTabFood').onclick=()=>bkSetMode('foods');
  document.getElementById('bkTemplate').onclick=downloadTemplate;
  document.getElementById('bkImport').onclick=bkImport;
  document.getElementById('bkBuiltin').onclick=()=>{
    BK_ROWS=BUILTIN_RECIPES.map(bkAssess); bkRender();
    toast('Checked the '+BUILTIN_RECIPES.length+' built-in recipes');
  };
  document.getElementById('bkFile').onchange=e=>{
    const f=e.target.files[0]; if(!f) return;
    const rd=new FileReader(); rd.onload=()=>{ BK_MODE==='foods'? bkFoodsFromText(rd.result) : bkFromText(rd.result); }; rd.readAsText(f);
  };
  document.getElementById('bulkModal').addEventListener('click',e=>{
    if(e.target.id==='bulkModal') guardedClose('bulkModal', closeBulk); });
  document.getElementById('fmClose').onclick=closeFoodModal;
  document.getElementById('fmCancel').onclick=closeFoodModal;
  document.getElementById('fmSave').onclick=saveNewFood;
  document.getElementById('fmPer100').onclick=()=>{FM_PER='100'; fmSetTab();};
  document.getElementById('fmPerServ').onclick=()=>{FM_PER='serv'; fmSetTab();};
  ['fmP','fmC','fmF','fmK','fmServG'].forEach(id=>document.getElementById(id).addEventListener('input',fmPreview));
  document.getElementById('fmUnit').addEventListener('change',fmPreview);
  document.getElementById('foodModal').addEventListener('click',e=>{
    if(e.target.id==='foodModal') guardedClose('foodModal', closeFoodModal); });
  document.getElementById('cmSaveLib').onclick=saveRecipeToLibrary;
  document.getElementById('cmAddFood').onclick=openFoodModal;
  document.getElementById('cmClose').onclick=closeCustomModal;
  document.getElementById('cmCancel').onclick=closeCustomModal;
  document.getElementById('cmSave').onclick=saveCustomMeal;
  document.getElementById('cmName').addEventListener('input',previewCustom);
  const cs=document.getElementById('cmSearch');
  let cmT;
  cs.addEventListener('input',()=>{
    clearTimeout(cmT);
    const q=cs.value.trim();
    if(q.length<2){ document.getElementById('cmResults').style.display='none'; return; }
    const mine = ++CM_SEQ;    // so a slow search cannot overwrite a newer one
    cmT=setTimeout(async()=>{
      let libHits=[];
      try{ libHits=(await window.CNLib.sbSearchFoods(q)).map(f=>({
        label:(f.brand? f.brand+' ':'')+f.name, p:+f.protein_100g, c:+f.carbs_100g, f:+f.fat_100g,
        kcal:Math.round(+f.kcal_100g), src:'Library', dbFood:f})); }catch(e){}
      if(mine !== CM_SEQ) return;
      cmRenderResults(libHits.concat(window.CNFood.searchFoods(q,12)));
    },160);
  });
  cs.addEventListener('keydown',e=>{ if(e.key==='Escape') document.getElementById('cmResults').style.display='none'; });
  document.getElementById('cmCat').addEventListener('change',previewCustom);
  document.getElementById('customModal').addEventListener('click',e=>{
    if(e.target.id==='customModal') guardedClose('customModal', closeCustomModal); });
  restoreCustomRecipes();
  document.getElementById('clearDayBtn').onclick=()=>{
    const day=S.days[S.active];
    if(!day) return;
    if(day.cleared){ restoreDay(S.active); return; }
    if(!confirm('Clear ' + DAYFULL[S.active] + '?\n\n' +
      'It stays on the plan as a day with nothing planned — useful when the player ' +
      'is off, or the club is feeding them. Nothing from it goes into the shopping list.\n\n' +
      'You can put the meals back afterwards.')) return;
    clearDay(S.active);
    toast(DAYFULL[S.active] + ' cleared');
  };
  document.getElementById('applyAll').onclick=applyAllDays;
  document.getElementById('exportBtn').onclick=exportPDF;
  document.getElementById('generateBtnMain').onclick=doGenerate;
  document.getElementById('fillAllDays').onclick=fillAllDaysFromDefault;
  document.getElementById('authBtn').onclick=doSignIn;
  ['authEmail','authPass'].forEach(id=>document.getElementById(id)
    .addEventListener('keydown',e=>{ if(e.key==='Enter') doSignIn(); }));
  try{ document.getElementById('authlogo').src=LOGO_BLACK; }catch(e){}
  checkSession().then(okSession=>{
    if(AUTH_REQUIRED && !okSession){ showAuth(true); return; }
    showAuth(false); renderWhoami();
    loadLibrary(true).then(renderLibList);
    loadPlayers();
  });
  const ws=document.getElementById('weekStart');
  if(!ws.value){ const d=new Date(); const off=(d.getDay()+6)%7; d.setDate(d.getDate()-off);
    ws.value=d.toISOString().slice(0,10); }               // defaults to this Monday
  const showWeek=()=>{
    const h=document.getElementById('weekHint');
    if(ws.value){
      const d=new Date(ws.value+'T00:00:00');
      h.innerHTML='Planning the week of <b>'+d.toLocaleDateString('en-GB',{weekday:'long',day:'numeric',month:'long',year:'numeric'})+'</b>';
      h.classList.add('okhint');
    } else { h.textContent='Pick the week commencing date.'; h.classList.remove('okhint'); }
  };
  ws.oninput=()=>{ S.weekStart=ws.value; showWeek(); save(); };
  ws.onchange=ws.oninput;
  showWeek();
  document.getElementById('applyWeek').onclick=()=>{
    if(!ws.value){ toast('Pick a date first'); return; }
    S.weekStart=ws.value; showWeek(); save();
    flashBtn(document.getElementById('applyWeek'),'Set ✓');
    toast('Week set to '+fmtWeek(ws.value));
  };
  document.querySelectorAll('.quickwk .qw').forEach(b=>{
    b.onclick=()=>{
      const d=new Date(); const off=(d.getDay()+6)%7;          // back to Monday
      d.setDate(d.getDate()-off + (parseInt(b.dataset.wk)*7));
      ws.value=d.toISOString().slice(0,10);
      S.weekStart=ws.value; showWeek(); save();
      flashBtn(document.getElementById('applyWeek'),'Set ✓');
    };
  });
  document.getElementById('playerSel').onchange=e=>applyPlayer(e.target.value);
  document.getElementById('managePlayers').onclick=openPlayerModal;
  document.getElementById('pmClose').onclick=closePlayerModal;
  document.getElementById('pmCancelEdit').onclick=pmClearForm;
  document.getElementById('pmSave').onclick=savePlayer;
  document.querySelectorAll('.pmtab').forEach(b=>b.onclick=async()=>{
    pmTab(b.dataset.tab);
    if(b.dataset.tab==='pmTabWeeks') pmRenderWeeks();
    if(b.dataset.tab==='pmTabFavs')  pmRenderFavs();
    if(b.dataset.tab==='pmTabSupps'){ await pmSuppSetup(); pmRenderSupps(); }
  });
  document.getElementById('pmFavSearch').addEventListener('input', pmFavSuggest);
  document.getElementById('pmFavAdd').onclick = pmAddFav;
  document.getElementById('pmSuppPick').addEventListener('change', pmSuppPicked);
  document.getElementById('pmSuppAdd').onclick = pmAddSupp;
  document.getElementById('pmNew').onclick=()=>{ pmClearForm(); document.getElementById('pmName').focus(); };
  document.getElementById('pmAvoidAdd').onclick=pmAddAvoid;
  document.getElementById('pmAvoidSearch').addEventListener('input',pmAvoidSuggest);
  document.getElementById('pmBwAt').addEventListener('change',pmBwAge);
  document.getElementById('pmBw').addEventListener('input',()=>{ pmRenderDayGrid(); pmBwAge(); });
  ['pmName','pmBw','pmProKg','pmChoKg','pmFatKg','pmPro','pmCho','pmFat'].forEach(id=>{
    document.getElementById(id).addEventListener('keydown',e=>{ if(e.key==='Enter'){ e.preventDefault(); savePlayer(); } });
  });
  ['pmProKg','pmChoKg','pmFatKg'].forEach(id=>document.getElementById(id).addEventListener('input',pmSyncFromKg));
  ['pmPro','pmCho','pmFat'].forEach(id=>document.getElementById(id).addEventListener('input',pmSyncFromGrams));
  document.getElementById('pmBw').addEventListener('input',pmOnBw);
  document.getElementById('playerModal').addEventListener('click',e=>{ if(e.target.id==='playerModal') closePlayerModal(); });
  document.getElementById('saveWeek').onclick=()=>saveWeek(false);
  document.getElementById('saveAsNew').onclick=()=>saveWeek(true);
  updateWeekButtons();
  document.getElementById('openWeek').onclick=openWeekModal;
  document.getElementById('wmClose').onclick=closeWeekModal;
  document.getElementById('wmCancel').onclick=closeWeekModal;
  document.getElementById('wmPlayer').onchange=renderWeekList;
  document.getElementById('weekModal').addEventListener('click',e=>{ if(e.target.id==='weekModal') closeWeekModal(); });
  document.getElementById('resetBtn').onclick=()=>{ if(confirm('Clear everything and start over?')){ S=newState(); render(); save(); } };
  render();
}
document.addEventListener('DOMContentLoaded',init);
