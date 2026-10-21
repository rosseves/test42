/* ============ SHARED LIBRARY (Supabase) ============
   Recipes and foods live in one shared database, so anything added in the app is
   there for everyone. If it's unreachable the app falls back to the built-in recipes. */
const SB_URL = 'https://pelhjlgcptyotvlrxwcj.supabase.co';
const SB_KEY = 'sb_publishable_ukv9ECmFq8CIFW9I15d0ew_04WGqX1Z';

let SB_SESSION = null;
try{ SB_SESSION = JSON.parse(localStorage.getItem('cnSession')||'null'); }catch(e){}
function sbHeaders(){
  return {
    'apikey': SB_KEY,
    'Authorization': 'Bearer ' + ((SB_SESSION && SB_SESSION.access_token) || SB_KEY),
    'Content-Type': 'application/json'
  };
}
function sbSetSession(sess){
  SB_SESSION = sess;
  try{ sess ? localStorage.setItem('cnSession', JSON.stringify(sess))
            : localStorage.removeItem('cnSession'); }catch(e){}
}
function sbUser(){ return SB_SESSION && SB_SESSION.user ? SB_SESSION.user : null; }

/* ---- sign in / out ---- */
async function sbSignIn(email, password){
  const r = await fetch(SB_URL + '/auth/v1/token?grant_type=password', {
    method:'POST', headers:{'apikey':SB_KEY,'Content-Type':'application/json'},
    body: JSON.stringify({email:email, password:password})
  });
  const j = await r.json();
  if(!r.ok) throw new Error(j.error_description || j.msg || j.message || 'Sign in failed');
  sbSetSession(j);
  return j;
}
async function sbRefresh(){
  if(!SB_SESSION || !SB_SESSION.refresh_token) return null;
  const r = await fetch(SB_URL + '/auth/v1/token?grant_type=refresh_token', {
    method:'POST', headers:{'apikey':SB_KEY,'Content-Type':'application/json'},
    body: JSON.stringify({refresh_token: SB_SESSION.refresh_token})
  });
  if(!r.ok){ sbSetSession(null); return null; }
  const j = await r.json(); sbSetSession(j); return j;
}
function sbSignOut(){ sbSetSession(null); }
async function sbFetch(path, opts){
  // merge headers LAST, so a caller's Prefer header can never drop the API key
  const build = () => Object.assign({}, opts||{},
    {headers: Object.assign({}, sbHeaders(), (opts&&opts.headers)||{})});
  let r = await fetch(SB_URL + '/rest/v1/' + path, build());
  if((r.status===401 || r.status===403) && SB_SESSION){
    if(await sbRefresh()) r = await fetch(SB_URL + '/rest/v1/' + path, build());  // token expired
  }
  if(!r.ok){
    let msg = r.status + ' ' + r.statusText;
    try{ const j = await r.json(); if(j && j.message) msg = j.message; }catch(e){}
    throw new Error(msg);
  }
  if(r.status === 204) return null;
  const t = await r.text();
  return t ? JSON.parse(t) : null;
}

/* ---- unit handling: one place, so the app and the database always agree ---- */
const SB_UNITS = ['g','ml','each','tbsp','tsp','handful','slice'];
function sbGramsFor(food, qty, unit){
  const dens = food.density && food.density > 0 ? food.density : 1;
  switch(unit){
    case 'g':       return qty;
    case 'ml':      return qty * dens;
    case 'piece':
    case 'each':
    case 'slice':   return qty * (food.piece_grams > 0 ? food.piece_grams : 100);
    case 'tbsp':    return qty * 15 * (food.default_unit === 'ml' ? dens : 1);
    case 'tsp':     return qty * 5  * (food.default_unit === 'ml' ? dens : 1);
    case 'handful': return qty * 30;
    default:        return qty;
  }
}
// how an amount reads on the plan
function sbLabel(food, qty, unit){
  const nm = food.brand ? (food.brand + ' ' + food.name) : food.name;
  if(unit === 'g' || unit === 'ml') return Math.round(qty) + unit + ' ' + nm;
  if(unit === 'each' || unit === 'piece') return qty + ' ' + (food.piece_name || '') + (food.piece_name ? ' ' : '') + nm;
  return qty + ' ' + unit + ' ' + nm;
}

