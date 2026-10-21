const fs=require('fs'); const {JSDOM}=require('jsdom');
const html=fs.readFileSync('/mnt/user-data/outputs/close-nutrition-plan-builder.html','utf8');
const dom=new JSDOM(html,{runScripts:'dangerously',pretendToBeVisual:true,url:'https://x.test/',
 beforeParse(w){ w.fetch=()=>Promise.reject(new Error('x')); w.alert=()=>{}; w.scrollTo=()=>{}; }});
setTimeout(()=>{
  const w=dom.window;
  const cases=[
    // the traps
    ['Peanut Butter','Store cupboard'], ['Almond butter','Store cupboard'],
    ['Butter','Dairy & eggs'], ['Black Pepper','Seasoning'],
    ['Bell Pepper','Fruit & veg'], ['Red peppers','Fruit & veg'],
    ['Aubergine','Fruit & veg'], ['Panko breadcrumbs','Rice, pasta & bread'],
    ['Low-salt stock','Tins, pulses & jars'], ['Olive Oil','Store cupboard'],
    ['Coconut milk','Store cupboard'],
    // ordinary
    ['Chicken Breast, skinless','Meat & poultry'], ['5% beef mince','Meat & poultry'],
    ['Salmon Fillet','Fish'], ['King prawns','Fish'],
    ['0% Fat Greek Yoghurt','Dairy & eggs'], ['Large egg','Dairy & eggs'],
    ['Light mozzarella','Dairy & eggs'],
    ['Blueberries','Fruit & veg'], ['Sweet potato','Fruit & veg'],
    ['Spinach','Fruit & veg'], ['Banana','Fruit & veg'],
    ['Basmati Rice, dry','Rice, pasta & bread'], ['Wholemeal bread','Rice, pasta & bread'],
    ['Large flour tortilla wrap','Rice, pasta & bread'], ['Porridge oats','Rice, pasta & bread'],
    ['Passata','Tins, pulses & jars'], ['Black beans, drained','Tins, pulses & jars'],
    ['Reduced-salt soy sauce','Tins, pulses & jars'],
    ['Whey Protein Isolate','Store cupboard'], ['Honey','Store cupboard'],
    ['Smoked paprika','Seasoning'], ['Salt & black pepper','Seasoning'],
    ['Dried oregano','Seasoning'],
    // a second round, from the real recipe vocabulary
    ['Green beans / Mangetout','Fruit & veg'], ['Tenderstem broccoli','Fruit & veg'],
    ['Liquid egg whites','Dairy & eggs'], ['Semi-skimmed milk','Dairy & eggs'],
    ['Light evaporated milk','Dairy & eggs'], ['Cottage cheese','Dairy & eggs'],
    ['Beef cheek, well trimmed','Meat & poultry'], ['Chicken thigh, skinless','Meat & poultry'],
    ['Cod fillet, cut into fingers','Fish'], ['Mussels, cooked meat','Fish'],
    ['Jasmine rice, dry','Rice, pasta & bread'], ['Soba noodles, dry','Rice, pasta & bread'],
    ['Thin pizza base','Store cupboard'], ['Sweet chilli sauce','Tins, pulses & jars'],
    ['BBQ sauce','Tins, pulses & jars'], ['Hot sauce','Tins, pulses & jars'],
    ['Peri-peri seasoning','Seasoning'], ['Garam masala','Store cupboard'],
    ['Dark chocolate chips','Store cupboard'], ['Chia seeds','Store cupboard'],
    ['Rolled oats','Rice, pasta & bread'], ['Medium banana','Fruit & veg'],
    ['Fresh ginger','Fruit & veg'], ['Spring onion','Fruit & veg'],
    ['Mixed fresh berries','Fruit & veg'], ['Potatoes, roasted','Fruit & veg']
  ];
  let bad=0;
  cases.forEach(([n,want])=>{
    const got=w.eval('shopAisle(null, '+JSON.stringify(n)+')');
    if(got!==want){ bad++; console.log('  WRONG  '+n.padEnd(30)+'-> '+got+'   (wanted '+want+')'); }
  });
  console.log('cases tested :', cases.length);
  console.log('wrong        :', bad);
  // and that the swap group still wins when there is one
  console.log('swap group wins:', w.eval("shopAisle('poultry','Blueberries')"));
  process.exit(0);
},2400);
