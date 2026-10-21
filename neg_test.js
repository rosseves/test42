const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('x')); w.alert=()=>{}; w.scrollTo=()=>{}; }});
setTimeout(()=>{
  const w=dom.window;
  w.eval(`LIB_FOODS=[
    {id:'t1',name:'Tuna, tinned in spring water (drained)',protein_100g:25,carbs_100g:0,fat_100g:0.6,kcal_100g:108,default_unit:'g'},
    {id:'t2',name:'Sweetcorn kernels, canned in water, drained',protein_100g:2.9,carbs_100g:17,fat_100g:1.2,kcal_100g:90,default_unit:'g'},
    {id:'t3',name:'Salted peanuts',protein_100g:25,carbs_100g:12,fat_100g:49,kcal_100g:600,default_unit:'g'},
    {id:'t4',name:'Lemon zest cake',protein_100g:6,carbs_100g:50,fat_100g:20,kcal_100g:404,default_unit:'g'},
    {id:'t5',name:'Chickpeas in water, drained',protein_100g:7,carbs_100g:16,fat_100g:2.9,kcal_100g:120,default_unit:'g'}];
    CNFood.setUserFoods(LIB_FOODS);`);
  const cases=[
    ['100g Tuna, tinned in spring water (drained)', 'real'],
    ['200g Sweetcorn kernels, canned in water, drained','real'],
    ['30g Salted peanuts','real'],
    ['80g Lemon zest cake','real'],
    ['120g Chickpeas in water, drained','real'],
    // these genuinely are seasonings and must stay at zero
    ['300ml water','negligible'],
    ['Salt and pepper to taste','negligible'],
    ['1 tsp vanilla extract','negligible'],
    ['Ice cubes','negligible'],
    ['Lemon zest','negligible'],
    ['5g baking powder','negligible']
  ];
  let bad=0;
  cases.forEach(([line,want])=>{
    const r=JSON.parse(w.eval(`(function(){
      const b=CNFood.buildCustomRecipe({name:'x',ingredients:${JSON.stringify(line)},category:'lunchdinner'});
      if(!b||!b.recipe.ings.length) return JSON.stringify({none:true});
      const i=b.recipe.ings[0];
      return JSON.stringify({g:i.grams,neg:!!i.negligible,src:i.src,
        kcal:Math.round(i.grams*(4*i.pg+4*i.cg+9*i.fg))});
    })()`));
    const got = (r.neg || r.kcal===0) ? 'negligible' : 'real';
    if(got!==want){ bad++; console.log('  WRONG  '+line.padEnd(44)+'-> '+got+' ('+r.kcal+' kcal, '+r.src+')'); }
  });
  console.log('cases:', cases.length, '| wrong:', bad);
  process.exit(0);
},2400);