/* ---- turn database rows into the recipe shape the planner uses ---- */

/* The book names the actual herb — "~2g Nutmeg (1 Teaspoon)" — but it is mapped
   to a catch-all food ("Dried Herbs & Ground Spices (oregano, thyme, ...)") so
   the nutrition comes from one row instead of fifty. Showing the catch-all name
   loses the recipe: a Bircher muesli reads as containing cumin and turmeric.
   So: keep the catch-all for the macros, show what the recipe actually says. */
const SB_GENERIC = /etc\.\)|General Seasoning|Marinade or Seasoning/i;
const SB_LEAD = new RegExp(
  '^\\s*(?:~|approx\\.?\\s*)?' +
  '(?:pinch of|handful of|small handful of|a few|bunch of|\u00BD bunch|1/2 bunch)?\\s*' +
  '(?:[\\d.,/\u00BC\u00BD\u00BE\u2153\u2154]+\\s*)?' +
  '(?:g|ml|kg|tsp|tbsp|teaspoons?|tablespoons?|cups?|handfuls?|bunch(?:es)?|' +
  'sprigs?|pinch(?:es)?|cloves?)?\\s*(?:of\\s+)?', 'i');

// "150g 0% Fat Greek Yoghurt (for soaking)" and "50g ... (for topping)" are not
// a duplication — the recipe uses it twice for different jobs. Without the
// qualifier the two lines look identical and read as a mistake.
function sbQualifier(displayText){
  if(!displayText) return null;
  const m = /\(([^)]*)\)\s*$/.exec(String(displayText));
  if(m){
    const q = m[1].trim();
    // ignore the ones that are just restating the amount, e.g. "(1 Teaspoon)"
    if(/^[\d.,/\s\u00BC\u00BD\u00BE\u2153\u2154\u215B-\u215E~]*(g|ml|kg|tsp|tbsp|teaspoons?|tablespoons?|cups?|handfuls?|sprigs?|pinch(es)?|cloves?|slices?|each|x\\s*\\d+)?$/i.test(q)) return null;
    if(/^\d/.test(q)) return null;
    return q;
  }
  const f = /,\s*(to serve|to garnish|to taste|for [^,]+)\s*$/i.exec(String(displayText));
  return f ? f[1].trim() : null;
}

function sbSpecificName(displayText, foodName){
  if(!displayText || !SB_GENERIC.test(String(foodName||''))) return null;
  let r = String(displayText).replace(SB_LEAD, '').trim();
  r = r.replace(/\s*\([^)]*\)\s*$/, '').trim().replace(/^[,\s]+|[,\s]+$/g, '');
  if(!r || r.length < 2 || /^\d/.test(r)) return null;
  return r.charAt(0).toUpperCase() + r.slice(1);
}

function sbBuildRecipe(rec, lines, foodsById){
  const servings = Math.max(1, rec.servings || 1);
  const ings = [];
  let P = 0, C = 0, F = 0;
  // how many times each food appears in this recipe
  const dupFoods = {};
  lines.forEach(l=>{ dupFoods[l.food_id] = (dupFoods[l.food_id]||0) + 1; });
  lines.sort((a,b)=>(a.sort_order||0)-(b.sort_order||0)).forEach(l=>{
    const food = foodsById[l.food_id];
    if(!food) return;
    const qty = (+l.qty) / servings;
    const grams = sbGramsFor(food, qty, l.unit);
    const pg = (+food.protein_100g)/100, cg = (+food.carbs_100g)/100, fg = (+food.fat_100g)/100;
    P += grams*pg; C += grams*cg; F += grams*fg;
    const dens = food.density && food.density>0 ? food.density : 1;
    const isLiquid = food.default_unit === 'ml';
    const specific = sbSpecificName(l.display_text, food.name);
    let shownName = specific || food.name;
    // only add the qualifier where the same food turns up more than once,
    // otherwise every line gains a bracket it does not need
    if(dupFoods[l.food_id] > 1){
      const q = sbQualifier(l.display_text);
      if(q) shownName = shownName + ' — ' + q;
    }
    ings.push({
      raw: sbLabel({name:shownName, piece_name:food.piece_name, default_unit:food.default_unit},
                   (l.unit==='g'||l.unit==='ml') ? qty : Math.round(qty*100)/100, l.unit),
      name: shownName, grams: Math.round(grams*100)/100, unit: l.unit==='ml'?'ml':(l.unit==='g'?'g':'each'),
      qty: qty, unitGrams: qty>0 ? grams/qty : 0,
      pg: pg, cg: cg, fg: fg,
      scalable: (pg+cg+fg) > 0 && grams > 0,
      header: false, negligible: (pg+cg+fg) === 0,
      // the reference still points at the food the numbers came from
      src: 'library:' + (food.brand ? food.brand+' ' : '') + food.name,
      genericFood: specific ? food.name : null,
      dens: isLiquid ? dens : 1, dunit: isLiquid ? 'ml' : 'g',
      group: 'fixed', foodId: food.id,
      // what this ingredient is doing in the dish, and what it could be
      // exchanged for. Without these the app cannot tell an onion it can drop
      // from the pork the recipe is built around.
      role: l.role || null, swapGroup: food.swap_group || null,
      allergens: food.allergens || null
    });
  });
  ings.forEach(i=>{
    if(!i.scalable){ i.group='fixed'; return; }
    const p=i.grams*i.pg, c=i.grams*i.cg, f=i.grams*i.fg, mx=Math.max(p,c,f);
    i.group = mx===p ? 'P' : (mx===c ? 'C' : 'F');
  });
  const pro=Math.round(P), cho=Math.round(C), fat=Math.round(F);
  const dirs = String(rec.method||'').split(/\r?\n/).map(s=>s.replace(/^\s*\d+[.)]\s*/,'').trim()).filter(Boolean);
  return {
    id: 'db_' + rec.id, dbId: rec.id, fromLibrary: true,
    name: rec.name, category: rec.slot || 'lunchdinner',
    tier: cho<40 ? 'low' : (cho<=70 ? 'medium' : 'high'),
    cho, pro, fat, kcal: Math.round(4*pro + 4*cho + 9*fat),
    servings, sheetCategory: 'LIBRARY',
    ingredients: ings.map(i=>i.raw), directions: dirs,
    protein: 'Library', ings,
    res: {p:0, c:0, f:0},                     // macros ARE the ingredients — no fudge factor
    createdAt: rec.created_at, createdBy: rec.created_by,
    scan: (rec.name + ' | ' + ings.map(i=>i.raw).join(' | ')).toLowerCase()
  };
}

/* ---- player profile: day-type targets, avoids, favourites ---- */
const CN_DAYTYPES = ['Normal','Game Day','Game Day -1','Game Day +1','Off'];

async function sbDayTargets(playerId){
  if(!playerId) return {};
  const rows = await sbFetch('player_day_targets?select=*&player_id=eq.' + playerId);
  const out = {};
  (rows||[]).forEach(r=>{ out[r.day_type] = {pro:+r.pro_g_kg||null, cho:+r.cho_g_kg||null, fat:+r.fat_g_kg||null}; });
  return out;
}
// one row per day type. Blank rows are removed rather than stored as zeros,
// so "nothing set" and "set to nought" stay different things.
async function sbSaveDayTargets(playerId, map){
  for(const dt of CN_DAYTYPES){
    const v = map[dt] || {};
    const has = v.pro!=null || v.cho!=null || v.fat!=null;
    const q = 'player_day_targets?player_id=eq.' + playerId + '&day_type=eq.' + encodeURIComponent(dt);
    if(!has){ await sbFetch(q, {method:'DELETE'}); continue; }
    await sbFetch('player_day_targets?on_conflict=player_id,day_type', {
      method:'POST',
      headers:{'Prefer':'resolution=merge-duplicates'},
      body: JSON.stringify({player_id:playerId, day_type:dt,
        pro_g_kg:v.pro, cho_g_kg:v.cho, fat_g_kg:v.fat})
    });
  }
}

async function sbAvoids(playerId){
  if(!playerId) return [];
  return await sbFetch('player_avoids?select=*,foods(name)&player_id=eq.' + playerId) || [];
}
async function sbAddAvoid(playerId, row){
  return await sbFetch('player_avoids', {method:'POST',
    headers:{'Prefer':'return=representation'},
    body: JSON.stringify(Object.assign({player_id:playerId}, row))});
}
async function sbRemoveAvoid(id){
  return await sbFetch('player_avoids?id=eq.' + id, {method:'DELETE'});
}

async function sbFavourites(playerId){
  const q = playerId ? 'favourites?select=*&player_id=eq.' + playerId
                     : 'favourites?select=*&player_id=is.null';
  return await sbFetch(q) || [];
}
async function sbAddFavourite(playerId, recipeId){
  return await sbFetch('favourites', {method:'POST',
    body: JSON.stringify({player_id:playerId||null, recipe_id:recipeId})});
}
async function sbRemoveFavourite(playerId, recipeId){
  const q = 'favourites?recipe_id=eq.' + recipeId +
            (playerId ? '&player_id=eq.' + playerId : '&player_id=is.null');
  return await sbFetch(q, {method:'DELETE'});
}


/* ---- archiving instead of deleting, and the supplement list ---- */
async function sbArchiveBatch(batch){
  return await sbFetch('recipes?import_batch=eq.' + encodeURIComponent(batch) +
    '&archived=is.false', {method:'PATCH', headers:{'Prefer':'return=representation'},
    body: JSON.stringify({archived:true, archived_at:new Date().toISOString(),
                          archived_by:'undo import'})}) || [];
}
async function sbArchiveRecipe(id, who){
  return await sbFetch('recipes?id=eq.'+id, {method:'PATCH',
    body: JSON.stringify({archived:true, archived_at:new Date().toISOString(), archived_by:who||null})});
}
async function sbRestoreRecipe(id){
  return await sbFetch('recipes?id=eq.'+id, {method:'PATCH',
    body: JSON.stringify({archived:false, archived_at:null, archived_by:null})});
}
async function sbArchivedRecipes(){
  return await sbFetch('archived_recipes?select=*') || [];
}
// every recipe with the book figure beside what its ingredients come to
async function sbValidation(){
  return await sbFetchAll('recipe_validation?select=*&order=pct_out.desc.nullslast') || [];
}
async function sbValidateRecipe(id, decision, who){
  return await sbFetch('rpc/cn_validate_recipe', {method:'POST',
    body: JSON.stringify({p_id:id, p_decision:decision, p_who:who||null})});
}

async function sbNeedsReview(){
  return await sbFetch('needs_review?select=*') || [];
}
// Clearing the flag was never enough: the list also carries a live comparison
// between the book's calories and the ingredients, which no flag can switch
// off. Recording when it was checked is what makes it stay gone — and it comes
// back on its own if the recipe is edited afterwards.
async function sbClearReview(id, who){
  return await sbFetch('recipes?id=eq.'+id, {method:'PATCH',
    body: JSON.stringify({needs_review:false, review_note:null,
                          reviewed_at:new Date().toISOString(),
                          reviewed_by: who || null})});
}

async function sbSupplements(){
  // A failed request throws rather than returning nothing, so the fallback has
  // to catch. This keeps working whether or not the archived column is there.
  try{
    return await sbFetch('supplements?select=*&archived=is.false&order=name.asc') || [];
  }catch(e){
    return await sbFetch('supplements?select=*&order=name.asc') || [];
  }
}
async function sbSaveSupplement(x){
  const row={name:x.name, brand:x.brand||null, dose_amount:x.dose_amount||null,
             dose_unit:x.dose_unit||null, default_slot:x.default_slot||null,
             notes:x.notes||null, source:x.source||'app'};
  if(x.id){
    const r=await sbFetch('supplements?id=eq.'+x.id, {method:'PATCH',
      headers:{'Prefer':'return=representation'}, body:JSON.stringify(row)});
    return r[0];
  }
  const r=await sbFetch('supplements', {method:'POST',
    headers:{'Prefer':'return=representation'}, body:JSON.stringify(row)});
  return r[0];
}
async function sbDeleteSupplement(id){ await sbFetch('supplements?id=eq.'+id, {method:'DELETE'}); }

async function sbPlayerSupplements(playerId){
  if(!playerId) return [];
  return await sbFetch('player_supplements?select=*,supplements(name,brand,dose_unit)&player_id=eq.'+playerId) || [];
}
async function sbAddPlayerSupplement(playerId, row){
  return await sbFetch('player_supplements', {method:'POST',
    headers:{'Prefer':'return=representation'},
    body: JSON.stringify(Object.assign({player_id:playerId}, row))});
}
async function sbRemovePlayerSupplement(id){
  await sbFetch('player_supplements?id=eq.'+id, {method:'DELETE'});
}
async function sbDaySlots(){
  return await sbFetch('day_slots?select=*&order=sort_order.asc') || [];
}

/* ---- public API ---- */
/* PostgREST returns at most 1,000 rows per request. The ingredient table has
   nearly 3,000, so a single fetch silently returned a third of it — and any
   recipe whose lines fell outside that first page came back with no
   ingredients and was dropped from the library altogether. That is why a
   recipe could save successfully and then not be there.
   This asks for successive pages until a short one comes back. */
async function sbFetchAll(path, pageSize){
  const size = pageSize || 1000;
  const sep = path.indexOf('?') >= 0 ? '&' : '?';
  let from = 0, out = [];
  for(;;){
    const page = await sbFetch(path + sep + 'limit=' + size + '&offset=' + from);
    if(!page || !page.length) break;
    out = out.concat(page);
    if(page.length < size) break;
    from += size;
    if(from > 100000) break;           // a stop, in case something goes wrong
  }
  return out;
}

async function sbLoadLibrary(){
  // If a database has not had the archiving migration run, asking for the
  // column errors. Fall back rather than leaving the app with no library.
  const safe = async (withFilter, without) => {
    try{ return await sbFetchAll(withFilter); }
    catch(e){ console.warn('archived filter unavailable, loading everything'); 
              return await sbFetchAll(without); }
  };
  const [foods, recipes, links] = await Promise.all([
    // archived rows must not come back, or archiving is only cosmetic — they
    // would still appear in the library, the dropdowns and generated plans
    safe('foods?select=*&archived=is.false&order=id.asc', 'foods?select=*&order=id.asc'),
    safe('recipes?select=*&archived=is.false&order=created_at.desc',
         'recipes?select=*&order=created_at.desc'),
    sbFetchAll('recipe_ingredients?select=*&order=recipe_id.asc,sort_order.asc')
  ]);
  const foodsById = {};
  (foods||[]).forEach(f=>foodsById[f.id]=f);
  const byRecipe = {};
  (links||[]).forEach(l=>{ (byRecipe[l.recipe_id]=byRecipe[l.recipe_id]||[]).push(l); });
  const built = (recipes||[]).map(r=>sbBuildRecipe(r, byRecipe[r.id]||[], foodsById))
                             .filter(r=>r.ings.length);
  // anything that arrived with no ingredients is a data problem worth knowing
  // about rather than something to hide
  const empty = (recipes||[]).filter(r=>!(byRecipe[r.id]||[]).length);
  if(empty.length) console.warn('recipes with no ingredient rows:',
    empty.length, empty.slice(0,5).map(r=>r.name));
  return {foods: foods||[], recipes: built};
}
// find an existing food row or create one (this is how the library grows)
/* Looking a food up per ingredient meant an import of 160 recipes fired well
   over a thousand requests one after another — minutes of traffic with nothing
   on screen, which looks like a stall. And the lookup was case-sensitive, so
   "passata" in a recipe missed "Passata" in the library and created a
   duplicate food. This keeps a map of what is already there. */
let SB_FOOD_CACHE = null;
function sbPrimeFoodCache(foods){
  SB_FOOD_CACHE = new Map();
  (foods||[]).forEach(f=>{
    const k = String(f.name||'').toLowerCase().replace(/\s+/g,' ').trim();
    if(k && !SB_FOOD_CACHE.has(k)) SB_FOOD_CACHE.set(k, f.id);
  });
}
function sbClearFoodCache(){ SB_FOOD_CACHE = null; }

// Creating a food is now something the caller has to ask for. An import that
// guessed the nutrition used to write it straight into the shared library —
// which is how "melon" ended up at 583 kcal per 100g.
let SB_ALLOW_NEW_FOODS = true;
function sbAllowNewFoods(on){ SB_ALLOW_NEW_FOODS = !!on; }

async function sbEnsureFood(f){
  if(f.dbId) return f.dbId;
  const key = String(f.name||'').toLowerCase().replace(/\s+/g,' ').trim();
  if(SB_FOOD_CACHE && SB_FOOD_CACHE.has(key)) return SB_FOOD_CACHE.get(key);
  // case-insensitive, so a lowercase ingredient finds the capitalised food
  const nameQ = encodeURIComponent(f.name);
  const found = await sbFetch('foods?select=id,name&name=ilike.' + nameQ + '&limit=1');
  if(found && found.length){
    if(SB_FOOD_CACHE) SB_FOOD_CACHE.set(key, found[0].id);
    return found[0].id;
  }
  const row = {
    name: f.name, brand: f.brand || null,
    protein_100g: +(+f.p).toFixed(2), carbs_100g: +(+f.c).toFixed(2),
    fat_100g: +(+f.f).toFixed(2),
    kcal_100g: +(+(f.kcal != null ? f.kcal : 4*f.p + 4*f.c + 9*f.f)).toFixed(1),
    default_unit: f.default_unit || 'g',
    density: f.density || null, piece_grams: f.piece_grams || null,
    piece_name: f.piece_name || null, portioning: f.portioning || 'free',
    is_custom: f.is_custom !== false, created_by: f.created_by || null
  };
  if(!SB_ALLOW_NEW_FOODS){
    throw new Error('"' + f.name + '" is not in the food library. ' +
      'Review the new foods before importing, or add it first.');
  }
  try{
    const ins = await sbFetch('foods', {
      method:'POST', headers:{'Prefer':'return=representation'}, body: JSON.stringify(row)
    });
    if(SB_FOOD_CACHE) SB_FOOD_CACHE.set(key, ins[0].id);
    return ins[0].id;
  }catch(e){
    /* The database treats "Tuna, tinned" and "tuna tinned" as the same name,
       which is stricter than the lookup above. Rather than failing with a
       constraint message nobody can act on, find the one that is already
       there and use it. */
    if(!/duplicate|unique/i.test(e.message || '')) throw e;
    const norm = String(f.name||'').toLowerCase().replace(/[^a-z0-9]/g,'');
    const all = await sbFetch('foods?select=id,name,brand');
    const hit = (all||[]).find(x=>
      String((x.brand? x.brand+' ':'') + x.name).toLowerCase().replace(/[^a-z0-9]/g,'') === norm ||
      String(x.name||'').toLowerCase().replace(/[^a-z0-9]/g,'') === norm);
    if(hit){
      if(SB_FOOD_CACHE) SB_FOOD_CACHE.set(key, hit.id);
      return hit.id;
    }
    throw new Error('A food called "' + f.name + '" already exists, but it could not be ' +
                    'found to reuse. Search for it in the food list.');
  }
}
async function sbSaveFood(f){
  const id = await sbEnsureFood(f);
  const rows = await sbFetch('foods?select=*&id=eq.' + id);
  return rows && rows[0];
}
// save a whole recipe: makes sure every food exists, then writes the ingredient rows
async function sbSaveRecipe(r){
  const rec = await sbFetch('recipes', {
    method:'POST', headers:{'Prefer':'return=representation'},
    body: JSON.stringify({
      name: r.name, slot: r.slot || 'lunchdinner',
      servings: r.servings || 1, method: r.method || null,
      notes: r.notes || null, created_by: r.created_by || null,
      // stamps the import this arrived in, so a bad batch can be undone
      // as a batch instead of one recipe at a time
      import_batch: r.import_batch || null
    })
  });
  const recipeId = rec[0].id;
  try{
    const lines = [];
    for(let i=0; i<r.items.length; i++){
      const it = r.items[i];
      const foodId = await sbEnsureFood(it.food);
      lines.push({recipe_id: recipeId, food_id: foodId, qty: it.qty, unit: it.unit, sort_order: i});
    }
    if(lines.length) await sbFetch('recipe_ingredients', {method:'POST', body: JSON.stringify(lines)});
  }catch(e){
    await sbFetch('recipes?id=eq.' + recipeId, {method:'DELETE'});  // don't leave a half-saved recipe
    throw e;
  }
  return recipeId;
}
async function sbDeleteRecipe(id){ await sbFetch('recipes?id=eq.' + id, {method:'DELETE'}); }
async function sbSearchFoods(q){
  if(!q || q.length < 2) return [];
  const like = encodeURIComponent('*' + q + '*');
  return (await sbFetch('foods?select=*&or=(name.ilike.' + like + ',brand.ilike.' + like + ')&limit=15')) || [];
}
/* ---- players ---- */
async function sbPlayers(){ return (await sbFetch('players?select=*&order=name.asc'))||[]; }
async function sbSavePlayer(p){
  const row={name:p.name, bodyweight:p.bodyweight||null,
             pro_g:p.pro_g||null, cho_g:p.cho_g||null, fat_g:p.fat_g||null,
             notes:p.notes||null, height_cm:p.height_cm||null,
             bodyweight_at:p.bodyweight_at||null};
  if(p.id){
    const r=await sbFetch('players?id=eq.'+p.id, {method:'PATCH',
      headers:{'Prefer':'return=representation'}, body:JSON.stringify(row)});
    return r[0];
  }
  const r=await sbFetch('players', {method:'POST',
    headers:{'Prefer':'return=representation'}, body:JSON.stringify(row)});
  return r[0];
}
async function sbDeletePlayer(id){ await sbFetch('players?id=eq.'+id, {method:'DELETE'}); }

/* ---- saved weeks ---- */
async function sbPlans(playerId){
  const q = playerId ? ('&player_id=eq.'+playerId) : '';
  return (await sbFetch('plans?select=id,player_id,week_start,title,bodyweight,created_at,avg_kcal,avg_pro,avg_cho,avg_fat&order=week_start.desc'+q))||[];
}
async function sbLoadPlan(id){
  const r=await sbFetch('plans?select=*&id=eq.'+id);
  return r && r[0];
}
async function sbSavePlan(p){
  const row={player_id:p.player_id||null, week_start:p.week_start, title:p.title||null,
             bodyweight:p.bodyweight||null, data:p.data,
             avg_kcal:p.avg_kcal||null, avg_pro:p.avg_pro||null,
             avg_cho:p.avg_cho||null, avg_fat:p.avg_fat||null};
  if(p.id){
    const r=await sbFetch('plans?id=eq.'+p.id, {method:'PATCH',
      headers:{'Prefer':'return=representation'}, body:JSON.stringify(row)});
    return r[0];
  }
  const r=await sbFetch('plans', {method:'POST',
    headers:{'Prefer':'return=representation'}, body:JSON.stringify(row)});
  return r[0];
}
async function sbDeletePlan(id){ await sbFetch('plans?id=eq.'+id, {method:'DELETE'}); }

/* ---- editing recipes & foods ---- */
async function sbLoadRecipeForEdit(recipeId){
  const [rec, lines, foods]=await Promise.all([
    sbFetch('recipes?select=*&id=eq.'+recipeId),
    sbFetch('recipe_ingredients?select=*&recipe_id=eq.'+recipeId+'&order=sort_order.asc'),
    sbFetch('foods?select=*')
  ]);
  const byId={}; (foods||[]).forEach(f=>byId[f.id]=f);
  return {recipe:rec&&rec[0], lines:(lines||[]).map(l=>({...l, food:byId[l.food_id]}))};
}
async function sbUpdateRecipe(id, r){
  await sbFetch('recipes?id=eq.'+id, {method:'PATCH', body:JSON.stringify({
    name:r.name, slot:r.slot, servings:r.servings||1, method:r.method||null})});
  await sbFetch('recipe_ingredients?recipe_id=eq.'+id, {method:'DELETE'});
  const lines=[];
  for(let i=0;i<r.items.length;i++){
    const it=r.items[i];
    // an existing food is referenced directly; only a new one goes through
    // sbEnsureFood, which would otherwise create duplicates on every save
    const foodId = it.food_id || await sbEnsureFood(it.food);
    lines.push({recipe_id:id, food_id:foodId, qty:it.qty, unit:it.unit, sort_order:i,
      // the written text carries the specific herb and the "for soaking" note —
      // dropping it here would flatten every one of those back to the generic
      display_text: it.display_text || null,
      min_qty: it.min_qty != null ? it.min_qty : null,
      max_qty: it.max_qty != null ? it.max_qty : null,
      macro_role: it.macro_role || null,
      role: it.role || null});
  }
  if(lines.length) await sbFetch('recipe_ingredients', {method:'POST', body:JSON.stringify(lines)});
}
async function sbUpdateFood(id, f){
  await sbFetch('foods?id=eq.'+id, {method:'PATCH', body:JSON.stringify({
    name:f.name, brand:f.brand||null,
    protein_100g:+(+f.p).toFixed(2), carbs_100g:+(+f.c).toFixed(2), fat_100g:+(+f.f).toFixed(2),
    kcal_100g:+(+f.kcal).toFixed(1), default_unit:f.default_unit||'g',
    density:f.density||null, piece_grams:f.piece_grams||null,
    piece_name:f.piece_name||null, portioning:f.portioning||'free'})});
}
// refuse to delete a food that recipes rely on — tell the user which ones
async function sbDeleteFood(id){
  const used=await sbFetch('recipe_ingredients?select=recipe_id&food_id=eq.'+id+'&limit=50');
  if(used && used.length){
    const ids=[...new Set(used.map(u=>u.recipe_id))];
    const recs=await sbFetch('recipes?select=name&id=in.('+ids.join(',')+')');
    const names=(recs||[]).map(r=>r.name);
    const err=new Error('in use by '+names.length+' recipe(s): '+names.slice(0,4).join(', '));
    err.inUse=names; throw err;
  }
  await sbFetch('foods?id=eq.'+id, {method:'DELETE'});
}
async function sbAllFoods(){ return (await sbFetch('foods?select=*&order=name.asc'))||[]; }

window.CNLib = {sbSignIn, sbSignOut, sbRefresh, sbUser, sbSetSession, sbPlayers, sbSavePlayer, sbDeletePlayer, sbPlans, sbLoadPlan, sbSavePlan,
                sbDeletePlan, sbLoadRecipeForEdit, sbUpdateRecipe, sbUpdateFood, sbDeleteFood,
                sbAllFoods, sbLoadLibrary, sbSaveRecipe, sbSaveFood, sbSearchFoods, sbDeleteRecipe,
                sbEnsureFood, sbPrimeFoodCache, sbClearFoodCache, sbAllowNewFoods, SB_UNITS, SB_URL,
                sbDayTargets, sbSaveDayTargets, sbAvoids, sbAddAvoid, sbRemoveAvoid,
                sbFavourites, sbAddFavourite, sbRemoveFavourite, CN_DAYTYPES,
                sbArchiveRecipe, sbArchiveBatch, sbRestoreRecipe, sbArchivedRecipes, sbNeedsReview, sbValidation, sbValidateRecipe, sbClearReview,
                sbSupplements, sbSaveSupplement, sbDeleteSupplement,
                sbPlayerSupplements, sbAddPlayerSupplement, sbRemovePlayerSupplement, sbDaySlots};
