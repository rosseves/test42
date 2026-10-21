-- =====================================================================
-- Close Nutrition — Performance Plan Builder
-- 03. The master recipe book
--
-- Run AFTER 01_schema.sql and 02_api.sql.
-- Loads 258 foods, 292 recipes and their ingredients.
--
-- This only ever ADDS. It never overwrites anything already in the
-- database, so it is safe to re-run if a load is interrupted.
-- =====================================================================
begin;

-- ---------- 258 foods ----------
insert into foods (ext_id,name,brand,protein_100g,carbs_100g,fat_100g,kcal_100g,default_unit,piece_grams,piece_name,portioning,scaling_increment,allergens,dislike_tags,source_note,source,is_custom,needs_review,review_note) values
('ING001','Banana (whole, medium)',null,1.1,22.88,0.34,89.0,'g',118.0,'whole item','whole',0.5,null,'banana','Standard reference value (average medium banana).','master',false,false,null),
('ING002','Blueberries',null,0.7,14.0,0.3,57.0,'g',null,null,'free',5.0,null,'blueberries','Standard reference value.','master',false,false,null),
('ING003','Raspberries',null,1.2,12.0,0.7,52.0,'g',null,null,'free',5.0,null,'raspberries','Standard reference value.','master',false,false,null),
('ING004','0% Fat Greek Yoghurt — Fage Total 0%',null,10.3,3.0,0.0,54.0,'g',null,null,'free',5.0,'Milk',null,'Real product value from FAGE''s own UK product page (Total 0%), per 100g: 54kcal, 3.0g carbs (all naturally occurring milk sugar, no added sugar), 0g fat, 10.3g protein. Source: hom','master',false,false,null),
('ING005','Whey Protein Powder — Nutrition X Big Whey (30g scoop)',null,76.67,7.4,5.8,396.7,'g',null,null,'free',5.0,'Milk',null,'Real product value from Nutrition X''s own UK product page, per 1 level scoop (30g): 119kcal, 2.22g carbs (1.44g sugars), 1.74g fat (0.87g saturates), 23g protein. Nutrition X''s own','master',false,false,null),
('ING006','Semi-Skimmed Milk',null,3.4,4.7,1.7,46.0,'ml',null,null,'free',5.0,'Milk',null,'Standard reference value.','master',false,false,null),
('ING007','Nut Butter — Pip & Nut Almond Butter',null,23.0,6.8,53.0,610.0,'g',null,null,'free',5.0,'Nuts',null,'Real product value for Pip & Nut''s smooth almond butter, per 100g: 610kcal, 6.8g carbs (4.8g sugars), 53g fat, 23g protein (100% almonds, no added palm oil or sugar). Pip & Nut als','master',false,false,null),
('ING008','Rolled Oats (dry)',null,11.0,60.0,7.0,375.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference value. Tagged Gluten as standard oats carry cross-contact risk - retag if using certified gluten-free oats.','master',false,false,null),
('ING009','Peanut Butter — Pip & Nut',null,26.4,11.9,48.2,605.0,'g',null,null,'free',5.0,'Peanuts',null,'Real product value for Pip & Nut''s peanut butter, per 100g: 605kcal, 11.9g carbs (5.7g sugars), 48.2g fat (5.9g saturates), 26.4g protein (99.6% Argentinian hi-oleic peanuts, sea s','master',false,false,null),
('ING010','Chia Seeds',null,17.0,42.0,31.0,486.0,'g',null,null,'free',2.0,null,null,'Standard reference value.','master',false,false,null),
('ING011','Honey',null,0.3,76.0,0.0,304.0,'g',null,null,'free',5.0,null,null,'Standard reference value.','master',false,false,null),
('ING012','Dark Chocolate Chips',null,5.0,47.0,35.0,550.0,'g',null,null,'free',5.0,null,'chocolate','Standard reference value for dark chocolate; confirm the specific product is dairy-free if Milk needs to stay untagged.','master',false,false,null),
('ING013','Cocoa Powder (unsweetened)',null,20.0,58.0,14.0,228.0,'g',null,null,'free',2.0,null,null,'Standard reference value.','master',false,false,null),
('ING014','Vanilla Extract / Flavour Drops',null,0.0,0.0,0.0,0.0,'g',null,null,'free',1.0,null,null,'Amounts used in these recipes are nutritionally negligible; treated as zero for practical purposes.','master',false,false,null),
('ING015','Chickpeas, canned (drained)',null,7.5,20.0,2.6,139.0,'g',null,null,'free',10.0,null,'chickpeas','Standard reference value.','master',false,false,null),
('ING016','Maple Syrup',null,0.0,67.0,0.2,260.0,'g',null,null,'free',5.0,null,null,'Standard reference value.','master',false,false,null),
('ING017','Baking Powder / Bicarbonate of Soda',null,0.0,0.0,0.0,0.0,'g',null,null,'free',1.0,null,null,'Amounts used are nutritionally negligible; treated as zero.','master',false,false,null),
('ING018','Egg, whole (medium)',null,11.38,1.03,9.48,134.5,'g',58.0,'whole item','whole',1.0,'Egg',null,'Standard reference value for one medium whole egg.','master',false,false,null),
('ING019','Egg White (medium)',null,10.91,0.61,0.15,51.5,'g',33.0,'whole item','whole',1.0,'Egg',null,'Standard reference value for one medium egg white.','master',false,false,null),
('ING020','Avocado (whole medium)',null,2.0,8.5,14.67,160.0,'g',150.0,'whole item','whole',0.25,null,'avocado','Standard reference value for one whole medium avocado''s flesh.','master',false,false,null),
('ING021','Sourdough Bread (slice)',null,9.5,50.0,2.0,290.0,'g',40.0,'slice','whole',1.0,'Gluten',null,'Standard reference value for one 40g slice.','master',false,false,null),
('ING022','Smoked Salmon (slice)',null,18.0,0.0,4.67,120.0,'g',15.0,'slice','whole',1.0,'Fish',null,'Standard reference value for one 15g slice.','master',false,false,null),
('ING023','Olive Oil',null,0.0,0.0,91.6,824.0,'g',null,null,'free',2.0,null,null,'Standard reference value.','master',false,true,'Reads 824 kcal and 91.6g fat. Oil is very close to pure fat — the published figure is 884 kcal and 99.9g. The sesame oil in this same list is already 884. Used in 96 recipes, worth about +4 kcal a serving.'),
('ING024','Salt & Black Pepper (to taste)',null,0.0,0.0,0.0,0.0,'g',null,null,'free',1.0,null,null,'Nutritionally negligible; treated as zero.','master',false,false,null),
('ING025','Chicken Sausage, lean (each) — brand not yet chosen',null,16.0,3.0,4.0,110.0,'g',50.0,'whole item','whole',1.0,'Gluten',null,'No preferred supplier confirmed yet - Graeme wants only high-quality produce recommended generally. Kcal/Carbs/Fat/Protein below remain a generic estimate for a lean/fitness-style','master',false,false,null),
('ING026','Baked Beans (in tomato sauce)',null,4.7,14.5,0.4,80.0,'g',null,null,'free',10.0,null,null,'Standard reference value; confirm brand for allergen status.','master',false,false,null),
('ING027','Wholegrain Toast (slice, unbuttered)',null,9.14,40.0,3.43,251.4,'g',35.0,'slice','whole',1.0,'Gluten',null,'Standard reference value for one 35g slice of wholegrain bread, toasted, no butter/oil.','master',false,false,null),
('ING028','Water',null,0.0,0.0,0.0,0.0,'ml',null,null,'free',10.0,null,null,'Zero-calorie filler; included so the ingredient list still reads as a complete recipe.','master',false,false,null),
('ING029','Ice (chunks/cubes)',null,0.0,0.0,0.0,0.0,'g',null,null,'whole',1.0,null,null,'Zero-calorie filler; included so the ingredient list still reads as a complete recipe.','master',false,false,null),
('ING030','0% / Low-Fat Greek Yoghurt (generic, non-Fage)',null,9.5,3.6,0.2,56.0,'g',null,null,'free',5.0,'Milk',null,'Generic reference value used where a recipe just says ''Greek yoghurt'' without specifying Fage Total 0% - if this is meant to be the same product as ING004, swap in ING004 instead.','master',false,false,null),
('ING031','Almond Butter (natural, generic)',null,21.0,7.0,56.0,614.0,'g',null,null,'free',5.0,'Nuts',null,'If this is meant to be Pip & Nut Almond Butter, use ING007 instead - this generic entry is for a plain ''almond butter'' mention not tied to a brand.','master',false,false,null),
('ING032','Almonds (flaked/whole/ground)',null,21.0,22.0,50.0,579.0,'g',null,null,'free',5.0,'Nuts',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING033','Anchovy Fillet (each, in oil, drained)',null,22.5,0.0,12.5,200.0,'g',4.0,'whole item','whole',1.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING034','Apple (incl. grated)',null,0.32,12.4,0.16,52.0,'g',125.0,'whole item','whole',0.5,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING035','Asparagus',null,2.4,1.8,0.3,22.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING036','BBQ Sauce (incl. Reduced-Sugar)',null,1.5,32.0,0.5,140.0,'g',null,null,'free',5.0,null,null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING037','Baguette (slice, ~25g)',null,10.0,52.0,2.4,272.0,'g',25.0,'slice','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING038','Baked Tortilla Chips',null,7.0,70.0,13.0,440.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING039','Balsamic Vinegar (incl. Balsamic Glaze)',null,0.5,17.0,0.0,88.0,'ml',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING040','Bamboo Shoots, tinned (drained)',null,1.5,2.6,0.3,15.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING041','Basil Pesto / Fresh Pesto',null,4.0,5.0,43.0,430.0,'g',null,null,'free',2.0,'Milk|Nuts',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING042','Basmati / Jasmine / Long Grain Rice (dry weight)',null,7.5,78.0,0.6,349.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING043','Bay Leaf / Curry Leaves / Kaffir Lime Leaf / Star Anise / Cinnamon Stick / Cardamom Pods / Cloves (whole spice, garnish)',null,0.0,0.0,0.0,0.0,'g',100.0,'item','free',1.0,null,null,'Whole aromatic spices infused into a dish and usually removed/not eaten - negligible macro contribution.','master',false,false,null),
('ING044','Beansprouts',null,3.0,4.5,0.5,30.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING045','Beef Cheek (raw)',null,23.0,0.0,8.0,165.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING046','Beef Short Rib (raw, before braising/skimming)',null,24.0,0.0,14.0,220.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING047','Black Beans, tinned (drained)',null,9.0,20.0,0.5,132.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING048','Bread Roll / Wholemeal Roll / Pau Bun / Soft Bread Roll',null,9.33,48.0,4.0,260.0,'g',75.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING049','Breadcrumbs (panko / wholemeal / fresh)',null,13.0,72.0,3.0,380.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING050','Broccoli / Tenderstem Broccoli',null,4.0,3.1,0.9,33.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING051','Brown Sugar (light/soft, incl. Palm Sugar)',null,0.0,98.0,0.0,380.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING052','Bulgur Wheat (dry weight)',null,12.0,76.0,1.3,342.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING053','Burger Bun (incl. brioche-style)',null,9.33,46.67,5.33,266.7,'g',75.0,'whole item','whole',1.0,'Gluten|Egg',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING054','Butter',null,0.9,0.6,81.0,717.0,'g',null,null,'free',5.0,'Milk',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING055','Cacao Nibs',null,12.0,34.0,40.0,480.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING056','Capers',null,2.4,4.9,0.4,23.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING057','Carrot',null,0.6,7.6,0.2,35.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING058','Cashew Nuts',null,18.0,30.0,44.0,553.0,'g',null,null,'free',5.0,'Nuts',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING059','Cauliflower',null,2.0,2.6,0.5,25.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING060','Celery (incl. celery stick)',null,0.5,1.5,0.1,8.0,'g',null,null,'free',10.0,'Celery',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING061','Cherry Tomatoes',null,0.9,3.9,0.3,18.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING062','Chicken Breast, skinless (raw)',null,24.0,0.0,1.1,106.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING063','Chicken Thigh, skinless & boneless (raw)',null,19.0,0.0,5.7,130.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING064','Chinese Pancake (for duck/lamb wraps)',null,7.22,50.0,5.56,277.8,'g',18.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING065','Chipotle Paste / Tamarind Paste',null,2.0,20.0,1.5,110.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING066','Chocolate Spread / Lotus Biscoff Spread',null,6.0,57.0,32.0,539.0,'g',null,null,'free',5.0,'Gluten|Milk|Nuts',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING067','Cider Vinegar / Red Wine Vinegar',null,0.0,0.9,0.0,22.0,'ml',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING068','Coconut Oil',null,0.0,0.0,99.1,862.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING069','Coconut Water',null,0.7,3.7,0.2,19.0,'ml',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING070','Coleslaw Mix (cabbage/carrot/onion, undressed)',null,1.2,5.4,0.2,27.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING071','Cooked Lobster Meat',null,19.0,0.5,0.9,89.0,'g',null,null,'free',10.0,'Crustaceans',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING072','Corn Tortilla (small)',null,5.67,46.67,2.33,226.7,'g',30.0,'whole item','whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING073','Corn on the Cob',null,3.28,20.0,1.12,88.8,'g',125.0,'whole item','whole',0.5,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING074','Cornflake Crumb Coating',null,7.0,84.0,1.0,380.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING075','Cornflour',null,0.6,87.0,0.5,354.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING076','Courgette',null,1.5,2.0,0.2,18.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING077','Couscous (dry weight)',null,13.0,72.0,1.6,360.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING078','Cranberry Juice',null,0.4,11.5,0.0,46.0,'ml',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING079','Croissant',null,8.33,43.33,20.83,400.0,'g',60.0,'whole item','whole',1.0,'Gluten|Egg|Milk',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING080','Cucumber',null,0.6,1.5,0.1,12.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING081','Curry Powder (incl. Tandoori/Biryani/Massaman spice mix, Fajita/Cajun/Taco seasoning)',null,13.0,34.0,14.0,325.0,'g',null,null,'free',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,true,'Reads 325 kcal. The published blend figure is about 233.'),
('ING082','Dark Chocolate (bar, for chopping)',null,5.0,47.0,35.0,550.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING083','Digestive Biscuit',null,6.43,68.5,20.0,480.0,'g',14.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,true,'CHANGED ON IMPORT: the book had carbs 75.0 and 500 kcal, which made the macros add up to 101.4g per 100g — impossible. Set to the published figure for a plain digestive (68.5g carbs, 480 kcal). Please confirm.'),
('ING084','Dijon Mustard / Wholegrain Mustard',null,8.0,5.0,8.0,143.0,'g',null,null,'free',2.0,'Mustard',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING085','Dried Herbs & Ground Spices (oregano, thyme, cumin, paprika, turmeric, cinnamon, allspice, garam masala, five spice, etc.)',null,12.0,45.0,8.0,280.0,'g',null,null,'free',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific). Used in small (sub-5g) quantities per recipe so the macro contribution is minor either way; one shared','master',false,false,null),
('ING086','Dried Lasagne Sheets',null,12.0,71.0,1.5,352.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING087','Dried Red Lentils',null,25.0,54.0,1.6,318.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING088','Duck Breast, skin removed (raw)',null,22.0,0.0,4.3,130.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING089','Edamame Beans, shelled (cooked)',null,11.0,9.0,5.0,122.0,'g',null,null,'free',10.0,'Soybeans',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING090','Egg Yolk (medium)',null,15.88,1.76,26.47,323.5,'g',17.0,'whole item','whole',1.0,'Egg',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING091','Fat-Free Skyr / Skyr Yoghurt',null,11.0,4.0,0.2,63.0,'g',null,null,'free',5.0,'Milk',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING092','Fennel Bulb',null,1.2,3.1,0.2,17.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING093','Feta',null,14.2,1.5,21.0,264.0,'g',null,null,'free',5.0,'Milk',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING094','Firm Tofu',null,8.0,0.7,4.2,76.0,'g',null,null,'free',10.0,'Soybeans',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING095','Fish Sauce',null,5.0,3.6,0.0,35.0,'ml',null,null,'free',2.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING096','Flaxseed / Flaxseeds',null,18.0,29.0,42.0,534.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING097','Flour Tortilla (small)',null,7.78,48.89,6.67,288.9,'g',45.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING098','Fresh Ginger (per cm piece, ~2g)',null,0.0,40.0,0.0,200.0,'g',null,null,'whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,true,'Reads 200 kcal and 40g carbs. That is the dried ground ginger figure; fresh root ginger is about 60 kcal and 12g carbs. Used in 58 recipes.'),
('ING099','Fresh Herbs (basil, coriander, parsley, mint, dill, chives, rosemary, thyme sprigs, etc.)',null,3.0,4.0,0.6,30.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific). Typically used as a garnish in small quantities (a handful/few sprigs) - macro contribution is minor.','master',false,false,null),
('ING100','Fresh Potato Gnocchi',null,3.5,32.0,1.0,156.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING101','Fresh Tomato Salsa',null,1.2,7.0,0.3,36.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING102','Frozen Peas',null,6.0,11.0,0.9,78.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING103','Full-Fat Coconut Milk',null,2.0,2.8,19.0,187.0,'ml',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING104','Garlic Clove',null,6.67,33.33,0.0,133.3,'g',3.0,'whole item','whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,true,'Reads 133 kcal and 33.3g carbs. Raw garlic is about 98 kcal and 16g carbs. Used in 127 recipes, but the amounts are so small it barely moves a meal.'),
('ING105','Gherkin / Pickles',null,0.3,2.0,0.2,11.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING106','Goat Meat, lean (raw)',null,21.0,0.0,2.3,109.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING107','Granola',null,9.0,62.0,15.0,435.0,'g',null,null,'free',5.0,'Gluten|Nuts',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING108','Greek Flatbread',null,8.67,49.33,3.33,266.7,'g',75.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING109','Green Beans / Mangetout',null,2.0,4.9,0.2,31.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING110','Ground Almonds',null,21.0,8.0,50.0,579.0,'g',null,null,'free',5.0,'Nuts',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING111','Halloumi',null,21.0,2.2,25.0,321.0,'g',null,null,'free',5.0,'Milk',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING112','Harissa / Korean Chilli Paste / Chilli Paste',null,3.0,18.0,5.0,140.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING113','Hoisin Sauce (incl. Reduced-Sugar)',null,3.0,44.0,3.5,220.0,'g',null,null,'free',5.0,'Gluten|Soybeans',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING114','Hummus',null,7.0,11.0,12.0,177.0,'g',null,null,'free',5.0,'Sesame',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING115','Jalapeño',null,1.43,6.43,0.36,28.6,'g',14.0,'whole item','whole',0.25,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING116','Kidney Beans, tinned (drained)',null,8.7,18.0,0.5,127.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING117','King Prawns, raw (peeled)',null,17.6,0.9,0.5,71.0,'g',null,null,'free',10.0,'Crustaceans',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING118','Kiwi Fruit',null,1.05,11.71,0.53,55.3,'g',76.0,'whole item','whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING119','Lamb Breast (raw, fatty cut)',null,17.0,0.0,30.0,350.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING120','Lamb Loin Chops (well-trimmed, raw, bone-in weight)',null,19.0,0.0,8.0,150.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING121','Large Wholemeal Tortilla Wrap',null,8.57,42.86,5.71,257.1,'g',70.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING122','Lean Beef Brisket / Shin / Chuck (trimmed, raw)',null,25.0,0.0,6.0,155.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING123','Lean Beef Mince, 5% Fat (raw)',null,22.0,0.0,5.0,137.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING124','Lean Beef Steak (rump/sirloin, trimmed, raw)',null,26.0,0.0,4.0,143.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING125','Lean Chicken Breast Mince (raw)',null,24.0,0.0,1.6,111.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING126','Lean Lamb Leg / Shoulder (trimmed, raw)',null,20.0,0.0,8.0,156.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING127','Lean Lamb Mince, 10% Fat (raw)',null,20.0,0.0,12.0,196.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING128','Lean Turkey Mince, 5% Fat (raw)',null,20.0,0.0,5.0,120.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING129','Lemon (whole, for juice/zest)',null,1.03,9.31,0.34,29.3,'g',58.0,'whole item','whole',0.25,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING130','Lemon or Lime Juice (squeeze, ~5ml)',null,0.0,30.0,0.0,100.0,'ml',null,null,'whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,true,'Reads 100 kcal and 30g carbs per 100ml. Fresh lemon or lime juice is about 7-20 kcal and 6g carbs; 100 kcal is a cordial figure. Used in 37 recipes, worth about 5 kcal a serving.'),
('ING131','Lemongrass Stalk',null,0.1,1.0,0.0,5.0,'g',100.0,'whole item','whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING132','Light Coconut Milk',null,1.0,2.5,7.0,78.0,'ml',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING133','Light Mayonnaise',null,1.0,7.0,20.0,210.0,'g',null,null,'free',5.0,'Egg',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING134','Lime (whole, for juice/zest)',null,0.68,10.0,0.23,29.5,'g',44.0,'whole item','whole',0.25,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING135','Low-Calorie Cooking / Oil Spray',null,0.0,0.0,10.0,100.0,'g',null,null,'free',1.0,null,null,'Negligible per light spray used - not intended to be scaled as a meaningful macro contributor.','master',false,false,null),
('ING136','Low-Fat Crème Fraîche',null,3.5,4.6,15.0,165.0,'g',null,null,'free',5.0,'Milk',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING137','Mango Chutney',null,0.4,48.0,0.2,195.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING138','Mango, fresh (diced/pureed)',null,0.8,15.0,0.4,60.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING139','Mature Cheddar',null,25.0,0.1,35.0,416.0,'g',null,null,'free',5.0,'Milk',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING140','Medium Egg Noodles (dry weight)',null,12.0,72.0,2.6,355.0,'g',null,null,'free',5.0,'Gluten|Egg',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING141','Mirin',null,0.2,43.0,0.0,226.0,'ml',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING142','Mixed / Frozen Berries (blueberries, raspberries, strawberries mix)',null,1.0,10.0,0.4,48.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING143','Mixed Salad Leaves / Little Gem / Romaine / Lettuce',null,1.2,2.0,0.2,14.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING144','Mixed Seafood (prawns/squid/mussels mix, raw)',null,15.0,1.5,1.2,85.0,'g',null,null,'free',10.0,'Crustaceans|Molluscs',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING145','Mushrooms (incl. Chestnut/Portobello)',null,3.1,1.1,0.4,22.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING146','Mussels, cooked (meat only)',null,12.0,3.4,2.2,86.0,'g',null,null,'free',10.0,'Molluscs',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING147','Mustard Seeds',null,26.0,28.0,36.0,508.0,'g',null,null,'free',1.0,'Mustard',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING148','Nduja (spreadable spiced sausage)',null,14.0,1.0,44.0,450.0,'g',null,null,'free',5.0,'Sulphites',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING149','Onion / White Onion',null,1.1,8.0,0.1,40.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING150','Orange (whole, for juice/zest)',null,0.79,10.0,0.07,42.9,'g',140.0,'whole item','whole',0.5,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING151','Orzo Pasta (dry weight)',null,12.0,71.0,1.5,352.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING152','Oyster Sauce',null,1.4,11.0,0.3,51.0,'g',null,null,'free',2.0,'Soybeans|Molluscs',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING153','Pak Choi',null,1.5,1.2,0.2,13.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING154','Parmesan',null,38.0,0.9,29.0,431.0,'g',null,null,'free',5.0,'Milk',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING155','Passata / Chopped Tomatoes (tinned)',null,1.6,5.6,0.3,32.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING156','Pasta, dry weight (penne/fusilli/linguine/spaghetti/tagliatelle/macaroni/pappardelle)',null,12.0,71.0,1.5,352.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING157','Peach',null,0.93,8.67,0.2,38.7,'g',150.0,'whole item','whole',0.5,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING158','Pecan Nuts',null,9.0,14.0,72.0,691.0,'g',null,null,'free',5.0,'Nuts',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING159','Peri-Peri / Jerk Marinade or Seasoning',null,4.0,15.0,3.0,120.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING160','Pine Nuts',null,14.0,13.0,68.0,673.0,'g',null,null,'free',5.0,'Nuts',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING161','Pineapple, fresh or tinned (in juice, drained)',null,0.5,12.5,0.1,50.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING162','Pitta Bread (white or wholemeal)',null,8.77,50.77,1.54,253.8,'g',65.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING163','Pitted Dates',null,2.5,68.0,0.4,282.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING164','Plain Flour / Self-Raising Flour',null,9.4,76.0,1.3,341.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING165','Pomegranate Seeds',null,1.7,19.0,1.2,83.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING166','Pork Fillet / Tenderloin (raw)',null,22.0,0.0,2.3,108.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING167','Potato (white, incl. new/baby potatoes)',null,2.0,17.0,0.1,77.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING168','Pumpkin Seeds (toasted)',null,30.0,15.0,46.0,559.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING169','Raisins',null,3.1,79.0,0.5,299.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING170','Rapeseed Oil',null,0.0,0.0,92.0,828.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING171','Red / Green / Yellow Pepper',null,1.0,4.7,0.4,26.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING172','Red Chilli / Chilli Pepper',null,2.0,8.67,0.67,40.0,'g',15.0,'whole item','whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING173','Red Onion',null,1.1,8.0,0.1,40.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING174','Red or White Wine (for cooking)',null,0.1,2.6,0.0,82.0,'ml',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING175','Reduced-Fat Cheddar',null,32.0,0.1,15.0,261.0,'g',null,null,'free',5.0,'Milk',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING176','Reduced-Fat Mozzarella (incl. "Light Mozzarella")',null,24.0,2.0,17.0,254.0,'g',null,null,'free',5.0,'Milk',null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING177','Rice Vinegar / Rice Wine Vinegar / White Wine Vinegar / White Vinegar',null,0.0,2.0,0.0,20.0,'ml',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING178','Roasted Peanuts (crushed/ground)',null,26.0,16.0,50.0,602.0,'g',null,null,'free',5.0,'Peanuts',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING179','Rocket Leaves',null,2.6,2.1,0.7,25.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING180','Saffron Strands (pinch)',null,0.0,0.0,0.0,0.0,'g',null,null,'free',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING181','Sake',null,0.5,5.0,0.0,134.0,'ml',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING182','Salmon Fillet (raw)',null,20.0,0.0,13.0,200.0,'g',null,null,'free',10.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING183','Salt Fish (dried salted cod, soaked/rehydrated)',null,20.0,0.0,0.7,90.0,'g',null,null,'free',10.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING184','Salt, Black Pepper & General Seasoning (to taste)',null,0.0,0.0,0.0,0.0,'g',null,null,'free',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING185','Scotch Bonnet Chilli',null,2.0,9.0,0.5,40.0,'g',10.0,'whole item','whole',0.25,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING186','Sea Bass Fillet (raw)',null,20.0,0.0,4.0,124.0,'g',null,null,'free',10.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING187','Sesame Oil',null,0.0,0.0,100.0,884.0,'g',null,null,'free',2.0,'Sesame',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING188','Sesame Seeds (incl. black sesame)',null,18.0,12.0,50.0,573.0,'g',null,null,'free',2.0,'Sesame',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING189','Shallot',null,2.5,17.0,0.1,72.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING190','Silken Tofu',null,5.0,1.0,2.4,55.0,'g',null,null,'free',10.0,'Soybeans',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING191','Skimmed Milk',null,3.4,4.8,0.1,34.0,'ml',null,null,'free',10.0,'Milk',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING192','Soy Sauce (Light / Reduced-Salt)',null,8.0,6.0,0.1,60.0,'ml',null,null,'free',2.0,'Gluten|Soybeans',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING193','Spinach, fresh or frozen (thawed weight)',null,2.9,1.6,0.4,23.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING194','Spring Onion (each)',null,2.0,4.0,0.33,33.3,'g',15.0,'whole item','whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING195','Sriracha / Buffalo Hot Sauce',null,1.9,19.0,0.9,93.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING196','Steamed Bao Bun',null,7.5,50.0,2.5,250.0,'g',40.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING197','Stock (Chicken / Beef / Fish / Vegetable, low salt)',null,0.8,0.5,0.2,8.0,'ml',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING198','Stock Cube (chicken/beef/vegetable)',null,5.0,10.0,3.0,120.0,'g',10.0,'whole item','whole',1.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING199','Strawberries',null,0.8,7.7,0.2,33.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING200','Sweet Chilli Sauce (incl. Reduced-Sugar)',null,0.6,40.0,0.2,165.0,'g',null,null,'free',2.0,null,null,'Generic placeholder value - this is a branded/processed product where exact macros depend on the specific product. Swap in the real label values for the product you use.','master',false,false,null),
('ING201','Sweet Potato',null,1.6,20.0,0.1,86.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING202','Sweetcorn Kernels',null,3.2,19.0,1.2,86.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING203','Tahini',null,17.0,11.0,54.0,595.0,'g',null,null,'free',5.0,'Sesame',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING204','Thai Curry Paste (Green/Red/Yellow/Massaman)',null,2.5,12.0,3.5,90.0,'g',null,null,'free',2.0,'Crustaceans|Fish',null,'Standard reference value for a typical Thai curry paste - some brands add shrimp paste (crustacean/fish traces), check the specific product''s allergen label.','master',false,false,null),
('ING205','Tomato (standard / beef tomato)',null,0.9,3.9,0.2,18.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING206','Tomato Purée / Tomato Ketchup',null,3.5,19.0,0.3,82.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING207','Tomato Relish',null,1.0,25.0,0.2,105.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING208','Tuna Steak, fresh (raw)',null,28.0,0.0,1.0,132.0,'g',null,null,'free',10.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING209','Tuna, tinned in spring water (drained)',null,26.0,0.0,1.0,116.0,'g',null,null,'free',10.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING210','Udon Noodles (dry weight)',null,9.0,74.0,1.0,348.0,'g',null,null,'free',5.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING211','Unsweetened Almond Milk',null,0.5,0.3,1.1,13.0,'ml',null,null,'free',10.0,'Nuts',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING212','Unsweetened Coconut Flakes / Shredded Coconut',null,7.0,6.0,65.0,660.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING213','Vegetable Oil',null,0.0,0.0,91.6,824.0,'g',null,null,'free',2.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING214','Vine Tomato / Portobello Mushroom / Asparagus (grilled side veg)',null,1.5,3.0,0.3,25.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING215','Walnuts',null,15.0,14.0,65.0,654.0,'g',null,null,'free',5.0,'Nuts',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING216','White / Red Cabbage',null,1.3,5.8,0.1,25.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING217','White Bread (slice)',null,8.89,47.22,2.78,250.0,'g',36.0,'slice','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING218','White Crab Meat',null,18.0,0.0,0.9,87.0,'g',null,null,'free',10.0,'Crustaceans',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING219','White Fish Fillet (e.g. Cod, Hake, Monkfish, Sea Bass) (raw)',null,18.0,0.0,0.8,82.0,'g',null,null,'free',10.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING220','White Miso Paste',null,12.0,26.0,6.0,199.0,'g',null,null,'free',2.0,'Soybeans',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING221','Wholemeal / Wholegrain Bread (slice)',null,10.0,40.0,2.75,235.0,'g',40.0,'slice','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING222','Wholemeal Flatbread',null,9.33,45.33,3.33,253.3,'g',75.0,'whole item','whole',1.0,'Gluten',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING223','Wonton Wrapper',null,10.0,60.0,2.5,300.0,'g',4.0,'whole item','whole',1.0,'Gluten|Egg',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING224','Worcestershire Sauce',null,0.0,19.5,0.0,78.0,'ml',null,null,'free',2.0,'Fish',null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING225','Yam',null,1.5,28.0,0.2,118.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value for the generic food (not brand-specific).','master',false,false,null),
('ING226','Quinoa (dry weight)',null,14.1,64.2,6.1,368.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING227','Butternut Squash',null,1.0,11.7,0.1,45.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING228','Dried Apricots',null,4.0,62.6,0.5,241.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING229','Mixed Nuts, chopped',null,20.0,13.0,54.0,607.0,'g',null,null,'free',5.0,'Nuts',null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING230','Haddock Fillet (raw)',null,18.0,0.0,0.6,81.0,'g',null,null,'free',10.0,'Fish',null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING231','Mackerel Fillet (fresh or smoked)',null,18.6,0.0,17.8,262.0,'g',null,null,'free',10.0,'Fish',null,'Standard reference value, mid-point between fresh and smoked mackerel - flag for Graeme if a specific product should be used instead.','master',false,false,null),
('ING232','Goji Berries (dried)',null,14.0,77.0,0.4,349.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING233','Weetabix Protein biscuit (each, ~19g)',null,24.74,52.63,8.95,415.8,'g',19.0,'whole item','whole',1.0,null,null,'Generic placeholder - brand/product not yet confirmed. Standard reference value.','master',false,false,null),
('ING234','High Protein Pancake, M&S (each, ~35g)',null,20.0,28.57,5.71,242.9,'g',35.0,'whole item','whole',1.0,'Gluten|Egg|Milk',null,'Generic placeholder for M&S High Protein Pancakes - exact label values not yet confirmed. Standard reference value.','master',false,false,null),
('ING235','Kimchi',null,1.5,4.0,0.5,23.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING236','Brown Rice (dry weight)',null,7.5,76.2,2.7,362.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING237','Cottage Cheese, reduced fat',null,12.0,3.5,1.4,78.0,'g',null,null,'free',5.0,'Milk',null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING238','Rhubarb',null,0.9,4.5,0.2,21.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING239','Pear',null,0.4,13.9,0.1,57.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING240','Light Cream (15% fat)',null,2.9,4.4,16.0,185.0,'ml',null,null,'free',5.0,'Milk',null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING241','Rice Noodles (dry weight)',null,6.6,79.0,0.6,360.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING242','Rice Cake, lightly salted (each, ~9g)',null,7.78,85.56,3.33,388.9,'g',9.0,'whole item','whole',1.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING243','Guacamole',null,2.0,6.0,14.0,150.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING244','Teriyaki Sauce',null,5.5,15.0,0.6,89.0,'ml',null,null,'free',2.0,'Gluten|Soybeans',null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING245','Beetroot, raw or roasted',null,1.6,10.0,0.2,43.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING246','Apple Juice',null,0.1,11.3,0.1,46.0,'ml',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11).','master',false,false,null),
('ING247','Prosciutto / Cured Ham (thin slices)',null,28.0,0.0,17.0,271.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null),
('ING248','Bacon Rashers (cooked)',null,33.0,1.0,40.0,500.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,true,'Reads 500 kcal. Grilled back bacon is about 287; 500 is closer to streaky fried in its own fat.'),
('ING249','Ham (cooked slices)',null,21.0,1.5,5.0,145.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null),
('ING250','Stevia / Granulated Sweetener (near-zero calorie)',null,0.0,5.0,0.0,20.0,'g',null,null,'free',5.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null),
('ING251','Apple Sauce, unsweetened',null,0.2,10.0,0.1,40.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null),
('ING252','Turkey Breast, skinless (raw, sliced)',null,24.0,0.0,1.0,104.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null),
('ING253','''Cherry Active'' Montmorency Cherry Concentrate (each sachet, ~30ml)',null,0.3,16.0,0.0,65.0,'ml',100.0,'whole item','whole',1.0,null,null,'Generic placeholder for ''Cherry Active'' branded sachet - exact label values not yet confirmed. Standard reference value.','master',false,false,null),
('ING254','Broad Beans',null,6.5,8.5,0.6,72.0,'g',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null),
('ING255','Seeded Bread (slice)',null,12.5,37.5,7.5,250.0,'g',40.0,'slice','whole',1.0,'Gluten|Sesame',null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null),
('ING256','Patak''s Korma Curry Paste',null,2.5,8.0,18.0,200.0,'g',null,null,'free',5.0,null,null,'Standard reference value for a jarred korma paste - close to Patak''s own published figures but not label-confirmed.','master',false,false,null),
('ING257','Orange Juice',null,0.7,10.4,0.1,45.0,'ml',null,null,'free',10.0,null,null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null),
('ING258','Full-Fat Milk (whole milk)',null,3.2,4.6,3.6,65.0,'ml',null,null,'free',10.0,'Milk',null,'Standard reference nutrition value (new ingredient, added 2026-09-11 second batch).','master',false,false,null)
on conflict (name_key) do nothing;

-- ---------- recipes ----------
insert into recipes (ext_id,name,slot,servings,method,notes,published_kcal,source,needs_review,review_note) values
('R001','Red Berry & Yoghurt Smoothie','smoothie',1,'1. Add all ingredients into a blender & blitz',null,300.0,'master',false,null),
('R002','Green Boost Smoothie','smoothie',1,'1. Add all ingredients into a blender & blitz',null,354.0,'master',false,null),
('R003','Kiwi & Strawberry Smoothie','smoothie',1,'1. Add all ingredients into a blender & blitz',null,302.0,'master',false,null),
('R004','Banana & Chocolate Energy Smoothie','smoothie',1,'1. Roughly chop banana
2. Add all ingredients into a blender & blitz',null,497.0,'master',false,null),
('R005','Fuelling Strawberry & Banana Oat Smoothie','smoothie',1,'1. Roughly chop banana
2. Add all ingredients into a blender & blitz',null,500.0,'master',false,null),
('R006','Banana & Nut Butter Smoothie','smoothie',1,'1. Roughly chop banana
2. Add all ingredients into a blender & blitz',null,595.0,'master',false,null),
('R007','Casein Bowl','snack',1,'1. Add the protein, milk and frozen berries into a blender and blend on low for 10-15 seconds.
2. Stop and scrape the mixture stuck to the sides of the blender before whizzing on high for 5-10 seconds or until the mixture reaches a soft consistency
3. Scoop into a bowl and top with the fresh berries to serve!',null,233.0,'master',false,null),
('R008','Chocolate Whey Protein Recovery Bowl','snack',1,'Prepare the Base
1. Add almond milk, Greek yoghurt and ice cubes to a blender.
2. Add the chocolate whey protein powder, cocoa powder, almond butter & vanilla extract.
3. Blend until smooth and creamy.
4. If too thick, add a splash more almond milk; if too thin, add a few more ice cubes or extra Greek yoghurt.
5. Pour into a bowl. The consistency should be thicker than a smoothie but thin enough to eat with a spoon. Add the Toppings
1. Arrange sliced banana along one side of the bowl.
2. Sprinkle coconut flakes and cacao nibs over the bowl.
3. Sprinkle chia seeds & ½ Crushed Digestive over the top',null,567.0,'master',false,null),
('R009','Mixed Berry Whey Protein Recovery Bowl','snack',1,'Prepare the Base
1. Add almond milk, Greek yoghurt and ice cubes to a blender.
2. Add the whey protein powder, cocoa powder, almond butter & vanilla extract.
3. Blend until smooth and creamy.
4.If too thick, add a splash more almond milk; if too thin, add a few more ice cubes or extra Greek yoghurt.
5. Pour into a bowl. The consistency should be thicker than a smoothie but thin enough to eat with a spoon. Add the Toppings
1. Arrange berries along one side of the bowl.
2. Sprinkle coconut flakes and cacao nibs over the bowl.
3. Sprinkle chia seeds & ½ Crushed Digestive',null,567.0,'master',false,null),
('R010','High Protein Energy Balls','snack',20,'1. In a Large mixing bowl, combine the oats, protein powder, chia seeds, and cocoa powder. Mix well.
2. Add peanut butter, honey, yoghurt, vanilla extract. Mix thoroughly. If mixture is too dry, add more yoghurt. Fold in chocolate chips to finish mixture.
3. Form protein balls (Around tablespoon size)
4. Place balls on a lined baking tray and refrigerate for 30-60 mins.
5. Can be stored for up to 7-days in an air tight container','Values are PER PROTEIN BALL (recipe makes 20), not the whole batch',105.0,'master',false,null),
('R011','Chocolate Chip Protein Blondies','snack',10,'1. Preheat oven to 180 degrees
2.Add your Ingredients into a Large Mixing Bowl and fold together
3. Stir in your chocolate chips and add the mixture to a lined baking tin (or bun cases) and bake for 20-30mins, cut into 10 squares.','Values are PER BLONDIE (recipe makes 10), not the whole batch',165.0,'master',false,null),
('R012','Satay Chicken Skewers','snack',1,'1. Prepare dressing in a separate mixing bowl by combining nut butter & greek yoghurt.
2. Cube large chicken breast and grill/fry until cooked
3. Add cooked chicken to skewers and add dressing
4. Top with finely sliced spring onions and seasoning',null,366.0,'master',false,null),
('R013','Almond Butter bars','snack',16,'1. Pour boiling water over dates and soak for 10 mins
2. Add dates to blender with 6 Tbsps of the water they were soaking in and the almond butter.
3. Blend until a caramel sauce is formed.
4. Add the oats to the mixture and blend until combined.
5. Spread mixture into a lined baking tray.
6. Melt the chocolate and drizzle over.
7. Chill in fridge for 30mins then chop into 16 bars.','Values are PER SLICE (recipe makes 16), not the whole batch',232.0,'master',false,null),
('R014','Summer Fruits Greek Yoghurt Bowl','snack',1,'1. Wash and slice the fruit.
2. Spoon the Greek yoghurt into a serving bowl. Stir in honey if you prefer a sweeter taste.
3. Arrange the fruit on top of the yoghurt.
4. Sprinkle the chopped walnuts, seeds, and shredded coconut on top.',null,366.0,'master',false,null),
('R015','Tropical Fruit Greek Yoghurt Bowl','snack',1,'1. Dice the mango and pineapple into small, bite-sized pieces.
2. Slice the kiwi into thin rounds or half-moons.
3. In a serving bowl, add the Greek yoghurt as the base. If you like it sweeter, stir in the honey.
4.Arrange the diced mango, pineapple, and kiwi on top of the yoghurt.
5. Sprinkle the shredded coconut, chia seeds, and sliced almonds on top.',null,393.0,'master',false,null),
('R016','Strawberry, Kiwi & Pecan Greek Yoghurt Bowl','snack',1,'1. Dice the kiwi and half the strawberries
2. Slightly Chop the pecan nuts
3. In a serving bowl, add the Greek yoghurt as the base. If you like it sweeter, stir in the honey.
4. Arrange the fruits on top of the yoghurt.
5. Sprinkle the pecans and chia seeds over the fruit.',null,497.0,'master',false,null),
('R017','Peach & Blueberry Greek Yoghurt Bowl','snack',1,'1. Prepare the Peach and Blueberries
2. In a serving bowl, add the Greek yoghurt as the base. If you like it sweeter, stir in the honey.
3. Arrange the fruits on top of the yoghurt.
4. Sprinkle the cacao bibs, granola and chia seeds over the fruit.
5. If you want a little something extra, melt over some almond butter.',null,422.0,'master',false,null),
('R018','Fuelling Cinnamon & Oat Banana Bread','snack',5,'1. Place oats into a large mixing bowl
2.Blend the remaining ingredients and pour over the oats and mix thoroughly
3.Pour mixture into a lined bread tin and place in oven at 180* for 30-35 mins.
4. Remove from oven, let cool and slice into 10 slices.','Values are PER 2 SLICES (recipe makes 5), not the whole batch',369.0,'master',true,'The book had a second copy of this recipe (R199), written in tablespoons rather than grams. Not imported.'),
('R019','Banana, Blueberry & Oat Muffins','snack',4,'1. Preheat oven to 180°
2.In a blender, mix the eggs, coconut oil, banana & Honey until smooth.
3. Add the mixture to a large bowl and mix to form a wet dough. Add in the blueberries (coated with a dusting of flour to stop them falling the the bottom)
4. Transfer the mix and evenly distribute to muffin cases
5. Bake in the oven for 25-30 mins','Values are PER MUFFIN (recipe makes 4), not the whole batch',350.0,'master',false,null),
('R020','Greek Yoghurt & Granola Fuel Bowl','snack',1,'1. Place the Greek yoghurt in a serving bowl.
2. Drizzle half of the honey (7-8g) over the yoghurt and fold in.
3.Sprinkle half of the chia seeds into the yoghurt mixture and stir. Add the Toppings
1. Scatter the granola around the edge of the bowl.
2. Arrange the sliced strawberries.
3. Sprinkle the chopped walnuts and cacao nibs evenly over the surface.
4. Drizzle the remaining honey over the entire bowl.
5. Finish by sprinkling the remaining chia seeds on top with a pinch of cinnamon if desired.',null,580.0,'master',false,null),
('R021','Smoked Salmon, Scrambled Eggs & Smashed Avocado on Sourdough','snack',1,'1. Crack the eggs into a bowl along with the milk and whisk with a fork. Add olive oil to a pan over medium heat.
2. Whilst you wait for the pan to heat, pop the sourdough bread into the toaster
3. Pour the egg mixture into the pan and stir using a spatula, ensuring the egg doesn’t stick.
4. The eggs will be ready when they seem nearly cooked throughout
5.Cut your avocado in half, removing the stone and spoon out the avocado flesh and cut into slices
6. Assemble the avocado, egg and salmon on top of the toasted sourdough bread',null,467.0,'master',false,null),
('R022','Mixed Berry & Banana Porridge','snack',1,'1. Add the oats and milk to a saucepan on low heat and continuously stir.
2. Once thickened to your liking, remove from the saucepan and add to a bowl.
3. Top with your berries, banana, yogurt and peanut butter.
If you are using frozen berries: Add the frozen mixed berries, chopped banana and 150ml water to a saucepan over high heat and stir. After 2-3mins, add in the oats along with 50ml semi skimmed milk. Cook on low heat for a further 5-6mins until thickened to your liking. Transfer to a bowl and top with banana, yogurt and peanut butter.',null,664.0,'master',false,null),
('R023','Egg, Avocado & Tomato Breakfast Pitta','snack',1,'1. Add the oil to a pan and begin to heat. Whilst the oil is warming, whisk the eggs in a small bowl and season.
2. Scramble the eggs over a medium heat for 2-3 minutes.
3. Once cooked remove from the heat. Whilst scrambling the eggs, place the pitta in the toaster until warm .
4. Cut the warm pitta in half creating two pockets. Fill them with the scrambled egg, avocado and tomatoes, top with sriracha sauce and enjoy!',null,651.0,'master',false,null),
('R024','Lotus Biscoff & Banana Porridge','snack',1,'1. Add the oats and milk to a saucepan on low heat and continuously stir.
2. Once thickened to your liking, remove from the saucepan and add to a bowl.
3. Top with banana, yoghurt and Biscoff spread and enjoy!',null,664.0,'master',false,null),
('R025','Fuelling Banana & Blueberry Overnight Oats','snack',1,'1. Place the milk, yoghurt, honey and half the banana into a blender and blitz until smooth
2. Place the oats in a bowl, pour over the smoothie before combining
3. Add the blueberries and the other half of the banana (Chopped) and place in the fridge overnight.
4. Enjoy the next day!',null,597.0,'master',false,null),
('R026','Blueberry & Honey Granola Pot','snack',1,'1. Roughly Mix all the ingredients together and enjoy!
2. Add Layers of extra yoghurt/fruit if required',null,708.0,'master',false,null),
('R027','Vanilla & Red Berry Recovery Pancakes','snack',1,'1. Blend the eggs, banana & whey until the mixture is smooth.
2. Heat the coconut oil in a frying pan over a medium heat.
3. Pour the mixture into the pan to form several small pancakes
4. Cook each batch for 60-90 seconds
5. Plate and serve with your berries and drizzle with honey',null,802.0,'master',true,'DUPLICATE INGREDIENT: ''1 Large Banana'' + ''1 Small Banana'' listed as two separate lines - normalize to a single combined line (e.g. ''2 medium bananas'') per Graeme''s convention. Also flagged below for macro mismatch (ingredient sum ~43% higher than Published Kcal) - worth checking whether this duplica'),
('R028','Athlete’s French Toast','snack',1,'1. Add the milk, egg, cinnamon, one teaspoon of honey and protein powder to a bowl and whisk together using a fork.
2.Heat the oil in a pan over a medium to high heat. Once hot, dip your bread in the whisked mixture, coating well, before transferring to the hot pan.
3. Pan fry for 2-3 minutes each side, or until the fried bread looks golden on both sides.
4. Remove from the pan and plate up. Top with greek yoghurt, fresh berries and the remaining honey and enjoy!',null,539.0,'master',false,null),
('R029','Smoky Chicken Salad','lunchdinner',1,'1. Heat a pan to high heat with minimal oil and add the chicken (thinly sliced).
2. While cooking, prepare the dressing by combining yoghurt, mustard, oil, lime & paprika in a separate bowl
3. Add Mixed Green Leaves & Rocket in a large bowl.
4. Add in cherry tomato and finely slice peppers and onions.
5. Mix all ingredients together. Once chicken is cooked, lay through the salad bowl and crumple feta cubes.
6. Pour over dressing and enjoy!',null,484.0,'master',false,null),
('R030','Chicken & Berry Recovery Bowl','lunchdinner',1,'1. Add the chicken, sweet potato, spinach, berries and nuts to a large mixing bowl.
2. To make the dressing, add the cranberry juice, oil, balsamic, orange zest, dijon and salt and pepper to a small jar before adding the lid and shaking thoroughly. If you don''t have a jar then just add to a cup and mix well with a fork.
3. Pour the dressing over the salad and mix everything together thoroughly in the large bowl before plating up to eat!',null,637.0,'master',false,null),
('R031','Creamy Mustard Pork & Roasted Potatoes','lunchdinner',2,'1. Roughly chop the potatoes and place in a pre-heated oven.
2. Place a large non-stick frying pan on a high heat. Slice the pork into 6 medallions, bashing to flatten slightly, and roughly slice the mushrooms.
3. Place these in the pan with 1 tablespoon of olive oil and cook for 2 minutes on each side, or until the mushrooms are golden and the pork is cooked through, then remove just the mushrooms to a plate.
4.Add to the pan the mustard and crème fraîche and cook for 1 minute, loosening with a splash of water, if needed, taste and season with salt and black pepper.
5. Once the potatoes are cooked assemble the meal with the remaining sauce from the pan and rocket served on top',null,660.0,'master',true,'MACRO MISMATCH: ingredient list computes 56% LOWER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R033','Chicken & Cashew Nut Stir Fry with Basmati Rice','lunchdinner',4,'1. Combine soy sauce, ginger, garlic, chilli flakes and honey into a marinade; coat chicken with marinade and refrigerate for 15 minutes.
2. Bring rice and water to a boil in a saucepan.
3. Heat 1 tsp coconut oil in a pan. Cook and stir bell pepper, broccoli, and onion until just tender. Remove vegetables from pan.
4. Remove chicken from marinade, reserving liquid. Heat remaining coconut oil in the pan over a medium-high heat. Cook and stir chicken until almost cooked.
5. Return vegetables and left-over marinade to pan. Bring to a boil; cook and stir until chicken is cooked and vegetables are tender.
6. Serve and enjoy!',null,563.0,'master',false,null),
('R034','Jamaican Jerk Chicken & Rice','lunchdinner',1,'1. Blend all marinade ingredients until smooth.
2. Poke holes in chicken breast.
3. Put chicken into a large bowl. Pour marinade onto chicken and cover completely.
4. Marinade chicken in the fridge for at least 2 hours.
5. Place marinated chicken in preheated oven @ 200 C for 25-minutes and ensure cooked through.
6. When the chicken is near cooked, prepare your rice with a serving size as per your requirements
7. Add cubed Pineapple to finish',null,592.0,'master',true,'MACRO MISMATCH: ingredient list computes 94% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R035','Lemon Salmon & Sweet Potato Cubes','lunchdinner',1,'1. Wash and prep the vegetables accordingly. Cut the ends off the asparagus, carrot and courgette into chunks and cut the cherry tomatoes into halves.
2. Bake Sweet Potato Chunks for 35-45 mins
3. Steam the vegetables on a low to medium heat for 10 minutes.
4. Mix olive oil, chilli flakes, lemon juice and black pepper in a bowl.
5. Pour the mixture over the salmon
6. Place the salmon fillet skin side down on a cold non- stick pan and bring the pan to medium heat and cook for 5- 7 mins. Flip the salmon to the other side for a remaining 5- 7mins until cooked throughout.
7. Serve with the sweet potatoes and vegetables.',null,637.0,'master',false,null),
('R036','Sirloin Steak, Roasted Potatoes & Tenderstem Broccoli','lunchdinner',1,'1. Prepare the potatoes and place in a pre-heated oven at 180°C for 30-35 mins (Adjust for taste).
2. Bring a Saucepan to the boil and add tenderstem broccoli
3. When Potatoes are nearing completion, prepare steak and cook on a high-heat (adjust for personal taste).
4. Season Potatoes with Fresh Rosemary
5. Season Broccoli with Chilli Flakes and Salt
6. Serve together and add any optional extras as required',null,784.0,'master',true,'MACRO MISMATCH: ingredient list computes 54% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R037','Tunisian Prawn Spaghetti','lunchdinner',1,'1. Boil spaghetti according to packet instructions.
2.Toss prawns with the harissa and leave to marinate for 5- 10 minutes.
3. Place prawns in a large frying pan on medium heat with 1 tbsp olive oil and fry until golden, stir regularly then remove from the pan.
4. Chop and reserve the top of the leafy half of the parsley, then finely slice the stalks and add them to the pan with salt & black pepper.
5. Fry for 1 min, add prawns back in and cook for 1 min.
6. Add pasta into pan, squeeze 1/2 lemon juice over the mixture, add parsley leaves & toss together.
7. To serve, cut the remaining lemon half into wedges and squeeze over.',null,381.0,'master',false,null),
('R038','Thai Red Chicken Curry','lunchdinner',1,'1. Slice chicken breast into strips & pat dry
2. Season lightly with salt and pepper
3. Heat a large wok or deep skillet over medium-high heat
4. Add 10ml of coconut milk
5. Fry Thai red curry paste for 2-3 minutes
6.Gradually add remaining coconut milk, stirring constantly
7. Add chicken to the wok
8. Cook for 5-6 minutes, stirring occasionally
9. Add bell peppers, green beans, and bamboo shoots
10. Simmer for additional 3-4 minutes
11. Stir in brown sugar and ginger
12. Add fresh lime juice
13. Garnish with Thai basil, green onions, and top with sliced red chilli
14. Prepare rice per packet instructions and serve together!',null,763.0,'master',false,null),
('R039','Chicken Quesadillas with Tomato & Avocado Salsa','lunchdinner',2,'1. Heat olive oil & add 1/4 of the chopped onion and cook
2.Grate lime peel & squeeze the juice into a bowl (save a bit of the lime juice for the salsa!), add salt and pepper – put the chopped chicken into this mixture stirring to coat it evenly
3. Add chicken and lime mixture to the onions in the pan
4. Evenly divide the chicken and cheese (grated) to the 2 tortillas – folding to make them into semi circles
5. Cook the quesadillas in two batches until both sides are browned and heated through
6. To make the Avocado salsa chop the avocado flesh and combine half of this with the left over of onion, halved cherry tomatoes, one garlic clove – blitz until smooth then add the remaining avocado roughly chopped.
7. Serve the quesadilla with the salsa on the side!',null,491.0,'master',false,null),
('R040','Lamb Kofta Curry & Basmati Rice','lunchdinner',4,'1.Finely chop the red onion and mince the garlic and set aside.
2. Season the lamb mince with black pepper and chilli flakes. Using your hands, roll into evenly shaped balls and set aside.
3. Cook the rice to packet instructions.
4. Using a large non-stick pan on a low/ medium heat, add the olive oil, add the onion and garlic and fry for 2-3 mins.
5. Add the lamb balls and fry on medium heat for another 10mins, turning occasionally to seal the balls. Season with cumin, paprika, fresh coriander and parsley.
6. Pour in the tinned tomatoes and cook for another 15-20 mins until the sauce has reduced.
7. Serve with the cooked rice and finely sliced red chilli to garnish.',null,508.0,'master',false,null),
('R041','Salmon & Mediterranean Tabbouleh with Yoghurt Dressing','lunchdinner',1,'Tabbouleh & Salmon
1. Pour boiling water over bulgur wheat, cover and stand for 20 mins.
2. Fluff with fork & cool to room temperature
3. Preheat oven to 200°C. Brush salmon with olive oil, season with oregano, lemon zest, salt & pepper
4. Bake for 20-25 mins until cooked through
5. Mix cooled bulgur wheat with chopped parsley, mint & add cucumber, tomatoes, and red onion - gently tossing to combine
Greek Yoghurt Dressing
1. Mix Greek yoghurt with lemon juice, olive oil, dill, garlic & season with salt and pepper
To Serve
1. Spread Tabbouleh on plate
2. Place baked salmon on top
3.Drizzle with Greek yogurt dressing and sprinkle pomegranate seeds over the top',null,725.0,'master',false,null),
('R042','Honey & Oat Chicken Goujons with Sweet Potato Fries','lunchdinner',1,'1. Preheat the oven to 180°C.
2.Crack the egg into a shallow bowl and mix in the milk. Quickly blend the oats and spices together and place in a separate shallow bowl.
3.Dip the chicken in the egg and milk mix before transferring to the oat and spice mix, rolling the chicken and coating.
4. Place the goujons on a lined baked tray and lightly drizzle with olive oil and honey.
5. Slice the sweet potato into fries, lightly sprinkling with your spice before placing alongside the goujons on the tray.
6. Oven cook the goujons and sweet potato for approximately 25-30 minutes or until they are done. Check the chicken is cooked throughout.
7. While the chicken is cooking slice up some cherry tomatoes and toss through the lettuce before drizzling over with balsamic vinegar.
8.Serve the goujons and sweet potato on a bed of the balsamic salad.',null,639.0,'master',false,null),
('R043','Salmon with Blueberry Cous Cous','lunchdinner',1,'1. 1. Cover the cous cous with cold water & leave to the side for 10-15 mins or until the cous cous has absorbed all the water & is soft to touch & crumbles between your fingers. You can use boiling water if you''re in a rush and the cous cous should be ready in 3-4 minutes.
2. Season the salmon with salt and pepper before squeezing the lime over it & rubbing it in.
3. Drizzle the salmon with the oil.
4. Place this on a tray and oven bake at 180C for approximately 8-10 minutes or until cooked (it can be pan fried also if this is easier for you!).
5. Toss the rocket, berries and mint through the prepared cous cous & plate up.
6. Serve the cooked salmon on top of the bed of cous cous & drizzle with balsamic glaze before serving!',null,556.0,'master',false,null),
('R044','Zesty Chicken Kebabs & Baked Sweet Potato Wedges','lunchdinner',2,'1. Roughly Chop the Sweet Potato and Bake for 30 min @ ~200°C
2. Chop the chicken breasts into even pieces and place into a large bowl. Add the spices, herbs and lime juice and zest to the bowl and mix well. Cover the bowl and leave to marinade in the fridge for 1 hour. While this is happening now is a good time to cook your potatoes according to packet instructions.
3. After marinading, remove the chicken from the fridge and place pieces of chicken onto a kebab stick. Heat a griddle pan over a high heat and place the kebabs onto the pan.
4. Cook the kebabs until golden all over, then finish off by by placing into an oven at 180 C/Gas mark 4 for 5 to 6 minutes to cook through.
5. Once the chicken is cooked through, serve hot alongside the potatoes and side salad (mixed leaves, cucumber and tomatoes).',null,542.0,'master',false,null),
('R045','Simple Sticky Korean Beef Stir Fry & Basmati Rice','lunchdinner',4,'1. In a bowl, mix soy sauce, sesame oil, rice vinegar, garlic, ginger, honey, chilli paste, and cornflour.
2. Add the beef strips to the marinade, ensuring each piece is coated. Cover and refrigerate for at least 30 minutes Cook the Beef & Rice:
1. Heat a large non-stick skillet or wok over medium-high heat. Add the marinated beef strips in a single layer, cooking for about 2-3 minutes on each side until browned and slightly sticky. Remove the beef and set aside.
2. Cook the rice to the packet instructions Stir-Fry the Vegetables:
1. In the same skillet, add the olive oil. Once hot, add the onion, red bell pepper and broccoli. Stir-fry for 4-5 minutes until the vegetables are tender but crisp. Combine and Serve:
1.Return the beef to the skillet with the vegetables. Stir everything together for 1-2 minutes to allow the flavours to combine.
2. Serve over the cooked rice. Garnish with sesame seeds, spring onions, and sliced chilies.',null,552.0,'master',false,null),
('R046','Chicken & Chickpea Curry (family)','lunchdinner',4,'1. Dice the chicken and sweet potato. Chop the onion and garlic, and grate the ginger.
2. Cook the onion for 5 minutes until soft, then add the garlic, ginger, curry powder and cinnamon.
3. Add the chicken and cook for 5–6 minutes until lightly browned.
4. Add the sweet potato, chickpeas, coconut milk and 200ml chicken stock.
5. Simmer for 20–25 minutes until the chicken is cooked and the sweet potato is soft.
6. Stir in the ground almonds and green beans, then cook for a further 3–5 minutes.
7. Meanwhile, cook the basmati rice according to the packet instructions.
8. Serve the curry with the rice and enjoy!',null,718.0,'master',true,'Renamed: the book had two different dishes called "Chicken & Chickpea Curry". This is the four-serving one with sweet potato.'),
('R047','Chicken & Tomato Tagliatelle','lunchdinner',1,'1. Cook the tagliatelle according to the packet instructions. Reserve a small amount of the pasta water before draining.
2.Season the chicken with mixed herbs and pepper. Heat a little of the olive oil in a pan and cook the chicken until browned and cooked through. Remove and set aside.
3.Add the remaining olive oil to the pan with the chopped onion and garlic. Cook for 3–4 minutes until softened.
4. Add the chopped tomatoes, tomato purée and white wine vinegar. Cook for another 3–4 minutes, adding a splash of pasta water to loosen the sauce.
5. Add the cooked tagliatelle and toss through the tomato sauce.
6. Season and serve with the cooked chicken.',null,696.0,'master',false,null),
('R049','Mango Chicken Pasta','lunchdinner',2,'1. Cook the tagliatelle according to the packet instructions, then drain and set aside.
2. Heat the olive oil in a non-stick pan. Add the onion, garlic and chicken and cook for 4–5 minutes.
3. Add the mushrooms, pepper, chilli powder, oregano and basil. Cook for another 4–5 minutes, until the chicken is cooked through.
4. Stir in the mango chutney, tomato purée and sliced sun- dried tomatoes.
5. Add the cooked tagliatelle and toss everything together for 2–3 minutes.
6. Season with salt and pepper and serve.',null,549.0,'master',false,null),
('R050','Salmon Coconut Curry & Jasmine Rice','lunchdinner',2,'1.Preheat the oven to 200°C. Place the salmon on a lined baking tray and cook for 10–15 minutes, or until cooked through.
2. Heat the olive oil in a large pan over a medium heat.
3. Add the garlic, onion, chilli, ginger and curry leaves. Cook for 2–3 minutes until softened.
4. Add the lemongrass, sliced yellow peppers and curry powder. Cook for another 3–4 minutes.
5. Stir in the lime zest and juice, then add the coconut milk and cherry tomatoes.
6. Bring to a gentle simmer and cook for 8–10 minutes, until the sauce has slightly thickened and the peppers are tender.
7. Meanwhile, cook the jasmine rice according to the packet instructions.
8. Remove the lemongrass from the curry sauce.
9. Serve the salmon with the jasmine rice and spoon the coconut curry sauce over the top.',null,779.0,'master',false,null),
('R051','Chicken Shawarma Pasta Salad','lunchdinner',2,'1. Mix the chicken with the garlic, chilli, lemon zest and juice, cumin, paprika, turmeric and cinnamon. Leave to marinate if you have time.
2. Preheat the oven to 200°C. Place the chicken on a tray, drizzle with the olive oil and cook for 15–20 minutes, or until cooked through.
3. Meanwhile, cook the penne according to the packet instructions, then drain and allow to cool slightly.
4.Combine the pasta with the spring onions, cucumber, onion, tomatoes and parsley.
5. Add the cooked chicken, season with salt and pepper and toss everything together.',null,520.0,'master',false,null),
('R052','Turkey Spaghetti Bolognese','lunchdinner',4,'1. Heat the olive oil in a large non-stick pan. Add the onion and cook for 3–4 minutes until softened.
2. Add the turkey mince and cook for 4–5 minutes, breaking it up as it cooks.
3. Add the celery, garlic and carrots and cook for another 3–5 minutes.
4. Stir in the chopped tomatoes, tomato purée, oregano and Worcestershire sauce. Season with salt and pepper.
5. Simmer gently for 20–30 minutes, until the sauce has thickened and the turkey is cooked through.
6. Meanwhile, cook the spaghetti according to the packet instructions.
7. Divide the spaghetti between four bowls, top with the turkey bolognese and sprinkle over the Parmesan.',null,709.0,'master',false,null),
('R054','Prawn & Pineapple Power Bowl','lunchdinner',2,'1. Heat the coconut oil in a large frying pan over a medium heat.
2. Add the onion, pepper, garlic and ginger and cook for 5–7 minutes until softened.
3. Meanwhile, cook the basmati rice according to the packet instructions.
4. Add the cooked prawns, pineapple and soy sauce to the pan and cook for 3–4 minutes, until the prawns are piping hot.
5. Stir through the cooked rice and coriander, then divide between two bowls and serve.',null,755.0,'master',false,null),
('R055','Lamb Souvlaki & Basmati Rice','lunchdinner',4,'1. Mix the olive oil, lemon juice, red wine vinegar, oregano, garlic, salt and pepper in a bowl.
2. Add the lamb and mix well to coat. Cover and marinate in the fridge for at least 30 minutes, or for a few hours if possible.
3. Thread the lamb onto skewers and discard any leftover marinade.
4. Cook under a medium-high grill for around 8–10 minutes, turning regularly, until the lamb is cooked through to your preference.
5. Meanwhile, cook the basmati rice according to the packet instructions.
6. Toss the cucumber, cherry tomatoes and lettuce together to make the side salad.
7. Divide the rice between four plates and serve with the lamb skewers and salad.',null,762.0,'master',false,null),
('R056','Fillet Steak with Chimihurri & Baked Sweet Potato Fries','lunchdinner',1,'1. Preheat the oven to 200°C. Cut the sweet potato into fries, toss with around ¾ tsp vegetable oil and a little salt, then bake for 25–30 minutes in the oven.
2. Mix the chilli, coriander, parsley, garlic, olive oil, red wine vinegar, oregano and water to make the chimichurri.
3. Season the steak. Heat the remaining vegetable oil in a frying pan and cook the steak to your preference. Remove and rest.
4. Add the mushrooms and butter to the pan and cook until browned. Stir through the soy sauce.
5. Slice the steak and serve with the sweet potato fries, mushrooms and chimichurri.',null,858.0,'master',false,null),
('R057','Crispy Sea Bass with Asian Greens','lunchdinner',1,'1. Cook the rice according to the packet instructions.
2. Mix the cornflour, Chinese five-spice, salt and pepper, then coat the sea bass in the mixture.
3. Heat the sesame oil in a non-stick frying pan. Add the broccoli, pak choi, garlic, ginger and chilli and stir-fry for 3–4 minutes.
4. Add the soy sauce, rice wine vinegar, lime juice and honey. Cook for another 1–2 minutes, then remove the vegetables from the pan and keep warm.
5. Place the sea bass in the hot pan, skin-side down, and cook for 3–4 minutes until crisp. Turn and cook for another 2–3 minutes, or until cooked through.
6. Serve the sea bass with the rice and Asian greens, topped with the sliced spring onions.',null,512.0,'master',false,null),
('R058','Lean Beef Salad with Fresh Egg Noodles','lunchdinner',1,'1. Heat a non-stick frying pan over a medium heat. Add the beef mince and cook for 7–10 minutes, breaking it up as it cooks, until browned and cooked through. Season with salt and pepper.
2. Cook the fresh egg noodles according to the packet instructions, then drain.
3. Chop the avocado, tomatoes, cucumber, red pepper, red onion and lettuce.
4. Mix the olive oil and lemon juice together and season with salt and pepper.
5. Add the lettuce and vegetables to a bowl and toss through the dressing.
6. Add the cooked noodles and beef mince.
7. Top with the avocado and serve with the lime on the side.',null,863.0,'master',true,'MACRO MISMATCH: ingredient list computes 45% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R059','Salmon Pasta with Green Beans & Lemon-Thyme Vinaigrette','lunchdinner',1,'1. Cook the penne according to the packet instructions. Add the green beans for the final 3–4 minutes. Reserve a small amount of pasta water, then drain.
2. Season the salmon with salt and pepper and brush with 1 tsp olive oil.
3.Heat a non-stick frying pan and cook the salmon for around 3–4 minutes on each side, or until cooked through. Remove and set aside.
4. Return the pasta and beans to the pan. Add the remaining 1 tsp olive oil, lemon zest and juice, thyme and garlic salt.
5. Add a splash of the reserved pasta water and toss everything together.
6. Flake the salmon into large pieces and serve with the pasta and beans. Garnish with lemon wedges and fresh thyme.',null,823.0,'master',false,null),
('R060','Chicken & Green Pesto Gnocchi','lunchdinner',1,'1. Cut the chicken into even pieces and season with Italian herbs, salt and pepper.
2. Heat 1 tsp olive oil in a non-stick frying pan and cook the chicken for 6–8 minutes, or until cooked through. Remove and keep warm.
3. To make the pesto, blend the basil, pine nuts, Parmesan, garlic and 15ml olive oil until combined. Season to taste.
4. Cook the gnocchi according to the packet instructions, then drain.
5. Add the gnocchi and cherry tomatoes to the frying pan and cook for 2–3 minutes until lightly golden and the tomatoes begin to soften.
6. Stir through the pesto.
7. Add the cooked chicken and toss everything together.
8. Garnish with fresh basil and serve.',null,818.0,'master',false,null),
('R061','Beef Teriyaki Noodles','lunchdinner',1,'1. Slice the beef into thin strips. Coat with the cornflour and season with salt and pepper.
2. Cook the noodles according to the packet instructions, drain and set aside.
3. Mix the soy sauce, rice vinegar, brown sugar, ginger and garlic together.
4. Heat half the sesame oil in a large wok or frying pan over a high heat.
5. Add the beef and stir-fry for 2–3 minutes until browned. Remove and set aside.
6. Add the remaining sesame oil, broccoli, carrot, beansprouts and pepper. Stir-fry for 3–4 minutes.
7. Return the beef to the pan and add the teriyaki sauce.
8. Add the cooked noodles and toss everything together for another 2–3 minutes, until piping hot.
9. Serve topped with the sliced red chilli and sesame seeds.',null,754.0,'master',false,null),
('R062','Miso Cod Power Bowl','lunchdinner',1,'1. Mix the miso paste, mirin, sake and honey together.
2.Coat the cod with the miso mixture and marinate in the fridge for 30 minutes to 1 hour, if time allows.
3. Preheat the oven to 200°C. Place the cod on a lined baking tray and cook for 12–15 minutes, or until cooked through.
4. Meanwhile, cook the basmati rice according to the packet instructions.
5. Steam the Tenderstem broccoli and edamame for 3–5 minutes until tender.
6. Toss the cooked vegetables with the sesame oil and a little salt.
7. Add the rice, broccoli and edamame to a bowl and place the miso cod on top.
8. Sprinkle with the black sesame seeds and chilli flakes and serve.',null,784.0,'master',false,null),
('R063','Thai Coconut & Prawn Curry with Basmati Rice','lunchdinner',1,'1. Pat the prawns dry, lightly coat with the cornflour and set aside.
2. Cook the basmati rice according to the packet instructions.
3. Meanwhile, heat a large non-stick pan over a medium heat. Add the ginger, garlic and red onion and cook for 2–3 minutes.
4.Stir in the curry paste, then add the coconut milk, fish sauce and brown sugar. Simmer gently for 5 minutes.
5. Add the red pepper and cook for a further 2–3 minutes.
6.Add the prawns and cook for 3–4 minutes, until pink and cooked through.
7. Stir through the lime juice and spring onions.
8. Serve with the basmati rice and garnish with the coriander and sliced red chilli.',null,787.0,'master',false,null),
('R064','Chicken Katsu Curry & Jasmine Rice','lunchdinner',1,'1. Place the chicken between two sheets of cling film and gently flatten to an even thickness. Season with salt and pepper.
2. Place the flour, beaten egg and panko breadcrumbs into three separate bowls. Coat the chicken in the flour, then egg, followed by the breadcrumbs.
3.Heat olive oil in a non-stick frying pan and cook the chicken for around 4–5 minutes on each side, or until golden and cooked through. Remove, rest and slice.
4. For the curry sauce, heat the remaining olive oil in a small saucepan. Add the onion and carrot and cook for 3–4 minutes.
5. Add the garlic and ginger and cook for another minute. Stir in the curry powder and garam masala.
6. Add the tomato purée, chicken stock, soy sauce and honey. Simmer gently for 8–10 minutes.
7. Stir in the cornflour mixture and cook for another 1–2 minutes, until the sauce thickens.
8. Meanwhile, cook the jasmine rice according to the packet instructions.
9. Serve the sliced katsu chicken with the rice and curry sauce.',null,678.0,'master',false,null),
('R065','High Protein Hoisin Beef Noodles','lunchdinner',1,'1. Toss the beef strips with 1 tsp cornflour and season with salt and black pepper.
2. In a small bowl, mix together the hoisin sauce, soy sauce, rice vinegar, honey, ginger, garlic and chilli paste.
3. Cook the egg noodles according to the packet instructions. Add the broccoli for the final 2–3 minutes, then drain.
4. Heat the sesame oil in a wok or large frying pan over a high heat.
5. Add the beef and stir-fry for 2–3 minutes until browned. Remove and set aside.
6. Add the green pepper and carrot and stir-fry for another 2–3 minutes.
7. Return the beef to the pan and add the noodles, broccoli and hoisin sauce mixture.
8. Stir in the cornflour and water mixture and cook for another 1–2 minutes, until the sauce has thickened and everything is piping hot.
9. Stir through most of the spring onions.
10.Serve topped with the remaining spring onions and sesame seeds.',null,733.0,'master',false,null),
('R066','Grilled Salmon with Mango & Avocado Salsa & Coconut Rice','lunchdinner',1,'1. Mix the lime juice, cumin, chilli powder, paprika, garlic, salt and pepper. Coat the salmon and leave to marinate for around 15 minutes.
2. Add the rice, light coconut milk and water to a saucepan. Bring to the boil, cover and simmer according to the rice packet instructions until cooked.
3. Stir the lime zest and half the coriander through the cooked rice.
4. Mix the mango, avocado, red onion, red pepper, jalapeño and remaining coriander together to make the salsa.
5. Heat a grill pan or frying pan over a medium-high heat. Cook the salmon for around 4–5 minutes on the first side, then turn and cook for another 3–4 minutes, or until cooked through.
6. Serve the salmon with the coconut rice and mango and avocado salsa.',null,796.0,'master',false,null),
('R067','Beef & Broccoli Noodles','lunchdinner',1,'1. Toss the beef strips with the cornflour and season with salt and pepper.
2. Mix the soy sauce, oyster sauce, rice vinegar, brown sugar, ginger and garlic in a small bowl.
3. Cook the noodles according to the packet instructions, drain and set aside.
4. Heat the sesame oil in a large wok or frying pan over a high heat.
5. Add the beef and stir-fry for 2–3 minutes until browned. Remove and set aside.
6. Add the broccoli and green pepper and stir-fry for 3–4 minutes until just tender.
7. Return the beef to the pan and pour over the sauce.
8. Add the noodles and toss everything together for another 2–3 minutes, until piping hot.
9. Stir through the spring onions and serve topped with the sesame seeds and coriander.',null,832.0,'master',false,null),
('R068','Sticky Balsamic & Sweet Chilli Chicken and Rice','lunchdinner',1,'1. Mix the chicken with the garlic, ginger, chilli, red onion, soy sauce and sweet chilli sauce. Leave to marinate for 15–30 minutes if time allows.
2. Cook the basmati rice according to the packet instructions.
3. Heat the olive oil in a non-stick frying pan over a medium- high heat.
4. Add the chicken and marinade and cook for 5–6 minutes, stirring regularly.
5. Add the balsamic vinegar and pak choi and cook for another 3–4 minutes, until the chicken is cooked through and the sauce becomes sticky.
6. Stir through the fresh basil.
7. Serve the sticky chicken and vegetables over the basmati rice.',null,699.0,'master',false,null),
('R069','Sticky Honey & Ginger Power Chicken','lunchdinner',1,'1. Mix half the ginger and garlic with a little of the soy sauce. Add the chicken, season with salt and pepper and toss to coat.
2. In a separate bowl, mix the honey, remaining ginger and garlic, remaining soy sauce, lime juice, tomato purée, cumin, chilli powder and paprika.
3. Cook the basmati rice according to the packet instructions.
4.Steam or boil the broccoli for 3–4 minutes until just tender.
5. Heat the olive oil in a large non-stick frying pan. Add the chicken and cook for 4–5 minutes until browned.
6. Add the green pepper and cook for another 2–3 minutes.
7. Pour over the honey and ginger sauce and simmer for 2–3 minutes.
8. Stir in the cornflour mixture and cook for another 1–2 minutes, until the sauce becomes sticky and the chicken is cooked through.
9. Serve with the rice and broccoli, then sprinkle over the coriander and sesame seeds.',null,664.0,'master',false,null),
('R070','Peri-Peri Chicken Thighs with Spicy Rice & Peas','lunchdinner',1,'1.Mix the sliced red pepper, chilli, 2 garlic cloves, smoked paprika, oregano, cumin, lemon juice, honey and olive oil to make the peri-peri marinade.
2.Coat the chicken thighs in the marinade and leave for 15–30 minutes if time allows.
3.Preheat the oven to 200°C. Place the chicken on a lined baking tray and cook for around 20–25 minutes, or until cooked through.
4.Meanwhile, add the onion, diced red pepper and remaining garlic to a non-stick saucepan and cook for 2–3 minutes, adding a splash of stock if needed.
5.Stir in the tomato purée, cumin and smoked paprika.
6.Add the rice and chicken stock. Cover and simmer according to the rice packet instructions, until the rice is cooked and the liquid has been absorbed.
7.Cook the peas for 3–4 minutes, then stir through or serve alongside the spicy rice.
8.Serve the peri-peri chicken with the spicy rice and peas.',null,772.0,'master',false,null),
('R071','Lemon Pepper Chicken Gnocchi','lunchdinner',1,'1.Mix the chicken with 1 tsp olive oil, 2 tsp lemon juice, lemon zest, garlic powder, oregano, salt and pepper.
2.Cook the gnocchi according to the packet instructions, then drain and set aside.
3.Heat a non-stick frying pan over a medium-high heat and cook the chicken for 5–6 minutes, until golden and cooked through. Remove and set aside.
4.Add the remaining 1 tsp olive oil to the pan. Add the garlic and green pepper and cook for 2–3 minutes.
5.Add the cherry tomatoes and cook for another 2 minutes, then stir through the spinach until wilted.
6.Add the lemon juice and chicken stock and simmer briefly.
7.Reduce the heat and stir through the Greek yoghurt, Parmesan and lemon zest.
8.Add the gnocchi and chicken back to the pan and gently combine until everything is heated through.
9.Stir through the parsley and basil, season to taste and garnish with lemon slices.',null,706.0,'master',true,'POSSIBLE DUPLICATE: ''~2g lemon zest (1 tsp)'' appears twice, verbatim, in the ingredient list - looks like an accidental double entry rather than two intentional uses (no distinguishing label like ''for the sauce''). Worth checking against the source card and removing one if it''s a duplicate.'),
('R072','Vietnamese Lemongrass Chicken & Rice Bowl','lunchdinner',1,'1.Cook the jasmine rice according to the packet instructions, then set aside.
2.Mix the lemongrass, garlic, ginger, soy sauce, brown sugar and lime juice. Add the chicken, season with pepper and leave to marinate for 15–30 minutes if time allows.
3.Prepare the carrot, cucumber and lettuce and roughly chop the fresh herbs.
4.Mix all the dressing ingredients together until the sugar has dissolved.
5.Heat the vegetable oil in a non-stick frying pan over a medium-high heat. Add the chicken and marinade and cook for 6–8 minutes, until browned and cooked through.
6.Add the rice to a bowl and arrange the chicken, carrot, cucumber and lettuce on top.
7.Drizzle over the dressing (soy sauce, lime juice, sugar, water, garlic, Thai chilli) and finish with the fresh mint and coriander.',null,697.0,'master',true,'POSSIBLE DUPLICATE: ''~11g reduced-salt soy sauce (2 tsp)'' and ''~4g brown sugar (1 tsp)'' each appear twice, verbatim. Could be a genuine two-part recipe (chicken marinade + a separate dipping sauce, both using soy/sugar/lime) or an accidental duplicate - worth confirming against the source card eithe'),
('R073','Smashed Avocado & Grilled Chicken Burger & Sweet Potato Fries','lunchdinner',1,'1.Preheat the oven to 200°C. Cut the sweet potato into fries, toss with 1 tsp olive oil, paprika, salt and pepper, and bake for 25–30 minutes, turning halfway.
2.Season the chicken with salt and pepper.
3.Heat the remaining 1 tsp olive oil in a non-stick or griddle pan and cook the chicken for around 4–5 minutes on each side, or until cooked through. Set aside to rest.
4.Mix the Greek yoghurt, light mayonnaise, Dijon mustard, honey and garlic powder to make the sauce.
5.Lightly toast the brioche bun in the pan.
6.Spread the sauce over the bun and layer with the mixed leaves, tomato, red onion, chicken, smashed avocado and pickles.
7.Serve with the baked sweet potato fries.',null,912.0,'master',true,'MINOR: ''Salt & black pepper'' listed twice, verbatim - cosmetic duplicate only (negligible calorie impact), tidy up if convenient.'),
('R074','Fuelling Chicken Pasta Primavera','lunchdinner',1,'1. Cook the fusilli according to the packet instructions. Reserve 1 tbsp pasta water, then drain.
2. Season the chicken with salt, pepper and mixed herbs.
3. Heat 1 tsp olive oil in a non-stick frying pan and cook the chicken for 5–6 minutes, until cooked through. Remove and set aside.
4. Add the remaining ½ tsp olive oil, red onion and garlic to the pan and cook for 1–2 minutes.
5. Add the broccoli and red pepper and cook for 3–4 minutes. Add the tomatoes and spinach and cook until the spinach has wilted.
6. Mix the Greek yoghurt, Parmesan, lemon juice, chopped herbs and reserved pasta water together.
7. Return the chicken and pasta to the pan, then stir through the yoghurt sauce.
8. Heat gently for 1–2 minutes, season to taste and serve.',null,692.0,'master',false,null),
('R075','Garlic & Herb Sauce','lunchdinner',1,'1. Place all ingredients into a blender and blend until you reach your desired consistency','No nutrition values provided in source document',null,'master',false,null),
('R076','Honey, Lime & Mustard Sauce','lunchdinner',1,'1. Place all ingredients into a blender and blend until you reach your desired consistency','No nutrition values provided in source document',null,'master',false,null),
('R077','4 Chicken Sausages, Baked Beans, ½ Avocado, Toast, 3 Eggs Scrambled','breakfast',1,'1. Grill the chicken sausages until cooked through.
2. Warm the baked beans in a small pan.
3. Scramble the whole eggs and egg whites together in a non-stick pan with no added fat.
4. Toast the bread, unbuttered.
5. Slice the avocado.
6. Plate the sausages, beans, scrambled egg, toast and avocado together.','How it''s kept light: 3 lean chicken sausages grilled (not fried), 2 whole eggs + 2 whites scrambled dry, ⅓ avocado, 1 slice wholegrain toast unbuttered, no added oil

DRAFT RECIPE: written from the Menus 2.docx placeholder as a demo of the new structure. Ingredient quantities (particularly the baked beans) and the generic sausage/egg macro values have NOT been reconciled to the published 460 / 46 / 16 / 33 target yet - check the Variance columns to the right and adjust quantities (or the Ingredi',460.0,'master',false,null),
('R078','Porridge, Berries, Banana, Honey','breakfast',1,'1. Add the oats and milk to a small saucepan and place over medium heat.
2. Bring to a gentle simmer, stirring frequently, for 5-6 minutes until the oats are soft and creamy, adding a splash of water if it thickens too much.
3. Remove from the heat and stir in the protein powder until fully dissolved and smooth (mixing it off the heat prevents clumping and protects the protein).
4. Spoon the porridge into a bowl and top with the sliced banana and mixed berries.
5. Finish with a light drizzle of honey and serve immediately.','How it''s kept light: Oats cooked in semi-skimmed or protein-fortified milk, berries, banana, light drizzle of honey, no added cream or butter

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingr',415.0,'master',false,null),
('R079','Bircher Muesli, Mango Yoghurt','breakfast',1,'1. In a bowl or jar, combine the oats, milk, 150g of the Greek yoghurt, grated apple, cinnamon and a squeeze of lemon juice.
2. Stir well, cover and refrigerate overnight (minimum 6 hours) to let the oats soften.
3. The next morning, stir the mixture again, loosening with a splash of milk if it has thickened too much.
4. Lightly swirl the mango through the remaining 50g of yoghurt to create a rippled effect rather than mixing it in fully.
5. Spoon the mango yoghurt over the bircher muesli and scatter with the flaked almonds to serve.','How it''s kept light: Oats soaked overnight in low-fat milk and 0% Greek yoghurt, grated apple, mango-swirled 0% yoghurt topping, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingr',395.0,'master',false,null),
('R080','Roasted Tomato & Red Pepper Soup, Cheese Toastie','lunchdinner',1,'1. Preheat oven to 200°C. Halve and deseed the red peppers, toss with the olive oil and roast for 25 minutes until soft and lightly charred.
2. Meanwhile, soften the chopped red onion and garlic in a splash of the vegetable stock in a saucepan for 5 minutes.
3. Add the tinned tomatoes, red lentils and remaining vegetable stock. Simmer for 15 minutes until the lentils are tender.
4. Add the roasted peppers and basil, then blend until smooth. Season with salt and black pepper.
5. For the toastie, sandwich the reduced-fat cheddar between the two slices of wholegrain bread and cook in a dry non-stick pan over medium heat for 2-3 minutes each side until golden and the cheese has melted.
6. Slice the toastie and serve alongside the soup.','How it''s kept light: Reduced-fat cheese toastie on wholegrain, soup blended with vegetable stock, no cream

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantitie',675.0,'master',true,'MACRO MISMATCH: ingredient list computes 67% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R081','Chicken & Sweetcorn Noodle Soup','lunchdinner',1,'1. Poach the chicken breast in the chicken stock with the garlic and ginger for 12-15 minutes until cooked through. Remove and shred with two forks.
2. Return the stock to a simmer and add the sweetcorn and egg noodles. Cook for 3-4 minutes until the noodles are tender.
3. Beat the egg in a small bowl. Stir the soup in a slow circular motion and drizzle in the egg to create thin ribbons.
4. Return the shredded chicken to the pan and stir through the soy sauce and white pepper.
5. Ladle into a bowl and scatter over the sliced spring onions to serve.','How it''s kept light: Shredded chicken breast, egg-drop style, noodle portion controlled, no added oil in stock

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quant',515.0,'master',true,'MACRO MISMATCH: ingredient list computes 55% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R082','Pea & Mint Soup','lunchdinner',1,'1. Soften the finely chopped shallot and garlic in the olive oil over low heat for 5 minutes.
2. Add the vegetable stock and bring to a simmer, then add the frozen peas and cook for 3-4 minutes until just tender.
3. Meanwhile, lower the egg into a small pan of simmering water and soft-boil for 6 minutes. Cool briefly under cold water, then peel and halve.
4. Add the mint to the soup and blend until smooth. Season with salt and black pepper.
5. Pour into a bowl, swirl through the Greek yoghurt and serve with the soft-boiled egg alongside.','How it''s kept light: Peas blended with stock and mint, swirl of 0% Greek yoghurt, soft-boiled egg on the side for protein

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and a',295.0,'master',false,null),
('R083','Roasted Cauliflower & Miso Soup','lunchdinner',1,'1. Preheat oven to 200°C. Toss the cauliflower florets with the olive oil and roast for 25 minutes, turning once, until golden.
2. Simmer the garlic and ginger in the vegetable stock for 5 minutes.
3. Add most of the roasted cauliflower (reserving a few florets for garnish) along with the silken tofu and miso paste.
4. Blend until smooth and creamy, loosening with a little extra stock if needed.
5. Ladle into a bowl, top with the reserved cauliflower and sliced spring onion.','How it''s kept light: Miso stock, roasted cauliflower, silken tofu blended in for protein and creaminess without cream

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjus',270.0,'master',false,null),
('R084','Roasted Carrot & Halloumi Soup','lunchdinner',1,'1. Preheat oven to 200°C. Peel and chop the carrots, toss with the olive oil and cumin, and roast for 30 minutes until soft and caramelised.
2. Soften the chopped onion and garlic in a splash of the vegetable stock for 5 minutes.
3. Add the roasted carrots and remaining stock, simmer for 5 minutes, then blend until smooth. Season with salt and black pepper.
4. Slice the halloumi and grill or griddle for 1-2 minutes each side until golden.
5. Ladle the soup into a bowl and top with the grilled halloumi.','How it''s kept light: Carrot blended with stock, small amount of halloumi grilled (not fried) on top

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or I',325.0,'master',false,null),
('R085','Prawn Wonton Soup','lunchdinner',1,'1. Finely chop half the prawns with the garlic, half the ginger and one spring onion. Season and spoon a small amount onto each wonton wrapper, wet the edges and fold into parcels.
2. Bring the stock to a simmer with the remaining ginger and the soy sauce.
3. Add the wontons and remaining whole prawns, simmer for 4-5 minutes until the prawns are pink and the wontons float.
4. Add the pak choi and cook for a further 1-2 minutes until just wilted.
5. Stir through the sesame oil, ladle into a bowl and scatter with the remaining sliced spring onion.','How it''s kept light: King prawn wontons, clear broth, pak choi, minimal oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values',315.0,'master',false,null),
('R086','Crispy Sesame Beef Noodle Broth','lunchdinner',1,'1. Preheat oven to 220°C. Toss the beef strips in the cornflour and spread on a lined baking tray. Roast for 8-10 minutes, turning once, until crisp at the edges.
2. Meanwhile, simmer the beef stock with the garlic, ginger and soy sauce for 5 minutes.
3. Cook the egg noodles in the broth for 3-4 minutes, then add the beansprouts and pak choi for a final minute.
4. Ladle the noodles and broth into a bowl and top with the crispy beef.
5. Drizzle with the sesame oil and scatter over the sesame seeds, sliced chilli and spring onion.','How it''s kept light: Lean beef strips oven-crisped (not deep-fried), light sesame drizzle, noodle portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust',559.0,'master',true,'MACRO MISMATCH: ingredient list computes 47% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R087','Tomato Soup, Meatballs','lunchdinner',1,'1. Preheat oven to 200°C. Mix half the finely diced onion and one clove of crushed garlic with the turkey mince, breadcrumbs, salt and pepper. Shape into 6-8 small meatballs and bake for 15 minutes until cooked through.
2. Meanwhile, soften the remaining onion and garlic in a splash of the vegetable stock for 5 minutes.
3. Add the tinned tomatoes and remaining stock, simmer for 10 minutes, then blend until smooth.
4. Return the soup to the pan, add the orzo and simmer for 8-10 minutes until tender.
5. Stir in the basil and add the baked meatballs to warm through for the final 2 minutes.
6. Season and serve.','How it''s kept light: Lean beef/turkey meatballs baked not fried, tomato and basil soup base

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredien',454.0,'master',true,'MACRO MISMATCH: ingredient list computes 57% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R088','Bouillabaisse','lunchdinner',1,'1. Soften the finely sliced onion, garlic and fennel in a splash of the fish stock over low heat for 6-8 minutes until softened.
2. Add the chopped tomatoes, remaining fish stock, saffron and orange zest. Simmer for 10 minutes.
3. Add the white fish and mussels, cover and cook for 4 minutes.
4. Add the king prawns and cook for a further 2-3 minutes until the prawns are pink, the fish is cooked through and the mussels have opened (discard any that remain closed).
5. Season with salt and black pepper.
6. Toast the slice of baguette and serve alongside the bouillabaisse.','How it''s kept light: Mixed fish and shellfish in a tomato-saffron stock, thin toast on the side, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quanti',445.0,'master',true,'MACRO MISMATCH: ingredient list computes 69% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R089','Panko Chicken Caesar','lunchdinner',1,'1. Preheat oven to 200°C (fan 180°C). Season chicken, dust in flour, dip in egg white, then press into panko breadcrumbs to coat evenly.
2. Place on a wire rack over a baking tray, mist lightly with cooking spray and bake for 18-20 minutes, turning once, until golden and cooked through (75°C core).
3. Meanwhile mix the yoghurt, mustard, lemon juice, garlic and parmesan to make the Caesar dressing; season to taste.
4. Slice the cooked chicken into strips.
5. Warm the wrap for 10 seconds, spread with half the dressing, top with shredded lettuce and chicken strips, and drizzle over the remaining dressing.
6. Roll tightly, slice in half and serve.','How it''s kept light: Oven-baked panko chicken breast, light yoghurt-based Caesar dressing, wholemeal wrap

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities',435.0,'master',false,null),
('R090','Pulled BBQ Chicken & Slaw','lunchdinner',1,'1. Poach or bake the chicken breast (200°C, covered, 20-25 minutes) until cooked through, then shred with two forks while warm.
2. Mix the shredded chicken with the BBQ sauce in a small pan and warm through gently for 2-3 minutes.
3. For the slaw, combine cabbage, carrot and red onion with the yoghurt and cider vinegar; season to taste.
4. Split and lightly toast the roll.
5. Pile the pulled BBQ chicken into the roll, top with a generous spoon of slaw and serve the rest of the slaw on the side.','How it''s kept light: Lean pulled chicken breast in reduced-sugar BBQ sauce, slaw dressed with yoghurt not mayo

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quant',415.0,'master',false,null),
('R091','Mexican Chicken Burrito','lunchdinner',1,'1. Toss the chicken breast in the cumin, paprika and coriander, then grill or griddle for 5-6 minutes per side until cooked through and lightly charred. Slice.
2. Cook the rice according to packet instructions and warm the black beans.
3. Mix the diced tomato, red onion, fresh coriander and lime juice for a quick salsa.
4. Warm the tortilla wrap, then layer rice, beans, chicken, salsa, yoghurt, cheese and lettuce down the centre.
5. Fold in the sides and roll tightly into a burrito, then slice in half to serve.','How it''s kept light: Grilled chicken breast, beans, rice portion controlled, 0% yoghurt in place of soured cream

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust qua',465.0,'master',false,null),
('R092','Tandoori Chicken, Mango Chutney, Riata','lunchdinner',1,'1. Mix 2 tbsp yoghurt with the tandoori spice and lemon juice, coat the chicken and marinate for at least 20 minutes (longer if time allows).
2. Grill or griddle the chicken for 5-6 minutes per side until charred and cooked through, then slice.
3. For the raita, mix the remaining yoghurt with cucumber and mint; season lightly.
4. Warm the pitta and split open to form a pocket.
5. Fill with lettuce, sliced tandoori chicken, a spoon of mango chutney and a spoon of raita.','How it''s kept light: Tandoori-spiced grilled chicken breast, low-sugar mango chutney, low-fat riata

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or I',390.0,'master',false,null),
('R093','Philly Cheese Steak','lunchdinner',1,'1. Heat a non-stick pan with the olive oil and dry-fry the peppers and onions over medium heat for 5-6 minutes until softened and lightly browned. Set aside.
2. Season the steak strips and fry in the same pan for 1-2 minutes over high heat, stirring, until just cooked (do not overcook, as the strips are thin).
3. Return the peppers and onions to the pan with the steak and toss together for 30 seconds.
4. Split the baguette and warm through, then scatter the grated cheese inside so it starts to melt from the heat.
5. Pile in the steak, pepper and onion mixture and serve immediately.','How it''s kept light: Lean sirloin strips, peppers and onions dry-fried, reduced-fat cheese, thin baguette

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities',435.0,'master',false,null),
('R094','Meatball Croissant Sub','lunchdinner',1,'1. Preheat oven to 200°C (fan 180°C). Mix the mince with breadcrumbs, crushed garlic and oregano, season, and roll into 5-6 small meatballs.
2. Place on a lined tray, mist with cooking spray and bake for 15-18 minutes until cooked through and browned.
3. Meanwhile simmer the chopped tomatoes with garlic and basil for 8-10 minutes to make a light sauce; season to taste.
4. Add the baked meatballs to the sauce and warm through for 2 minutes.
5. Split the croissant and roll half open lengthways and join them end to end to form one sub-length base.
6. Spoon in the meatballs and sauce, scatter over the mozzarella and grill for 1-2 minutes until melted.','How it''s kept light: Lean beef/turkey meatballs baked, light tomato sauce, half croissant/half light roll to cut butter content

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet,',440.0,'master',false,null),
('R095','Tuna Melt','lunchdinner',1,'1. Flake the tuna into a bowl and mix with the yoghurt, mustard, spring onion and sweetcorn; season to taste.
2. Toast the wholegrain bread lightly on one side under the grill.
3. Turn the slices over and pile the tuna mixture onto the untoasted sides.
4. Scatter the grated cheese over the top and return to the grill for 3-4 minutes until the cheese is melted and bubbling.
5. Serve open-faced, or close into a sandwich once slightly cooled.','How it''s kept light: Tuna in spring water mixed with low-fat yoghurt (not mayo), light cheese, wholegrain bread

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quan',395.0,'master',false,null),
('R096','Fish Finger Sandwich','lunchdinner',1,'1. Preheat oven to 200°C (fan 180°C). Season the fish strips, dust in flour, dip in egg white, then coat in panko breadcrumbs.
2. Place on a lined tray, mist with cooking spray and bake for 12-14 minutes, turning once, until golden and cooked through.
3. Meanwhile mix the yoghurt, gherkin, capers and lemon juice for the light tartare sauce.
4. Split and lightly toast the roll.
5. Spread the tartare sauce on both sides of the roll, add the lettuce and fish fingers, and serve immediately.','How it''s kept light: Oven-baked (not fried) breaded white fish, light tartare sauce, soft roll

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingred',405.0,'master',false,null),
('R097','Greek Chicken & Hummus','lunchdinner',1,'1. Toss the chicken with oregano, lemon juice and garlic and marinate for 10-15 minutes.
2. Grill or griddle for 5-6 minutes per side until cooked through, then slice.
3. Warm the pitta and split open to form a pocket.
4. Spread the hummus inside, then fill with cucumber, tomato, red onion and the sliced chicken.
5. Finish with a scattering of feta and serve.','How it''s kept light: Grilled chicken breast, hummus, cucumber and tomato, pitta, no added oil dressing

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (o',425.0,'master',false,null),
('R098','Chicken Teriyaki, Cucumber','lunchdinner',1,'1. Mix the soy sauce, rice vinegar, honey, garlic and ginger to make the teriyaki glaze.
2. Griddle or grill the chicken for 5-6 minutes per side until nearly cooked, then brush generously with the glaze and cook for a further 1-2 minutes until sticky and cooked through.
3. Slice the chicken and toss in any remaining glaze from the pan.
4. Warm the wrap, drizzle with the sesame oil, then top with cucumber ribbons, spring onion and the teriyaki chicken.
5. Scatter over the sesame seeds, roll tightly and slice to serve.','How it''s kept light: Grilled chicken breast in reduced-sugar teriyaki glaze, cucumber, minimal oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or In',395.0,'master',false,null),
('R099','Chicken Shawarma','lunchdinner',1,'1. Mix the cumin, paprika, turmeric, garlic and lemon juice, coat the chicken and marinate for 15-20 minutes.
2. Grill or griddle the chicken for 5-6 minutes per side until charred and cooked through, then slice thinly.
3. Mix the yoghurt with the extra garlic clove and a squeeze of lemon for the garlic sauce.
4. Warm the flatbread, then layer with lettuce, tomato, red cabbage and the shawarma chicken.
5. Drizzle over the garlic yoghurt sauce, fold or roll and serve.','How it''s kept light: Shawarma-spiced grilled chicken breast, light garlic yoghurt sauce, flatbread

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or In',415.0,'master',false,null),
('R100','Nando''s-Style Chicken, Halloumi, Rocket','lunchdinner',1,'1. Coat the chicken breast in the peri-peri marinade and leave for at least 20 minutes.
2. Griddle or grill the chicken for 5-6 minutes per side until charred and cooked through.
3. Griddle the halloumi slices for 1-2 minutes per side until golden (no added oil needed).
4. Split and lightly toast the roll.
5. Slice the chicken and layer into the roll with the halloumi, roasted red pepper and rocket.','How it''s kept light: Grilled peri-peri chicken breast, small portion of grilled halloumi, rocket, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quant',430.0,'master',false,null),
('R101','Chicken Sando','lunchdinner',1,'1. Preheat oven to 200°C (fan 180°C). Season the chicken, dust in flour, dip in egg white, then coat evenly in panko breadcrumbs.
2. Place on a wire rack over a tray, mist with cooking spray and bake for 16-18 minutes, turning once, until golden and cooked through.
3. Mix the cabbage with the yoghurt and cider vinegar to make a light slaw; season to taste.
4. Split and lightly toast the bun.
5. Build the sando with a base of slaw, the baked chicken breast, gherkin slices and a final layer of slaw.','How it''s kept light: Oven-baked breaded chicken breast, light slaw, soft milk bun

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library',395.0,'master',false,null),
('R102','Tuna Tostados','lunchdinner',1,'1. Preheat oven to 190°C (fan 170°C). Mist the corn tortillas lightly with cooking spray and bake for 6-8 minutes, turning once, until crisp to form tostada bases.
2. Meanwhile mix the tomato, red onion, lime juice and coriander to make a fresh salsa.
3. Rub the tuna steak with the olive oil, season, and sear in a hot pan for 60-90 seconds per side, keeping the centre pink. Slice thinly.
4. Top each tostada base with shredded cabbage, seared tuna slices, salsa and a few slices of avocado.
5. Serve immediately while the bases are still crisp.','How it''s kept light: Seared tuna, baked (not fried) corn tostada base, salsa, avocado in moderation

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or I',345.0,'master',false,null),
('R103','Smashed Prawn Tacos','lunchdinner',1,'1. Toss the prawns with the olive oil, smoked paprika and garlic.
2. Heat a non-stick pan over high heat and pan-sear the prawns for 2-3 minutes until pink and just cooked, then roughly smash/chop with a spatula.
3. Mix the shredded cabbage with the yoghurt and half the lime juice to make a quick slaw.
4. Warm the corn tacos in a dry pan for 20-30 seconds per side.
5. Fill each taco with slaw and smashed prawns, scatter over coriander and finish with the remaining lime juice.','How it''s kept light: Prawns pan-seared in minimal oil, soft corn tacos, slaw, lime

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library',350.0,'master',false,null),
('R104','Chicken Caesar','lunchdinner',1,'1. Preheat oven to 200°C. Toss the bread cubes with a light spray of oil and a pinch of salt, then bake for 8-10 mins until golden and crisp; set aside.
2. Season the chicken breast with black pepper and griddle over medium-high heat for 5-6 mins per side until cooked through. Rest for 3 mins, then slice.
3. Whisk the yoghurt, lemon juice, mustard, chopped anchovy, garlic and grated parmesan together with 1 tbsp water until smooth.
4. Tear the romaine lettuce into a bowl and toss through the dressing to coat lightly.
5. Top with the sliced chicken, scatter over the croutons and shaved parmesan.
6. Finish with a crack of black pepper and serve immediately.','How it''s kept light: Grilled chicken breast, light yoghurt-based Caesar dressing, small crouton portion, parmesan shaved not chunked

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients s',335.0,'master',false,null),
('R105','Chicken Caesar Pasta','lunchdinner',1,'1. Cook the pasta in boiling salted water according to pack instructions until al dente; drain and cool slightly under cold water.
2. Season the chicken breast with black pepper and griddle over medium-high heat for 5-6 mins per side until cooked through. Rest, then slice or dice.
3. Whisk the yoghurt, lemon juice, mustard, chopped anchovy and garlic with 1 tbsp water until smooth to make the dressing.
4. Toss the pasta with the dressing, shredded romaine and cherry tomatoes.
5. Top with the sliced chicken and shaved parmesan, finish with black pepper and serve.','How it''s kept light: Grilled chicken breast, pasta portion controlled, light yoghurt-based Caesar dressing

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantitie',410.0,'master',false,null),
('R106','Chicken Fajita, Tortilla Chips','lunchdinner',1,'1. Toss the sliced chicken breast in the fajita spice mix and a pinch of salt.
2. Dry-fry the chicken in a non-stick pan over medium-high heat for 6-7 mins, turning, until cooked through and lightly charred; remove and rest.
3. In the same pan, dry-fry the peppers and onion for 4-5 mins until softened and charred at the edges.
4. Return the chicken to the pan with the peppers and onion, and squeeze over half the lime juice.
5. Arrange the mixed leaves on a plate, top with the chicken and pepper mix, chopped tomatoes and coriander.
6. Serve with the baked tortilla chips and remaining lime wedge on the side.','How it''s kept light: Grilled fajita chicken breast, peppers and onions dry-fried, small baked tortilla chip portion

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust',385.0,'master',false,null),
('R107','Crab & Prawn','lunchdinner',1,'1. Boil the new potatoes for 10-12 mins until tender; drain, cool slightly and dice.
2. Arrange the mixed leaves, cucumber and cherry tomatoes on a plate with the diced potatoes.
3. Flake the white crab meat over the salad and scatter the king prawns on top.
4. Whisk the olive oil and lime juice together and drizzle over the salad.
5. Top with the sliced avocado and chopped chives, season with black pepper and serve.','How it''s kept light: White crab meat and prawns, light citrus dressing, avocado in moderation, mixed leaves

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantiti',290.0,'master',false,null),
('R108','Ribeye Steak, Chimichurri, Croutons','lunchdinner',1,'1. Preheat oven to 200°C. Bake the bread cubes for 8-10 mins until golden and crisp for the croutons.
2. Mix the parsley, garlic, red wine vinegar, lime juice, chilli flakes and oregano together to make the chimichurri; season and set aside to let the flavours develop.
3. Season the ribeye with salt and black pepper, then sear in a hot, dry non-stick pan for 3-4 mins per side for medium. Rest for 5 mins.
4. Slice the steak thinly against the grain.
5. Arrange the salad leaves, cherry tomatoes and red onion on a plate.
6. Top with the sliced steak and croutons, spoon over the chimichurri and serve.','How it''s kept light: Lean-trimmed ribeye grilled, oil-free herb chimichurri (citrus/vinegar base), small crouton portion

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and ad',360.0,'master',false,null),
('R109','Beef Cheek Ragu, Gnocchi','lunchdinner',1,'1. Season the beef cheek and sear in the olive oil in a hot pan until browned all over, then set aside.
2. In the same pan, soften the onion, carrot, celery and garlic over a medium heat for 5 minutes.
3. Return the beef to the pan, add the red wine and simmer for 2 minutes to cook off the alcohol.
4. Add the chopped tomatoes, stock and bay leaf, cover and braise on a low heat (or in a 150°C oven) for 3 hours until the beef shreds easily.
5. Remove the beef, shred with two forks, skim any fat from the surface of the sauce, then return the meat to the ragu.
6. Cook the gnocchi in boiling water for 1-2 minutes until it floats, then drain and stir through the ragu.
7. Serve topped with grated parmesan.','How it''s kept light: Slow-braised lean beef cheek, tomato ragu, gnocchi portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient',739.0,'master',true,'MACRO MISMATCH: ingredient list computes 69% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R110','Meatballs','lunchdinner',1,'1. Preheat the oven to 200°C. Mix the mince, breadcrumbs, milk, garlic and chopped basil, season well, and shape into 5-6 meatballs.
2. Place on a lined baking tray and bake for 15-18 minutes until browned and cooked through, turning once.
3. Meanwhile, soften the onion and garlic in a pan with a splash of water over a medium heat for 4-5 minutes.
4. Add the passata, season, and simmer for 10 minutes.
5. Cook the spaghetti in boiling water according to pack instructions, then drain.
6. Add the baked meatballs to the tomato sauce and simmer for 2-3 minutes to combine.
7. Serve the meatballs and sauce over the spaghetti, scattered with torn basil.','How it''s kept light: Baked lean beef/turkey meatballs, tomato basil sauce, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Li',515.0,'master',true,'WORTH A GLANCE: garlic appears twice (''1/2 Garlic Clove, crushed'' and ''1 Garlic Clove, crushed'') with no purpose label distinguishing them - plausible if used in both the meatball mix and the tomato sauce, but worth confirming it isn''t a duplicate entry.'),
('R111','Mussel & Prawn in White Wine','lunchdinner',1,'1. Cook the linguine in boiling water according to pack instructions, then drain, reserving a little pasta water.
2. Heat the olive oil in a large pan and soften the onion and garlic for 3-4 minutes.
3. Add the white wine and simmer for 1-2 minutes to reduce slightly.
4. Add the chopped tomatoes and simmer for 5 minutes.
5. Add the mussels, cover with a lid and cook for 3-4 minutes until they open, discarding any that remain closed.
6. Add the prawns for the final 2 minutes until pink and cooked through.
7. Toss through the drained linguine, loosening with a little pasta water if needed, and finish with chopped parsley.','How it''s kept light: Mussels and prawns in a white wine and tomato broth, minimal oil, linguine portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust q',590.0,'master',true,'MACRO MISMATCH: ingredient list computes 75% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R112','Jerk Chicken, Rasta Pasta','lunchdinner',1,'1. Coat the chicken breast in jerk seasoning and leave to marinate for at least 15 minutes.
2. Griddle or grill the chicken for 6-7 minutes each side until cooked through and charred, then rest and slice.
3. Cook the pasta in boiling water according to pack instructions, then drain.
4. Meanwhile, sauté the onion, garlic and peppers in a non-stick pan with a splash of stock for 4-5 minutes until softened.
5. Add the coconut milk and remaining stock and simmer for 3-4 minutes until slightly thickened.
6. Toss the drained pasta through the sauce, then top with the sliced jerk chicken and spring onion.','How it''s kept light: Grilled jerk chicken breast, reduced-fat coconut milk sauce, peppers

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient',510.0,'master',false,null),
('R113','Chicken Milanese, Tomato','lunchdinner',1,'1. Preheat the oven to 200°C. Mix the panko with the grated parmesan and seasoning.
2. Dip the chicken breast in egg white, then coat evenly in the panko mixture.
3. Place on a wire rack over a baking tray and bake for 15-18 minutes until golden and cooked through.
4. Meanwhile, soften the onion and garlic in a pan with a splash of water for 4 minutes, add the passata and simmer for 10 minutes with torn basil.
5. Cook the spaghetti in boiling water according to pack instructions, then drain and toss through the tomato sauce.
6. Slice the chicken Milanese and serve on top of the tomato spaghetti.','How it''s kept light: Oven-baked panko chicken breast, tomato sauce, pasta portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredie',505.0,'master',false,null),
('R114','Nduja Seafood','lunchdinner',1,'1. Cook the linguine in boiling water according to pack instructions, then drain.
2. Meanwhile, gently melt the nduja in a non-stick pan over a low-medium heat for 1-2 minutes.
3. Add the onion and garlic and cook for 3-4 minutes until softened.
4. Add the white wine and simmer for 1 minute, then add the chopped tomatoes and simmer for 8-10 minutes.
5. Add the mixed seafood and prawns and cook for 3-4 minutes until the prawns are pink and the seafood is cooked through.
6. Toss through the drained pasta and finish with chopped parsley.','How it''s kept light: Small amount of nduja for flavour intensity keeps added fat low, mixed seafood, tomato base

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust qua',515.0,'master',false,null),
('R115','Lamb Neck Ragu','lunchdinner',1,'1. Season the lamb neck and sear in the olive oil in a hot pan until browned, then set aside.
2. Soften the onion, carrot, celery and garlic in the same pan for 5 minutes.
3. Return the lamb to the pan, add the red wine and simmer for 2 minutes.
4. Add the chopped tomatoes, stock and rosemary, cover and braise on a low heat (or in a 150°C oven) for 2.5-3 hours until the lamb is meltingly tender.
5. Remove the lamb, shred, and skim any excess fat from the surface of the sauce before returning the meat.
6. Cook the pappardelle in boiling water according to pack instructions, then drain and toss through the ragu.
7. Serve topped with grated parmesan.','How it''s kept light: Slow-braised lean-trimmed lamb neck, tomato ragu, fat skimmed off before serving

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or',732.0,'master',true,'MACRO MISMATCH: ingredient list computes 41% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R116','Prawn & Red Wine','lunchdinner',1,'1. Cook the linguine in boiling water according to pack instructions, then drain.
2. Heat the olive oil in a pan and soften the onion and garlic for 3-4 minutes.
3. Add the red wine and simmer for 2 minutes to reduce and cook off the alcohol.
4. Add the chopped tomatoes and chilli flakes and simmer for 10 minutes.
5. Add the prawns and cook for 2-3 minutes until pink and cooked through.
6. Toss through the drained pasta and finish with chopped parsley.','How it''s kept light: King prawns, red wine and tomato sauce, minimal oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) u',440.0,'master',false,null),
('R117','Lasagne','lunchdinner',1,'1. Brown the beef mince in a non-stick pan with no added oil, breaking it up, then set aside.
2. In the same pan, soften the onion, carrot, courgette and garlic for 5 minutes with a splash of stock.
3. Return the mince to the pan, add the chopped tomatoes and remaining stock, and simmer for 20 minutes.
4. For the béchamel, melt the butter in a saucepan, stir in the flour and cook for 1 minute, then gradually whisk in the skimmed milk over a low heat until thickened.
5. Preheat the oven to 180°C. Layer the ragu, lasagne sheets and béchamel in a small ovenproof dish, finishing with a béchamel layer topped with grated cheddar.
6. Bake for 30-35 minutes until golden, bubbling and the pasta is tender.','How it''s kept light: Lean beef ragu, béchamel made with skimmed milk and minimal butter, extra vegetable layers

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quan',505.0,'master',false,null),
('R118','Peri Peri Chicken','lunchdinner',1,'1. Coat the chicken breast in peri peri marinade and leave to marinate for at least 20 minutes.
2. Griddle or grill the chicken for 6-7 minutes each side until cooked through, then rest and slice.
3. Cook the penne in boiling water according to pack instructions, then drain.
4. Meanwhile, soften the onion, garlic and red pepper in a pan with a splash of water for 4-5 minutes.
5. Add the passata and chilli flakes and simmer for 8-10 minutes to make the peri sauce.
6. Toss the drained pasta through the sauce, top with the sliced peri peri chicken and scatter with coriander.','How it''s kept light: Grilled peri-peri chicken breast, tomato-based peri sauce, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredie',490.0,'master',false,null),
('R119','Salmon & Pesto','lunchdinner',1,'1. Season the salmon and oven-bake at 200°C for 12-15 minutes until cooked through and flaking easily.
2. Cook the pasta in boiling water according to pack instructions, adding the cherry tomatoes for the final 2 minutes, then drain, reserving a little pasta water.
3. Stir the pesto through the drained pasta with the skimmed milk and a splash of pasta water to loosen into a light sauce.
4. Flake the salmon and toss gently through the pasta.
5. Finish with a squeeze of lemon juice and black pepper.','How it''s kept light: Salmon''s natural omega-3 fat counted toward the total; pesto used sparingly rather than oil-heavy

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adju',525.0,'master',false,null),
('R120','Lobster & Prawn Mac and Cheese','lunchdinner',1,'1. Cook the macaroni in boiling water according to pack instructions, then drain.
2. Meanwhile, melt the butter in a saucepan, stir in the flour and cook for 1 minute, then gradually whisk in the skimmed milk over a low heat until smooth and thickened.
3. Remove from the heat and stir in the cheddar, parmesan and mustard until melted.
4. Pan-fry the prawns in a non-stick pan for 2-3 minutes until pink and just cooked through.
5. Stir the prawns and lobster meat through the cheese sauce for 1-2 minutes to warm through.
6. Fold in the drained macaroni and serve immediately.','How it''s kept light: Light cheese sauce made with skimmed milk, lobster and prawn for protein, pasta portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adj',505.0,'master',false,null),
('R121','Spicy Crab Mac and Cheese','lunchdinner',1,'1. Cook the macaroni in boiling water according to pack instructions, then drain.
2. Melt the butter in a saucepan, stir in the flour and cook for 1 minute, then gradually whisk in the skimmed milk over a low heat until smooth and thickened.
3. Remove from the heat and stir in the cheddar and chilli flakes until melted.
4. Fold the white crab meat and diced chilli through the sauce, warming gently for 1-2 minutes.
5. Stir in the drained macaroni and a squeeze of lemon juice, then serve immediately.','How it''s kept light: White crab meat, light cheese sauce (skimmed-milk base), pasta portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (o',485.0,'master',false,null),
('R122','Seafood Orzo Carbonara','lunchdinner',1,'1. Cook the orzo in boiling water according to pack instructions, then drain, reserving a cup of the cooking water.
2. Meanwhile, whisk the egg, egg yolk and parmesan together with plenty of black pepper.
3. Pan-fry the garlic, prawns and mixed seafood in a non-stick pan for 3-4 minutes until cooked through.
4. Remove the pan from the heat, add the drained orzo and toss briefly to cool slightly.
5. Pour in the egg mixture, stirring constantly and adding a splash of the reserved pasta water to create a silky sauce (the residual heat cooks the egg without scrambling it).
6. Serve immediately, scattered with chopped parsley.','How it''s kept light: Egg and light cheese sauce (no cream), mixed seafood, orzo portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or In',490.0,'master',false,null),
('R123','Caramelised Onion & Prawn','lunchdinner',1,'1. Place the sliced onions in a non-stick pan with a splash of stock and cook slowly over a low-medium heat for 20-25 minutes, adding more stock a little at a time to prevent catching, until deeply caramelised.
2. Stir in the balsamic vinegar and garlic for the final 2 minutes.
3. Cook the pasta in boiling water according to pack instructions, then drain, reserving a little pasta water.
4. Add the prawns to the onions and cook for 2-3 minutes until pink and cooked through, loosening with the remaining stock as needed.
5. Toss through the drained pasta with the thyme leaves, adding pasta water to loosen if needed.
6. Serve topped with grated parmesan.','How it''s kept light: Onions caramelised without added oil (stock-assisted), king prawns

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Li',455.0,'master',false,null),
('R124','Tuscan Chicken','lunchdinner',1,'1. Season the chicken breast and grill or griddle for 6-7 minutes each side until cooked through, then rest and slice.
2. Cook the pasta in boiling water according to pack instructions, then drain.
3. Meanwhile, soften the onion and garlic in a pan with a splash of water for 4 minutes.
4. Add the chopped tomatoes and simmer for 8 minutes, then stir in the spinach until wilted.
5. Remove from the heat and stir through the crème fraîche until glossy.
6. Toss the drained pasta through the sauce, top with the sliced chicken and serve.','How it''s kept light: Grilled chicken breast, light tomato and spinach sauce with a little low-fat crème fraîche

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quan',500.0,'master',false,null),
('R125','Marry Me Orzo','lunchdinner',1,'1. Season the diced chicken and pan-fry in a non-stick pan for 5-6 minutes until browned and cooked through, then set aside.
2. In the same pan, soften the onion and garlic with a splash of stock for 3-4 minutes.
3. Add the orzo, chopped tomatoes, sundried tomatoes and remaining stock, and simmer for 10-12 minutes, stirring occasionally, until the orzo is tender and most of the liquid is absorbed.
4. Stir in the skimmed milk and parmesan and cook for 1-2 minutes until creamy.
5. Return the chicken to the pan and warm through.
6. Finish with torn basil leaves before serving.','How it''s kept light: Chicken breast, sundried tomato and light sauce (skimmed-milk base, minimal cream)

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (',470.0,'master',false,null),
('R126','Tandoori Chicken Wrap','lunchdinner',1,'1. Preheat oven to 220°C (or preheat grill to high).
2. Mix the diced chicken with the Fage Total 0% yoghurt, tandoori spice mix and smoked paprika. Marinate for at least 10 mins.
3. Lay the chicken on a grill tray and grill for 6-8 mins, turning once, until charred at the edges and cooked through.
4. Meanwhile, place the tortilla wrap on a baking tray and spread the passata evenly over the base, leaving a small border.
5. Scatter over the grilled chicken, red onion and mozzarella.
6. Bake for 6-8 mins until the cheese is melted and the edges of the wrap are crisp — no oil brushing needed.
7. Drizzle with mango chutney, scatter with coriander and serve with the lemon wedge.','How it''s kept light: Thin base, grilled tandoori chicken breast, light cheese, no oil brushing

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingred',430.0,'master',true,'Renamed: the book had two different dishes called "Tandoori Chicken". This is the one with a tortilla.'),
('R127','Crispy Lamb','lunchdinner',1,'1. Preheat oven to 220°C.
2. Toss the trimmed lamb strips with Chinese five spice and spread in a single layer on a wire rack set over a baking tray.
3. Oven-crisp for 10-12 mins, turning once, until browned and crisp at the edges — no oil needed.
4. Spread half the hoisin sauce thinly over the tortilla wrap base and scatter over the mozzarella.
5. Bake the topped wrap for 5-6 mins until the cheese has melted and the base is crisp.
6. Top with the crispy lamb, cucumber ribbons and spring onion.
7. Drizzle with the remaining hoisin, scatter with sesame seeds and chilli flakes, and serve immediately.','How it''s kept light: Lean-trimmed lamb, oven-crisped not fried, thin base, light cheese

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Li',460.0,'master',false,null),
('R128','Meatball','lunchdinner',1,'1. Preheat oven to 200°C.
2. Mix the beef mince with breadcrumbs, egg white, oregano, crushed garlic and black pepper. Roll into 4-5 small meatballs.
3. Place on a lined baking tray and bake for 12-14 mins, turning halfway, until browned and cooked through.
4. Spread the passata evenly over the tortilla wrap base.
5. Halve the baked meatballs and arrange over the sauce, then scatter with mozzarella.
6. Bake for 6-8 mins until the cheese is melted and the base is crisp.
7. Finish with torn basil and a grind of black pepper.','How it''s kept light: Baked lean meatballs, tomato base, light cheese, thin base

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library va',465.0,'master',false,null),
('R129','Chilli Crab','lunchdinner',1,'1. Preheat oven to 220°C.
2. Mix the passata with half the chopped red chilli and a squeeze of lime juice to make the chilli tomato base.
3. Spread the base evenly over the tortilla wrap.
4. Scatter over the sweetcorn, red onion and mozzarella.
5. Bake for 7-8 mins until the cheese is melted and the base is crisp.
6. Flake the white crab meat over the hot flatbread.
7. Drizzle with chilli oil, scatter with the remaining chilli, lime zest and coriander, and serve immediately.','How it''s kept light: White crab meat, chilli tomato base, light cheese, thin base

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library',430.0,'master',false,null),
('R130','Texas BBQ','lunchdinner',1,'1. Preheat oven to 220°C.
2. Toss the shredded chicken (or beef) with half the reduced-sugar BBQ sauce.
3. Spread the remaining BBQ sauce over the tortilla wrap base as the pizza sauce.
4. Scatter over the BBQ chicken, sweetcorn, red onion and mozzarella.
5. Bake for 7-8 mins until the cheese is melted and the edges of the wrap are crisp.
6. Top with sliced jalapeño and chopped coriander.
7. Finish with a grind of black pepper and serve immediately.','How it''s kept light: Lean pulled chicken or beef, reduced-sugar BBQ base, light cheese

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Lib',460.0,'master',false,null),
('R131','Lamb Keema','lunchdinner',1,'1. Dry-fry the onion, garlic and ginger in a non-stick pan over medium heat for 2-3 mins until softened — no oil needed.
2. Add the lamb mince, garam masala, cumin and turmeric, and dry-fry for 5-6 mins, breaking up the mince, until browned and cooked through.
3. Stir in the passata, peas and par-cooked potato, and simmer for 3-4 mins until the sauce has reduced slightly.
4. Preheat oven to 220°C.
5. Spread the lamb keema evenly over the tortilla wrap base and scatter with mozzarella.
6. Bake for 6-8 mins until the cheese is melted and the base is crisp.
7. Finish with chopped coriander and a squeeze of lemon juice.','How it''s kept light: Lean minced lamb keema, spiced, thin base, light cheese, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient',450.0,'master',false,null),
('R132','Smashed Beef','lunchdinner',1,'1. Season the beef mince with salt and pepper, then shape into a loose ball.
2. Heat a non-stick pan until smoking hot (no oil needed) and press the beef ball flat with a spatula to smash it thin.
3. Cook for 2 minutes, flip, and top with the reduced-fat cheddar to melt for a further 1-2 minutes until cooked through.
4. Toast the cut side of the burger bun in the same pan for 30 seconds.
5. Build the burger: bun base, lettuce, tomato, red onion, the smashed patty with melted cheese, then tomato relish and the bun top.','How it''s kept light: 5%-fat beef patty smashed on non-stick, no added oil, light bun, tomato relish not mayo

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantit',455.0,'master',false,null),
('R133','Crispy Cajun Prawn','lunchdinner',1,'1. Preheat the oven to 200°C (fan) and line a baking tray.
2. Pat the prawns dry, dip in the beaten egg white, then toss in the panko breadcrumbs mixed with Cajun seasoning.
3. Arrange on the tray, spritz with cooking spray, and bake for 8-10 minutes, turning once, until crisp and cooked through.
4. Toss the coleslaw mix with half the light mayonnaise and a squeeze of lime.
5. Toast the burger bun, then build with the coleslaw, the crispy Cajun prawns and a drizzle of the remaining mayonnaise.
6. Serve with a lime wedge.','How it''s kept light: Oven-baked (not deep-fried) Cajun-spiced prawns, light bun, slaw

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Libr',410.0,'master',false,null),
('R134','Crispy Chicken, Pesto & Mozzarella','lunchdinner',1,'1. Preheat the oven to 200°C (fan). Butterfly and flatten the chicken breast to an even thickness.
2. Dip the chicken in the beaten egg, then coat in the panko breadcrumbs. Place on a lined tray and spritz with low-calorie cooking spray.
3. Bake for 15-18 minutes, turning once, until golden and cooked through, topping with the mozzarella for the final 2 minutes to melt.
4. Toast the bun. Spread the base with the pesto and layer with rocket and tomato.
5. Top with the crispy chicken and melted mozzarella, close the bun and serve.','How it''s kept light: Oven-baked panko chicken breast, light mozzarella, pesto used sparingly

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredie',450.0,'master',false,null),
('R135','Zinger Tower','lunchdinner',1,'1. Preheat the oven to 200°C (fan). Flatten the chicken breast to an even thickness.
2. Dip in the beaten egg, then coat in the spiced crumb. Place on a lined tray, spritz with cooking spray, and bake for 15-18 minutes, turning halfway, until crisp and cooked through.
3. Toast the burger bun and spread the base with the spiced light mayonnaise.
4. Layer the shredded lettuce, then add the crispy chicken.
5. Finish with a little more spiced mayonnaise, close the bun and serve.','How it''s kept light: Oven-baked spiced chicken breast (not deep-fried), light bun, minimal sauce

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingr',445.0,'master',false,null),
('R136','BBQ Cheek','lunchdinner',1,'1. Season the beef cheek and sear in a non-stick pan for 2-3 minutes per side.
2. Transfer to a covered casserole dish with a splash of beef stock and braise at 150°C for 3 hours (or slow-cook on low for 6-8 hours) until fork-tender.
3. Remove from the liquid, skim off any fat, then shred the beef cheek and toss through the reduced-sugar BBQ sauce.
4. Toast the burger bun and spread the base with the light mayonnaise.
5. Layer lettuce and pickles, top with the BBQ beef cheek, close the bun and serve.','How it''s kept light: Slow-braised lean beef cheek, fat skimmed, reduced-sugar BBQ sauce

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Li',450.0,'master',false,null),
('R137','Buffalo Chicken & Ranch','lunchdinner',1,'1. Preheat the oven to 200°C (fan). Season the chicken breast and bake for 18-20 minutes until cooked through, then slice.
2. Toss the sliced chicken through the buffalo hot sauce.
3. Mix the Fage 0% yoghurt, light mayonnaise, garlic powder, chives and dill to make the ranch dressing.
4. Toast the burger bun and spread the base with a little of the ranch dressing.
5. Layer lettuce and avocado, top with the buffalo chicken, and drizzle with the remaining ranch. Close the bun and serve.','How it''s kept light: Oven-baked chicken breast, light buffalo sauce, low-fat yoghurt ranch not soured cream

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantiti',435.0,'master',false,null),
('R138','Smashed Beef, Beef Chilli','lunchdinner',1,'1. Season 70g of the beef mince, shape into a ball, and smash flat on a hot non-stick pan (no oil needed). Cook for 2-3 minutes per side until cooked through.
2. Meanwhile, dry-fry the onion and garlic with the remaining 35g beef mince in a separate pan until browned.
3. Add the chopped tomatoes, kidney beans, chilli powder, cumin and smoked paprika, and simmer for 8-10 minutes to make the beef chilli.
4. Toast the burger bun. Spread the base with light mayonnaise and add lettuce.
5. Add the smashed beef patty, then top with the beef chilli and grated cheddar.
6. Close the bun and serve immediately.','How it''s kept light: 5%-fat beef patty, lean beef chilli topping, light bun

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values',475.0,'master',false,null),
('R139','Tandoori King Prawn Masala','lunchdinner',1,'1. Combine the prawns with 30g yoghurt, tandoori spice mix, and half the garlic and ginger. Marinate for 15 minutes (or up to overnight).
2. Cook the basmati rice according to pack instructions; keep warm.
3. Heat the rapeseed oil in a non-stick pan. Sauté the onion for 3-4 minutes until soft, then add the remaining garlic and ginger and cook for 1 minute.
4. Add the cumin, garam masala, turmeric and chilli powder; cook for 30 seconds until fragrant.
5. Add the chopped tomatoes and simmer for 8-10 minutes until reduced to a thick masala base.
6. Meanwhile, chargrill or griddle the marinated prawns for 2-3 minutes per side until charred and cooked through.
7. Stir the grilled prawns into the masala sauce along with the remaining 20g yoghurt; warm through for 1-2 minutes (do not boil).
8. Serve over the basmati rice, garnished with fresh coriander and a lemon wedge.','How it''s kept light: King prawns, tomato masala base, light on cream, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredi',375.0,'master',false,null),
('R140','Lamb Saag','lunchdinner',1,'1. Heat the rapeseed oil in a non-stick pan and sauté the onion for 3-4 minutes until soft.
2. Add the garlic, ginger and spices; cook for 1 minute until fragrant.
3. Add the diced lamb and brown on all sides for 4-5 minutes.
4. Add the spinach and 50ml water, cover and simmer for 20-25 minutes until the lamb is tender, stirring occasionally.
5. Blitz half the spinach mixture with a stick blender for a traditional saag texture, then stir back through.
6. Cook the basmati rice according to pack instructions.
7. Remove the curry from the heat and stir through the Greek yoghurt.
8. Serve over the rice, garnished with fresh coriander.','How it''s kept light: Lean-trimmed lamb, spinach sauce, minimal ghee swapped for an oil spray

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredie',395.0,'master',false,null),
('R141','Tandoori Chicken','lunchdinner',1,'1. Mix the yoghurt, tandoori spice mix, cumin, paprika, garlic, ginger and lemon juice in a bowl. Add the chicken and coat thoroughly; marinate for at least 30 minutes (ideally overnight).
2. Preheat a griddle pan or grill to high, brushed lightly with the rapeseed oil.
3. Chargrill the chicken for 5-6 minutes per side until charred and cooked through (internal temp 75°C).
4. Meanwhile, cook the basmati rice according to pack instructions.
5. Mix the remaining yoghurt with the cucumber and mint to make a quick raita.
6. Rest the chicken for 2 minutes, then slice.
7. Serve with the rice, raita and a lemon wedge.','How it''s kept light: Chicken breast marinated in yoghurt and spice, chargrilled not fried

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient',345.0,'master',false,null),
('R142','Thai Green Monkfish Curry','lunchdinner',1,'1. Cook the rice according to pack instructions.
2. Heat a non-stick pan or wok over medium heat and dry-fry the green curry paste for 1 minute until fragrant.
3. Add the light coconut milk and fish sauce, stir to combine, and bring to a gentle simmer.
4. Add the green beans, red pepper and bamboo shoots; simmer for 4-5 minutes.
5. Add the monkfish and lime leaf; simmer gently for 5-6 minutes until the fish is just cooked through and opaque.
6. Stir through the Thai basil.
7. Serve over the rice with a lime wedge.','How it''s kept light: Monkfish, reduced-fat coconut milk, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library v',365.0,'master',false,null),
('R143','Thai Red Cod Curry','lunchdinner',1,'1. Cook the rice according to pack instructions.
2. Heat a non-stick pan over medium heat and dry-fry the red curry paste for 1 minute until fragrant.
3. Stir in the light coconut milk and fish sauce; bring to a gentle simmer.
4. Add the mangetout, red pepper and lime leaf; simmer for 3-4 minutes.
5. Add the cod and simmer gently for 5-6 minutes until just cooked through and flaking.
6. Stir through the fresh coriander.
7. Serve over the rice with a lime wedge.','How it''s kept light: Cod, reduced-fat coconut milk, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values',350.0,'master',false,null),
('R144','Soy Braised Chicken Thighs','lunchdinner',1,'1. Heat the sesame oil in a non-stick pan over medium-high heat. Brown the chicken thighs for 2-3 minutes per side.
2. Add the soy sauce, honey, stock, garlic, ginger and star anise. Bring to a simmer.
3. Cover and braise gently for 20-25 minutes, turning occasionally, until the chicken is tender and the sauce has reduced and thickened slightly.
4. Meanwhile, cook the basmati rice according to pack instructions.
5. Remove the star anise. Shred or slice the chicken and spoon over the reduced braising liquid.
6. Serve over the rice, scattered with sesame seeds and spring onion.','How it''s kept light: Skin removed, braised in soy and stock rather than oil, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or',395.0,'master',false,null),
('R145','Thai Yellow Coconut Chicken Meatballs','lunchdinner',1,'1. Preheat oven to 200°C. Combine the chicken mince, breadcrumbs, egg white, garlic and ginger; season and shape into 6-8 small meatballs.
2. Place on a lined baking tray and bake for 12-15 minutes until cooked through and lightly golden.
3. Meanwhile, cook the rice according to pack instructions.
4. Heat a non-stick pan and dry-fry the yellow curry paste for 1 minute until fragrant.
5. Stir in the light coconut milk, bring to a gentle simmer, then add the carrot and peas; simmer for 4-5 minutes.
6. Add the baked meatballs to the sauce and simmer for 2-3 minutes to heat through and coat.
7. Stir through the fresh coriander.
8. Serve over the rice with a lime wedge.','How it''s kept light: Baked lean chicken meatballs, reduced-fat coconut sauce, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or',390.0,'master',false,null),
('R146','Spiced Lamb Chops','lunchdinner',1,'1. Combine the spices, garlic and ginger and rub firmly all over the lamb chops (no oil needed). Leave to marinate for at least 15 minutes.
2. Preheat a griddle pan or grill to high.
3. Cook the lamb chops for 3-4 minutes per side (medium), until charred on the outside and cooked to preference.
4. Meanwhile, cook the basmati rice according to pack instructions.
5. Rest the lamb chops for 2-3 minutes.
6. Serve with the rice, a side salad and a lemon wedge, scattered with fresh coriander.','How it''s kept light: Lean-trimmed lamb chops, dry-spiced and grilled, no added oil marinade

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredien',390.0,'master',false,null),
('R147','Cauliflower & Potato (side)','lunchdinner',1,'1. Preheat oven to 200°C. Toss the cauliflower and potato with the oil (or a generous spray), cumin seeds, mustard seeds, turmeric and chilli powder.
2. Spread on a baking tray and roast for 25-30 minutes, turning halfway, until golden and tender.
3. In the last 5 minutes, heat a small non-stick pan with a spray of oil, sauté the onion, garlic and ginger for 2-3 minutes, then stir in the peas and 1 tbsp water; cook for 2 minutes.
4. Combine the roasted vegetables with the onion and pea mixture.
5. Garnish with fresh coriander and serve.','How it''s kept light: Roasted with spices, minimal oil spray, no cream or ghee

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library valu',150.0,'master',false,null),
('R148','Lamb Biryani','lunchdinner',1,'1. Combine the lamb with the yoghurt, biryani spice mix, turmeric, chilli powder, garlic and ginger. Marinate for at least 30 minutes (ideally overnight).
2. Par-boil the basmati rice with the whole spices for 5-6 minutes until roughly 70% cooked; drain.
3. Heat the oil in a non-stick pan and sauté the onion for 5-6 minutes until golden and softened.
4. In an ovenproof dish or heavy-based pan, brown the marinated lamb for 4-5 minutes, then add 100ml water, cover and simmer for 25-30 minutes until tender.
5. Layer the part-cooked rice over the lamb, scatter over the fried onion, raisins, saffron water, coriander and mint.
6. Cover tightly and steam on low heat for 15-20 minutes (or finish covered in an oven at 160°C) until the rice is fully cooked and fragrant.
7. Gently fold through before serving to combine the layers.','How it''s kept light: Lean-trimmed lamb, rice portion controlled, layered not fried, minimal ghee

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingr',480.0,'master',false,null),
('R149','Lamb Keema Pau','lunchdinner',1,'1. Heat a non-stick pan lightly sprayed with oil (no added oil beyond a spray). Sauté the onion for 3-4 minutes until soft.
2. Add the garlic, ginger and spices; cook for 1 minute until fragrant.
3. Add the lamb mince and brown, breaking it up with a spoon, for 5-6 minutes.
4. Stir in the chopped tomato and peas, then simmer for 12-15 minutes until the tomato breaks down and the keema is rich and thickened, adding a splash of water if needed.
5. Lightly toast the halved pau bun in a dry pan or under the grill.
6. Spoon the keema onto the bun base, scatter with fresh coriander, and serve with a lime wedge.','How it''s kept light: Lean minced lamb keema, soft bun (pau), no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values)',435.0,'master',false,null),
('R150','Lamb Massaman','lunchdinner',1,'1. Heat a non-stick pan and dry-fry the massaman curry paste for 1 minute until fragrant.
2. Add the light coconut milk, fish sauce, tamarind paste and palm sugar; stir to combine.
3. Add the lamb, onion, potato and bay leaf/cinnamon. Bring to a gentle simmer.
4. Cover and simmer gently for 45-50 minutes, stirring occasionally, until the lamb is tender and the potato is cooked through, adding a splash of water if the sauce reduces too much.
5. Remove the bay leaf/cinnamon stick.
6. Scatter with crushed peanuts and fresh coriander before serving.','How it''s kept light: Lean-trimmed lamb, reduced-fat coconut sauce, potato, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or In',415.0,'master',false,null),
('R151','Crispy Chilli Beef','lunchdinner',1,'1. Preheat oven to 220°C (fan 200°C). Toss the beef strips in the cornflour until lightly coated.
2. Arrange on a lined baking tray in a single layer and spray with a little oil. Bake for 10-12 mins, turning once, until crisp and cooked through.
3. Meanwhile, cook the rice according to packet instructions.
4. Heat the sesame oil in a non-stick wok over high heat. Stir-fry the garlic, ginger, chilli and spring onions for 1 min.
5. Add the sweet chilli sauce and 2-3 tbsp water and bring to a simmer.
6. Toss the crispy beef through the sauce until coated. Serve immediately over the rice.','How it''s kept light: Lean beef strips oven-crisped (not deep-fried), chilli sauce, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantitie',430.0,'master',false,null),
('R152','Crispy Duck Fried Rice','lunchdinner',1,'1. Cook the rice according to packet instructions, then spread on a tray and chill (or use day-old rice).
2. Season the trimmed duck breast and roast at 200°C for 12-14 mins, or pan-sear in a hot non-stick pan, until cooked through and lightly browned. Rest for 5 mins, then slice thinly.
3. Beat the egg and cook in a hot non-stick wok for 30-45 secs, scrambling lightly. Set aside.
4. Add the sesame oil to the wok with the garlic and ginger and stir-fry for 30 secs.
5. Add the cooked rice and the peas & sweetcorn, and stir-fry over high heat for 2-3 mins.
6. Return the egg and sliced duck to the wok, add the soy sauce and spring onions, and toss for 1-2 mins until piping hot.','How it''s kept light: Duck skin removed and fat trimmed, rice stir-fried in minimal oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Lib',455.0,'master',false,null),
('R153','Lamb Breast Pancakes','lunchdinner',1,'1. Preheat oven to 200°C. Season the lamb breast and place on a rack over a tray. Roast for 20-25 mins until cooked through and crisp at the edges, allowing the fat to render and drip away.
2. Rest for 5 mins, then thinly slice, discarding any excess rendered fat.
3. Steam the Chinese pancakes according to packet instructions, or warm in a dry pan for 20-30 secs per side.
4. Spread each pancake with hoisin sauce, top with sliced lamb, cucumber matchsticks and shredded spring onion, and roll to serve.','How it''s kept light: Lean-trimmed lamb breast, reduced-sugar hoisin, thin pancakes, cucumber

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredie',533.0,'master',true,'MACRO MISMATCH: ingredient list computes 54% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R154','Sweet & Sour Prawns','lunchdinner',1,'1. Cook the rice according to packet instructions.
2. Mix the cornflour with 1 tbsp cold water to make a slurry.
3. Heat the oil in a non-stick wok over high heat. Stir-fry the onion and red pepper for 2-3 mins.
4. Add the garlic and prawns and stir-fry for 2-3 mins until the prawns turn pink.
5. Add the pineapple chunks and juice, ketchup, brown sugar and vinegar, and bring to a simmer.
6. Stir in the cornflour slurry and cook for 1-2 mins until the sauce thickens and coats the prawns. Serve over the rice.','How it''s kept light: King prawns, sauce thickened without oil, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Lib',370.0,'master',false,null),
('R155','Beef Cheek Udon','lunchdinner',1,'1. Place the beef cheek, stock, garlic and ginger in a lidded pan. Bring to a simmer, cover, and braise for 2.5-3 hrs (or 6-8 hrs on low in a slow cooker) until meltingly tender.
2. Remove the beef cheek and skim any fat from the surface of the braising liquid, then shred the meat with two forks.
3. Cook the udon noodles according to packet instructions and drain.
4. Return the shredded beef to the skimmed braising liquid with the soy sauce and mirin, and bring to a simmer. Add the pak choi and cook for 2 mins until just wilted.
5. Place the noodles in a bowl, ladle over the beef, broth and pak choi, and top with sliced spring onion.','How it''s kept light: Slow-braised lean beef cheek, fat skimmed, udon broth

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values)',430.0,'master',false,null),
('R156','Short Rib Bao Buns','lunchdinner',1,'1. Season the short rib and place in a lidded pan with the garlic, ginger and enough water or stock to cover. Bring to a simmer, cover, and braise for 3-3.5 hrs until falling off the bone.
2. Remove the meat, discard the bone, and skim off and discard all visible fat from the surface of the cooking liquid.
3. Shred the meat with two forks and toss with half the hoisin sauce.
4. Steam the bao buns according to packet instructions.
5. Fill each bun with shredded short rib, cucumber matchsticks and spring onion, and finish with a drizzle of the remaining hoisin sauce.','How it''s kept light: Slow-braised short rib, fat skimmed off, steamed (not fried) bao

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Libr',430.0,'master',false,null),
('R157','Szechuan Lamb Stir-fry','lunchdinner',1,'1. Cook the rice according to packet instructions.
2. Mix the cornflour with 2 tbsp water, the soy sauce and honey to make a sauce.
3. Heat the oil in a non-stick wok over high heat. Stir-fry the lamb strips for 2-3 mins until browned, then remove and set aside.
4. Add the Szechuan peppercorns, garlic, ginger and chilli to the wok and stir-fry for 30 secs.
5. Add the pepper, onion and mangetout and stir-fry for 2-3 mins until just tender.
6. Return the lamb to the wok, pour in the sauce, and toss for 1-2 mins until everything is coated and piping hot. Serve over the rice.','How it''s kept light: Lean-trimmed lamb, wok-fried in minimal oil, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient',405.0,'master',false,null),
('R158','Sesame Prawn Toast (side)','lunchdinner',1,'1. Preheat oven to 200°C. Blend the prawns, egg white, spring onion and ginger to a smooth paste.
2. Spread the prawn paste evenly over the slice of bread, right to the edges.
3. Sprinkle with sesame seeds, pressing gently to help them stick, then brush lightly with sesame oil.
4. Place on a lined baking tray and bake for 10-12 mins until golden and crisp. Cut into triangles to serve.','How it''s kept light: Oven-baked not deep-fried, light sesame coating

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) until',160.0,'master',false,null),
('R159','Honey Chicken','lunchdinner',1,'1. Preheat oven to 200°C. Toss the chicken pieces in the 10g cornflour until lightly coated.
2. Arrange on a lined baking tray and bake for 12-15 mins, turning once, until golden and cooked through.
3. Meanwhile, cook the rice according to packet instructions.
4. Heat the sesame oil in a small pan, add the garlic and ginger, and cook for 30 secs.
5. Add the honey, soy sauce and the cornflour-water mix, and simmer for 1-2 mins until glossy and slightly thickened.
6. Toss the baked chicken through the glaze until fully coated, sprinkle with sesame seeds, and serve over the rice.','How it''s kept light: Chicken breast, reduced-sugar honey glaze, oven-baked not battered/fried, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adju',390.0,'master',false,null),
('R160','Monkfish Fajitas','lunchdinner',1,'1. Toss the monkfish cubes in half the fajita spice mix.
2. Heat the olive oil in a non-stick pan over high heat. Dry-fry the peppers and onion for 4-5 mins until softened and lightly charred.
3. Push the vegetables to one side, add the monkfish and remaining spice mix, and cook for 3-4 mins, turning, until opaque and cooked through.
4. Warm the corn tortillas in a dry pan or microwave for 20-30 seconds.
5. Divide the monkfish and vegetables between the tortillas, top with the Fage Total 0% yoghurt and coriander, and serve with a lime wedge.','How it''s kept light: Monkfish, peppers and onions dry-fried in minimal oil, small tortilla portion

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or In',370.0,'master',false,null),
('R161','Beef Birria','lunchdinner',1,'1. Trim the beef of all visible fat and cut into large chunks. Heat the olive oil in a lidded pan or casserole dish and sear the beef on all sides until browned.
2. Add the onion and garlic and cook for 2-3 mins until softened.
3. Stir in the blended chillies (or chipotle paste), chopped tomatoes, beef stock, cumin, oregano and bay leaf.
4. Cover and simmer gently for 2-2.5 hours (or pressure cook for 45 mins), until the beef is fork-tender, topping up with water if needed.
5. Remove the beef, shred with two forks, and skim any fat from the surface of the braising liquid before returning the beef to the pot.
6. Warm the corn tortilla and serve alongside the birria with a lime wedge and coriander.','How it''s kept light: Lean-trimmed beef, fat skimmed from the braising liquid, corn tortilla on the side

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (',385.0,'master',false,null),
('R162','Beef Shin Chilli','lunchdinner',1,'1. Trim the beef shin of all visible fat and dice into small pieces.
2. Heat the olive oil in a pan and brown the beef on all sides for 3-4 mins.
3. Add the onion and garlic and cook for 2-3 mins until softened.
4. Stir in the cumin, smoked paprika and chilli powder and cook for 1 min until fragrant.
5. Add the chopped tomatoes, beef stock and black beans, cover and simmer gently for 1.5-2 hours, topping up with water as needed, until the beef is tender and the sauce has thickened.
6. Skim any excess fat from the surface, season to taste and serve topped with fresh coriander.','How it''s kept light: Lean beef shin, fat trimmed, beans, minimal oil base

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values)',375.0,'master',false,null),
('R163','Beef Barbacoa','lunchdinner',1,'1. Trim the beef of all visible fat and cut into large chunks. Heat the olive oil in a lidded pan and sear the beef on all sides until browned.
2. Add the onion and garlic and cook for 2-3 mins until softened.
3. Stir in the chipotle paste, beef stock, orange juice, cumin and bay leaf.
4. Cover and simmer gently for 2-2.5 hours (or pressure cook for 45 mins), until the beef is fork-tender.
5. Shred the beef with two forks, skimming any fat from the surface of the braising liquid before stirring the beef back through.
6. Warm the corn tortillas and serve alongside the barbacoa with a lime wedge and coriander.','How it''s kept light: Lean-trimmed beef, slow-braised, fat skimmed, corn tortilla on the side

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredie',375.0,'master',false,null),
('R164','“Taco Bell” Nachos','lunchdinner',1,'1. Preheat oven to 190°C. Arrange the tortilla triangles on a baking tray in a single layer, spray lightly with oil, and bake for 8-10 mins until golden and crisp.
2. Meanwhile, dry-fry the beef mince (or chicken) in a non-stick pan with the taco seasoning until cooked through.
3. Warm the black beans in a small pan or microwave.
4. Scatter the baked chips on a plate, top with the cooked mince, black beans and grated cheese, and return to the oven for 2-3 mins until the cheese has melted.
5. Finish with the salsa, Fage Total 0% yoghurt, jalapeño, spring onion and coriander.','How it''s kept light: Baked (not fried) tortilla chips, lean beef/chicken, light cheese, salsa and yoghurt not soured cream

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and',420.0,'master',false,null),
('R165','Spatchcock Peri Peri Chicken','lunchdinner',1,'1. Butterfly and flatten the chicken breast. Mix the lemon juice, garlic, smoked paprika, chilli flakes and oregano to make a peri-peri style marinade, and coat the chicken. Leave to marinate for at least 15 mins (or up to overnight).
2. Preheat a griddle pan or grill to high heat.
3. Chargrill the chicken for 5-6 mins per side, basting with any remaining marinade, until cooked through and charred at the edges.
4. Char the sweetcorn (or corn on the cob) on the griddle for 3-4 mins.
5. Serve the chicken with the charred corn, mixed salad, sliced avocado and a lime wedge.','How it''s kept light: Chicken breast portion, skin removed, chargrilled with peri marinade, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (',340.0,'master',false,null),
('R166','Jerk Chicken','lunchdinner',1,'1. Blitz the scotch bonnet, garlic, ginger, spring onion, allspice, thyme and lime juice with the rapeseed oil into a paste. Coat the chicken breast and marinate for at least 30 minutes, ideally overnight.
2. Preheat a griddle pan or grill to high. Cook the chicken for 5-6 mins per side until charred and cooked through, then rest for 2 mins and slice.
3. Cook the rice in salted boiling water according to pack instructions, then drain.
4. Warm the light coconut milk and kidney beans together in a small pan for 3-4 mins, then fold through the cooked rice to make rice and peas.
5. Serve the sliced jerk chicken over the rice and peas with a lime wedge.','How it''s kept light: Chicken breast marinated in jerk spice, grilled not fried, rice and peas portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust qua',370.0,'master',false,null),
('R167','Beef Suya','lunchdinner',1,'1. Toss the beef cubes with the ground peanuts, paprika, cayenne, ground ginger, garlic powder and stock powder, then thread onto skewers with the onion wedges and cherry tomatoes.
2. Brush the skewers lightly with rapeseed oil and grill or griddle on high heat for 3-4 mins per side until charred and cooked to preference.
3. Toss the sweet potato wedges in any remaining oil, spread on a tray and roast at 200°C for 20-25 mins, turning once, until tender and golden.
4. Serve the suya skewers with the sweet potato wedges and a lime wedge.','How it''s kept light: Lean-trimmed beef skewers, suya spice, grilled, minimal oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library v',360.0,'master',false,null),
('R168','Pepper Soup','lunchdinner',1,'1. Place the goat meat in a pot with the stock, bring to the boil, then skim off any excess fat and reduce to a simmer.
2. Add the scotch bonnet, ginger, garlic and spice mix, and simmer gently for 40-45 mins until the goat is tender.
3. Add the yam and simmer for a further 15-20 mins until cooked through.
4. Season to taste, stir through the scent leaf or basil, and serve hot with a lime wedge.','How it''s kept light: Lean goat or chicken, light spiced broth, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values',250.0,'master',false,null),
('R169','Nigerian Chicken Stew, Jollof','lunchdinner',1,'1. Season the chicken breast and sear in 1/2 tsp of the rapeseed oil for 2-3 mins per side until golden, then remove and set aside.
2. In the same pan, soften the onion, red pepper, garlic and ginger in the remaining oil for 5 mins.
3. Add the tomato passata, stock cube, thyme, bay leaf and scotch bonnet, and simmer for 10 mins to reduce.
4. Stir in the rice, return the chicken to the pan, cover with a splash of water and simmer for 18-20 mins until the rice is cooked and the chicken is cooked through.
5. Rest briefly, slice the chicken and serve stirred through the jollof rice.','How it''s kept light: Chicken breast, tomato-pepper stew, jollof rice portion controlled, minimal oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or',430.0,'master',false,null),
('R170','Caribbean King Prawn Curry','lunchdinner',1,'1. Cook the rice in salted boiling water according to pack instructions, then drain.
2. Soften the onion, garlic, ginger and scotch bonnet in a non-stick pan for 3-4 mins.
3. Stir in the curry powder, thyme and allspice and cook for 1 min until fragrant.
4. Add the light coconut milk, bring to a gentle simmer and cook for 5 mins to reduce slightly.
5. Add the king prawns and cook for 3-4 mins until just pink and cooked through.
6. Serve the curry over the rice.','How it''s kept light: King prawns, reduced-fat coconut sauce, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Libra',365.0,'master',false,null),
('R171','Curry Goat','lunchdinner',1,'1. Brown the goat meat in the rapeseed oil in a heavy-based pot for 4-5 mins, then remove and set aside.
2. Soften the onion, garlic, ginger and scotch bonnet in the same pot for 5 mins.
3. Stir in the curry powder, allspice and thyme and cook for 1 min, then return the goat to the pot with the light coconut milk and enough water to just cover.
4. Cover and simmer gently for 1.5-2 hours, topping up with water as needed and skimming any fat from the surface, until the goat is tender.
5. Meanwhile, cook the rice in salted boiling water according to pack instructions.
6. Serve the curry goat over the rice.','How it''s kept light: Lean-trimmed goat, slow-braised, fat skimmed, rice portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient',400.0,'master',false,null),
('R172','Salt Fish Fritters (side)','lunchdinner',1,'1. Preheat oven to 200°C and line a baking tray with parchment.
2. Mix the flaked salt fish, flour, beaten egg, spring onion, thyme and scotch bonnet into a thick batter.
3. Spoon into small fritters onto the tray and lightly brush or spray with the rapeseed oil.
4. Bake for 15-18 mins, turning once, until golden and cooked through.','How it''s kept light: Oven-baked not deep-fried, light batter

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) until they cl',155.0,'master',false,null),
('R173','Scotch Bonnet, Ginger Chilli Jam (side)','lunchdinner',1,'1. Place the mango, scotch bonnet, ginger, sugar, vinegar and lime juice in a small pan with a splash of water.
2. Simmer gently for 12-15 mins, stirring occasionally, until reduced to a sticky jam consistency.
3. Cool and season with a pinch of salt before serving.','How it''s kept light: Fruit and chilli-based reduction, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) until',45.0,'master',true,'MACRO MISMATCH: ingredient list computes 74% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R174','Jamaican Fried Chicken','lunchdinner',1,'1. Preheat oven to 200°C and set a wire rack over a baking tray.
2. Butterfly/flatten the chicken breast to an even thickness. Mix the flour with the paprika, allspice, garlic powder, onion powder, thyme, cayenne, salt and pepper.
3. Dredge the chicken in the seasoned flour, dip in the beaten egg, then coat in the panko breadcrumbs.
4. Place on the rack, spray or brush with the rapeseed oil, and bake for 20-22 mins, turning once, until golden and cooked through.','How it''s kept light: Chicken breast, oven-‘fried’ spiced coating (baked, not deep-fried)

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient L',385.0,'master',false,null),
('R175','Souvlaki','lunchdinner',1,'1. Cube the chicken breast and toss with 1 tsp of the olive oil, lemon juice, crushed garlic and oregano; marinate for at least 15 mins.
2. Thread the chicken onto skewers.
3. Griddle or grill over high heat for 8-10 mins, turning regularly, until charred and cooked through.
4. Mix the Greek yoghurt with the grated cucumber, dill and a pinch of garlic to make the tzatziki.
5. Warm the pitta on the griddle for 20-30 secs each side.
6. Toss the cherry tomatoes, red onion and remaining cucumber with the last 1/2 tsp olive oil for the salad.
7. Serve the skewers with the warmed pitta, tzatziki and salad.','How it''s kept light: Lean chicken or pork skewers, grilled, minimal oil marinade, pitta portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantitie',370.0,'master',false,null),
('R176','Gyros','lunchdinner',1,'1. Slice the lamb thinly and toss with 1 tsp of the olive oil, cumin, smoked paprika, oregano and crushed garlic; marinate for 15 mins.
2. Heat a griddle pan and cook the lamb for 3-4 mins, turning, until charred and cooked through.
3. Mix the Greek yoghurt with the grated cucumber, mint or dill and a pinch of garlic to make the tzatziki.
4. Warm the flatbread on the griddle for 20-30 secs each side, brushing with the remaining 1/2 tsp olive oil.
5. Fill the flatbread with the lamb, tzatziki, red onion and tomato. Wrap and serve.','How it''s kept light: Lean-trimmed meat, grilled not fried, light tzatziki (0% yoghurt), flatbread

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ing',410.0,'master',false,null),
('R177','Kleftiko & Potatoes','lunchdinner',1,'1. Preheat oven to 160°C.
2. Trim the lamb shoulder of visible fat, cube, and season with the oregano, garlic and lemon zest.
3. In an ovenproof dish, toss the potatoes and onion with the olive oil, then top with the lamb, tomato, bay leaf and lemon juice. Pour over the stock.
4. Cover tightly with foil and slow-roast for 2 1/2-3 hours until the lamb is meltingly tender.
5. Lift out the lamb and potatoes, then skim any fat from the cooking juices before spooning the jus back over to serve.','How it''s kept light: Slow-roasted lean lamb, fat skimmed, potato portion controlled, minimal oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingr',400.0,'master',false,null),
('R178','Prawns & Mussel Orzo','lunchdinner',1,'1. Cook the orzo in salted boiling water according to packet instructions until al dente, then drain.
2. Heat the olive oil in a pan and sauté the onion and garlic for 2-3 mins until softened.
3. Add the chopped tomatoes and stock, and simmer for 5 mins to reduce slightly.
4. Add the prawns and mussels to the sauce and cook for 3-4 mins until the prawns turn pink and everything is heated through.
5. Stir in the cooked orzo, lemon juice and parsley, then serve.','How it''s kept light: Mixed shellfish, tomato base, minimal oil, orzo portion controlled

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Li',395.0,'master',false,null),
('R179','Lamb Shoulder','lunchdinner',1,'1. Preheat oven to 150°C. Trim the lamb shoulder of excess fat, season with the garlic and rosemary, and place in a roasting tin with the stock.
2. Cover tightly with foil and slow-roast for 3 hours until tender, basting occasionally.
3. Toss the carrots with 1/2 tsp olive oil and roast alongside for the final 40 mins until caramelised.
4. Boil the potato until tender, drain and mash with the milk (no added butter).
5. Rest the lamb, then skim any fat from the cooking juices; reduce the skimmed liquid with the red wine (or extra stock) to make a light jus.
6. Slice the lamb and serve with the mash, roasted carrots and jus.','How it''s kept light: Slow-roasted lean-trimmed lamb shoulder, fat skimmed from the jus

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Lib',390.0,'master',false,null),
('R180','Loaded Potatoes','lunchdinner',1,'1. Preheat oven to 200°C. Prick the potato all over and rub the skin with the olive oil. Bake for 60-75 mins until the skin is crisp and the flesh is soft.
2. Meanwhile, season and grill the chicken breast until cooked through, then shred.
3. Halve the baked potato and fluff the flesh with a fork.
4. Top with the shredded chicken and grated cheddar, then return to the oven for 3-4 mins until the cheese has melted.
5. Finish with a dollop of Greek yoghurt, a scattering of chives and black pepper.','How it''s kept light: Baked (not fried) potato, light cheese and yoghurt topping, lean protein topping

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or',415.0,'master',false,null),
('R181','Minted Peas (side)','lunchdinner',1,'1. Bring the vegetable stock to a simmer in a small pan. Add the peas and cook for 2-3 mins until just tender.
2. Drain any excess stock, then stir through the chopped mint and a generous grind of black pepper.
3. Scatter over the toasted pumpkin seeds and serve immediately.','How it''s kept light: Steamed, dressed with mint and a little vegetable stock, no added butter

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredi',80.0,'master',false,null),
('R182','Grilled Broccoli (side)','lunchdinner',1,'1. Bring a pan of water to the boil and blanch the Tenderstem Broccoli for 2 mins, then drain well and pat dry.
2. Heat a griddle pan until smoking hot and chargrill the broccoli for 3-4 mins, turning, until tender with visible char lines. Do not add any oil to the pan.
3. Transfer to a plate, squeeze over the lemon juice and scatter with the zest, chilli flakes and toasted flaked almonds. Season with sea salt and serve.','How it''s kept light: Chargrilled, lemon and chilli, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) until the',60.0,'master',false,null),
('R183','Parmesan Green Beans (side)','lunchdinner',1,'1. Bring a pan of water to the boil and blanch the green beans for 3-4 mins until just tender but still with a bite.
2. Drain well and pat dry, then transfer to a serving dish.
3. Shave over the parmesan while the beans are still warm so it lightly softens, season with black pepper and a pinch of salt, and serve.','How it''s kept light: Steamed/blanched, light parmesan shaving, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values',70.0,'master',false,null),
('R184','Bang Bang Cauliflower (side)','lunchdinner',1,'1. Preheat oven to 200°C. Toss the cauliflower florets in the cornflour, smoked paprika and garlic powder until evenly coated.
2. Spread out on a lined baking tray, spray lightly with oil and bake for 20-25 mins, turning halfway, until golden and crisp at the edges.
3. Whisk the yoghurt and sriracha together to make the bang bang sauce.
4. Toss the baked cauliflower through the sauce, scatter with sliced spring onion and serve immediately.','How it''s kept light: Oven-baked not deep-fried, light spiced yoghurt-based sauce not mayo-heavy

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingre',120.0,'master',false,null),
('R185','Tomato Salsa (side)','lunchdinner',1,'1. Combine the diced tomatoes and red onion in a bowl.
2. Add the lime juice, chopped coriander, chilli flakes and a pinch of salt.
3. Stir to combine and leave to stand for 5 mins before serving to let the flavours develop.','How it''s kept light: Fresh tomato, onion, lime, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) until they cl',35.0,'master',false,null),
('R186','Bombay Potatoes (side)','lunchdinner',1,'1. Boil the potato cubes for 8-10 mins until just tender, then drain well.
2. Heat the oil in a non-stick pan and fry the mustard and cumin seeds for 30 secs until they start to pop.
3. Add the onion and curry leaves and cook for 2-3 mins until softened.
4. Stir in the turmeric and chilli powder, then add the boiled potatoes and toss to coat, pan-frying for 4-5 mins until lightly spiced and golden. Season and serve.','How it''s kept light: Roasted/pan-spiced in minimal oil, not deep-fried

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) unt',155.0,'master',false,null),
('R187','Saag (side)','lunchdinner',1,'1. Heat the oil in a pan and fry the cumin seeds for 30 secs until fragrant.
2. Add the onion, garlic and ginger and cook for 3-4 mins until softened.
3. Stir in the garam masala and chilli powder, then add the spinach in batches, stirring until wilted.
4. Blend or roughly mash the mixture to your preferred texture, then stir through the yoghurt off the heat to finish. Season and serve.','How it''s kept light: Spinach, light spice, minimal ghee swapped for an oil spray

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library v',100.0,'master',false,null),
('R188','Honey Roasted Carrots (side)','lunchdinner',1,'1. Preheat oven to 200°C. Toss the carrots with the olive oil, salt and pepper on a lined baking tray.
2. Roast for 20 mins, then drizzle over the honey and scatter with thyme sprigs.
3. Return to the oven for a further 10-15 mins until tender and lightly caramelised.','How it''s kept light: Roasted with a light honey glaze, minimal oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) until t',105.0,'master',false,null),
('R189','Crispy Smashed Potatoes (side)','lunchdinner',1,'1. Boil the baby potatoes for 12-15 mins until tender. Drain and allow to steam-dry for a few minutes.
2. Preheat oven to 220°C. Place the potatoes on a lined baking tray and gently smash each one with the back of a fork.
3. Drizzle with the olive oil, scatter over the garlic, rosemary and parmesan, and season with sea salt.
4. Roast for 25-30 mins until golden and crisp at the edges.','How it''s kept light: Oven-roasted with a minimal oil spray, not deep-fried

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values)',170.0,'master',false,null),
('R190','Mashed Potato & Carrot (side)','lunchdinner',1,'1. Boil the potato and carrot together for 15-18 mins until soft. Drain well.
2. Mash thoroughly, then stir in the skimmed milk and olive oil until smooth and creamy.
3. Season with white pepper, scatter with chopped chives and serve.','How it''s kept light: Mashed with a splash of skimmed milk, no added butter

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values)',140.0,'master',false,null),
('R191','Hummus (Variations) (side)','lunchdinner',1,'1. Add the chickpeas, tahini, lemon juice, garlic and cumin to a food processor.
2. Blend, adding a splash of cold water gradually, until smooth and creamy.
3. Season with sea salt and blend again briefly. Vary with roasted red pepper, beetroot or coriander & lime for different flavour profiles as needed.
4. Transfer to a bowl and serve.','How it''s kept light: Chickpea-based, light tahini, no added oil drizzle

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) un',140.0,'master',false,null),
('R192','Corn on the Cob (side)','lunchdinner',1,'1. Steam the corn cob for 8-10 mins until tender, or blanch in boiling water for the same time.
2. Heat a griddle pan and char the steamed cob for 3-4 mins, turning, until lightly blistered.
3. Squeeze over the lime juice, dust with chilli powder, scatter with coriander and a pinch of salt, then serve.','How it''s kept light: Steamed/grilled, no added butter

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) until they close. Tr',120.0,'master',false,null),
('R193','Leaf Salad (side)','lunchdinner',1,'1. Arrange the mixed leaves, cherry tomatoes and cucumber in a serving bowl.
2. Whisk together the olive oil and balsamic vinegar to make a light vinaigrette.
3. Drizzle over the salad just before serving, season with sea salt and black pepper, and toss lightly.','How it''s kept light: Mixed leaves, light vinaigrette, oil kept minimal

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values) unt',35.0,'master',false,null),
('R194','Guacamole (side)','lunchdinner',1,'1. Scoop the avocado into a bowl and roughly mash with a fork to your preferred consistency.
2. Stir through the tomato, red onion, lime juice and coriander.
3. Season with chilli flakes and sea salt, mix well and serve immediately.','How it''s kept light: Avocado''s natural fat only, lime, tomato, no added oil

DRAFT RECIPE: first-pass ingredients and method written from the Menus 2.docx placeholder name and macro target (no original ingredients/method existed for this dish). Quantities are an initial estimate aimed at the Published macros to the left, not yet reconciled - check the Ingredient-Sum and Variance columns once this recipe is added to the Recipe Ingredients sheet, and adjust quantities (or Ingredient Library values',115.0,'master',false,null),
('R195','Honey & Oat Coated Chicken Goujons with Sweet Potato & Balsamic Salad','lunchdinner',2,'1. Preheat oven to 180C. 2. Whisk egg with milk; blend oats and spice in a separate bowl. 3. Dip chicken in egg mix, then coat in oat/spice mix. 4. Place on a lined tray, drizzle with olive oil and honey; add sweet potato wedges alongside. 5. Bake 25-30 mins until cooked through. 6. Toss cherry tomatoes through the lambs lettuce with a balsamic drizzle and serve alongside.','NEW RECIPES START HERE (added 2026-09-11, R195 onward) — Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',667.0,'master',false,null),
('R196','Vanilla & Coconut Protein Balls','snack',6,'1. Mix oats, whey, dried fruit and nuts. 2. Add milk, honey and peanut butter; mix thoroughly. 3. Roll into 12 balls (2 balls = 1 serving). 4. Roll each ball in desiccated coconut. 5. Chill 2-3 hours before serving.','Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',360.0,'master',false,null),
('R197','Spiced Salmon & Sweet Potato Fries','lunchdinner',1,'1. Preheat oven to 180C. 2. Toss sweet potato wedges and onion with oil and cumin; roast 20-30 mins. 3. Add salmon to a tray, squeeze over lemon juice and sprinkle with chilli flakes; bake ~20 mins. 4. Boil the corn. 5. Serve salmon with the roast veg and sweetcorn.','Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',497.0,'master',false,null),
('R198','Thai Rainbow Prawn Salad','lunchdinner',2,'1. Cook noodles, drain and cool. 2. Heat sesame oil, peanut butter, chilli, water, honey and soy sauce into a thin sauce; cook the prawns in it 7-8 mins, then stir through the beansprouts off the heat. 3. Toss cooked noodles with the carrots, spring onion, coriander, mint, spinach, cabbage and pepper. 4. Add the prawns, beansprouts and sauce; squeeze over lime. Season and serve.','Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',501.0,'master',true,'The book had a second copy of this recipe (R032), written as a single serving. Not imported — this one agreed better with the stated calories.'),
('R200','Kiwi, Banana & Berry Recovery Smoothie','smoothie',1,'1. Blitz all ingredients in a blender until smooth.','Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',294.0,'master',false,null),
('R201','High Fuel Turkey Spaghetti Bolognese','lunchdinner',4,'1. Fry the onion 3-4 mins, add the turkey mince and cook 4-5 mins. 2. Add celery, garlic and carrots, cook 3-5 mins. 3. Stir in tomatoes, puree, herbs and Worcestershire sauce; season. 4. Simmer 20-30 mins. 5. Cook the spaghetti per pack instructions. 6. Serve the bolognese over the pasta, topped with parmesan.','Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',726.0,'master',false,null),
('R202','Banana & Choc Chip Protein Pancakes','breakfast',1,'1. Blend the eggs, 1 banana and protein powder until smooth. 2. Heat coconut oil in a pan. 3. Cook small pancakes in batches, 45-90 secs each side. 4. Top with blueberries, chocolate chips, sliced banana and honey.','Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',629.0,'master',false,null),
('R203','Quick & Juicy Turkey Burgers','lunchdinner',5,'1. Fry onion and garlic in oil 3-5 mins, add oats and fry 2 more mins; cool. 2. Add turkey, carrot, apricots and egg; mix and shape into 5 patties. 3. Seal each side 3-4 mins in a hot pan, then bake at 200C for 12-15 mins. 4. Build the burgers with relish, patty, avocado, tomato and lettuce.','Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',491.0,'master',false,null),
('R204','Carrot Cake Overnight Oats','breakfast',1,'1. Mix the oats, milk, yogurt, sultanas, walnuts, carrot, cinnamon and nutmeg in a bowl. 2. Transfer to a sealed jar/tub and leave overnight in the fridge.','Transcribed from a Close Nutrition-branded recipe-card image. Photo-transcribed - worth a spot check against the source card.',504.0,'master',false,null),
('R205','Tomato & Feta Omelette','breakfast',1,'1. Heat the oil, add the tomato and fry. Whisk the eggs with the mixed herbs and pour into the pan. 2. After 2-3 mins flip or grill; add the feta and serve.','Transcribed from a Close Nutrition-branded recipe-card image. Photo-transcribed - worth a spot check against the source card.',322.0,'master',false,null),
('R206','Spicy Vegetable Thai Green Curry','lunchdinner',4,'1. Heat oil, add ginger, chilli and tofu, cook 6-8 mins until browned. 2. Add coconut milk, curry paste, lime juice, peanut butter and soy sauce; simmer 15 mins. 3. Cook the rice. Serve together.','Transcribed from a Close Nutrition-branded recipe-card image. Photo-transcribed - worth a spot check against the source card.',611.0,'master',true,'The book had a second copy of this recipe (R053). Not imported — this one agreed better with the stated calories.'),
('R207','Lamb Steak with Spiced Sweet Potato Mash','lunchdinner',1,'1. Boil and mash the sweet potato with cinnamon and a little Greek yogurt for creaminess. 2. Rub the lamb with oil, cumin, smoked paprika, salt and pepper; sear 3-4 mins each side, rest 5 mins. 3. Steam the green beans. 4. Plate the mash, top with the lamb and serve with the green beans.','Close Nutrition-branded card - no nutrition figure was given on the source card, so Published macros below are the workbook''s own ingredient-calculated total (see Notes & Conversions).',490.0,'master',false,null),
('R208','Soy & Ginger Glazed Salmon with Coconut Rice and Stir-fried Veg','lunchdinner',1,'1. Cook the rice, stirring in coconut milk for the last 2-3 mins. 2. Mix soy sauce, honey, ginger, garlic and rice vinegar; brush half over the salmon. 3. Pan-fry the salmon skin-side down 4-5 mins, flip, brush with remaining glaze, cook 3-4 mins more. 4. Stir-fry the vegetables in sesame oil 5-7 mins. 5. Plate the rice, top with salmon and vegetables; garnish with sesame seeds and lime.','Close Nutrition-branded card - no nutrition figure was given on the source card, so Published macros below are the workbook''s own ingredient-calculated total (see Notes & Conversions). "Mixed vegetables" quantity approximated as pepper for macro purposes.',533.8,'master',false,null),
('R209','Garlic & Herb Lamb with Potato Wedges & Roasted Veg','lunchdinner',1,'1. Toss potato wedges with half the oil, salt, pepper and herbs; roast 25-30 mins. 2. Toss the vegetables with the remaining oil and herbs; roast alongside. 3. Rub the lamb with garlic, herbs, salt and pepper; sear 3-4 mins each side, rest 5 mins. 4. Steam the green veg. Plate together.','Close Nutrition-branded card - no nutrition figure was given on the source card, so Published macros below are the workbook''s own ingredient-calculated total (see Notes & Conversions).',399.8,'master',false,null),
('R210','Lemon Salmon with Sweet Potato and Vegetables','lunchdinner',1,'1. Toss sweet potato wedges with oil, chilli flakes, lemon juice and pepper; roast at 200C for 25-30 mins. 2. Pour the oil mixture over the salmon, pan-fry skin-side down 5-7 mins, flip, cook 5-7 mins more. 3. Steam the vegetables 10 mins. 4. Serve together.','Close Nutrition-branded card.',631.0,'master',false,null),
('R211','Jerk Chicken with Charred Courgette and Cous Cous','lunchdinner',1,'1. Season the chicken with jerk seasoning. 2. Slice and season the courgette. 3. Griddle the chicken and courgette. 4. Cover the cous cous with an equal amount of boiling water, cover 5 mins. 5. Arrange the cous cous and courgette on a plate, slice the chicken on top.','Close Nutrition-branded card.',459.0,'master',false,null),
('R212','Lamb Kofta','lunchdinner',4,'1. Finely chop the onion and mince the garlic. 2. Season the lamb mince with black pepper and chilli flakes; roll into ~12 balls. 3. Fry the onion and garlic in oil 2-3 mins, add the lamb balls, fry 10 mins turning occasionally, season with cumin, paprika, coriander and parsley. 4. Cook the rice. 5. Add the tomatoes, simmer 15-20 mins until reduced. Garnish with sliced red chilli. Serve with rice.','Close Nutrition-branded card.',507.0,'master',false,null),
('R213','Anti Inflammatory Green Smoothie','smoothie',1,'1. Blend all ingredients until smooth.','Transcribed from a Close Nutrition-branded recipe-card image. Photo-transcribed - worth a spot check against the source card.',282.0,'master',false,null),
('R214','Peanut Butter Chocolate Smoothie','smoothie',1,'1. Blend all ingredients until smooth.','Transcribed from a Close Nutrition-branded recipe-card image. Photo-transcribed - worth a spot check against the source card.',291.0,'master',false,null),
('R215','Berry Repair Smoothie','smoothie',1,'1. Blend all ingredients until smooth.','Transcribed from a Close Nutrition-branded recipe-card image. Photo-transcribed - worth a spot check against the source card.',292.0,'master',false,null),
('R216','Chilli & Lime Salmon with Blueberry Cous Cous','lunchdinner',1,'1. Cover the cous cous with water and leave 10-15 mins to absorb. 2. Season the salmon, rub with lime juice, oil and chilli. 3. Bake at 180C for 8-10 mins. 4. Toss rocket, blueberries and mint through the cous cous. 5. Serve the salmon on the cous cous, drizzled with balsamic glaze.','Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',556.0,'master',false,null),
('R217','Vegetable Tagine with Apricot Quinoa','lunchdinner',4,'1. Fry the onion 3 mins, add garlic and squash, cook 7 mins. 2. Add remaining vegetables, then chickpeas, tomatoes, stock and spices; simmer 30 mins uncovered. 3. Cook the quinoa; stir in the apricots and almonds with a pinch of salt. 4. Whisk tahini and lemon juice for the dressing. 5. Serve the tagine over the quinoa, drizzled with the tahini dressing.','Source card''s instructions (''stir in the apricots and almonds'') and its photo both show almonds, but the printed ingredient list omits them - added a reasonable handful (15g flaked almonds) to match. Transcribed from a Hexis-branded recipe-card image (KM37 weekly meal-plan decks). Photo-transcribed - worth a spot check against the source card.',461.0,'master',true,'MACRO MISMATCH: ingredient list computes 50% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R218','Overnight Oats (Base Recipe)','breakfast',1,'1. Combine all ingredients in a jar or tub, cover and refrigerate 6+ hours.','From the flexible ''Breakfasts & Snacks'' options grid (Menu_WB13thJan deck) - a fixed-quantity version of a ''choose your own'' option. No nutrition figure was given, so Published macros below are the workbook''s own ingredient-calculated total.',343.6,'master',false,null),
('R219','Almond Berry Shake','smoothie',1,'1. Blend all ingredients until smooth.','From the flexible ''Breakfasts & Snacks'' options grid (Menu_WB13thJan deck) - a fixed-quantity version of a ''choose your own'' option. No nutrition figure was given, so Published macros below are the workbook''s own ingredient-calculated total.',269.1,'master',false,null),
('R220','Greens & Berry Shake','smoothie',1,'1. Blend all ingredients until smooth.','From the flexible ''Breakfasts & Snacks'' options grid (Menu_WB13thJan deck) - a fixed-quantity version of a ''choose your own'' option. No nutrition figure was given, so Published macros below are the workbook''s own ingredient-calculated total. "Kale" approximated using spinach values.',268.2,'master',false,null),
('R221','Banana & Peanut Butter Shake','smoothie',1,'1. Blend all ingredients until smooth.','From the flexible ''Breakfasts & Snacks'' options grid (Menu_WB13thJan deck) - a fixed-quantity version of a ''choose your own'' option. No nutrition figure was given, so Published macros below are the workbook''s own ingredient-calculated total.',393.9,'master',false,null),
('R222','High Protein Weetabix','breakfast',1,'1. Combine Weetabix Protein biscuits with milk, top with sliced banana and chia seeds.','From the flexible ''Breakfasts & Snacks'' options grid (Menu_WB13thJan deck) - a fixed-quantity version of a ''choose your own'' option. No nutrition figure was given, so Published macros below are the workbook''s own ingredient-calculated total. "Full fat milk" macros approximated using semi-skimmed milk values.',481.3,'master',false,null),
('R223','M&S High Protein Pancakes with Yoghurt & Banana','breakfast',1,'1. Warm the pancakes, top with Greek yoghurt and sliced banana.','From the flexible ''Breakfasts & Snacks'' options grid (Menu_WB13thJan deck) - a fixed-quantity version of a ''choose your own'' option. No nutrition figure was given, so Published macros below are the workbook''s own ingredient-calculated total.',342.0,'master',false,null),
('R224','Revive & Refuel: Haddock with Recovery Rice','lunchdinner',1,'1. Cook the fish and rice. 2. Sauté the spinach. 3. Mix the Greek yogurt with turmeric for the sauce. 4. Serve the fish over rice with edamame, spinach and the turmeric yogurt sauce.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',572.0,'master',false,null),
('R225','Steak and Superfood Iron Boost Bowl','lunchdinner',1,'1. Grill the steak to preference. 2. Cook the quinoa. 3. Roast the sweet potatoes and steam the broccoli. 4. Plate together.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',756.0,'master',false,null),
('R226','Korean Chicken Rice Bowl','lunchdinner',1,'1. Grill the chicken. 2. Cook the rice and steam the spinach. 3. Assemble the bowl with kimchi, drizzle with gochujang and sesame oil, top with sesame seeds.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',521.0,'master',false,null),
('R227','Performance Power Plate: Nitrate Rich Salmon & Roots','lunchdinner',1,'1. Grill the salmon. 2. Roast the sweet potato and beetroot. 3. Sauté the spinach with garlic in olive oil. 4. Toss the beetroot with rocket and a little olive oil. 5. Serve everything together with the bread roll.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',720.0,'master',false,null),
('R228','Nitrate Rich Crumble & Crème Anglaise','snack',4,'1. Combine the fruit base ingredients in a baking dish. 2. Mix the crumble ingredients and scatter over the fruit. 3. Bake until golden and bubbling. 4. Warm the milk, whisk with vanilla, cornflour, egg yolks and sugar over a low heat until thickened for the crème anglaise. 5. Serve the crumble with the crème anglaise.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',327.0,'master',false,null),
('R229','Beef Teriyaki Recovery Bowl','lunchdinner',1,'1. Cook the beef, noodles and rice. 2. Stir-fry the vegetables with sesame oil. 3. Combine everything in a bowl, drizzle with teriyaki and soy sauce, top with avocado, chia seeds and leafy greens.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series). (Game Day post-match meal.)',633.0,'master',false,null),
('R230','Chicken & Vegetable Rice Bowl','lunchdinner',1,'1. Cook the chicken strips in olive oil. 2. Stir-fry the vegetables with garlic and ginger in sesame oil, add soy sauce. 3. Serve over the cooked brown rice.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',420.0,'master',false,null),
('R231','Turkey Noodle Stir-Fry','lunchdinner',1,'1. Cook the noodles. 2. Stir-fry the turkey until cooked, push aside and scramble in the eggs. 3. Add the vegetables and garlic, stir-fry until tender. 4. Add the noodles, soy sauce, oyster sauce and sesame oil; toss together.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',670.0,'master',true,'MACRO MISMATCH: ingredient list computes 52% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R232','Chicken Quinoa Power Bowl','lunchdinner',1,'1. Cook the chicken breast. 2. Cook the quinoa. 3. Sauté the vegetables with garlic powder and paprika. 4. Combine in a bowl.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',403.0,'master',false,null),
('R233','Tuna Lettuce Wraps','lunchdinner',1,'1. Mix the tuna with yogurt, red onion, celery, parsley and Dijon mustard; season. 2. Spoon into the lettuce leaves and serve.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',165.0,'master',false,null),
('R234','High Protein Loaf','snack',8,'1. Combine all ingredients into a batter. 2. Pour into a lined loaf tin. 3. Bake at 180C until set and a skewer comes out clean. 4. Cool, then slice.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',204.0,'master',false,null),
('R235','Dark Chocolate & Goji Berry ''Rocky Road'' Bites','snack',8,'1. Melt the chocolate. 2. Stir in the mixed nuts, honey and goji berries. 3. Spoon into 8 bite-sized portions on baking paper. 4. Chill until set (optionally sprinkle with desiccated coconut).','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',180.0,'master',false,null),
('R236','Chicken & Chickpea Curry','lunchdinner',1,'1. Fry the onion, garlic and ginger in oil. 2. Add the chicken and brown. 3. Stir in curry powder and cumin, then chickpeas, tomatoes and coconut milk. 4. Simmer until the chicken is cooked through. 5. Serve with rice.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',460.0,'master',false,null),
('R237','Spaghetti Carbonara','lunchdinner',1,'1. Cook the spaghetti. 2. Whisk the egg yolk, parmesan and cream together. 3. Toss the hot pasta with the chicken, peas and egg mixture off the heat, so it thickens into a sauce. Season and serve.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',606.0,'master',false,null),
('R238','Power-Packed Chicken Stroganoff','lunchdinner',1,'1. Fry the chicken in oil until browned; set aside. 2. Fry the onion and garlic, add the mushrooms, paprika and thyme. 3. Return the chicken, stir in mustard, yoghurt and stock; simmer gently (do not boil). 4. Cook the rice. 5. Serve the stroganoff over rice, topped with parsley and a squeeze of lemon.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',608.0,'master',false,null),
('R239','Chicken Linguini','lunchdinner',1,'1. Cook the linguini. 2. Pan-fry the chicken and garlic in oil. 3. Add the cream and parmesan, toss with the drained pasta. Season and serve.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',812.0,'master',false,null),
('R240','Mini Omelette Muffins','snack',2,'1. Whisk the eggs with almond milk. 2. Stir in cheese, spinach, salt, pepper and garlic powder. 3. Pour into a greased muffin tin. 4. Bake at 180C for ~15-18 mins until set.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',249.0,'master',false,null),
('R241','Mediterranean Performance Tilapia with Sweet Potato & Roasted Veg','lunchdinner',1,'1. Roast the sweet potato. 2. Roast the onion, peppers and courgette with oil, oregano, basil and paprika. 3. Simmer the tinned tomatoes with garlic, oregano, balsamic vinegar, paprika and chilli flakes for the sauce. 4. Pan-fry or bake the tilapia with lemon juice. 5. Serve together.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',450.0,'master',false,null),
('R242','Mackerel Muscle Recovery Fuel','lunchdinner',1,'1. Pan-fry or grill the mackerel with oil, salt, pepper and lemon juice. 2. Toss the salad leaves, avocado, red pepper, cucumber and red onion. 3. Whisk the ginger, turmeric, vinegar and oil for the dressing. 4. Serve the mackerel over the salad, drizzled with dressing.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',520.0,'master',false,null),
('R243','Anti-Inflammatory Ginger Salmon Bowl with Leafy Greens & Golden Wedges','lunchdinner',1,'1. Toss the potato wedges with oil, paprika, garlic powder, salt and pepper; roast at 200C for 25-30 mins. 2. Mix ginger, garlic, soy sauce, honey, lemon juice and oil; marinate and pan-fry or bake the salmon in it, topping with sesame seeds. 3. Sauté the spinach/kale with garlic, oil and lemon juice. 4. Serve the salmon over the greens with the wedges.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',648.0,'master',false,null),
('R244','Rebuild Fuel – Lamb Chop & Sweet Potato','lunchdinner',1,'1. Rub the lamb chop with oil, garlic, rosemary, salt and pepper; pan-fry to preference, finish with lemon juice. 2. Roast the sweet potato. 3. Roast or steam the pepper and broccoli. 4. Plate together.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',492.0,'master',false,null),
('R245','Tendon ''Power Cod'' with Buttered Veggies and Quinoa','lunchdinner',1,'1. Grill the cod. 2. Steam the broccoli and carrots, toss with butter. 3. Cook the quinoa, drizzle with olive oil. 4. Serve together.','Source card lists ''20g grilled cod fillet'', inconsistent with the stated 27g protein / 467kcal for a single serving - corrected to 200g. Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',481.0,'master',false,null),
('R246','Peanut Butter and Banana Overnight Oats','breakfast',1,'1. Combine all ingredients in a jar, cover and refrigerate overnight.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',507.0,'master',false,null),
('R247','Black Bean, Chicken & Sweetcorn Quesadilla','lunchdinner',2,'1. Cook and dice the chicken. 2. Fry the pepper and chilli in oil with cumin, paprika and oregano, add the beans, sweetcorn and chicken. 3. Fill the tortillas with the mixture and cheese, fold and pan-fry until golden. 4. Serve with a lime wedge.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',528.0,'master',false,null),
('R248','Sriracha Chicken Rice Bowl','lunchdinner',2,'1. Cook the chicken and rice. 2. Steam the broccoli and corn. 3. Combine in a bowl with the black beans, drizzle with sriracha and a squeeze of lime.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',645.0,'master',true,'The book had a second copy of this recipe (R048), written as a single serving. Not imported — this one agreed better with the stated calories.'),
('R249','Smoked Salmon, Scrambled Eggs & Avocado on Sourdough','breakfast',1,'1. Whisk the eggs with milk; scramble gently in oil. 2. Toast the sourdough. 3. Top the toast with mashed avocado, scrambled eggs and smoked salmon. Season and serve.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',541.0,'master',false,null),
('R250','Tendon Repair Fish Cakes','lunchdinner',1,'1. Flake the mackerel and tuna into a bowl. 2. Finely dice the red onion; mix in with the egg, breadcrumbed bread, cottage cheese, red pepper sauce, coriander, mustard and black pepper. 3. Shape into cakes and pan-fry in the oil until golden. 4. Serve with a colourful salad.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',605.0,'master',false,null),
('R251','Super Healing – Chicken & Bone Broth Soup','lunchdinner',1,'1. Bring the bone broth to a simmer with the carrots, celery, onion and quinoa. 2. Cook until the quinoa and vegetables are tender. 3. Stir through the shredded chicken and heat through.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',265.0,'master',false,null),
('R252','Salmon & Avocado Rehab Bowl','lunchdinner',1,'1. Season the salmon with paprika, garlic powder, salt and pepper; pan-fry with oil, finish with lemon juice. 2. Mix the avocado, red onion, tomato, coriander and lime juice for the salsa. 3. Sauté the cauliflower rice with garlic in oil. 4. Serve the salmon over the cauliflower rice, topped with the avocado salsa.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',424.0,'master',false,null),
('R253','Power Plate: Herb-Crusted Lamb Chop with Veggies & Potatoes','lunchdinner',1,'1. Rub the lamb chop with oil, garlic, herbs, salt and pepper; pan-fry to preference, finish with lemon juice. 2. Roast or steam the carrots and green beans in oil. 3. Roast the potatoes in oil. 4. Plate together.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',560.0,'master',false,null),
('R254','Chicken Fajitas','lunchdinner',1,'1. Slice the chicken, peppers and onion. 2. Fry in oil with fajita seasoning until cooked. 3. Serve in the tortilla with salsa and yogurt or guacamole.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',530.0,'master',false,null),
('R255','Spaghetti & Meatballs','lunchdinner',5,'1. Shape the beef mince into meatballs. 2. Brown in oil, remove. 3. Fry the onion and garlic, add tomatoes, roasted peppers, puree and mustard; simmer. 4. Return the meatballs to the sauce and simmer until cooked through. 5. Cook the spaghetti and serve with the sauce.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series).',463.0,'master',false,null),
('R256','Super Tendon Repair Fish Cakes','lunchdinner',1,'1. Flake the mackerel and tuna into a bowl. 2. Finely dice the red onion; mix in with the egg, breadcrumbed bread, cottage cheese, red pepper sauce, coriander, mustard and black pepper. 3. Shape into cakes and pan-fry in the oil until golden. 4. Serve with a colourful salad.','Extracted from the KM37 weekly meal-plan deck text (performance/game-day meal series). Kept as a separate row from "Tendon Repair Fish Cakes" per Graeme''s instruction to keep differently-worded near-duplicates separate rather than silently merge them.',605.0,'master',false,null),
('R257','Berry Brekkie Smoothie','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',223.0,'master',false,null),
('R258','Chocberry Smoothie','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',304.0,'master',false,null),
('R259','Chocolate and Pear Smoothie','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. Wyldsson Hazelnut and',270.0,'master',false,null),
('R260','Simple Berry Yoghurt Smoothie','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',333.0,'master',false,null),
('R261','Raisin-Nut Smoothie','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',317.0,'master',false,null),
('R262','Blueberry, Strawberry Smoothie Immune Boost','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. CONFIRMED with Graeme',303.0,'master',false,null),
('R263','Banana & Peanut Butter (Weight Gain Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',622.0,'master',false,null),
('R264','Banana and Nutella (Weight Gain Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. ''Wyldsson Nutella'' ma',516.0,'master',false,null),
('R265','Choco Banana Butter (Weight Gain Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',582.0,'master',false,null),
('R266','Oaty Banana (Weight Gain Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',548.0,'master',false,null),
('R267','Cherry, Berry Green (Recovery Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',494.0,'master',false,null),
('R268','Greens Boost Smoothie (Green Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',376.0,'master',false,null),
('R269','Peach & Ginger Green Boost (Immune Boost Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',221.0,'master',false,null),
('R270','Ginger Boost (Immune Boost, Low Cal Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. Dried cranberries map',180.0,'master',false,null),
('R271','Kiwi & Strawberry (Recovery Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',364.0,'master',false,null),
('R272','Fruity Yoghurt & Orange Smoothie (Recovery Option)','smoothie',1,'1. Add all ingredients into a blender & blitz.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',465.0,'master',false,null),
('R273','Chia Seed Pudding (High-Protein, Low-Sugar)','snack',1,'1. Mix Ingredients - In a bowl or jar, whisk together the chia seeds, almond milk, protein powder, vanilla extract, and cinnamon until fully combined. 2. Let It Sit - Allow the mixture to rest for 5 minutes, then stir again to prevent clumping. 3. Refrigerate - Cover and place in the fridge for at least 2 hours, or preferably overnight. 4. Check Consistency - If too thick, add a splash of milk and stir; if too thin, let it sit longer. 5. Serve - Enjoy plain or topped with a few nuts, seeds, or a sprinkle of unsweetened coconut.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',297.0,'master',false,null),
('R274','High-Protein Overnight Oats (Low-Sugar, Light on the Stomach)','breakfast',1,'1. Mix Ingredients - In a jar or bowl, combine oats, chia seeds, flaxseeds, protein powder, cinnamon, and vanilla. 2. Add Liquid - Pour in the almond milk and stir well. 3. Rest & Stir - Let sit for 5 minutes, then stir again. 4. Refrigerate Overnight - Cover and place in the fridge for at least 4 hours, preferably overnight. 5. Adjust Consistency - If too thick, add a splash of milk. 6. Serve - Eat as is, or top with a few crushed nuts or seeds.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',408.0,'master',false,null),
('R275','Mini Omelette Muffins (High-Protein, Low-Carb, Light on the Stomach)','breakfast',6,'1. Preheat oven to 180°C (350°F) and grease a muffin tin. 2. Whisk together the eggs, almond milk, salt, pepper, and garlic powder. 3. Chop the spinach and shred the cheese; distribute into the muffin tin cups. 4. Pour the egg mixture into each cup, filling about ¾ full. 5. Bake for 15-18 minutes, until set and slightly golden. 6. Let cool for a few minutes before removing from the tin. Makes 6 mini muffins.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',70.0,'master',true,'MACRO MISMATCH: ingredient list computes 84% HIGHER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R276','Banana Choc-chip Muffin','snack',8,'1. Mash the bananas in a bowl. 2. Mix the egg and milk together and beat very well. 3. Add the rest of the ingredients to the egg and milk mixture and beat well. 4. Line 8 muffin cases with a large circle of greaseproof paper. 5. Spoon around 2 dessert spoonfuls of the mixture into each muffin case. 6. Bake in a preheated oven for 20 minutes at 180C.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. Wholemeal/plain flour',82.0,'master',false,null),
('R277','Banoffee Treat','snack',1,'1. Crush the digestive biscuits and put at the bottom of a wide tumbler or bowl. 2. Thinly slice the banana and place on top of the digestives. 3. Spoon the yoghurt on top. 4. Drizzle with honey. 5. Eat!','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',305.0,'master',false,null),
('R278','Beetroot & Chocolate Brownies','snack',20,'1. Put beetroot in a bowl with a splash of water, cover with clingfilm and cook in microwave for 7 mins. 2. Drain and put in a blender with chocolate (in chunks), vanilla essence and butter. Blitz until smooth. 3. Whisk eggs and honey together until frothy, fold in the beetroot mixture. 4. Blitz the oats, cocoa powder and baking powder together to form a flour; add to the beetroot mixture. 5. Pour into a lined 20cm x 20cm tin and bake at 150C for 45 mins, until the top has small cracks all over. 6. Leave in tin until cooled then slice and enjoy! Makes 20 brownies (published figures are per brownie).','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',159.0,'master',false,null),
('R279','Cinnamon and Raisin Oat Bread','snack',12,'1. In a large bowl, mix all the ingredients together thoroughly. 2. Pour the mixture into a lined bread tin. 3. Bake at 180C for 30-40 minutes. 4. Let sit for an hour or overnight in the fridge before slicing. Makes approximately 12 slices (published figures are per slice).','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',168.0,'master',false,null),
('R280','High Protein Loaf Protein & Energy Rich','snack',10,'1. Pre-heat oven to 180 degrees and line a loaf tin with baking parchment. 2. In a large mixing bowl, add the porridge oats, chia seeds, yoghurt, whey, ground cinnamon and milk and whisk together until smooth. 3. Finely slice the banana and add half of it to the mixture along with the blueberries and goji berries. 4. Pour into the loaf tin and place the remaining banana slices over the top. 5. Bake for 45 minutes until golden brown and cooked through. 6. Serve with a drizzle of honey, maple syrup or a dollop of Greek yoghurt! Recipe makes 10 slices (published figures are per slice).','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',204.0,'master',false,null),
('R281','Oat & Walnut Banana Bread','snack',8,'1. Set aside the oats in a large mixing bowl. 2. Blend the remainder of the ingredients together and pour over the oats. 3. Mix thoroughly until the oats are fully coated. 4. Pour into a lined bread tin and bake at 180C for 30-40 minutes. 5. Remove whilst slightly sticky in the middle and let cool in the tin for 10 minutes before leaving to set in the fridge overnight. 6. Slice into 8 slices (published figures are per slice).','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',276.0,'master',false,null),
('R282','Low Cal Apple Crumble','snack',4,'1. Set the oven to 190C. 2. Peel and core the apples and cut into chunks. 3. Put the apples into a pan with the honey and 1 tablespoon of water, cook over a low heat until soft. 4. Place the flour and oats into a bowl and mix well; chop the butter in and rub together with your fingers. 5. Add the sugar to the crumble and mix through. 6. Put the apple into an oven proof dish. 7. Cover with the crumble mixture and bake for 20 minutes until golden brown.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. Wholemeal flour mappe',200.0,'master',false,null),
('R283','Chicken & Vegetable Rice Bowl Perfect for Fueling Performance & Recovery','lunchdinner',1,'1. Cook the rice or use pre-cooked microwave brown rice. 2. Heat olive oil in a pan; add chicken strips, season and cook until golden (6-8 mins). 3. Add garlic and ginger, stir for 1 minute. 4. Add chopped vegetables, stir-fry for 3-5 mins until tender-crisp. 5. Stir in soy sauce and sesame oil, cook a further minute. 6. Serve the chicken and vegetables over the rice, topped with spring onions and toasted sesame seeds if desired.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',420.0,'master',false,null),
('R284','Chicken Korma made with Greek Yoghurt','lunchdinner',4,'1. Heat the oil in a pan, add the onion and cook for 5 minutes until softened. 2. Add the curry paste with 50ml water, the garlic, chilli and ginger and cook for 5 minutes until reduced and thickened. 3. Add the chicken and fry for a couple of minutes. 4. Add another 50ml water, bring to a simmer, cover and cook for 10 minutes, then stir through the yoghurt and coconut milk. 5. Simmer for another 5 minutes. 6. Serve garnished with toasted almonds, a side salad of spinach and red pepper and a portion of basmati rice. Serves 4 (published figures are per serving).','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. Rice quantity (560g)',429.0,'master',false,null),
('R285','Chicken, Chili and Corn Soup','lunchdinner',4,'1. Melt the butter in a pan and cook the onion, garlic, bacon and chillies until soft but not brown. 2. Add stock and bring to the boil. 3. Add the remaining ingredients and simmer covered for 20 minutes. 4. Give a quick blend if preferred, or serve as it stands. 5. Season with black pepper and salt to taste. Serves 4 (published figures are per serving).','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. CONFIRMED with Graeme',324.0,'master',false,null),
('R286','Honey & Mustard Salmon with Herby New Potatoes & Buttered Greens','lunchdinner',1,'1. Mix the glaze ingredients and coat the salmon. 2. Bake at 200C (400F) for 12-15 mins (grill for 2 mins at the end). 3. Boil new potatoes for 15 mins, then toss with butter, parsley, thyme, salt and pepper. 4. Boil peas, broad beans & carrots for 4-5 mins, then mix with butter and mint. 5. Plate up the salmon, potatoes and greens; add a squeeze of lemon and black pepper to finish.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',782.0,'master',false,null),
('R287','Muscle Repair Fish Cakes','lunchdinner',1,'1. Peel and finely dice the onion; add to a mixing bowl. 2. Blitz a slice of bread in a blender and add to the bowl. 3. Chop the mackerel and tuna and add, with the coriander, red pepper sauce, black pepper, mustard, cottage cheese and egg. Mix well. 4. Form into fishcakes. 5. Fry in the oil over medium heat, 4 mins per side. 6. Serve with a colourful salad!','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. Nearly identical to t',605.0,'master',false,null),
('R288','Omelette Wrap','breakfast',1,'1. Chop the pepper, tomatoes, onion and ham. 2. Fry off the vegetables in olive oil for 2-3 minutes. 3. Whisk the eggs and milk, season, and add to the pan; shake until evenly distributed. 4. Cook for 3-4 mins without sticking. 5. Add the ham over the omelette and cook a further 1-2 mins. 6. Slide the omelette onto the wrap, roll, and press to seal.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',618.0,'master',false,null),
('R289','Peppered Beef and Broccoli Stir Fry','lunchdinner',4,'1. Rinse rice then cook in boiling water for about 12 minutes until tender; drain well. 2. Heat oil in a pan; stir-fry the beef and pepper over high heat for 2-3 mins until browned. Remove. 3. Reheat pan, add garlic and spring onion, stir-fry 1 minute; add remaining vegetables and stir-fry about 5 minutes. 4. Add oyster sauce and honey, stir through. 5. Return beef to the pan, stir until heated through, stir in coriander. Serve over rice.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. Rice quantity approxi',301.0,'master',false,null),
('R290','Poached Butter & Lemon Cod with Chunky Potato Wedges','lunchdinner',1,'1. Preheat oven to 200C. Peel and chop the potato into chunky wedges; toss with olive oil, salt and white pepper. Bake 25-30 mins, turning halfway. 2. In a small saucepan, heat stock, butter, lemon juice, salt and white pepper. Add the cod, cover and gently simmer for 6-8 minutes until it flakes easily. 3. Peel and steam the carrots and courgette (5-7 minutes). 4. Plate the poached cod with the lemony broth spooned over, the potato wedges, and the buttered vegetables on the side.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',325.0,'master',true,'WORTH A GLANCE: butter appears twice (''15g butter'' and ''1 tsp butter'') with no purpose label - plausible (poaching butter + a knob for the vegetables) but worth confirming it isn''t a duplicate entry.'),
('R291','Prosciutto Quiche','breakfast',4,'1. Preheat oven to 200C. 2. Lightly oil a mini muffin pan (4 cups). 3. Press 1 piece of prosciutto into each of 4 cups. 4. Whisk the egg whites and whole egg until smooth; add the yoghurt, olives, rosemary and a pinch of salt and pepper, whisk well. 5. Divide between the 4 cups. 6. Bake for 10-12 minutes until cooked through. Makes 4 (published figures are per quiche cup).','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. CONFIRMED with Graeme',60.0,'master',true,'MACRO MISMATCH: ingredient list computes 69% LOWER than Published Kcal (once divided by servings) - ingredients and/or published figure worth a second look against the source card.'),
('R292','Soy & Ginger Chicken Rice Bowl','lunchdinner',1,'1. Poach or bake the chicken until cooked; slice thin. 2. Cook the rice; melt butter in a pan and stir in grated ginger. 3. Add soy sauce, then stir the rice through the buttery ginger mix. 4. Chop and roast the carrots and courgette. 5. Assemble: rice in a bowl, chicken on top, roasted vegetables on the side. Drizzle with mild honey if desired.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. ''200g cooked white ri',575.0,'master',false,null),
('R293','Tuna Lettuce Wraps Lean, Protein-Packed Snack or Meal','snack',1,'1. Combine the drained tuna, Greek yogurt, diced red onion, diced celery, chopped parsley, Dijon mustard, salt and pepper in a bowl; mix well. 2. Wash and dry the lettuce leaves. 3. Spoon the tuna salad onto the centre of each leaf. 4. Fold the sides over and roll up from the bottom. 5. Serve with rice cakes if needed and a squeeze of lemon.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',165.0,'master',false,null),
('R294','Turkey Burger in a Wholegrain Bap with Sweet Potato Mash and Spicy Tomato Chutney','lunchdinner',4,'1. Combine the minced turkey, bread crumbs, chopped onion, parsley, Worcestershire sauce and hot sauce in a bowl; mix well. 2. Divide into 4 patties. 3. Grill until browned on both sides and heated through, about 7 mins a side. 4. Serve each burger on a bun topped with tomato, onion, lettuce and ketchup. 5. For the mash: cube and steam or boil the sweet potato until tender, then mash (add a splash of milk if desired). Serves 4 (published figures are per serving).','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',484.0,'master',false,null),
('R295','Turkey Noodle Stir-Fry High Protein Packed Meal','lunchdinner',1,'1. Cook the rice noodles per packet instructions; drain and set aside. 2. Heat olive oil in a wok. 3. Add turkey, season, and stir-fry until cooked through (4-5 mins). 4. Push turkey aside, add beaten eggs and scramble until just set. 5. Add garlic and vegetables, stir-fry 3-4 minutes. 6. Add the noodles, soy sauce, oyster sauce and sesame oil; mix well. 7. Add chilli flakes if using. 8. Serve hot, garnished with spring onions, sesame seeds and a lime wedge if desired.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual. CONFIRMED with Graeme',747.0,'master',false,null),
('R296','Vanilla & Banana Protein Pancakes','breakfast',1,'1. Blend the egg, banana and whey together. 2. Heat the coconut oil in a pan over medium heat. 3. Pour the mixture into small rounds, making 3-4 small pancakes. 4. Cook for 60 seconds on each side until browned. 5. Serve with fresh berries and Greek yoghurt.','Transcribed from the second 2026-09-11 PowerPoint upload (Nial_Breakfasts, CN_Branded_Smoothies, Tim_Lynch_recipes, PD20 and Suwi weekly meal-plan decks). Appears repeated across multiple weekly decks/personal archives; ingredient quantities are a reasonable single-serving estimate consistent with the card''s own published macros, not always an exact card transcription of vague measures like ''a handful'' or ''a chunk'' - flagged via the Ingredient-Sum/Variance columns as usual.',422.0,'master',false,null)
on conflict (name_key) do nothing;

-- ---------- ingredients ----------
create temporary table ri_stage (recipe_ext text, food_ext text, qty numeric, unit text, display_text text, min_qty numeric, max_qty numeric, macro_role text, sort_order integer) on commit drop;
insert into ri_stage values
('R001','ING001',0.5,'each','1/2 Medium Banana',null,1.0,'Carb',1),
('R001','ING002',38.0,'g','~38g Blueberries (3 Tbsp)',20.0,60.0,'Carb',2),
('R001','ING003',30.0,'g','~30g Raspberries (3 Tbsp)',15.0,45.0,'Carb',3),
('R001','ING004',30.0,'g','~30g 0% Fat Greek Yoghurt (2 Tbsp)',15.0,45.0,'Protein',4),
('R001','ING005',30.0,'g','~30g Vanilla Whey Protein (1 Scoop)',15.0,45.0,'Protein',5),
('R001','ING028',100.0,'ml','100ml Water',50.0,150.0,'Carb',6),
('R001','ING029',6.0,'g','6 Chunks of Ice',null,12.0,'Carb',7),
('R006','ING001',1.0,'each','1 Large Banana',0.5,1.5,'Carb',1),
('R006','ING004',15.0,'g','~15g 0% Greek Yoghurt (1 Tbsp)',null,30.0,'Protein',2),
('R006','ING007',32.0,'g','~32g Nut Butter (2 Tbsp)',16.0,48.0,'Fat',3),
('R006','ING005',30.0,'g','~30g Vanilla Whey Protein (1 Scoop)',15.0,45.0,'Protein',4),
('R006','ING008',40.0,'g','40g Rolled Oats',20.0,60.0,'Carb',5),
('R006','ING006',100.0,'ml','100ml Semi-Skimmed Milk',50.0,150.0,'Carb',6),
('R006','ING029',6.0,'g','6 Chunks of Ice',null,12.0,'Carb',7),
('R010','ING008',100.0,'g','100g Rolled Oats',50.0,150.0,'Carb',1),
('R010','ING005',50.0,'g','50g Whey Protein',25.0,75.0,'Protein',2),
('R010','ING009',100.0,'g','100g Peanut Butter',50.0,150.0,'Fat',3),
('R010','ING010',30.0,'g','30g Chia Seeds',15.0,45.0,'Carb',4),
('R010','ING011',50.0,'g','50g Honey',25.0,75.0,'Carb',5),
('R010','ING012',25.0,'g','25g Dark Choc Chips',10.0,40.0,'Carb',6),
('R010','ING004',60.0,'g','60g 0% Fat Greek Yoghurt',30.0,90.0,'Protein',7),
('R010','ING013',10.0,'g','10g Cocoa Powder',5.0,20.0,'Carb',8),
('R010','ING014',4.0,'g','~4g Vanilla Extract (1 Tsp)',2.0,6.0,'Carb',9),
('R011','ING015',240.0,'g','1 Can of Chickpeas (~240g drained)',200.0,280.0,'Carb',1),
('R011','ING005',30.0,'g','~30g Vanilla Protein (1 Scoop)',15.0,45.0,'Protein',2),
('R011','ING009',125.0,'g','125g of Peanut Butter',60.0,190.0,'Fat',3),
('R011','ING016',70.0,'g','70g Maple Syrup',35.0,105.0,'Carb',4),
('R011','ING017',1.0,'g','~1g Baking Powder (1/4 Teaspoon)',0.5,2.0,'Carb',5),
('R011','ING017',1.0,'g','~1g Bicarbonate Soda (1/4 Teaspoon)',0.5,2.0,'Carb',6),
('R011','ING014',1.0,'g','5-6 Vanilla Flavour Drops',null,2.0,'Carb',7),
('R011','ING012',50.0,'g','50g Dark Chocolate Chips',20.0,80.0,'Carb',8),
('R021','ING018',2.0,'each','2 Eggs',1.0,3.0,'Protein',1),
('R021','ING006',20.0,'ml','20ml Semi-Skimmed Milk',null,40.0,'Carb',2),
('R021','ING020',0.5,'each','1/2 Avocado',0.25,1.0,'Fat',3),
('R021','ING021',1.0,'each','~40g Sourdough (1 Slice)',1.0,2.0,'Carb',4),
('R021','ING022',2.0,'each','~30g Smoked Salmon (2 Slices)',1.0,4.0,'Protein',5),
('R021','ING023',4.0,'g','~4g Olive Oil (1 Tsp)',null,8.0,'Fat',6),
('R021','ING024',1.0,'g','Salt & Black Pepper',null,1.0,'Carb',7),
('R077','ING025',3.0,'each','3 Lean Chicken Sausages, grilled',2.0,4.0,'Protein',1),
('R077','ING018',2.0,'each','2 Whole Eggs, scrambled dry',1.0,3.0,'Protein',2),
('R077','ING019',2.0,'each','2 Egg Whites, scrambled dry',null,4.0,'Protein',3),
('R077','ING020',0.33,'each','1/3 Avocado',0.25,0.5,'Fat',4),
('R077','ING027',1.0,'each','1 Slice Wholegrain Bread, unbuttered',1.0,2.0,'Carb',5),
('R077','ING026',150.0,'g','Baked Beans (~150g) - DRAFT quantity, not yet reconciled',100.0,200.0,'Carb',6),
('R002','ING001',1.0,'each','1 Large Banana',null,2.0,'Carb',1),
('R002','ING030',45.0,'g','~45g 0% Greek Yoghurt (3 Tbsp)',22.5,67.5,'Protein',2),
('R002','ING193',30.0,'g','~30g Spinach (1 Handful)',15.0,45.0,'Protein',3),
('R002','ING060',20.0,'g','1/2 Celery',10.0,30.0,'Carb',4),
('R002','ING054',16.0,'g','~16g Nut Butter (1 Tbsp)',8.0,24.0,'Fat',5),
('R002','ING069',100.0,'ml','100ml Coconut Water',50.0,150.0,'Carb',6),
('R002','ING029',6.0,'g','6 Chunks of Ice',5.0,7.0,'Carb',7),
('R003','ING118',1.0,'each','1 Kiwi',null,2.0,'Carb',1),
('R003','ING005',30.0,'g','~30g Strawberry Protein (1 Scoop)',15.0,45.0,'Protein',2),
('R003','ING030',15.0,'g','~15g 0% Greek Yoghurt (1 Tbsp)',7.5,22.5,'Protein',3),
('R003','ING199',5.0,'g','5 Large Strawberries',2.5,7.5,'Carb',4),
('R003','ING011',14.0,'g','~14g Honey (2 Tsp)',7.0,21.0,'Carb',5),
('R003','ING028',100.0,'ml','100ml Water',50.0,150.0,'Carb',6),
('R003','ING029',6.0,'g','6 Chunks of Ice',5.0,7.0,'Carb',7),
('R004','ING001',1.0,'each','1 Large Banana',null,2.0,'Carb',1),
('R004','ING066',20.0,'g','~20g Chocolate Spread (1 Tbsp)',10.0,30.0,'Carb',2),
('R004','ING005',30.0,'g','~30g Chocolate Whey (1 Scoop)',15.0,45.0,'Protein',3),
('R004','ING030',30.0,'g','~30g 0% Greek Yoghurt (2 Tbsp)',15.0,45.0,'Protein',4),
('R004','ING006',250.0,'ml','250ml Semi-Skimmed Milk',125.0,375.0,'Carb',5),
('R004','ING011',42.0,'g','~42g Honey (2 Tbsp)',21.0,63.0,'Carb',6),
('R004','ING029',6.0,'g','6 Chunks of Ice',5.0,7.0,'Carb',7),
('R005','ING001',1.0,'each','1 Large Banana',null,2.0,'Carb',1),
('R005','ING199',6.0,'g','6 Strawberries',3.0,9.0,'Carb',2),
('R005','ING006',200.0,'ml','200ml Semi-Skimmed Milk',100.0,300.0,'Carb',3),
('R005','ING091',150.0,'g','150g Fat-Free Skyr',75.0,225.0,'Protein',4),
('R005','ING008',40.0,'g','40g Rolled Oats',20.0,60.0,'Carb',5),
('R005','ING029',6.0,'g','6 Chunks of Ice',5.0,7.0,'Carb',6),
('R007','ING005',30.0,'g','30g Vanilla Casein Protein',15.0,45.0,'Protein',1),
('R007','ING142',150.0,'g','~150g Frozen Berries (1 Cup)',75.0,225.0,'Carb',2),
('R007','ING006',150.0,'ml','150ml Semi Skimmed Milk',75.0,225.0,'Carb',3),
('R007','ING199',40.0,'g','~40g Fresh Berries (1 Handful)',20.0,60.0,'Carb',4),
('R007','ING010',4.0,'g','~4g Chia Seeds (1 Tsp)',2.0,6.0,'Carb',5),
('R008','ING005',60.0,'g','~60g Chocolate Whey (2 Scoops)',30.0,90.0,'Protein',1),
('R008','ING013',15.0,'g','15g Unsweetened Cocoa Powder',7.5,22.5,'Carb',2),
('R008','ING211',250.0,'ml','250ml Unsweetened Almond Milk',125.0,375.0,'Fat',3),
('R008','ING030',100.0,'g','100g Greek yogurt (0% fat)',50.0,150.0,'Protein',4),
('R008','ING007',15.0,'g','15g Natural Almond Butter',7.5,22.5,'Fat',5),
('R008','ING014',3.0,'g','3g vanilla extract (½ teaspoon)',1.5,4.5,'Carb',6),
('R008','ING029',5.0,'g','5 ice cubes',4.0,6.0,'Carb',7),
('R008','ING001',0.5,'each','1/2 Small Sliced Banana',null,1.5,'Carb',8),
('R008','ING212',10.0,'g','10g Unsweetened Coconut flakes',5.0,15.0,'Fat',9),
('R008','ING055',5.0,'g','5g cacao nibs',2.5,7.5,'Fat',10),
('R008','ING010',5.0,'g','5g chia seeds',2.5,7.5,'Carb',11),
('R008','ING083',0.5,'each','½ Crushed Digestive Biscuit',null,1.5,'Carb',12),
('R009','ING005',60.0,'g','~60g Strawberry or Vanilla Whey (2 Scoops)',30.0,90.0,'Protein',1),
('R009','ING013',15.0,'g','15g Unsweetened Cocoa Powder',7.5,22.5,'Carb',2),
('R009','ING211',250.0,'ml','250ml Unsweetened Almond Milk',125.0,375.0,'Fat',3),
('R009','ING030',100.0,'g','100g Greek yoghurt (0% fat)',50.0,150.0,'Protein',4),
('R009','ING007',15.0,'g','15g Natural Almond Butter',7.5,22.5,'Fat',5),
('R009','ING014',3.0,'g','3g vanilla extract (½ teaspoon)',1.5,4.5,'Carb',6),
('R009','ING029',5.0,'g','5 ice cubes',4.0,6.0,'Carb',7),
('R009','ING142',80.0,'g','~80g Mixed Berries (2 Handful)',40.0,120.0,'Carb',8),
('R009','ING212',10.0,'g','10g Unsweetened Coconut flakes',5.0,15.0,'Fat',9),
('R009','ING055',5.0,'g','5g cacao nibs',2.5,7.5,'Fat',10),
('R009','ING010',5.0,'g','5g chia seeds',2.5,7.5,'Carb',11),
('R009','ING083',0.5,'each','½ Crushed Digestive Biscuit',null,1.5,'Carb',12),
('R012','ING062',150.0,'g','1 Large Chicken Breast',75.0,225.0,'Protein',1),
('R012','ING054',16.0,'g','~16g Nut Butter (1 Tablespoon)',8.0,24.0,'Fat',2),
('R012','ING004',15.0,'g','~15g 0% Fat Greek Yoghurt (1 Tablespoon)',7.5,22.5,'Protein',3),
('R012','ING194',1.0,'each','1 x Spring Onion',null,2.0,'Carb',4),
('R012','ING184',1.0,'g','Seasoning to taste',0.5,1.5,'Carb',5),
('R013','ING163',150.0,'g','150g Pitted Dates',75.0,225.0,'Carb',1),
('R013','ING031',300.0,'g','300g Almond Butter',150.0,450.0,'Fat',2),
('R013','ING008',400.0,'g','400g Oats',200.0,600.0,'Carb',3),
('R013','ING082',100.0,'g','100g Dark Chocolate',50.0,150.0,'Carb',4),
('R014','ING030',200.0,'g','200g 0% Greek Yoghurt',100.0,300.0,'Protein',1),
('R014','ING011',7.0,'g','~7g Honey (1 Teaspoon)',3.5,10.5,'Carb',2),
('R014','ING199',50.0,'g','~50g Sliced Strawberries (1/4 Cup)',25.0,75.0,'Carb',3),
('R014','ING002',50.0,'g','~50g Blueberries (1/4 Cup)',25.0,75.0,'Carb',4),
('R014','ING003',40.0,'g','~40g Raspberries (1/4 Cup)',20.0,60.0,'Carb',5),
('R014','ING157',0.5,'each','1/2 Medium Sliced Peach(~75g)',null,1.5,'Carb',6),
('R014','ING215',7.0,'g','~7g Chopped Walnuts (1 Tablespoon)',3.5,10.5,'Fat',7),
('R014','ING010',12.0,'g','~12g Flaxseeds or Chia Seeds (1 Tablespoon)',6.0,18.0,'Carb',8),
('R014','ING212',5.0,'g','~5g Shredded Coconut (1 Tablespoon)',2.5,7.5,'Fat',9),
('R015','ING030',200.0,'g','200g 0% Greek Yoghurt',100.0,300.0,'Protein',1),
('R015','ING011',21.0,'g','~21g Honey (1 Tablespoon)',10.5,31.5,'Carb',2),
('R015','ING138',100.0,'g','1/2 Medium Diced Mango (~100g)',0.25,0.75,'Carb',3),
('R015','ING161',100.0,'g','1/4 Medium Diced Pineapple (~100g)',0.12,0.38,'Carb',4),
('R015','ING118',0.5,'each','1/2 Medium Sliced Kiwi (~50g)',null,1.5,'Carb',5),
('R015','ING212',5.0,'g','~5g Shredded Coconut (1 Tbsp)',2.5,7.5,'Fat',6),
('R015','ING010',12.0,'g','~12g Chia Seeds (1 Tbsp)',6.0,18.0,'Carb',7),
('R015','ING032',6.0,'g','~6g Sliced Almonds (1 Tbsp)',3.0,9.0,'Fat',8),
('R016','ING030',200.0,'g','200g 0% Greek Yoghurt',100.0,300.0,'Protein',1),
('R016','ING011',21.0,'g','~21g Honey (1 Tablespoon)',10.5,31.5,'Carb',2),
('R016','ING199',10.0,'g','10 Halved Strawberries',5.0,15.0,'Carb',3),
('R016','ING118',1.0,'each','1 Whole Diced Kiwi',null,2.0,'Carb',4),
('R016','ING158',25.0,'g','25g Pecan Nuts',12.5,37.5,'Fat',5),
('R016','ING010',12.0,'g','~12g Chia Seeds (1 Tbsp)',6.0,18.0,'Carb',6),
('R017','ING004',200.0,'g','200g 0% Fat Greek Yoghurt',100.0,300.0,'Protein',1),
('R017','ING011',21.0,'g','~21g Honey (1 Tablespoon)',10.5,31.5,'Carb',2),
('R017','ING002',40.0,'g','~40g Blueberries (1 Handful)',20.0,60.0,'Carb',3),
('R017','ING157',1.0,'each','6-8 Fresh Peach Slices',null,2.0,'Carb',4),
('R017','ING107',20.0,'g','~20g Plain Granola (1 Handful)',10.0,30.0,'Carb',5),
('R017','ING055',4.0,'g','~4g Cacao Nibs (½ Tbsp)',2.0,6.0,'Fat',6),
('R017','ING010',12.0,'g','~12g Chia Seeds (1 Tbsp)',6.0,18.0,'Carb',7),
('R018','ING008',300.0,'g','300g Oats',150.0,450.0,'Carb',1),
('R018','ING018',2.0,'each','2 Eggs',1.0,3.0,'Protein',2),
('R018','ING001',3.0,'each','3 Bananas',2.0,4.0,'Carb',3),
('R018','ING030',60.0,'g','~60g Low Fat Greek Yoghurt (4 Tbsp)',30.0,90.0,'Protein',4),
('R018','ING011',42.0,'g','~42g Honey (2 Tbsp)',21.0,63.0,'Carb',5),
('R018','ING068',14.0,'g','~14g Coconut Oil (1 Tbsp)',7.0,21.0,'Fat',6),
('R018','ING085',8.0,'g','~8g Cinnamon (1 Tbsp)',4.0,12.0,'Carb',7),
('R019','ING008',150.0,'g','150g Oats',75.0,225.0,'Carb',1),
('R019','ING001',1.0,'each','1 Banana',null,2.0,'Carb',2),
('R019','ING018',3.0,'each','3 Eggs',2.0,4.0,'Protein',3),
('R019','ING096',20.0,'g','~20g Flaxseed (2 Tbsp)',10.0,30.0,'Fat',4),
('R019','ING110',14.0,'g','~14g Ground Almonds (2 Tbsp)',7.0,21.0,'Fat',5),
('R019','ING002',100.0,'g','100g Blueberries',50.0,150.0,'Carb',6),
('R019','ING011',63.0,'g','~63g Honey (3 Tbsp)',31.5,94.5,'Carb',7),
('R019','ING017',14.0,'g','~14g Baking Powder (1 Tbsp)',7.0,21.0,'Carb',8),
('R019','ING085',8.0,'g','~8g Cinnamon (1 Tbsp)',4.0,12.0,'Carb',9),
('R019','ING068',14.0,'g','~14g Coconut Oil (1 Tbsp)',7.0,21.0,'Fat',10),
('R019','ING184',1.0,'g','1 Pinch Salt',0.5,1.5,'Carb',11),
('R020','ING030',150.0,'g','150g Greek Yoghurt (2% fat)',75.0,225.0,'Protein',1),
('R020','ING107',60.0,'g','60g Granola',30.0,90.0,'Carb',2),
('R020','ING199',100.0,'g','100g Sliced Strawberries',50.0,150.0,'Carb',3),
('R020','ING215',20.0,'g','20g Chopped Walnuts',10.0,30.0,'Fat',4),
('R020','ING055',10.0,'g','10g Cacao Nibs',5.0,15.0,'Fat',5),
('R020','ING011',15.0,'g','15g Honey',7.5,22.5,'Carb',6),
('R020','ING010',10.0,'g','10g Chia Seeds',5.0,15.0,'Carb',7),
('R020','ING014',4.0,'g','~4g Vanilla Extract (1 Tsp)',2.0,6.0,'Carb',8),
('R020','ING085',1.0,'g','Pinch of Cinnamon',0.5,1.5,'Carb',9),
('R020','ING212',5.0,'g','5g unsweetened coconut flakes',2.5,7.5,'Fat',10),
('R022','ING006',200.0,'ml','200ml Semi Skimmed Milk',100.0,300.0,'Carb',1),
('R022','ING008',50.0,'g','50g Porridge Oats',25.0,75.0,'Carb',2),
('R022','ING142',100.0,'g','100g Mixed Fresh Berries',50.0,150.0,'Carb',3),
('R022','ING091',150.0,'g','150g Fat Free Skyr Yogurt',75.0,225.0,'Protein',4),
('R022','ING009',5.0,'g','~5g Peanut Butter (1 Teaspoon)',2.5,7.5,'Fat',5),
('R022','ING001',1.0,'each','1 Medium Banana',null,2.0,'Carb',6),
('R023','ING162',1.0,'each','1 Large Wholemeal Pitta',null,2.0,'Carb',1),
('R023','ING018',2.0,'each','2 Large Eggs',1.0,3.0,'Protein',2),
('R023','ING061',52.5,'g','3-4 Cherry Tomatoes',26.25,78.75,'Carb',3),
('R023','ING020',0.5,'each','½ Avocado',null,1.5,'Fat',4),
('R023','ING195',17.0,'g','~17g Sriracha Sauce (1 Tbsp)',8.5,25.5,'Carb',5),
('R023','ING023',4.0,'g','~4g Extra Virgin Olive Oil (1 Tsp)',2.0,6.0,'Fat',6),
('R024','ING006',200.0,'ml','200ml Semi Skimmed Milk',100.0,300.0,'Carb',1),
('R024','ING008',50.0,'g','50g Porridge Oats',25.0,75.0,'Carb',2),
('R024','ING091',150.0,'g','150g Fat Free Skyr Yoghurt',75.0,225.0,'Protein',3),
('R024','ING066',16.0,'g','~16g Lotus Biscoff Spread (3 Teaspoon)',8.0,24.0,'Carb',4),
('R024','ING001',1.0,'each','1 Medium Banana',null,2.0,'Carb',5),
('R025','ING008',60.0,'g','60g Dry Oats',30.0,90.0,'Carb',1),
('R025','ING006',150.0,'ml','150ml Semi-Skimmed Milk',75.0,225.0,'Carb',2),
('R025','ING002',40.0,'g','~40g Fresh Blueberries (1 Handful)',20.0,60.0,'Carb',3),
('R025','ING001',1.0,'each','1 Large Banana',null,2.0,'Carb',4),
('R025','ING011',21.0,'g','~21g Honey (1 Tbsp)',10.5,31.5,'Carb',5),
('R025','ING030',135.0,'g','135g 0% Greek Yoghurt',67.5,202.5,'Protein',6),
('R026','ING107',100.0,'g','~100g Granola (1 Cup)',50.0,150.0,'Carb',1),
('R026','ING030',75.0,'g','~75g 0% Greek Yoghurt (5 Tbsp)',37.5,112.5,'Protein',2),
('R026','ING011',7.0,'g','~7g Honey (1 Tsp)',3.5,10.5,'Carb',3),
('R026','ING002',40.0,'g','~40g Fresh Blueberries (1 Handful)',20.0,60.0,'Carb',4),
('R027','ING005',45.0,'g','45g Vanilla Whey Protein',22.5,67.5,'Protein',1),
('R027','ING001',2.0,'each','2 Medium Bananas',null,2.0,'Carb',2),
('R027','ING018',3.0,'each','3 Eggs',2.0,4.0,'Protein',3),
('R027','ING068',7.0,'g','~7g Coconut Oil (1/2 Tbsp)',10.5,31.5,'Fat',4),
('R027','ING003',80.0,'g','~80g Fresh Raspberries (2 Handfuls)',40.0,120.0,'Carb',5),
('R027','ING011',21.0,'g','~21g Honey (1 Tbsp)',21.0,63.0,'Carb',6),
('R028','ING221',2.0,'each','~80g Wholemeal Bread (2 Slices)',1.0,3.0,'Carb',1),
('R028','ING006',150.0,'ml','150ml Semi-Skimmed Milk',75.0,225.0,'Carb',2),
('R028','ING018',1.0,'each','1 Egg',null,2.0,'Protein',3),
('R028','ING085',3.0,'g','~3g Cinnamon (1 Tsp)',1.5,4.5,'Carb',4),
('R028','ING011',14.0,'g','~14g Honey (2 Tsp)',7.0,21.0,'Carb',5),
('R028','ING005',15.0,'g','15g Vanilla Whey Protein',7.5,22.5,'Protein',6),
('R028','ING004',30.0,'g','~30g 0% Fat Greek Yoghurt (2 Tbsp)',15.0,45.0,'Protein',7),
('R028','ING142',40.0,'g','~40g Mixed Berries (1 Handful)',20.0,60.0,'Carb',8),
('R028','ING068',4.0,'g','~4g Coconut Oil (1 Tsp)',2.0,6.0,'Fat',9),
('R029','ING062',150.0,'g','1 Large Chicken Breast',75.0,225.0,'Protein',1),
('R029','ING184',1.0,'g','Salt & Pepper',0.5,1.5,'Carb',2),
('R029','ING143',600.0,'g','2 Mixed Green Leaves',300.0,900.0,'Carb',3),
('R029','ING179',20.0,'g','~20g Rocket (1 Handful)',10.0,30.0,'Protein',4),
('R029','ING061',75.0,'g','5 Cherry Tomatoes',37.5,112.5,'Carb',5),
('R029','ING171',60.0,'g','60g Sliced Red Pepper',30.0,90.0,'Carb',6),
('R029','ING173',40.0,'g','40g Sliced Red Onion',20.0,60.0,'Carb',7),
('R029','ING093',5.0,'g','5 Feta Cheese Cubes',2.5,7.5,'Fat',8),
('R029','ING023',14.0,'g','~14g Extra Virgin Olive Oil (1 Tbsp)',7.0,21.0,'Fat',9),
('R029','ING004',15.0,'g','~15g 0% Fat Greek Yoghurt (1 Tbsp)',7.5,22.5,'Protein',10),
('R029','ING084',10.0,'g','~10g Dijon Mustard (2 Tsp)',5.0,15.0,'Protein',11),
('R029','ING085',2.0,'g','~2g Paprika (1 Tsp)',1.0,3.0,'Carb',12),
('R029','ING130',15.0,'ml','~15g Lime Juice (1 TBSP)',14.0,16.0,'Carb',13),
('R030','ING062',150.0,'g','1 Cooked Chicken Breast sliced',75.0,225.0,'Protein',1),
('R030','ING193',60.0,'g','~60g Spinach (2 Handfuls)',30.0,90.0,'Protein',2),
('R030','ING201',180.0,'g','1 Cooked Sweet Potato, cubed',90.0,270.0,'Carb',3),
('R030','ING002',40.0,'g','~40g Blueberries (1 Handful)',20.0,60.0,'Carb',4),
('R030','ING199',40.0,'g','~40g Strawberries, sliced (1 Handful)',20.0,60.0,'Carb',5),
('R030','ING215',50.0,'g','50g Walnuts, crushed',25.0,75.0,'Fat',6),
('R030','ING078',15.0,'ml','~15g Cranberry Juice (1 tbsp)',7.5,22.5,'Carb',7),
('R030','ING023',14.0,'g','~14g Extra Virgin Olive Oil (1 tbsp)',7.0,21.0,'Fat',8),
('R030','ING039',10.0,'ml','~10g Balsamic Glaze (1/2 tbsp)',5.0,15.0,'Carb',9),
('R030','ING150',0.007,'each','~1g Orange Zest (1/2 tsp)',null,1.00714285714286,'Carb',10),
('R030','ING084',2.0,'g','~2g Dijon Mustard (1/2 tsp)',1.0,3.0,'Protein',11),
('R030','ING184',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',12),
('R031','ING166',300.0,'g','300g Pork Fillet',150.0,450.0,'Protein',1),
('R031','ING145',200.0,'g','200g Mushrooms',100.0,300.0,'Protein',2),
('R031','ING084',5.0,'g','~5g Wholegrain Mustard (1 Tsp)',2.5,7.5,'Protein',3),
('R031','ING136',10.0,'g','~10g Crème Fraîche (2 Tsp)',5.0,15.0,'Fat',4),
('R031','ING179',40.0,'g','40g Rocket',20.0,60.0,'Protein',5),
('R031','ING167',240.0,'g','240g Roasted Potato',120.0,360.0,'Carb',6),
('R033','ING028',960.0,'ml','~960g Water (4 Cups)',480.0,1440.0,'Carb',1),
('R033','ING042',70.0,'g','70g Dry White Rice',35.0,105.0,'Carb',2),
('R033','ING192',64.0,'ml','~64g Soy Sauce (4 Tablespoons)',32.0,96.0,'Protein',3),
('R033','ING098',3.0,'g','~6g Crushed Ginger (1 Tablespoon)',2.0,4.0,'Carb',4),
('R033','ING104',2.667,'each','~8g Minced Garlic (1 Tablespoon)',1.66666666666667,3.66666666666667,'Carb',5),
('R033','ING085',1.0,'g','~1g Chilli Flakes (½ Teaspoon)',0.5,1.5,'Carb',6),
('R033','ING011',21.0,'g','~21g Honey (1 Tablespoon)',10.5,31.5,'Carb',7),
('R033','ING062',600.0,'g','4 Chicken Breasts',300.0,900.0,'Protein',8),
('R033','ING068',14.0,'g','~14g Coconut Oil (1 Tablespoon)',7.0,21.0,'Fat',9),
('R033','ING171',300.0,'g','2 Red Bell Peppers',150.0,450.0,'Carb',10),
('R033','ING050',300.0,'g','1 Head Broccoli',150.0,450.0,'Protein',11),
('R033','ING058',68.0,'g','~68g Cashew Nuts (½ Cup)',34.0,102.0,'Fat',12),
('R033','ING149',150.0,'g','1 Onion, Cut into Large Chunks',75.0,225.0,'Carb',13),
('R034','ING062',150.0,'g','1 Large Chicken Breast',75.0,225.0,'Protein',1),
('R034','ING042',75.0,'g','75g Dry Basmati Rice',37.5,112.5,'Carb',2),
('R034','ING161',200.0,'g','200g Cubed Pineapple',100.0,300.0,'Carb',3),
('R034','ING185',1.0,'each','1 Scotch Bonnet Pepper',null,2.0,'Carb',4),
('R034','ING173',150.0,'g','1 Small Red Onion',75.0,225.0,'Carb',5),
('R034','ING104',5.0,'each','4-6 Garlic Cloves',4.0,6.0,'Carb',6),
('R034','ING194',4.0,'each','4 Spring Onion Stalks',3.0,5.0,'Carb',7),
('R034','ING192',64.0,'ml','~64g Soy Sauce (1/4 Cup)',32.0,96.0,'Protein',8),
('R034','ING177',60.0,'ml','~60g White Vinegar (1/4 Cup)',30.0,90.0,'Carb',9),
('R034','ING023',28.0,'g','~28g Olive Oil (2 Tablespoons)',14.0,42.0,'Fat',10),
('R034','ING150',0.5,'each','Juice From 1 Large Orange',null,1.5,'Carb',11),
('R034','ING134',0.5,'each','Juice From 1/2 Lime',null,1.5,'Carb',12),
('R034','ING098',3.0,'g','~6g Grated Ginger (1 Tablespoon)',2.0,4.0,'Carb',13),
('R034','ING051',26.0,'g','~26g Brown Sugar (2 Tablespoons)',13.0,39.0,'Carb',14),
('R034','ING085',2.0,'g','~2g Nutmeg (1 Teaspoon)',1.0,3.0,'Carb',15),
('R034','ING085',2.0,'g','~2g Allspice (1 Teaspoon)',1.0,3.0,'Carb',16),
('R034','ING085',3.0,'g','~3g Cinnamon (1 Teaspoon)',1.5,4.5,'Carb',17),
('R034','ING085',1.0,'g','~1g Dried Thyme (1 Teaspoon)',0.5,1.5,'Carb',18),
('R034','ING184',1.0,'g','Salt & Pepper To Taste',0.5,1.5,'Carb',19),
('R035','ING182',150.0,'g','1 Large Salmon Fillet',75.0,225.0,'Protein',1),
('R035','ING076',100.0,'g','½ Courgette',50.0,150.0,'Carb',2),
('R035','ING035',5.0,'g','5 Asparagus Tips',2.5,7.5,'Protein',3),
('R035','ING061',60.0,'g','4 Cherry Tomatoes',30.0,90.0,'Carb',4),
('R035','ING057',30.0,'g','½ Carrot',15.0,45.0,'Carb',5),
('R035','ING129',0.25,'each','¼ Lemon',null,1.25,'Carb',6),
('R035','ING023',4.0,'g','~4g Olive Oil (1 Tsp)',2.0,6.0,'Fat',7),
('R035','ING085',1.0,'g','Pinch of Chilli Flakes',0.5,1.5,'Carb',8),
('R035','ING184',1.0,'g','Salt & Pepper',0.5,1.5,'Carb',9),
('R035','ING201',200.0,'g','200g Cubed Sweet Potato',100.0,300.0,'Carb',10),
('R036','ING124',230.0,'g','230g Sirloin Steak (Raw)',115.0,345.0,'Protein',1),
('R036','ING104',2.0,'each','2 x Garlic Cloves',1.0,3.0,'Carb',2),
('R036','ING050',120.0,'g','6 Tenderstem Broccoli Stalks',900.0,2700.0,'Protein',3),
('R036','ING167',350.0,'g','350g White Potato',175.0,525.0,'Carb',4),
('R036','ING099',1.0,'g','Fresh Rosemary',0.5,1.5,'Carb',5),
('R036','ING085',1.0,'g','Chilli Flakes',0.5,1.5,'Carb',6),
('R036','ING184',1.0,'g','Salt & Pepper',0.5,1.5,'Carb',7),
('R036','ING214',1.0,'g','Grilled Vine Tomato',0.5,1.5,'Carb',8),
('R036','ING214',1.0,'g','Grilled Portobello Mushroom',0.5,1.5,'Carb',9),
('R036','ING214',1.0,'g','Grilled Asparagus',0.5,1.5,'Carb',10),
('R037','ING156',65.0,'g','65g Dried Spaghetti',32.5,97.5,'Carb',1),
('R037','ING117',60.0,'g','60g Raw King Prawns',30.0,90.0,'Protein',2),
('R037','ING112',12.0,'g','~12g rose harissa (2 teaspoons)',6.0,18.0,'Carb',3),
('R037','ING099',0.5,'g','½ bunch flat-leaf parsley',0.25,0.75,'Carb',4),
('R037','ING129',1.0,'each','1 lemon',null,2.0,'Carb',5),
('R038','ING062',250.0,'g','250g Sliced Chicken Breast',125.0,375.0,'Protein',1),
('R038','ING103',200.0,'ml','200ml Coconut Milk',100.0,300.0,'Fat',2),
('R038','ING204',30.0,'g','30g Thai Red Curry Paste',15.0,45.0,'Carb',3),
('R038','ING098',5.0,'g','10g Minced Ginger',4.0,6.0,'Carb',4),
('R038','ING051',10.0,'g','10g Brown Sugar',5.0,15.0,'Carb',5),
('R038','ING171',100.0,'g','100g Sliced Red Bell Pepper',50.0,150.0,'Carb',6),
('R038','ING109',80.0,'g','80g Green Beans',40.0,120.0,'Carb',7),
('R038','ING040',50.0,'g','50g Bamboo Shoots',25.0,75.0,'Carb',8),
('R038','ING099',30.0,'g','30g Basil',15.0,45.0,'Carb',9),
('R038','ING194',1.333,'each','20g Chopped Spring Onion',0.333333333333333,2.33333333333333,'Carb',10),
('R038','ING130',10.0,'ml','10g Lime Juice',9.0,11.0,'Carb',11),
('R038','ING172',0.333,'each','5g Sliced Red Chilli',null,1.33333333333333,'Carb',12),
('R038','ING042',75.0,'g','75g Dry White Rice',37.5,112.5,'Carb',13),
('R039','ING023',4.0,'g','~4g olive oil (1 teaspoon)',2.0,6.0,'Fat',1),
('R039','ING149',75.0,'g','1/2 Onion',37.5,112.5,'Carb',2),
('R039','ING134',0.5,'each','1/2 Lime',null,1.5,'Carb',3),
('R039','ING062',170.0,'g','170g Cooked Chicken Breast',85.0,255.0,'Protein',4),
('R039','ING097',2.0,'each','2 Flour Tortillas',1.0,3.0,'Carb',5),
('R039','ING175',30.0,'g','30g Reduced Fat Cheese',15.0,45.0,'Protein',6),
('R039','ING020',0.5,'each','1/2 Avocado',null,1.5,'Fat',7),
('R039','ING061',90.0,'g','6 Cherry Tomatoes',45.0,135.0,'Carb',8),
('R039','ING104',0.5,'each','1/2 Garlic Clove',null,1.5,'Carb',9),
('R039','ING184',1.0,'g','Salt & Pepper',0.5,1.5,'Carb',10),
('R040','ING127',450.0,'g','450g Minced Lamb',225.0,675.0,'Protein',1),
('R040','ING155',400.0,'g','1 can of Chopped Tomatoes',200.0,600.0,'Carb',2),
('R040','ING173',150.0,'g','1 Red Onion',75.0,225.0,'Carb',3),
('R040','ING099',30.0,'g','~30g Chopped Parsley (½ Cup)',15.0,45.0,'Carb',4),
('R040','ING129',0.5,'each','½ Lemon',null,1.5,'Carb',5),
('R040','ING099',16.0,'g','~16g fresh Coriander (1 Cup)',8.0,24.0,'Carb',6),
('R040','ING104',2.0,'each','2 Garlic Cloves',1.0,3.0,'Carb',7),
('R040','ING085',7.0,'g','~7g Paprika (1 Tbsp)',3.5,10.5,'Carb',8),
('R040','ING085',6.0,'g','~6g Ground Cumin (1 Tbsp)',3.0,9.0,'Carb',9),
('R040','ING023',14.0,'g','~14g Olive Oil (1 Tbsp)',7.0,21.0,'Fat',10),
('R040','ING085',4.0,'g','~4g Chilli flakes (2 Tsp)',2.0,6.0,'Carb',11),
('R040','ING172',1.0,'each','1 Red Chilli',null,2.0,'Carb',12),
('R040','ING042',220.0,'g','220g Dry Basmati Rice',110.0,330.0,'Carb',13),
('R041','ING182',250.0,'g','250g Salmon Fillet',125.0,375.0,'Protein',1),
('R041','ING085',5.0,'g','5g Oregano',2.5,7.5,'Carb',2),
('R041','ING129',0.086,'each','5g Lemon Zest',null,1.08620689655172,'Carb',3),
('R041','ING052',40.0,'g','100g Bulgur Wheat & 200ml Boiled Water',20.0,60.0,'Carb',4),
('R041','ING099',100.0,'g','100g Chopped Fresh Parsley',50.0,150.0,'Carb',5),
('R041','ING099',50.0,'g','50g Chopped Fresh Mint',25.0,75.0,'Carb',6),
('R041','ING080',80.0,'g','80g Diced Cucumber',40.0,120.0,'Carb',7),
('R041','ING061',50.0,'g','50g Chopped Cherry Tomatoes',25.0,75.0,'Carb',8),
('R041','ING173',30.0,'g','30g Finely Diced Red Onion',15.0,45.0,'Carb',9),
('R041','ING004',100.0,'g','100g 0% Fat Greek Yoghurt',50.0,150.0,'Protein',10),
('R041','ING130',15.0,'ml','15ml Lemon Juice',14.0,16.0,'Carb',11),
('R041','ING023',10.0,'g','10ml Olive Oil',5.0,15.0,'Fat',12),
('R041','ING099',5.0,'g','5g Chopped Dill',2.5,7.5,'Carb',13),
('R041','ING104',1.0,'each','3g Minced Garlic',null,2.0,'Carb',14),
('R041','ING165',20.0,'g','20g Pommegranate seeds',10.0,30.0,'Carb',15),
('R041','ING184',1.0,'g','Salt & Pepper',0.5,1.5,'Carb',16),
('R042','ING062',120.0,'g','120g Chicken Breast Mini Fillets',60.0,180.0,'Protein',1),
('R042','ING018',1.0,'each','1 Egg',null,2.0,'Protein',2),
('R042','ING008',40.0,'g','40g Oats',20.0,60.0,'Carb',3),
('R042','ING006',15.0,'ml','~15g Semi-Skimmed Milk (1 Tbsp)',7.5,22.5,'Carb',4),
('R042','ING011',14.0,'g','~14g Honey (2 Tsp)',7.0,21.0,'Carb',5),
('R042','ING081',2.0,'g','~2g Paprika/Chicken Spice (1 Tsp)',1.0,3.0,'Carb',6),
('R042','ING023',9.0,'g','~9g Olive Oil (2 Tsp)',4.5,13.5,'Fat',7),
('R042','ING143',60.0,'g','~60g Mixed Leaves (2 Handful)',30.0,90.0,'Carb',8),
('R042','ING061',50.0,'g','~50g Cherry Tomato (1 Handful)',25.0,75.0,'Carb',9),
('R042','ING039',15.0,'ml','15ml Balsamic Vinegar',7.5,22.5,'Carb',10),
('R042','ING201',150.0,'g','150g Baked Sweet Potato',75.0,225.0,'Carb',11),
('R042','ING085',2.0,'g','~2g Paprika (1 tsp)',1.0,3.0,'Carb',12),
('R043','ING182',150.0,'g','1 Medium Salmon Fillet',75.0,225.0,'Protein',1),
('R043','ING077',50.0,'g','50g Cous Cous, dry',25.0,75.0,'Carb',2),
('R043','ING179',20.0,'g','~20g Rocket (1 Handful)',10.0,30.0,'Protein',3),
('R043','ING002',40.0,'g','~40g Blueberries (1 Handful)',20.0,60.0,'Carb',4),
('R043','ING099',3.0,'g','~3g Fresh Mint, chopped (1 tbsp)',1.5,4.5,'Carb',5),
('R043','ING134',1.0,'each','1 Lime',null,2.0,'Carb',6),
('R043','ING023',4.0,'g','~4g Olive Oil (1 Tsp)',2.0,6.0,'Fat',7),
('R043','ING039',20.0,'ml','~20g Balsamic Glaze (1 Tbsp)',10.0,30.0,'Carb',8),
('R044','ING062',300.0,'g','2 Chicken Breast',150.0,450.0,'Protein',1),
('R044','ING023',14.0,'g','~14g Olive Oil (1 Tbsp)',7.0,21.0,'Fat',2),
('R044','ING085',1.0,'g','1 Pinch Cinnamon',0.5,1.5,'Carb',3),
('R044','ING085',1.0,'g','1 Pinch Cumin',0.5,1.5,'Carb',4),
('R044','ING085',1.0,'g','1 Pinch Coriander',0.5,1.5,'Carb',5),
('R044','ING011',7.0,'g','~7g Honey (1 Tsp)',3.5,10.5,'Carb',6),
('R044','ING099',10.0,'g','~10g Fresh Coriander (1 Handful)',5.0,15.0,'Carb',7),
('R044','ING130',1.0,'ml','1 Lime Juice',null,2.0,'Carb',8),
('R044','ING134',1.0,'each','1 Lime Zest',null,2.0,'Carb',9),
('R044','ING143',30.0,'g','~30g Mixed Salad Leaves (1 Handful)',15.0,45.0,'Carb',10),
('R044','ING080',150.0,'g','1/2 Chopped Cucumber',75.0,225.0,'Carb',11),
('R044','ING061',50.0,'g','~50g Baby Tomatoes (1 Handful)',25.0,75.0,'Carb',12),
('R044','ING167',360.0,'g','2 x Medium Baked Potato',180.0,540.0,'Carb',13),
('R045','ING124',500.0,'g','500g Lean Beef Strips',250.0,750.0,'Protein',1),
('R045','ING192',32.0,'ml','~32g Soy Sauce (2 Tablespoons)',16.0,48.0,'Protein',2),
('R045','ING187',14.0,'g','~14g Sesame Oil (1 Tablespoon)',7.0,21.0,'Fat',3),
('R045','ING177',15.0,'ml','~15g Rice Vinegar (1 Tablespoon)',7.5,22.5,'Carb',4),
('R045','ING104',2.0,'each','2 Cloves Minced Garlic',1.0,3.0,'Carb',5),
('R045','ING098',3.0,'g','~6g Grated Ginger (1 Tablespoon)',2.0,4.0,'Carb',6),
('R045','ING011',21.0,'g','~21g Honey (1 Tablespoon)',10.5,31.5,'Carb',7),
('R045','ING112',18.0,'g','~18g Korean Chilli Paste (1 Tablespoon)',9.0,27.0,'Carb',8),
('R045','ING075',8.0,'g','~8g Cornflour (1 Tablespoon)',4.0,12.0,'Carb',9),
('R045','ING023',14.0,'g','~14g Olive Oil (1 Tablespoon)',7.0,21.0,'Fat',10),
('R045','ING149',150.0,'g','1 Medium Sliced Onion',75.0,225.0,'Carb',11),
('R045','ING171',150.0,'g','1 Sliced Red Bell Pepper',75.0,225.0,'Carb',12),
('R045','ING050',90.0,'g','~90g Broccoli Florets (1 Cup)',45.0,135.0,'Protein',13),
('R045','ING042',265.0,'g','265g Dry Basmati Rice',132.5,397.5,'Carb',14),
('R045','ING188',9.0,'g','~9g Sesame Seeds (1 Tablespoon)',4.5,13.5,'Fat',15),
('R045','ING194',2.0,'each','2 Sliced Spring Onions',1.0,3.0,'Carb',16),
('R045','ING172',1.5,'each','1-2 Sliced Red Chilies',0.5,2.5,'Carb',17),
('R046','ING062',500.0,'g','500g Chicken Breast (raw)',250.0,750.0,'Protein',1),
('R046','ING149',150.0,'g','1 Onion',75.0,225.0,'Carb',2),
('R046','ING104',3.0,'each','3 Garlic Cloves',2.0,4.0,'Carb',3),
('R046','ING201',180.0,'g','1 Large Sweet Potato',90.0,270.0,'Carb',4),
('R046','ING015',240.0,'g','1 Tin Chickpeas',120.0,360.0,'Carb',5),
('R046','ING103',400.0,'ml','1 Tin Coconut Milk',200.0,600.0,'Fat',6),
('R046','ING198',1.0,'each','1 Chicken Stock Cube',null,2.0,'Carb',7),
('R046','ING110',14.0,'g','~14g Ground Almonds (2 Tbsp)',7.0,21.0,'Fat',8),
('R046','ING081',6.0,'g','~6g Curry Powder (1 Tbsp)',3.0,9.0,'Carb',9),
('R046','ING098',3.0,'g','~6g Grated Ginger (1 Tbsp)',2.0,4.0,'Carb',10),
('R046','ING109',250.0,'g','1 Bag Green Beans',125.0,375.0,'Carb',11),
('R046','ING085',8.0,'g','~8g Ground Cinnamon (1 Tbsp)',4.0,12.0,'Carb',12),
('R046','ING042',300.0,'g','300g Dry Basmati Rice',150.0,450.0,'Carb',13),
('R047','ING062',150.0,'g','150g Raw Chicken Breast',75.0,225.0,'Protein',1),
('R047','ING156',85.0,'g','85g Dry Tagliatelle',42.5,127.5,'Carb',2),
('R047','ING149',150.0,'g','1 Small Onion',75.0,225.0,'Carb',3),
('R047','ING205',240.0,'g','2 Medium Tomatoes',120.0,360.0,'Carb',4),
('R047','ING104',2.0,'each','2 Garlic Cloves',1.0,3.0,'Carb',5),
('R047','ING206',16.0,'g','~16g Tomato Purée (1 Tbsp)',8.0,24.0,'Carb',6),
('R047','ING023',16.0,'g','~16g Olive Oil (1 Tbsp + ½ Tsp)',8.0,24.0,'Fat',7),
('R047','ING177',5.0,'ml','~5g White Wine Vinegar (1 Tsp)',2.5,7.5,'Carb',8),
('R047','ING085',1.0,'g','Mixed Herb Seasoning',0.5,1.5,'Carb',9),
('R047','ING184',1.0,'g','Black Pepper',0.5,1.5,'Carb',10),
('R049','ING062',200.0,'g','200g Diced Chicken Breast',100.0,300.0,'Protein',1),
('R049','ING137',40.0,'g','~40g Mango Chutney (2 Tbsp)',20.0,60.0,'Carb',2),
('R049','ING149',150.0,'g','1 Chopped Onion',75.0,225.0,'Carb',3),
('R049','ING145',40.0,'g','~40g Sliced Mushroom (1 Handful)',20.0,60.0,'Protein',4),
('R049','ING206',32.0,'g','~32g Tomato Puree (2 Tbsp)',16.0,48.0,'Carb',5),
('R049','ING205',480.0,'g','4 Sliced Sun-Dried Tomatoes',240.0,720.0,'Carb',6),
('R049','ING085',2.0,'g','~2g Dried Oregano (2 Tsp)',1.0,3.0,'Carb',7),
('R049','ING104',1.0,'each','1 Crushed Garlic Cloce',null,2.0,'Carb',8),
('R049','ING171',150.0,'g','1 Thinkly Sliced Pepper',75.0,225.0,'Carb',9),
('R049','ING099',10.0,'g','~10g Fresh Basil (1 Handful)',5.0,15.0,'Carb',10),
('R049','ING085',1.0,'g','~1g Chilli Powder (1/4 Tsp)',0.5,1.5,'Carb',11),
('R049','ING156',150.0,'g','150g Dry Tagliatelle Pasta',75.0,225.0,'Carb',12),
('R049','ING023',4.0,'g','~4g Extra Virgin Olive Oil (1 Tsp)',2.0,6.0,'Fat',13),
('R049','ING184',1.0,'g','Salt & Pepper',0.5,1.5,'Carb',14),
('R050','ING182',250.0,'g','250g raw salmon fillets',125.0,375.0,'Protein',1),
('R050','ING042',130.0,'g','130g dry jasmine rice',65.0,195.0,'Carb',2),
('R050','ING023',14.0,'g','~14g extra virgin olive oil (1 tbsp)',7.0,21.0,'Fat',3),
('R050','ING104',2.0,'each','2 garlic cloves',1.0,3.0,'Carb',4),
('R050','ING172',1.0,'each','1 red chilli',null,2.0,'Carb',5),
('R050','ING149',75.0,'g','½ onion',37.5,112.5,'Carb',6),
('R050','ING043',5.0,'each','5 curry leaves',2.5,7.5,'Carb',7),
('R050','ING098',1.0,'g','~2g grated fresh ginger (1 tsp)',null,2.0,'Carb',8),
('R050','ING131',1.0,'each','1 lemongrass stalk',null,2.0,'Carb',9),
('R050','ING134',1.0,'each','1 lime – zest and juice',null,2.0,'Carb',10),
('R050','ING171',300.0,'g','2 yellow peppers',150.0,450.0,'Carb',11),
('R050','ING081',6.0,'g','~6g curry powder (1 tbsp)',3.0,9.0,'Carb',12),
('R050','ING132',400.0,'ml','1 × 400ml can light/reduced-fat coconut milk',200.0,600.0,'Fat',13),
('R050','ING061',100.0,'g','100g cherry tomatoes',50.0,150.0,'Carb',14),
('R051','ING062',220.0,'g','220g raw chicken breast, diced',110.0,330.0,'Protein',1),
('R051','ING156',170.0,'g','170g dry penne pasta',85.0,255.0,'Carb',2),
('R051','ING023',9.0,'g','~9g extra virgin olive oil (2 tsp)',4.5,13.5,'Fat',3),
('R051','ING104',2.0,'each','2 garlic cloves, chopped',1.0,3.0,'Carb',4),
('R051','ING172',0.25,'each','¼ red chilli, chopped',null,1.25,'Carb',5),
('R051','ING129',1.0,'each','1 lemon, zest and juice',null,2.0,'Carb',6),
('R051','ING085',2.0,'g','~2g ground cumin (1 tsp)',1.0,3.0,'Carb',7),
('R051','ING085',2.0,'g','~2g paprika (1 tsp)',1.0,3.0,'Carb',8),
('R051','ING085',2.0,'g','~2g ground turmeric (½ tsp)',1.0,3.0,'Carb',9),
('R051','ING085',1.0,'g','~1g ground cinnamon (½ tsp)',0.5,1.5,'Carb',10),
('R051','ING194',2.0,'each','2 spring onions, sliced',1.0,3.0,'Carb',11),
('R051','ING080',75.0,'g','¼ cucumber, sliced',37.5,112.5,'Carb',12),
('R051','ING149',75.0,'g','½ onion, sliced',37.5,112.5,'Carb',13),
('R051','ING061',75.0,'g','5 cherry tomatoes, chopped',37.5,112.5,'Carb',14),
('R051','ING099',10.0,'g','~10g fresh parsley, chopped (1 handful)',5.0,15.0,'Carb',15),
('R051','ING184',1.0,'g','Salt & pepper',0.5,1.5,'Carb',16),
('R052','ING128',500.0,'g','500g lean turkey mince (around 2% fat)',250.0,750.0,'Protein',1),
('R052','ING023',14.0,'g','~14g extra virgin olive oil (1 tbsp)',7.0,21.0,'Fat',2),
('R052','ING149',150.0,'g','1 onion, chopped',75.0,225.0,'Carb',3),
('R052','ING060',80.0,'g','2 celery stalks, chopped',40.0,120.0,'Carb',4),
('R052','ING104',2.0,'each','2 garlic cloves, crushed',1.0,3.0,'Carb',5),
('R052','ING057',120.0,'g','2 carrots, diced',60.0,180.0,'Carb',6),
('R052','ING155',400.0,'g','2 × 400g tins chopped tomatoes',200.0,600.0,'Carb',7),
('R052','ING206',32.0,'g','~32g tomato purée (2 tbsp)',16.0,48.0,'Carb',8),
('R052','ING085',2.0,'g','~2g dried oregano (2 tsp)',1.0,3.0,'Carb',9),
('R052','ING224',5.0,'ml','~5g Worcestershire sauce (1 tsp)',2.5,7.5,'Carb',10),
('R052','ING156',500.0,'g','500g dry spaghetti',250.0,750.0,'Carb',11),
('R052','ING154',10.0,'g','~10g grated Parmesan (2 tbsp)',5.0,15.0,'Protein',12),
('R052','ING184',1.0,'g','Salt & pepper',0.5,1.5,'Carb',13),
('R054','ING117',300.0,'g','300g cooked king prawns',150.0,450.0,'Protein',1),
('R054','ING042',250.0,'g','250g dry basmati rice',125.0,375.0,'Carb',2),
('R054','ING161',150.0,'g','150g pineapple chunks',75.0,225.0,'Carb',3),
('R054','ING173',150.0,'g','1 red onion, sliced',75.0,225.0,'Carb',4),
('R054','ING171',150.0,'g','1 red pepper, sliced',75.0,225.0,'Carb',5),
('R054','ING104',1.0,'each','1 garlic clove, crushed',null,2.0,'Carb',6),
('R054','ING098',1.0,'g','~2g grated fresh ginger (1 tsp)',null,2.0,'Carb',7),
('R054','ING192',32.0,'ml','~32g soy sauce (2 tbsp)',16.0,48.0,'Protein',8),
('R054','ING099',10.0,'g','~10g fresh coriander, chopped (1 handful)',5.0,15.0,'Carb',9),
('R054','ING068',28.0,'g','~28g coconut oil (2 tbsp)',14.0,42.0,'Fat',10),
('R055','ING126',375.0,'g','375g lean leg of lamb, cut into cubes',187.5,562.5,'Protein',1),
('R055','ING042',455.0,'g','455g dry basmati rice',227.5,682.5,'Carb',2),
('R055','ING023',70.0,'g','~70g olive oil (5 tbsp)',35.0,105.0,'Fat',3),
('R055','ING130',22.0,'ml','~22g lemon juice (1½ tbsp)',21.0,23.0,'Carb',4),
('R055','ING067',24.0,'ml','~24g red wine vinegar (1½ tbsp)',12.0,36.0,'Carb',5),
('R055','ING085',4.0,'g','~4g chopped oregano (1½ tbsp)',2.0,6.0,'Carb',6),
('R055','ING104',2.0,'each','2 garlic cloves, minced',1.0,3.0,'Carb',7),
('R055','ING024',3.0,'g','~3g salt (½ tsp)',1.5,4.5,'Carb',8),
('R055','ING024',1.0,'g','~1g black pepper (¼ tsp)',0.5,1.5,'Carb',9),
('R055','ING080',150.0,'g','½ large cucumber, sliced',75.0,225.0,'Carb',10),
('R055','ING061',180.0,'g','12 cherry tomatoes, halved',90.0,270.0,'Carb',11);
insert into ri_stage values
('R055','ING143',100.0,'g','~100g lettuce, roughly chopped (4 handfuls)',50.0,150.0,'Carb',12),
('R056','ING124',250.0,'g','250g fillet steak',125.0,375.0,'Protein',1),
('R056','ING201',310.0,'g','310g sweet potato',155.0,465.0,'Carb',2),
('R056','ING145',60.0,'g','60g chestnut mushrooms',30.0,90.0,'Protein',3),
('R056','ING213',7.0,'g','~7g vegetable oil (1½ tsp)',3.5,10.5,'Fat',4),
('R056','ING054',7.0,'g','7–8g butter',3.5,10.5,'Fat',5),
('R056','ING192',8.0,'ml','~8g soy sauce (1½ tsp)',4.0,12.0,'Protein',6),
('R056','ING172',0.25,'each','¼ small red chilli, finely chopped',null,1.25,'Carb',7),
('R056','ING099',4.0,'g','4g fresh coriander',2.0,6.0,'Carb',8),
('R056','ING099',4.0,'g','4g fresh parsley',2.0,6.0,'Carb',9),
('R056','ING104',0.25,'each','¼ garlic clove, crushed',null,1.25,'Carb',10),
('R056','ING023',7.0,'g','~7g olive oil (1½ tsp)',3.5,10.5,'Fat',11),
('R056','ING067',4.0,'ml','~4g red wine vinegar (¾ tsp)',2.0,6.0,'Carb',12),
('R056','ING085',1.0,'g','<1g dried oregano (¼ tsp)',0.5,1.5,'Carb',13),
('R056','ING028',1.0,'ml','Splash water',0.5,1.5,'Carb',14),
('R056','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',15),
('R057','ING186',130.0,'g','130g sea bass fillet',65.0,195.0,'Protein',1),
('R057','ING042',60.0,'g','60g dry white or jasmine rice',30.0,90.0,'Carb',2),
('R057','ING075',8.0,'g','~8g cornflour (1 tbsp)',4.0,12.0,'Carb',3),
('R057','ING085',1.0,'g','~1g Chinese five-spice (½ tsp)',0.5,1.5,'Carb',4),
('R057','ING187',4.0,'g','~4g sesame oil (1 tsp)',2.0,6.0,'Fat',5),
('R057','ING153',150.0,'g','1 head pak choi, chopped',0.5,1.5,'Protein',6),
('R057','ING050',100.0,'g','100g Tenderstem broccoli',50.0,150.0,'Protein',7),
('R057','ING194',2.0,'each','2 spring onions, sliced',1.0,3.0,'Carb',8),
('R057','ING104',2.0,'each','2 garlic cloves, sliced',1.0,3.0,'Carb',9),
('R057','ING172',1.0,'each','1 red chilli, sliced',null,2.0,'Carb',10),
('R057','ING098',3.0,'g','~6g grated fresh ginger (1 tbsp)',2.0,4.0,'Carb',11),
('R057','ING011',7.0,'g','~7g honey (1 tsp)',3.5,10.5,'Carb',12),
('R057','ING192',32.0,'ml','~32g soy sauce (2 tbsp)',16.0,48.0,'Protein',13),
('R057','ING177',16.0,'ml','~16g rice wine vinegar (1 tbsp)',8.0,24.0,'Carb',14),
('R057','ING130',15.0,'ml','~15g lime juice (1 tbsp)',14.0,16.0,'Carb',15),
('R057','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',16),
('R058','ING123',200.0,'g','200g 5% lean beef mince',100.0,300.0,'Protein',1),
('R058','ING140',200.0,'g','200g fresh egg noodles',100.0,300.0,'Carb',2),
('R058','ING020',0.667,'each','100g avocado, diced',null,1.66666666666667,'Fat',3),
('R058','ING061',150.0,'g','10 cherry tomatoes, halved',75.0,225.0,'Carb',4),
('R058','ING080',150.0,'g','½ medium cucumber, sliced',75.0,225.0,'Carb',5),
('R058','ING171',75.0,'g','½ red pepper, sliced',37.5,112.5,'Carb',6),
('R058','ING173',37.5,'g','¼ small red onion, finely sliced',18.75,56.25,'Carb',7),
('R058','ING143',100.0,'g','100g lettuce, chopped',50.0,150.0,'Carb',8),
('R058','ING023',5.0,'g','~5g Olive Oil (1 tsp)',10.0,30.0,'Fat',9),
('R058','ING130',15.0,'ml','~15g lemon juice (1 tbsp)',14.0,16.0,'Carb',10),
('R058','ING134',0.5,'each','½ lime, to serve',null,1.5,'Carb',11),
('R058','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',12),
('R059','ING182',170.0,'g','170g salmon fillet',85.0,255.0,'Protein',1),
('R059','ING156',90.0,'g','90g dry penne pasta',45.0,135.0,'Carb',2),
('R059','ING109',200.0,'g','200g green beans',100.0,300.0,'Carb',3),
('R059','ING129',1.0,'each','Zest and juice of 1 lemon',null,2.0,'Carb',4),
('R059','ING099',2.0,'g','~2g fresh thyme leaves (1 tbsp)',1.0,3.0,'Carb',5),
('R059','ING104',0.667,'each','~2g garlic salt (½ tsp)',null,1.66666666666667,'Carb',6),
('R059','ING023',9.0,'g','~9g olive oil (2 tsp)',4.5,13.5,'Fat',7),
('R059','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',8),
('R059','ING099',5.0,'g','Lemon wedges, to serve',2.5,7.5,'Carb',9),
('R059','ING099',5.0,'g','Fresh thyme sprigs, to garnish',2.5,7.5,'Carb',10),
('R060','ING062',110.0,'g','110g raw chicken breast',55.0,165.0,'Protein',1),
('R060','ING100',225.0,'g','225g fresh potato gnocchi',112.5,337.5,'Carb',2),
('R060','ING023',4.0,'g','~4g olive oil for cooking the chicken (1 tsp)',2.0,6.0,'Fat',3),
('R060','ING023',15.0,'g','15ml olive oil for the pesto',7.5,22.5,'Fat',4),
('R060','ING099',15.0,'g','15g fresh basil',7.5,22.5,'Carb',5),
('R060','ING160',20.0,'g','20g pine nuts',10.0,30.0,'Fat',6),
('R060','ING154',10.0,'g','10g Parmesan cheese',5.0,15.0,'Protein',7),
('R060','ING104',1.667,'each','5g garlic, minced',0.666666666666667,2.66666666666667,'Carb',8),
('R060','ING061',100.0,'g','100g cherry tomatoes',50.0,150.0,'Carb',9),
('R060','ING085',1.0,'g','Dried Italian herbs',0.5,1.5,'Carb',10),
('R060','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',11),
('R060','ING099',5.0,'g','Fresh basil leaves, to garnish',2.5,7.5,'Carb',12),
('R061','ING124',140.0,'g','140g lean beef strips',70.0,210.0,'Protein',1),
('R061','ING075',5.0,'g','5g cornflour',2.5,7.5,'Carb',2),
('R061','ING140',60.0,'g','60g dry noodles',30.0,90.0,'Carb',3),
('R061','ING187',20.0,'g','20–21g sesame oil',10.0,30.0,'Fat',4),
('R061','ING192',30.0,'ml','30g soy sauce',15.0,45.0,'Protein',5),
('R061','ING177',15.0,'ml','15g rice vinegar',7.5,22.5,'Carb',6),
('R061','ING051',5.0,'g','5g brown sugar',2.5,7.5,'Carb',7),
('R061','ING098',5.0,'g','10g fresh ginger, grated',4.0,6.0,'Carb',8),
('R061','ING104',3.333,'each','10g garlic, minced',2.33333333333333,4.33333333333333,'Carb',9),
('R061','ING050',100.0,'g','100g broccoli',50.0,150.0,'Protein',10),
('R061','ING057',80.0,'g','80g carrot, sliced',40.0,120.0,'Carb',11),
('R061','ING044',60.0,'g','60g beansprouts',30.0,90.0,'Carb',12),
('R061','ING171',60.0,'g','60g green pepper, sliced',30.0,90.0,'Carb',13),
('R061','ING172',0.5,'each','½ red chilli, finely sliced',null,1.5,'Carb',14),
('R061','ING188',5.0,'g','5g sesame seeds',2.5,7.5,'Fat',15),
('R061','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',16),
('R062','ING219',110.0,'g','110g raw cod fillet',55.0,165.0,'Protein',1),
('R062','ING042',55.0,'g','55g dry basmati rice',27.5,82.5,'Carb',2),
('R062','ING089',50.0,'g','50g edamame beans',25.0,75.0,'Protein',3),
('R062','ING050',150.0,'g','150g Tenderstem broccoli',75.0,225.0,'Protein',4),
('R062','ING220',30.0,'g','30g white miso paste',15.0,45.0,'Carb',5),
('R062','ING141',15.0,'ml','15g mirin',7.5,22.5,'Carb',6),
('R062','ING181',15.0,'ml','15g sake',7.5,22.5,'Carb',7),
('R062','ING011',12.0,'g','12g honey',6.0,18.0,'Carb',8),
('R062','ING187',21.0,'g','~21g sesame oil (1½ tbsp)',10.5,31.5,'Fat',9),
('R062','ING188',10.0,'g','10g black sesame seeds',5.0,15.0,'Fat',10),
('R062','ING085',1.0,'g','<1g chilli flakes (¼ tsp)',0.5,1.5,'Carb',11),
('R062','ING184',1.0,'g','Salt, to taste',0.5,1.5,'Carb',12),
('R063','ING117',180.0,'g','180g raw king prawns',90.0,270.0,'Protein',1),
('R063','ING075',10.0,'g','10g cornflour',5.0,15.0,'Carb',2),
('R063','ING103',175.0,'ml','175ml full-fat coconut milk',87.5,262.5,'Fat',3),
('R063','ING204',20.0,'g','20g Thai red curry paste',10.0,30.0,'Carb',4),
('R063','ING098',7.5,'g','15g fresh ginger, grated',6.5,8.5,'Carb',5),
('R063','ING104',1.0,'each','1 garlic clove, crushed',null,2.0,'Carb',6),
('R063','ING095',10.0,'ml','10ml fish sauce',5.0,15.0,'Protein',7),
('R063','ING051',5.0,'g','5g brown sugar',2.5,7.5,'Carb',8),
('R063','ING130',10.0,'ml','10ml lime juice',9.0,11.0,'Carb',9),
('R063','ING171',100.0,'g','100g red pepper, sliced',50.0,150.0,'Carb',10),
('R063','ING173',50.0,'g','50g red onion, sliced',25.0,75.0,'Carb',11),
('R063','ING194',2.0,'each','30g spring onion, sliced',1.0,3.0,'Carb',12),
('R063','ING099',10.0,'g','10g fresh coriander, chopped',5.0,15.0,'Carb',13),
('R063','ING172',0.5,'each','½ red chilli, sliced',null,1.5,'Carb',14),
('R063','ING042',55.0,'g','55g dry basmati rice',27.5,82.5,'Carb',15),
('R064','ING062',125.0,'g','125g raw chicken breast',62.5,187.5,'Protein',1),
('R064','ING164',10.0,'g','10g wholemeal flour',5.0,15.0,'Carb',2),
('R064','ING018',1.0,'each','1 small egg, beaten',null,2.0,'Protein',3),
('R064','ING049',15.0,'g','15g panko breadcrumbs',7.5,22.5,'Carb',4),
('R064','ING023',2.0,'g','~2g olive oil, for cooking (½ tsp)',1.0,3.0,'Fat',5),
('R064','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',6),
('R064','ING023',4.0,'g','4g olive oil, for the curry sauce',2.0,6.0,'Fat',7),
('R064','ING149',40.0,'g','40g onion, finely diced',20.0,60.0,'Carb',8),
('R064','ING057',30.0,'g','30g carrot, finely diced',15.0,45.0,'Carb',9),
('R064','ING104',3.333,'each','10g garlic, minced',2.33333333333333,4.33333333333333,'Carb',10),
('R064','ING098',2.5,'g','5g fresh ginger, grated',1.5,3.5,'Carb',11),
('R064','ING081',2.0,'g','~2g curry powder (1 tsp)',1.0,3.0,'Carb',12),
('R064','ING085',1.0,'g','~1g garam masala (½ tsp)',0.5,1.5,'Carb',13),
('R064','ING206',5.0,'g','~5g tomato purée (1 tsp)',2.5,7.5,'Carb',14),
('R064','ING197',150.0,'ml','150ml low-salt chicken stock',75.0,225.0,'Protein',15),
('R064','ING011',4.0,'g','~4g honey (½ tsp)',2.0,6.0,'Carb',16),
('R064','ING192',5.0,'ml','5g reduced-salt soy sauce',2.5,7.5,'Protein',17),
('R064','ING075',3.0,'g','3g cornflour mixed with 10ml water',1.5,4.5,'Carb',18),
('R064','ING042',55.0,'g','55g dry jasmine rice',27.5,82.5,'Carb',19),
('R065','ING124',170.0,'g','170g lean beef sirloin strips',85.0,255.0,'Protein',1),
('R065','ING075',3.0,'g','~3g cornflour (1 tsp)',1.5,4.5,'Carb',2),
('R065','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',3),
('R065','ING187',4.0,'g','~4g sesame oil (1 tsp)',2.0,6.0,'Fat',4),
('R065','ING113',33.0,'g','~33g hoisin sauce (1 tbsp + 2 tsp)',16.5,49.5,'Carb',5),
('R065','ING192',11.0,'ml','~11g reduced-salt soy sauce (2 tsp)',5.5,16.5,'Protein',6),
('R065','ING177',5.0,'ml','~5g rice vinegar (1 tsp)',2.5,7.5,'Carb',7),
('R065','ING011',4.0,'g','~4g honey (½ tsp)',2.0,6.0,'Carb',8),
('R065','ING098',1.0,'g','~2g fresh ginger, grated (1 tsp)',null,2.0,'Carb',9),
('R065','ING104',2.0,'each','~6g garlic, minced (2 tsp)',1.0,3.0,'Carb',10),
('R065','ING112',3.0,'g','~3g chilli paste (½ tsp)',1.5,4.5,'Carb',11),
('R065','ING075',3.0,'g','~3g cornflour mixed with 1 tbsp water (1 tsp)',1.5,4.5,'Carb',12),
('R065','ING140',50.0,'g','50g dry egg noodles',25.0,75.0,'Carb',13),
('R065','ING050',150.0,'g','150g broccoli florets',75.0,225.0,'Protein',14),
('R065','ING171',50.0,'g','50g green pepper, sliced',25.0,75.0,'Carb',15),
('R065','ING057',40.0,'g','40g carrot, sliced',20.0,60.0,'Carb',16),
('R065','ING194',2.0,'each','30g spring onions, chopped',1.0,3.0,'Carb',17),
('R065','ING188',9.0,'g','~9g sesame seeds (1 tbsp)',4.5,13.5,'Fat',18),
('R066','ING182',180.0,'g','180g salmon fillet',90.0,270.0,'Protein',1),
('R066','ING042',75.0,'g','75g dry jasmine rice',37.5,112.5,'Carb',2),
('R066','ING132',50.0,'ml','50ml light coconut milk',25.0,75.0,'Fat',3),
('R066','ING028',75.0,'ml','75ml water',37.5,112.5,'Carb',4),
('R066','ING138',80.0,'g','80g mango, diced',40.0,120.0,'Carb',5),
('R066','ING020',0.133,'each','20g avocado, diced',null,1.13333333333333,'Fat',6),
('R066','ING173',30.0,'g','30g red onion, finely diced',15.0,45.0,'Carb',7),
('R066','ING171',30.0,'g','30g red pepper, diced',15.0,45.0,'Carb',8),
('R066','ING099',10.0,'g','10g fresh coriander, chopped',5.0,15.0,'Carb',9),
('R066','ING115',0.5,'each','½ small jalapeño, finely chopped',null,1.5,'Carb',10),
('R066','ING130',15.0,'ml','~15g lime juice (1 tbsp)',14.0,16.0,'Carb',11),
('R066','ING134',0.045,'each','~2g lime zest (1 tsp)',null,1.04545454545455,'Carb',12),
('R066','ING085',2.0,'g','~2g ground cumin (1 tsp)',1.0,3.0,'Carb',13),
('R066','ING085',2.0,'g','~2g chilli powder (1 tsp)',1.0,3.0,'Carb',14),
('R066','ING085',2.0,'g','~2g paprika (1 tsp)',1.0,3.0,'Carb',15),
('R066','ING104',1.0,'each','1 garlic clove, crushed',null,2.0,'Carb',16),
('R066','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',17),
('R067','ING124',170.0,'g','170g lean sirloin beef strips',85.0,255.0,'Protein',1),
('R067','ING075',3.0,'g','~3g cornflour (1 tsp)',1.5,4.5,'Carb',2),
('R067','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',3),
('R067','ING140',120.0,'g','120g fresh egg noodles',60.0,180.0,'Carb',4),
('R067','ING187',7.0,'g','~7g sesame oil (1½ tsp)',3.5,10.5,'Fat',5),
('R067','ING192',32.0,'ml','~32g reduced-salt soy sauce (2 tbsp)',16.0,48.0,'Protein',6),
('R067','ING152',24.0,'g','~24g oyster sauce (1 tbsp + 1 tsp)',12.0,36.0,'Carb',7),
('R067','ING177',15.0,'ml','~15g rice vinegar (1 tbsp)',7.5,22.5,'Carb',8),
('R067','ING051',10.0,'g','~10g brown sugar (2½ tsp)',5.0,15.0,'Carb',9),
('R067','ING098',3.0,'g','~6g fresh ginger, grated (1 tbsp)',2.0,4.0,'Carb',10),
('R067','ING104',2.0,'each','2 garlic cloves, minced',1.0,3.0,'Carb',11),
('R067','ING050',200.0,'g','200g broccoli florets',100.0,300.0,'Protein',12),
('R067','ING171',50.0,'g','50g green pepper, sliced',25.0,75.0,'Carb',13),
('R067','ING194',2.0,'each','30g spring onions, sliced',1.0,3.0,'Carb',14),
('R067','ING188',6.0,'g','~6g sesame seeds (2 tsp)',3.0,9.0,'Fat',15),
('R067','ING099',10.0,'g','~10g fresh coriander, chopped (1 handful)',5.0,15.0,'Carb',16),
('R068','ING062',140.0,'g','140g raw chicken breast, diced',70.0,210.0,'Protein',1),
('R068','ING042',80.0,'g','80g dry basmati rice',40.0,120.0,'Carb',2),
('R068','ING039',16.0,'ml','~16g balsamic vinegar (1 tbsp)',8.0,24.0,'Carb',3),
('R068','ING023',9.0,'g','~9g extra virgin olive oil (2 tsp)',4.5,13.5,'Fat',4),
('R068','ING192',16.0,'ml','~16g reduced-salt soy sauce (1 tbsp)',8.0,24.0,'Protein',5),
('R068','ING200',40.0,'g','~40g sweet chilli sauce (2 tbsp)',20.0,60.0,'Carb',6),
('R068','ING172',1.0,'each','1 red chilli, sliced',null,2.0,'Carb',7),
('R068','ING104',2.0,'each','2 garlic cloves, crushed',1.0,3.0,'Carb',8),
('R068','ING098',1.0,'g','~2g fresh ginger, grated (1 tsp)',null,2.0,'Carb',9),
('R068','ING153',100.0,'g','100g pak choi, chopped',50.0,150.0,'Protein',10),
('R068','ING173',75.0,'g','½ small red onion, diced',37.5,112.5,'Carb',11),
('R068','ING099',10.0,'g','~10g fresh basil, chopped (1 handful)',5.0,15.0,'Carb',12),
('R068','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',13),
('R069','ING062',190.0,'g','190g raw chicken breast, cut into strips',95.0,285.0,'Protein',1),
('R069','ING042',70.0,'g','70g dry basmati rice',35.0,105.0,'Carb',2),
('R069','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',3),
('R069','ING011',21.0,'g','~21g honey (1 tbsp)',10.5,31.5,'Carb',4),
('R069','ING098',3.0,'g','~6g fresh ginger, grated (1 tbsp)',2.0,4.0,'Carb',5),
('R069','ING104',3.0,'each','3 garlic cloves, minced',2.0,4.0,'Carb',6),
('R069','ING192',16.0,'ml','~16g reduced-salt soy sauce (1 tbsp)',8.0,24.0,'Protein',7),
('R069','ING130',10.0,'ml','~10g lime juice (2 tsp)',9.0,11.0,'Carb',8),
('R069','ING206',5.0,'g','~5g tomato purée (1 tsp)',2.5,7.5,'Carb',9),
('R069','ING085',1.0,'g','~1g ground cumin (½ tsp)',0.5,1.5,'Carb',10),
('R069','ING085',1.0,'g','~1g chilli powder (½ tsp)',0.5,1.5,'Carb',11),
('R069','ING085',1.0,'g','~1g paprika (½ tsp)',0.5,1.5,'Carb',12),
('R069','ING075',1.0,'g','~1g cornflour mixed with 2 tsp water (½ tsp)',0.5,1.5,'Carb',13),
('R069','ING023',4.0,'g','~4g olive oil (1 tsp)',2.0,6.0,'Fat',14),
('R069','ING171',50.0,'g','50g green pepper, sliced',25.0,75.0,'Carb',15),
('R069','ING050',100.0,'g','100g broccoli florets',50.0,150.0,'Protein',16),
('R069','ING099',3.0,'g','~3g fresh coriander, chopped (1 tbsp)',1.5,4.5,'Carb',17),
('R069','ING188',3.0,'g','~3g sesame seeds (1 tsp)',1.5,4.5,'Fat',18),
('R070','ING063',210.0,'g','210g skinless, boneless chicken thighs',105.0,315.0,'Protein',1),
('R070','ING042',60.0,'g','60g dry long-grain rice',30.0,90.0,'Carb',2),
('R070','ING102',100.0,'g','100g garden peas',50.0,150.0,'Carb',3),
('R070','ING171',75.0,'g','½ red pepper, sliced',37.5,112.5,'Carb',4),
('R070','ING171',37.5,'g','¼ red pepper, diced',18.75,56.25,'Carb',5),
('R070','ING172',1.0,'each','1 red chilli, sliced',null,2.0,'Carb',6),
('R070','ING104',3.0,'each','3 garlic cloves, minced',2.0,4.0,'Carb',7),
('R070','ING085',5.0,'g','~5g smoked paprika (2 tsp)',2.5,7.5,'Carb',8),
('R070','ING085',1.0,'g','~1g dried oregano (1 tsp)',0.5,1.5,'Carb',9),
('R070','ING085',2.0,'g','~2g ground cumin (1 tsp)',1.0,3.0,'Carb',10),
('R070','ING130',15.0,'ml','~15g lemon juice (1 tbsp)',14.0,16.0,'Carb',11),
('R070','ING011',7.0,'g','~7g honey (1 tsp)',3.5,10.5,'Carb',12),
('R070','ING023',4.0,'g','~4g olive oil (1 tsp)',2.0,6.0,'Fat',13),
('R070','ING149',30.0,'g','30g onion, diced',15.0,45.0,'Carb',14),
('R070','ING206',5.0,'g','~5g tomato purée (1 tsp)',2.5,7.5,'Carb',15),
('R070','ING085',1.0,'g','~1g ground cumin (½ tsp)',0.5,1.5,'Carb',16),
('R070','ING085',1.0,'g','~1g smoked paprika (½ tsp)',0.5,1.5,'Carb',17),
('R070','ING197',200.0,'ml','200ml low-salt chicken stock',100.0,300.0,'Protein',18),
('R070','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',19),
('R071','ING062',125.0,'g','125g raw chicken breast, diced',62.5,187.5,'Protein',1),
('R071','ING100',215.0,'g','215g fresh potato gnocchi',107.5,322.5,'Carb',2),
('R071','ING023',9.0,'g','~9g olive oil (2 tsp)',4.5,13.5,'Fat',3),
('R071','ING130',10.0,'ml','~10g lemon juice (2 tsp)',9.0,11.0,'Carb',4),
('R071','ING129',0.034,'each','~2g lemon zest (1 tsp)',null,1.03448275862069,'Carb',5),
('R071','ING085',3.0,'g','~3g garlic powder (1 tsp)',1.5,4.5,'Carb',6),
('R071','ING085',1.0,'g','~1g dried oregano (1 tsp)',0.5,1.5,'Carb',7),
('R071','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',8),
('R071','ING104',2.0,'each','~6g minced garlic (2 tsp)',1.0,3.0,'Carb',9),
('R071','ING171',60.0,'g','60g green pepper, sliced',30.0,90.0,'Carb',10),
('R071','ING061',80.0,'g','80g cherry tomatoes, halved',40.0,120.0,'Carb',11),
('R071','ING193',60.0,'g','60g baby spinach',30.0,90.0,'Protein',12),
('R071','ING130',20.0,'ml','~20g lemon juice (4 tsp)',19.0,21.0,'Carb',13),
('R071','ING197',15.0,'ml','~15g low-salt chicken stock (1 tbsp)',7.5,22.5,'Protein',14),
('R071','ING030',40.0,'g','40g low-fat Greek yoghurt',20.0,60.0,'Protein',15),
('R071','ING154',20.0,'g','20g Parmesan, grated',10.0,30.0,'Protein',16),
('R071','ING099',4.0,'g','~4g fresh parsley, chopped (1 tbsp)',2.0,6.0,'Carb',17),
('R071','ING099',3.0,'g','~3g fresh basil, chopped (1 tbsp)',1.5,4.5,'Carb',18),
('R071','ING099',5.0,'g','Lemon slices, to garnish',2.5,7.5,'Carb',19),
('R072','ING062',190.0,'g','190g raw chicken breast, sliced',95.0,285.0,'Protein',1),
('R072','ING042',70.0,'g','70g dry jasmine rice',35.0,105.0,'Carb',2),
('R072','ING131',1.0,'each','1 stalk lemongrass, finely minced',null,2.0,'Carb',3),
('R072','ING104',2.0,'each','2 garlic cloves, minced',1.0,3.0,'Carb',4),
('R072','ING098',1.0,'g','~2g fresh ginger, grated (1 tsp)',null,2.0,'Carb',5),
('R072','ING192',11.0,'ml','~11g reduced-salt soy sauce (2 tsp)',5.5,16.5,'Protein',6),
('R072','ING051',4.0,'g','~4g brown sugar (1 tsp)',2.0,6.0,'Carb',7),
('R072','ING130',5.0,'ml','~5g lime juice (1 tsp)',4.0,6.0,'Carb',8),
('R072','ING213',11.0,'g','~11g vegetable oil (2½ tsp)',5.5,16.5,'Fat',9),
('R072','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',10),
('R072','ING057',70.0,'g','70g carrot, finely sliced',35.0,105.0,'Carb',11),
('R072','ING080',50.0,'g','50g cucumber, chopped',25.0,75.0,'Carb',12),
('R072','ING143',40.0,'g','40g lettuce, shredded',20.0,60.0,'Carb',13),
('R072','ING099',10.0,'g','~10g fresh mint and coriander, chopped. (1 handful)',5.0,15.0,'Carb',14),
('R072','ING192',11.0,'ml','~11g reduced-salt soy sauce (2 tsp)',5.5,16.5,'Protein',15),
('R072','ING130',10.0,'ml','~10g lime juice (2 tsp)',9.0,11.0,'Carb',16),
('R072','ING028',15.0,'ml','~15g water (1 tbsp)',7.5,22.5,'Carb',17),
('R072','ING104',1.0,'each','~3g garlic, minced (1 tsp)',null,2.0,'Carb',18),
('R072','ING172',1.0,'each','1 Thai chilli, finely sliced (optional)',null,2.0,'Carb',19),
('R073','ING062',160.0,'g','160g raw chicken breast, butterflied',80.0,240.0,'Protein',1),
('R073','ING053',1.0,'each','1 brioche burger bun (~70g)',null,2.0,'Carb',2),
('R073','ING201',220.0,'g','220g sweet potato, cut into fries',110.0,330.0,'Carb',3),
('R073','ING020',0.3,'each','45g avocado, mashed',null,1.3,'Fat',4),
('R073','ING143',40.0,'g','40g mixed leaves',20.0,60.0,'Carb',5),
('R073','ING205',60.0,'g','½ medium tomato, sliced',30.0,90.0,'Carb',6),
('R073','ING173',30.0,'g','30g red onion, sliced',15.0,45.0,'Carb',7),
('R073','ING105',15.0,'g','15g sliced pickles',7.5,22.5,'Carb',8),
('R073','ING023',9.0,'g','~9g olive oil (2 tsp)',4.5,13.5,'Fat',9),
('R073','ING184',1.0,'g','Salt & black pepper',0.5,1.5,'Carb',10),
('R073','ING085',1.0,'g','~1g paprika (½ tsp)',0.5,1.5,'Carb',11),
('R073','ING030',30.0,'g','30g 0% Greek yoghurt',15.0,45.0,'Protein',12),
('R073','ING133',9.0,'g','~9g light mayonnaise (2 tsp)',4.5,13.5,'Fat',13),
('R073','ING084',5.0,'g','~5g Dijon mustard (1 tsp)',2.5,7.5,'Protein',14),
('R073','ING011',7.0,'g','~7g honey (1 tsp)',3.5,10.5,'Carb',15),
('R073','ING085',2.0,'g','~2g garlic powder (½ tsp)',1.0,3.0,'Carb',16),
('R074','ING156',110.0,'g','110g dried fusilli pasta',55.0,165.0,'Carb',1),
('R074','ING062',80.0,'g','80g raw chicken breast, diced',40.0,120.0,'Protein',2),
('R074','ING184',1.0,'g','Salt, black pepper & mixed herbs',0.5,1.5,'Carb',3),
('R074','ING023',7.0,'g','~7g olive oil (1½ tsp)',3.5,10.5,'Fat',4),
('R074','ING050',60.0,'g','60g broccoli florets',30.0,90.0,'Protein',5),
('R074','ING061',50.0,'g','50g cherry tomatoes, halved',25.0,75.0,'Carb',6),
('R074','ING171',40.0,'g','40g red pepper, diced',20.0,60.0,'Carb',7),
('R074','ING173',30.0,'g','30g red onion, sliced',15.0,45.0,'Carb',8),
('R074','ING193',40.0,'g','40g baby spinach',20.0,60.0,'Protein',9),
('R074','ING104',1.0,'each','1 garlic clove, crushed',null,2.0,'Carb',10),
('R074','ING004',40.0,'g','40g 0% Fat Greek yoghurt',20.0,60.0,'Protein',11),
('R074','ING154',15.0,'g','15g Parmesan, grated',7.5,22.5,'Protein',12),
('R074','ING130',5.0,'ml','~5g lemon juice (1 tsp)',4.0,6.0,'Carb',13),
('R074','ING099',3.0,'g','~3g fresh basil and parsley, chopped (1 tbsp)',1.5,4.5,'Carb',14),
('R074','ING028',15.0,'ml','~15g reserved pasta water (1 tbsp)',7.5,22.5,'Carb',15),
('R075','ING004',122.0,'g','~122g 0% Fat Greek Yoghurt (1/2 Cup)',61.0,183.0,'Protein',1),
('R075','ING023',14.0,'g','~14g Olive Oil (1 Tbsp)',7.0,21.0,'Fat',2),
('R075','ING130',15.0,'ml','~15g Lemon Juice (1 Tbsp)',14.0,16.0,'Carb',3),
('R075','ING099',4.0,'g','~4g Fresh Parsley (1 Tbsp)',2.0,6.0,'Carb',4),
('R075','ING085',3.0,'g','~3g Garlic Powder (1 Tsp)',1.5,4.5,'Carb',5),
('R075','ING085',2.0,'g','~2g Onion Powder (1 Tsp)',1.0,3.0,'Carb',6),
('R075','ING084',5.0,'g','~5g Dijon Mustard (1 Tsp)',2.5,7.5,'Protein',7),
('R075','ING184',1.0,'g','Salt & Pepper to Taste',0.5,1.5,'Carb',8),
('R075','ING028',1.0,'ml','Water as Required for Texture',0.5,1.5,'Carb',9),
('R076','ING030',61.0,'g','~61g 0% Greek Yoghurt (1/4 Cup)',30.5,91.5,'Protein',1),
('R076','ING084',15.0,'g','~15g Dijon Mustard (1 Tbsp)',7.5,22.5,'Protein',2),
('R076','ING011',7.0,'g','~7g Hone (1 Tsp)',3.5,10.5,'Carb',3),
('R076','ING130',15.0,'ml','~15g Lime Juice (1 Tbsp)',14.0,16.0,'Carb',4),
('R076','ING104',1.0,'each','1 Garlic Clove',null,2.0,'Carb',5),
('R076','ING184',1.0,'g','Salt & Pepper',0.5,1.5,'Carb',6),
('R076','ING028',1.0,'ml','Water as Needed',0.5,1.5,'Carb',7),
('R078','ING008',35.0,'g','35g Porridge Oats',17.5,52.5,'Carb',1),
('R078','ING006',200.0,'ml','200ml Semi-Skimmed Milk',100.0,300.0,'Carb',2),
('R078','ING005',25.0,'g','25g Vanilla Whey Protein Powder',12.5,37.5,'Protein',3),
('R078','ING001',0.508,'each','60g Banana, sliced',null,1.50847457627119,'Carb',4),
('R078','ING142',80.0,'g','80g Mixed Berries (strawberries, blueberries, raspberries)',40.0,120.0,'Carb',5),
('R078','ING011',7.0,'g','1 Tsp Honey',3.5,10.5,'Carb',6),
('R079','ING008',35.0,'g','35g Porridge Oats',17.5,52.5,'Carb',1),
('R079','ING006',100.0,'ml','100ml Semi-Skimmed Milk',50.0,150.0,'Carb',2),
('R079','ING004',150.0,'g','150g 0% Fat Greek Yoghurt (for soaking)',75.0,225.0,'Protein',3),
('R079','ING034',1.0,'each','1 Small Apple, grated (approx 80g)',null,2.0,'Carb',4),
('R079','ING130',1.0,'ml','Squeeze of Lemon Juice',null,2.0,'Carb',5),
('R079','ING085',1.0,'g','Pinch of Cinnamon',0.5,1.5,'Carb',6),
('R079','ING004',50.0,'g','50g 0% Fat Greek Yoghurt (for topping)',25.0,75.0,'Protein',7),
('R079','ING138',40.0,'g','40g Fresh Mango, diced or pureed',20.0,60.0,'Carb',8),
('R079','ING032',8.0,'g','8g Flaked Almonds',4.0,12.0,'Fat',9),
('R080','ING171',300.0,'g','2 Red Peppers',150.0,450.0,'Carb',1),
('R080','ING155',400.0,'g','400g Tin Chopped Tomatoes',200.0,600.0,'Carb',2),
('R080','ING173',75.0,'g','1/2 Red Onion',37.5,112.5,'Carb',3),
('R080','ING104',2.0,'each','2 Cloves Garlic',1.0,3.0,'Carb',4),
('R080','ING197',300.0,'ml','300ml Vegetable Stock',150.0,450.0,'Protein',5),
('R080','ING087',30.0,'g','30g Dried Red Lentils',15.0,45.0,'Carb',6),
('R080','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',7),
('R080','ING099',5.0,'g','Handful Fresh Basil',2.5,7.5,'Carb',8),
('R080','ING221',2.0,'each','2 Slices Wholegrain Bread',1.0,3.0,'Carb',9),
('R080','ING175',40.0,'g','40g Reduced-Fat Mature Cheddar',20.0,60.0,'Protein',10),
('R080','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R081','ING062',120.0,'g','120g Chicken Breast',60.0,180.0,'Protein',1),
('R081','ING197',600.0,'ml','600ml Chicken Stock',300.0,900.0,'Protein',2),
('R081','ING202',80.0,'g','80g Sweetcorn',40.0,120.0,'Carb',3),
('R081','ING140',50.0,'g','50g Medium Egg Noodles (dry weight)',25.0,75.0,'Carb',4),
('R081','ING018',1.0,'each','1 Egg',null,2.0,'Protein',5),
('R081','ING194',2.0,'each','2 Spring Onions',1.0,3.0,'Carb',6),
('R081','ING104',1.0,'each','1 Clove Garlic',null,2.0,'Carb',7),
('R081','ING098',1.0,'g','1cm Fresh Ginger',null,2.0,'Carb',8),
('R081','ING192',5.0,'ml','1 Tsp Light Soy Sauce',2.5,7.5,'Protein',9),
('R081','ING184',1.0,'g','Pinch White Pepper',0.5,1.5,'Carb',10),
('R082','ING102',250.0,'g','250g Frozen Peas',125.0,375.0,'Carb',1),
('R082','ING197',500.0,'ml','500ml Vegetable Stock',250.0,750.0,'Protein',2),
('R082','ING189',40.0,'g','1 Shallot',20.0,60.0,'Carb',3),
('R082','ING104',1.0,'each','1 Clove Garlic',null,2.0,'Carb',4),
('R082','ING099',5.0,'g','Handful Fresh Mint',2.5,7.5,'Carb',5),
('R082','ING004',30.0,'g','2 Tbsp 0% Fat Greek Yoghurt',15.0,45.0,'Protein',6),
('R082','ING018',1.0,'each','1 Egg',null,2.0,'Protein',7),
('R082','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',8),
('R082','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',9),
('R083','ING059',300.0,'g','300g Cauliflower Florets',150.0,450.0,'Carb',1),
('R083','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',2),
('R083','ING197',500.0,'ml','500ml Vegetable Stock',250.0,750.0,'Protein',3),
('R083','ING220',31.5,'g','1.5 Tbsp White Miso Paste',15.75,47.25,'Carb',4),
('R083','ING190',100.0,'g','100g Silken Tofu',50.0,150.0,'Protein',5),
('R083','ING104',1.0,'each','1 Clove Garlic',null,2.0,'Carb',6),
('R083','ING098',1.0,'g','1cm Fresh Ginger',null,2.0,'Carb',7),
('R083','ING194',1.0,'each','1 Spring Onion',null,2.0,'Carb',8),
('R083','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',9),
('R084','ING057',400.0,'g','400g Carrots',200.0,600.0,'Carb',1),
('R084','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',2),
('R084','ING085',1.25,'g','1/2 Tsp Ground Cumin',0.62,1.88,'Carb',3),
('R084','ING149',75.0,'g','1/2 Onion',37.5,112.5,'Carb',4),
('R084','ING104',1.0,'each','1 Clove Garlic',null,2.0,'Carb',5),
('R084','ING197',500.0,'ml','500ml Vegetable Stock',250.0,750.0,'Protein',6),
('R084','ING111',60.0,'g','60g Halloumi Cheese',30.0,90.0,'Fat',7),
('R084','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',8),
('R085','ING117',150.0,'g','150g Raw King Prawns',75.0,225.0,'Protein',1),
('R085','ING223',6.0,'each','6 Wonton Wrappers',5.0,7.0,'Carb',2),
('R085','ING098',1.0,'g','1cm Fresh Ginger',null,2.0,'Carb',3),
('R085','ING104',1.0,'each','1 Clove Garlic',null,2.0,'Carb',4),
('R085','ING194',2.0,'each','2 Spring Onions',1.0,3.0,'Carb',5),
('R085','ING187',2.25,'g','1/2 Tsp Sesame Oil',1.12,3.38,'Fat',6),
('R085','ING197',600.0,'ml','600ml Fish or Chicken Stock',300.0,900.0,'Protein',7),
('R085','ING192',5.0,'ml','1 Tsp Light Soy Sauce',2.5,7.5,'Protein',8),
('R085','ING153',100.0,'g','100g Pak Choi',50.0,150.0,'Protein',9),
('R085','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R086','ING124',130.0,'g','130g Lean Beef Sirloin Strips',65.0,195.0,'Protein',1),
('R086','ING075',3.0,'g','1 Tsp Cornflour',1.5,4.5,'Carb',2),
('R086','ING140',60.0,'g','60g Medium Egg Noodles (dry weight)',30.0,90.0,'Carb',3),
('R086','ING197',600.0,'ml','600ml Beef Stock',300.0,900.0,'Protein',4),
('R086','ING104',1.0,'each','1 Clove Garlic',null,2.0,'Carb',5),
('R086','ING098',1.0,'g','1cm Fresh Ginger',null,2.0,'Carb',6),
('R086','ING044',50.0,'g','50g Beansprouts',25.0,75.0,'Carb',7),
('R086','ING153',50.0,'g','50g Pak Choi',25.0,75.0,'Protein',8),
('R086','ING192',5.0,'ml','1 Tsp Light Soy Sauce',2.5,7.5,'Protein',9),
('R086','ING187',4.5,'g','1 Tsp Sesame Oil',2.25,6.75,'Fat',10),
('R086','ING188',5.0,'g','1 Tsp Sesame Seeds',2.5,7.5,'Fat',11),
('R086','ING172',0.5,'each','1/2 Red Chilli',null,1.5,'Carb',12),
('R086','ING194',1.0,'each','1 Spring Onion',null,2.0,'Carb',13),
('R087','ING128',150.0,'g','150g Lean Turkey Mince (5% Fat)',75.0,225.0,'Protein',1),
('R087','ING049',15.0,'g','1 Tbsp Fresh Breadcrumbs',7.5,22.5,'Carb',2),
('R087','ING149',75.0,'g','1/2 Onion',37.5,112.5,'Carb',3),
('R087','ING104',2.0,'each','2 Cloves Garlic',1.0,3.0,'Carb',4),
('R087','ING155',400.0,'g','400g Tin Chopped Tomatoes',200.0,600.0,'Carb',5),
('R087','ING197',300.0,'ml','300ml Vegetable Stock',150.0,450.0,'Protein',6),
('R087','ING151',30.0,'g','30g Dried Orzo Pasta',15.0,45.0,'Carb',7),
('R087','ING099',5.0,'g','Handful Fresh Basil',2.5,7.5,'Carb',8),
('R087','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',9),
('R088','ING219',80.0,'g','80g White Fish Fillet (e.g. Cod or Hake)',40.0,120.0,'Protein',1),
('R088','ING117',60.0,'g','60g Raw King Prawns',30.0,90.0,'Protein',2),
('R088','ING146',100.0,'g','100g Mussels (in shell, cleaned)',50.0,150.0,'Protein',3),
('R088','ING149',75.0,'g','1/2 Onion',37.5,112.5,'Carb',4),
('R088','ING104',1.0,'each','1 Clove Garlic',null,2.0,'Carb',5),
('R088','ING092',100.0,'g','1/2 Fennel Bulb',50.0,150.0,'Carb',6),
('R088','ING155',400.0,'g','400g Tin Chopped Tomatoes',200.0,600.0,'Carb',7),
('R088','ING197',400.0,'ml','400ml Fish Stock',200.0,600.0,'Protein',8),
('R088','ING180',1.0,'g','Pinch Saffron',0.5,1.5,'Carb',9),
('R088','ING150',1.0,'each','Strip Orange Zest',null,2.0,'Carb',10),
('R088','ING037',1.0,'each','1 Slice Baguette',null,2.0,'Carb',11),
('R088','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',12),
('R089','ING062',130.0,'g','130g Chicken Breast (butterflied)',65.0,195.0,'Protein',1),
('R089','ING049',25.0,'g','25g Panko Breadcrumbs',12.5,37.5,'Carb',2),
('R089','ING164',9.0,'g','1 Tbsp Plain Flour',4.5,13.5,'Carb',3),
('R089','ING019',1.0,'each','1 Egg White, beaten',null,2.0,'Protein',4),
('R089','ING121',1.0,'each','1 Wholemeal Tortilla Wrap',null,2.0,'Carb',5),
('R089','ING004',45.0,'g','3 Tbsp 0% Fat Greek Yoghurt',22.5,67.5,'Protein',6),
('R089','ING084',7.0,'g','1 Tsp Dijon Mustard',3.5,10.5,'Protein',7),
('R089','ING130',1.0,'ml','1 Tsp Lemon Juice',null,2.0,'Carb',8),
('R089','ING104',0.5,'each','1/2 Clove Garlic, crushed',null,1.5,'Carb',9),
('R089','ING154',10.0,'g','10g Parmesan, finely grated',5.0,15.0,'Protein',10),
('R089','ING143',40.0,'g','40g Little Gem Lettuce, shredded',20.0,60.0,'Carb',11),
('R089','ING135',1.0,'g','1 Spray Cooking Oil',0.5,1.5,'Fat',12),
('R089','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',13),
('R090','ING062',150.0,'g','150g Chicken Breast',75.0,225.0,'Protein',1),
('R090','ING036',42.0,'g','2 Tbsp Reduced-Sugar BBQ Sauce',21.0,63.0,'Carb',2),
('R090','ING048',1.0,'each','1 Wholemeal Roll',null,2.0,'Carb',3),
('R090','ING216',60.0,'g','60g White Cabbage, finely shredded',30.0,90.0,'Carb',4),
('R090','ING057',30.0,'g','30g Carrot, grated',15.0,45.0,'Carb',5),
('R090','ING173',37.5,'g','1/4 Red Onion, thinly sliced',18.75,56.25,'Carb',6),
('R090','ING004',22.5,'g','1.5 Tbsp 0% Fat Greek Yoghurt',11.25,33.75,'Protein',7),
('R090','ING067',5.0,'ml','1 Tsp Cider Vinegar',2.5,7.5,'Carb',8),
('R090','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',9),
('R091','ING062',130.0,'g','130g Chicken Breast',65.0,195.0,'Protein',1),
('R091','ING085',1.25,'g','1/2 Tsp Ground Cumin',0.62,1.88,'Carb',2),
('R091','ING085',1.25,'g','1/2 Tsp Smoked Paprika',0.62,1.88,'Carb',3),
('R091','ING085',1.25,'g','1/2 Tsp Ground Coriander',0.62,1.88,'Carb',4),
('R091','ING121',1.0,'each','1 Large Wholemeal Tortilla Wrap',null,2.0,'Carb',5),
('R091','ING042',40.0,'g','40g Basmati Rice (dry weight), cooked',20.0,60.0,'Carb',6),
('R091','ING047',60.0,'g','60g Black Beans, drained and rinsed',30.0,90.0,'Carb',7),
('R091','ING205',40.0,'g','40g Tomato, diced',20.0,60.0,'Carb',8),
('R091','ING173',37.5,'g','1/4 Red Onion, diced',18.75,56.25,'Carb',9),
('R091','ING099',5.0,'g','Handful Fresh Coriander, chopped',2.5,7.5,'Carb',10),
('R091','ING134',0.5,'each','1/2 Lime, juiced',null,1.5,'Carb',11),
('R091','ING004',30.0,'g','2 Tbsp 0% Fat Greek Yoghurt',15.0,45.0,'Protein',12),
('R091','ING175',15.0,'g','15g Reduced-Fat Cheddar, grated',7.5,22.5,'Protein',13),
('R091','ING143',20.0,'g','20g Little Gem Lettuce, shredded',10.0,30.0,'Carb',14),
('R091','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',15),
('R092','ING062',140.0,'g','140g Chicken Breast',70.0,210.0,'Protein',1),
('R092','ING004',30.0,'g','2 Tbsp 0% Fat Greek Yoghurt (for marinade)',15.0,45.0,'Protein',2),
('R092','ING081',7.5,'g','1 Tbsp Tandoori Spice',3.75,11.25,'Carb',3),
('R092','ING129',0.5,'each','1/2 Lemon, juiced',null,1.5,'Carb',4),
('R092','ING162',1.0,'each','1 Wholemeal Pitta',null,2.0,'Carb',5),
('R092','ING137',21.0,'g','1 Tbsp Low-Sugar Mango Chutney',10.5,31.5,'Carb',6),
('R092','ING004',45.0,'g','3 Tbsp 0% Fat Greek Yoghurt (for raita)',22.5,67.5,'Protein',7),
('R092','ING080',40.0,'g','40g Cucumber, finely diced',20.0,60.0,'Carb',8),
('R092','ING099',5.0,'g','1 Tsp Fresh Mint, chopped',2.5,7.5,'Carb',9),
('R092','ING143',20.0,'g','20g Little Gem Lettuce, shredded',10.0,30.0,'Carb',10),
('R092','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R093','ING124',130.0,'g','130g Lean Sirloin Steak, thinly sliced',65.0,195.0,'Protein',1),
('R093','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',2),
('R093','ING171',75.0,'g','1/2 Green Pepper, sliced',37.5,112.5,'Carb',3),
('R093','ING149',75.0,'g','1/2 White Onion, sliced',37.5,112.5,'Carb',4),
('R093','ING037',2.4,'each','60g Thin Wholemeal Baguette (half a baguette)',1.4,3.4,'Carb',5),
('R093','ING175',30.0,'g','30g Reduced-Fat Cheddar, grated',15.0,45.0,'Protein',6),
('R093','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',7),
('R094','ING123',130.0,'g','130g Lean Beef Mince (5% fat) or Turkey Mince',65.0,195.0,'Protein',1),
('R094','ING049',15.0,'g','1 Tbsp Fresh Breadcrumbs',7.5,22.5,'Carb',2),
('R094','ING104',0.5,'each','1/2 Clove Garlic, crushed',null,1.5,'Carb',3),
('R094','ING085',2.5,'g','1 Tsp Dried Oregano',1.25,3.75,'Carb',4),
('R094','ING155',120.0,'g','120g Chopped Tomatoes',60.0,180.0,'Carb',5),
('R094','ING104',0.5,'each','1/2 Clove Garlic, crushed (for sauce)',null,1.5,'Carb',6),
('R094','ING099',5.0,'g','Few Fresh Basil Leaves',2.5,7.5,'Carb',7),
('R094','ING079',0.5,'each','1/2 Croissant',null,1.5,'Carb',8),
('R094','ING048',0.5,'each','1/2 Light Bread Roll',null,1.5,'Carb',9),
('R094','ING176',15.0,'g','15g Mozzarella',7.5,22.5,'Protein',10),
('R094','ING135',1.0,'g','1 Spray Cooking Oil',0.5,1.5,'Fat',11),
('R094','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',12),
('R095','ING209',120.0,'g','1 Can Tuna in Spring Water (120g drained), drained',0.5,1.5,'Protein',1),
('R095','ING004',30.0,'g','2 Tbsp 0% Fat Greek Yoghurt',15.0,45.0,'Protein',2),
('R095','ING084',7.0,'g','1 Tsp Dijon Mustard',3.5,10.5,'Protein',3),
('R095','ING194',1.0,'each','1 Spring Onion, finely sliced',null,2.0,'Carb',4),
('R095','ING202',20.0,'g','20g Sweetcorn',10.0,30.0,'Carb',5),
('R095','ING221',2.0,'each','2 Slices Wholegrain Bread',1.0,3.0,'Carb',6),
('R095','ING175',25.0,'g','25g Reduced-Fat Cheddar, grated',12.5,37.5,'Protein',7),
('R095','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',8),
('R096','ING219',130.0,'g','130g White Fish Fillet (cod or haddock), cut into strips',65.0,195.0,'Protein',1),
('R096','ING164',9.0,'g','1 Tbsp Plain Flour',4.5,13.5,'Carb',2),
('R096','ING019',1.0,'each','1 Egg White, beaten',null,2.0,'Protein',3),
('R096','ING049',25.0,'g','25g Panko Breadcrumbs',12.5,37.5,'Carb',4),
('R096','ING048',1.0,'each','1 Soft Wholemeal Roll',null,2.0,'Carb',5);
insert into ri_stage values
('R096','ING004',30.0,'g','2 Tbsp 0% Fat Greek Yoghurt',15.0,45.0,'Protein',6),
('R096','ING105',5.0,'g','1 Tsp Chopped Gherkin',2.5,7.5,'Carb',7),
('R096','ING056',5.0,'g','1 Tsp Capers',2.5,7.5,'Carb',8),
('R096','ING129',0.5,'each','1/2 Lemon, juiced',null,1.5,'Carb',9),
('R096','ING143',20.0,'g','20g Little Gem Lettuce, shredded',10.0,30.0,'Carb',10),
('R096','ING135',1.0,'g','1 Spray Cooking Oil',0.5,1.5,'Fat',11),
('R096','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',12),
('R097','ING062',140.0,'g','140g Chicken Breast',70.0,210.0,'Protein',1),
('R097','ING085',2.5,'g','1 Tsp Dried Oregano',1.25,3.75,'Carb',2),
('R097','ING129',0.5,'each','1/2 Lemon, juiced',null,1.5,'Carb',3),
('R097','ING104',0.5,'each','1/2 Clove Garlic, crushed',null,1.5,'Carb',4),
('R097','ING162',1.0,'each','1 Wholemeal Pitta',null,2.0,'Carb',5),
('R097','ING114',30.0,'g','30g Hummus',15.0,45.0,'Fat',6),
('R097','ING080',40.0,'g','40g Cucumber, sliced',20.0,60.0,'Carb',7),
('R097','ING205',40.0,'g','40g Tomato, sliced',20.0,60.0,'Carb',8),
('R097','ING173',37.5,'g','1/4 Red Onion, thinly sliced',18.75,56.25,'Carb',9),
('R097','ING093',10.0,'g','10g Feta, crumbled',5.0,15.0,'Fat',10),
('R097','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R098','ING062',140.0,'g','140g Chicken Breast',70.0,210.0,'Protein',1),
('R098','ING192',15.0,'ml','1 Tbsp Reduced-Salt Soy Sauce',7.5,22.5,'Protein',2),
('R098','ING177',5.0,'ml','1 Tsp Rice Vinegar',2.5,7.5,'Carb',3),
('R098','ING011',3.5,'g','1/2 Tsp Runny Honey',1.75,5.25,'Carb',4),
('R098','ING104',0.5,'each','1/2 Clove Garlic, crushed',null,1.5,'Carb',5),
('R098','ING098',0.5,'g','1/2 Tsp Fresh Ginger, grated',null,1.5,'Carb',6),
('R098','ING187',2.25,'g','1/2 Tsp Sesame Oil',1.12,3.38,'Fat',7),
('R098','ING121',1.0,'each','1 Wholemeal Tortilla Wrap',null,2.0,'Carb',8),
('R098','ING080',50.0,'g','50g Cucumber, ribboned',25.0,75.0,'Carb',9),
('R098','ING194',1.0,'each','1 Spring Onion, finely sliced',null,2.0,'Carb',10),
('R098','ING188',5.0,'g','1 Tsp Sesame Seeds',2.5,7.5,'Fat',11),
('R098','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',12),
('R099','ING062',140.0,'g','140g Chicken Breast',70.0,210.0,'Protein',1),
('R099','ING085',2.5,'g','1 Tsp Ground Cumin',1.25,3.75,'Carb',2),
('R099','ING085',2.5,'g','1 Tsp Smoked Paprika',1.25,3.75,'Carb',3),
('R099','ING085',1.25,'g','1/2 Tsp Ground Turmeric',0.62,1.88,'Carb',4),
('R099','ING104',0.5,'each','1/2 Clove Garlic, crushed',null,1.5,'Carb',5),
('R099','ING129',0.5,'each','1/2 Lemon, juiced',null,1.5,'Carb',6),
('R099','ING222',1.0,'each','1 Wholemeal Flatbread',null,2.0,'Carb',7),
('R099','ING004',45.0,'g','3 Tbsp 0% Fat Greek Yoghurt',22.5,67.5,'Protein',8),
('R099','ING104',0.5,'each','1/2 Clove Garlic, crushed (for sauce)',null,1.5,'Carb',9),
('R099','ING216',30.0,'g','30g Red Cabbage, finely shredded',15.0,45.0,'Carb',10),
('R099','ING205',20.0,'g','20g Tomato, diced',10.0,30.0,'Carb',11),
('R099','ING143',20.0,'g','20g Little Gem Lettuce, shredded',10.0,30.0,'Carb',12),
('R099','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',13),
('R100','ING062',140.0,'g','140g Chicken Breast',70.0,210.0,'Protein',1),
('R100','ING159',15.0,'g','1 Tbsp Peri-Peri Marinade',7.5,22.5,'Carb',2),
('R100','ING111',30.0,'g','30g Halloumi Cheese, sliced',15.0,45.0,'Fat',3),
('R100','ING048',1.0,'each','1 Wholemeal Roll',null,2.0,'Carb',4),
('R100','ING179',20.0,'g','20g Rocket',10.0,30.0,'Protein',5),
('R100','ING171',37.5,'g','1/4 Red Pepper, roasted and sliced',18.75,56.25,'Carb',6),
('R100','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',7),
('R101','ING062',130.0,'g','130g Chicken Breast (butterflied)',65.0,195.0,'Protein',1),
('R101','ING164',9.0,'g','1 Tbsp Plain Flour',4.5,13.5,'Carb',2),
('R101','ING019',1.0,'each','1 Egg White, beaten',null,2.0,'Protein',3),
('R101','ING049',25.0,'g','25g Panko Breadcrumbs',12.5,37.5,'Carb',4),
('R101','ING048',1.0,'each','1 Soft Milk Bun',null,2.0,'Carb',5),
('R101','ING216',50.0,'g','50g White Cabbage, finely shredded',25.0,75.0,'Carb',6),
('R101','ING004',22.5,'g','1.5 Tbsp 0% Fat Greek Yoghurt',11.25,33.75,'Protein',7),
('R101','ING067',5.0,'ml','1 Tsp Cider Vinegar',2.5,7.5,'Carb',8),
('R101','ING105',2.0,'g','2 Slices Pickled Gherkin',1.0,3.0,'Carb',9),
('R101','ING135',1.0,'g','1 Spray Cooking Oil',0.5,1.5,'Fat',10),
('R101','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R102','ING208',130.0,'g','130g Fresh Tuna Steak',65.0,195.0,'Protein',1),
('R102','ING023',2.25,'g','1/2 Tsp Olive Oil',1.12,3.38,'Fat',2),
('R102','ING072',2.0,'each','2 Small Corn Tortillas',1.0,3.0,'Carb',3),
('R102','ING135',1.0,'g','1 Spray Cooking Oil',0.5,1.5,'Fat',4),
('R102','ING205',40.0,'g','40g Tomato, diced',20.0,60.0,'Carb',5),
('R102','ING173',37.5,'g','1/4 Red Onion, finely diced',18.75,56.25,'Carb',6),
('R102','ING134',0.5,'each','1/2 Lime, juiced',null,1.5,'Carb',7),
('R102','ING099',5.0,'g','Handful Fresh Coriander, chopped',2.5,7.5,'Carb',8),
('R102','ING020',0.25,'each','1/4 Avocado, sliced',null,1.25,'Fat',9),
('R102','ING216',30.0,'g','30g Shredded Cabbage',15.0,45.0,'Carb',10),
('R102','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R103','ING117',160.0,'g','160g Raw King Prawns, peeled',80.0,240.0,'Protein',1),
('R103','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',2),
('R103','ING085',1.25,'g','1/2 Tsp Smoked Paprika',0.62,1.88,'Carb',3),
('R103','ING104',0.5,'each','1/2 Clove Garlic, crushed',null,1.5,'Carb',4),
('R103','ING072',2.0,'each','2 Small Soft Corn Tacos',1.0,3.0,'Carb',5),
('R103','ING216',50.0,'g','50g White Cabbage, finely shredded',25.0,75.0,'Carb',6),
('R103','ING004',15.0,'g','1 Tbsp 0% Fat Greek Yoghurt',7.5,22.5,'Protein',7),
('R103','ING134',0.5,'each','1/2 Lime, juiced',null,1.5,'Carb',8),
('R103','ING099',5.0,'g','Handful Fresh Coriander, chopped',2.5,7.5,'Carb',9),
('R103','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R104','ING062',130.0,'g','130g Chicken Breast',65.0,195.0,'Protein',1),
('R104','ING143',100.0,'g','100g Romaine Lettuce',50.0,150.0,'Carb',2),
('R104','ING221',0.375,'each','15g Wholemeal Bread (cubed, for croutons)',null,1.375,'Carb',3),
('R104','ING154',10.0,'g','10g Parmesan (shaved)',5.0,15.0,'Protein',4),
('R104','ING004',30.0,'g','2 Tbsp 0% Fat Greek Yoghurt',15.0,45.0,'Protein',5),
('R104','ING130',1.0,'ml','1 Tsp Lemon Juice',null,2.0,'Carb',6),
('R104','ING084',3.5,'g','1/2 Tsp Dijon Mustard',1.75,5.25,'Protein',7),
('R104','ING033',1.0,'each','1 Anchovy Fillet',null,2.0,'Protein',8),
('R104','ING104',0.5,'each','1/2 Clove Garlic (crushed)',null,1.5,'Carb',9),
('R104','ING154',5.0,'g','1 Tsp Parmesan (grated, for dressing)',2.5,7.5,'Protein',10),
('R104','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R105','ING062',120.0,'g','120g Chicken Breast',60.0,180.0,'Protein',1),
('R105','ING156',60.0,'g','60g Pasta (dry weight)',30.0,90.0,'Carb',2),
('R105','ING143',50.0,'g','50g Romaine Lettuce (shredded)',25.0,75.0,'Carb',3),
('R105','ING154',8.0,'g','8g Parmesan (shaved)',4.0,12.0,'Protein',4),
('R105','ING004',30.0,'g','2 Tbsp 0% Fat Greek Yoghurt',15.0,45.0,'Protein',5),
('R105','ING130',1.0,'ml','1 Tsp Lemon Juice',null,2.0,'Carb',6),
('R105','ING084',3.5,'g','1/2 Tsp Dijon Mustard',1.75,5.25,'Protein',7),
('R105','ING033',1.0,'each','1 Anchovy Fillet',null,2.0,'Protein',8),
('R105','ING104',0.5,'each','1/2 Clove Garlic (crushed)',null,1.5,'Carb',9),
('R105','ING061',90.0,'g','6 Cherry Tomatoes (halved)',45.0,135.0,'Carb',10),
('R105','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R106','ING062',130.0,'g','130g Chicken Breast (sliced)',65.0,195.0,'Protein',1),
('R106','ING081',2.5,'g','1 Tsp Fajita Spice',1.25,3.75,'Carb',2),
('R106','ING171',75.0,'g','1/2 Red Pepper (sliced)',37.5,112.5,'Carb',3),
('R106','ING171',75.0,'g','1/2 Green Pepper (sliced)',37.5,112.5,'Carb',4),
('R106','ING173',75.0,'g','1/2 Red Onion (sliced)',37.5,112.5,'Carb',5),
('R106','ING038',25.0,'g','25g Baked Tortilla Chips',12.5,37.5,'Carb',6),
('R106','ING143',50.0,'g','50g Mixed Salad Leaves',25.0,75.0,'Carb',7),
('R106','ING061',90.0,'g','6 Cherry Tomatoes (chopped)',45.0,135.0,'Carb',8),
('R106','ING099',15.0,'g','1 Tbsp Fresh Coriander (chopped)',7.5,22.5,'Carb',9),
('R106','ING134',0.5,'each','1/2 Lime',null,1.5,'Carb',10),
('R106','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R107','ING218',80.0,'g','80g White Crab Meat',40.0,120.0,'Protein',1),
('R107','ING117',80.0,'g','80g Cooked King Prawns',40.0,120.0,'Protein',2),
('R107','ING167',50.0,'g','50g New Potatoes (boiled, diced)',25.0,75.0,'Carb',3),
('R107','ING020',0.25,'each','1/4 Avocado (sliced)',null,1.25,'Fat',4),
('R107','ING143',60.0,'g','60g Mixed Salad Leaves',30.0,90.0,'Carb',5),
('R107','ING061',90.0,'g','6 Cherry Tomatoes (halved)',45.0,135.0,'Carb',6),
('R107','ING080',5.0,'g','5cm Cucumber (sliced)',2.5,7.5,'Carb',7),
('R107','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',8),
('R107','ING134',0.5,'each','1/2 Lime (juiced)',null,1.5,'Carb',9),
('R107','ING099',15.0,'g','1 Tbsp Fresh Chives (chopped)',7.5,22.5,'Carb',10),
('R107','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R108','ING124',150.0,'g','150g Ribeye Steak (trimmed of visible fat)',75.0,225.0,'Protein',1),
('R108','ING221',0.625,'each','25g Wholemeal Bread (cubed, for croutons)',null,1.625,'Carb',2),
('R108','ING143',60.0,'g','60g Mixed Salad Leaves',30.0,90.0,'Carb',3),
('R108','ING061',90.0,'g','6 Cherry Tomatoes (halved)',45.0,135.0,'Carb',4),
('R108','ING173',37.5,'g','1/4 Red Onion (thinly sliced)',18.75,56.25,'Carb',5),
('R108','ING099',15.0,'g','15g Fresh Parsley (finely chopped)',7.5,22.5,'Carb',6),
('R108','ING104',1.0,'each','1 Clove Garlic (crushed)',null,2.0,'Carb',7),
('R108','ING067',15.0,'ml','1 Tbsp Red Wine Vinegar',7.5,22.5,'Carb',8),
('R108','ING134',0.5,'each','1/2 Lime (juiced)',null,1.5,'Carb',9),
('R108','ING085',0.625,'g','1/4 Tsp Chilli Flakes',0.31,0.94,'Carb',10),
('R108','ING085',1.25,'g','1/2 Tsp Dried Oregano',0.62,1.88,'Carb',11),
('R108','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',12),
('R109','ING045',150.0,'g','150g Beef Cheek, trimmed of fat',75.0,225.0,'Protein',1),
('R109','ING100',250.0,'g','250g Fresh Gnocchi',125.0,375.0,'Carb',2),
('R109','ING155',200.0,'g','200g Chopped Tomatoes (tinned)',100.0,300.0,'Carb',3),
('R109','ING174',50.0,'ml','50ml Red Wine',25.0,75.0,'Carb',4),
('R109','ING197',100.0,'ml','100ml Beef Stock',50.0,150.0,'Protein',5),
('R109','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',6),
('R109','ING057',60.0,'g','1 Carrot, finely diced',30.0,90.0,'Carb',7),
('R109','ING060',40.0,'g','1 Celery Stick, finely diced',20.0,60.0,'Carb',8),
('R109','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',9),
('R109','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',10),
('R109','ING043',1.0,'each','1 Bay Leaf',0.5,1.5,'Carb',11),
('R109','ING154',10.0,'g','10g Parmesan, grated',5.0,15.0,'Protein',12),
('R109','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',13),
('R110','ING128',150.0,'g','150g Lean Turkey Mince (5% fat)',75.0,225.0,'Protein',1),
('R110','ING049',15.0,'g','15g Fresh Breadcrumbs',7.5,22.5,'Carb',2),
('R110','ING191',15.0,'ml','1 Tbsp Skimmed Milk',7.5,22.5,'Carb',3),
('R110','ING104',0.5,'each','1/2 Garlic Clove, crushed',null,1.5,'Carb',4),
('R110','ING099',5.0,'g','Handful Fresh Basil, chopped',2.5,7.5,'Carb',5),
('R110','ING156',75.0,'g','75g Spaghetti (dry weight)',37.5,112.5,'Carb',6),
('R110','ING155',200.0,'g','200g Tomato Passata',100.0,300.0,'Carb',7),
('R110','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',8),
('R110','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',9),
('R110','ING099',5.0,'g','Fresh Basil Leaves, to serve',2.5,7.5,'Carb',10),
('R110','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R111','ING156',75.0,'g','75g Linguine (dry weight)',37.5,112.5,'Carb',1),
('R111','ING146',300.0,'g','300g Mussels, cleaned and debearded',150.0,450.0,'Protein',2),
('R111','ING117',100.0,'g','100g Raw King Prawns, peeled',50.0,150.0,'Protein',3),
('R111','ING174',100.0,'ml','100ml White Wine',50.0,150.0,'Carb',4),
('R111','ING155',150.0,'g','150g Chopped Tomatoes (tinned)',75.0,225.0,'Carb',5),
('R111','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',6),
('R111','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',7),
('R111','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',8),
('R111','ING099',5.0,'g','Handful Fresh Parsley, chopped',2.5,7.5,'Carb',9),
('R111','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R112','ING062',150.0,'g','150g Chicken Breast',75.0,225.0,'Protein',1),
('R112','ING159',15.0,'g','1 Tbsp Jerk Seasoning',7.5,22.5,'Carb',2),
('R112','ING156',75.0,'g','75g Fusilli (dry weight)',37.5,112.5,'Carb',3),
('R112','ING132',100.0,'ml','100ml Reduced-Fat Coconut Milk',50.0,150.0,'Fat',4),
('R112','ING197',100.0,'ml','100ml Chicken Stock',50.0,150.0,'Protein',5),
('R112','ING171',37.5,'g','1/4 Red Pepper, sliced',18.75,56.25,'Carb',6),
('R112','ING171',37.5,'g','1/4 Yellow Pepper, sliced',18.75,56.25,'Carb',7),
('R112','ING171',37.5,'g','1/4 Green Pepper, sliced',18.75,56.25,'Carb',8),
('R112','ING149',75.0,'g','1/2 Onion, sliced',37.5,112.5,'Carb',9),
('R112','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',10),
('R112','ING194',1.0,'each','1 Spring Onion, sliced',null,2.0,'Carb',11),
('R112','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',12),
('R113','ING062',150.0,'g','150g Chicken Breast, butterflied',75.0,225.0,'Protein',1),
('R113','ING049',20.0,'g','20g Panko Breadcrumbs',10.0,30.0,'Carb',2),
('R113','ING154',10.0,'g','10g Parmesan, grated',5.0,15.0,'Protein',3),
('R113','ING019',1.0,'each','1 Egg White',null,2.0,'Protein',4),
('R113','ING156',75.0,'g','75g Spaghetti (dry weight)',37.5,112.5,'Carb',5),
('R113','ING155',200.0,'g','200g Tomato Passata',100.0,300.0,'Carb',6),
('R113','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',7),
('R113','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',8),
('R113','ING099',5.0,'g','Handful Fresh Basil',2.5,7.5,'Carb',9),
('R113','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R114','ING156',75.0,'g','75g Linguine',37.5,112.5,'Carb',1),
('R114','ING148',20.0,'g','20g Nduja Sausage',10.0,30.0,'Fat',2),
('R114','ING117',100.0,'g','100g Raw King Prawns, peeled',50.0,150.0,'Protein',3),
('R114','ING144',100.0,'g','100g Mixed Seafood (squid, mussels)',50.0,150.0,'Protein',4),
('R114','ING155',200.0,'g','200g Chopped Tomatoes (tinned)',100.0,300.0,'Carb',5),
('R114','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',6),
('R114','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',7),
('R114','ING174',50.0,'ml','50ml White Wine',25.0,75.0,'Carb',8),
('R114','ING099',5.0,'g','Handful Fresh Parsley, chopped',2.5,7.5,'Carb',9),
('R114','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R115','ING126',150.0,'g','150g Lamb Neck Fillet, trimmed of fat',75.0,225.0,'Protein',1),
('R115','ING156',75.0,'g','75g Dry Pappardelle (pasta)',37.5,112.5,'Carb',2),
('R115','ING155',200.0,'g','200g Chopped Tomatoes (tinned)',100.0,300.0,'Carb',3),
('R115','ING174',50.0,'ml','50ml Red Wine',25.0,75.0,'Carb',4),
('R115','ING197',100.0,'ml','100ml Lamb or Beef Stock',50.0,150.0,'Protein',5),
('R115','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',6),
('R115','ING057',60.0,'g','1 Carrot, finely diced',30.0,90.0,'Carb',7),
('R115','ING060',40.0,'g','1 Celery Stick, finely diced',20.0,60.0,'Carb',8),
('R115','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',9),
('R115','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',10),
('R115','ING099',1.0,'g','1 Sprig Rosemary',0.5,1.5,'Carb',11),
('R115','ING154',10.0,'g','10g Parmesan, grated',5.0,15.0,'Protein',12),
('R115','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',13),
('R116','ING156',75.0,'g','75g Linguine',37.5,112.5,'Carb',1),
('R116','ING117',150.0,'g','150g Raw King Prawns, peeled',75.0,225.0,'Protein',2),
('R116','ING155',200.0,'g','200g Chopped Tomatoes (tinned)',100.0,300.0,'Carb',3),
('R116','ING174',100.0,'ml','100ml Red Wine',50.0,150.0,'Carb',4),
('R116','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',5),
('R116','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',6),
('R116','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',7),
('R116','ING085',1.0,'g','Pinch Chilli Flakes (optional)',0.5,1.5,'Carb',8),
('R116','ING099',5.0,'g','Handful Fresh Parsley, chopped',2.5,7.5,'Carb',9),
('R116','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R117','ING123',120.0,'g','120g Lean Beef Mince (5% fat)',60.0,180.0,'Protein',1),
('R117','ING155',150.0,'g','150g Chopped Tomatoes (tinned)',75.0,225.0,'Carb',2),
('R117','ING197',50.0,'ml','50ml Beef Stock',25.0,75.0,'Protein',3),
('R117','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',4),
('R117','ING057',60.0,'g','1 Carrot, finely diced',30.0,90.0,'Carb',5),
('R117','ING076',100.0,'g','1/2 Courgette, diced',50.0,150.0,'Carb',6),
('R117','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',7),
('R117','ING086',4.0,'g','4 Sheets Dried Lasagne (approx 50g)',2.0,6.0,'Carb',8),
('R117','ING191',200.0,'ml','200ml Skimmed Milk',100.0,300.0,'Carb',9),
('R117','ING054',10.0,'g','10g Butter',5.0,15.0,'Fat',10),
('R117','ING164',10.0,'g','10g Plain Flour',5.0,15.0,'Carb',11),
('R117','ING139',15.0,'g','15g Mature Cheddar, grated',7.5,22.5,'Fat',12),
('R117','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',13),
('R118','ING062',150.0,'g','150g Chicken Breast',75.0,225.0,'Protein',1),
('R118','ING159',30.0,'g','2 Tbsp Peri Peri Marinade',15.0,45.0,'Carb',2),
('R118','ING156',75.0,'g','75g Penne (dry weight)',37.5,112.5,'Carb',3),
('R118','ING155',200.0,'g','200g Tomato Passata',100.0,300.0,'Carb',4),
('R118','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',5),
('R118','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',6),
('R118','ING171',75.0,'g','1/2 Red Pepper, diced',37.5,112.5,'Carb',7),
('R118','ING085',1.0,'g','Pinch Chilli Flakes (to taste)',0.5,1.5,'Carb',8),
('R118','ING099',5.0,'g','Handful Fresh Coriander, chopped',2.5,7.5,'Carb',9),
('R118','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R119','ING182',130.0,'g','130g Salmon Fillet',65.0,195.0,'Protein',1),
('R119','ING156',75.0,'g','75g Tagliatelle (dry weight)',37.5,112.5,'Carb',2),
('R119','ING041',15.0,'g','15g Fresh Pesto',7.5,22.5,'Fat',3),
('R119','ING191',15.0,'ml','1 Tbsp Skimmed Milk',7.5,22.5,'Carb',4),
('R119','ING099',5.0,'g','Handful Cherry Tomatoes, halved',2.5,7.5,'Carb',5),
('R119','ING130',1.0,'ml','Squeeze Lemon Juice',null,2.0,'Carb',6),
('R119','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',7),
('R120','ING156',75.0,'g','75g Macaroni (dry weight)',37.5,112.5,'Carb',1),
('R120','ING071',60.0,'g','60g Cooked Lobster Meat',30.0,90.0,'Protein',2),
('R120','ING117',80.0,'g','80g Raw King Prawns, peeled',40.0,120.0,'Protein',3),
('R120','ING191',200.0,'ml','200ml Skimmed Milk',100.0,300.0,'Carb',4),
('R120','ING054',10.0,'g','10g Butter',5.0,15.0,'Fat',5),
('R120','ING164',10.0,'g','10g Plain Flour',5.0,15.0,'Carb',6),
('R120','ING139',25.0,'g','25g Mature Cheddar, grated',12.5,37.5,'Fat',7),
('R120','ING154',5.0,'g','5g Parmesan, grated',2.5,7.5,'Protein',8),
('R120','ING084',7.0,'g','1 Tsp Dijon Mustard (optional)',3.5,10.5,'Protein',9),
('R120','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R121','ING156',75.0,'g','75g Macaroni (dry weight)',37.5,112.5,'Carb',1),
('R121','ING218',100.0,'g','100g White Crab Meat',50.0,150.0,'Protein',2),
('R121','ING191',200.0,'ml','200ml Skimmed Milk',100.0,300.0,'Carb',3),
('R121','ING054',10.0,'g','10g Butter',5.0,15.0,'Fat',4),
('R121','ING164',10.0,'g','10g Plain Flour',5.0,15.0,'Carb',5),
('R121','ING139',25.0,'g','25g Mature Cheddar, grated',12.5,37.5,'Fat',6),
('R121','ING085',1.0,'g','Pinch Chilli Flakes',0.5,1.5,'Carb',7),
('R121','ING172',0.5,'each','1/2 Red Chilli, finely diced (optional)',null,1.5,'Carb',8),
('R121','ING130',1.0,'ml','Squeeze Lemon Juice',null,2.0,'Carb',9),
('R121','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',10),
('R122','ING151',70.0,'g','70g Orzo (dry weight)',35.0,105.0,'Carb',1),
('R122','ING117',100.0,'g','100g Raw King Prawns, peeled',50.0,150.0,'Protein',2),
('R122','ING144',100.0,'g','100g Mixed Seafood (squid, mussels)',50.0,150.0,'Protein',3),
('R122','ING018',1.0,'each','1 Egg',null,2.0,'Protein',4),
('R122','ING090',1.0,'each','1 Egg Yolk',null,2.0,'Fat',5),
('R122','ING154',20.0,'g','20g Parmesan, grated',10.0,30.0,'Protein',6),
('R122','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',7),
('R122','ING184',1.0,'g','Black Pepper (generous, to taste)',0.5,1.5,'Carb',8),
('R122','ING099',5.0,'g','Handful Fresh Parsley, chopped',2.5,7.5,'Carb',9),
('R123','ING156',75.0,'g','75g Tagliatelle (dry weight)',37.5,112.5,'Carb',1),
('R123','ING117',150.0,'g','150g Raw King Prawns, peeled',75.0,225.0,'Protein',2),
('R123','ING149',300.0,'g','2 Onions, thinly sliced',150.0,450.0,'Carb',3),
('R123','ING197',100.0,'ml','100ml Vegetable or Chicken Stock',50.0,150.0,'Protein',4),
('R123','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',5),
('R123','ING039',5.0,'ml','1 Tsp Balsamic Vinegar',2.5,7.5,'Carb',6),
('R123','ING099',5.0,'g','Handful Fresh Thyme',2.5,7.5,'Carb',7),
('R123','ING154',10.0,'g','10g Parmesan, grated',5.0,15.0,'Protein',8),
('R123','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',9),
('R124','ING062',150.0,'g','150g Chicken Breast',75.0,225.0,'Protein',1),
('R124','ING156',75.0,'g','75g Fusilli (dry weight)',37.5,112.5,'Carb',2),
('R124','ING155',150.0,'g','150g Chopped Tomatoes (tinned)',75.0,225.0,'Carb',3),
('R124','ING193',50.0,'g','50g Spinach',25.0,75.0,'Protein',4),
('R124','ING136',30.0,'g','30g Low-Fat Crème Fraîche',15.0,45.0,'Fat',5),
('R124','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',6),
('R124','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',7),
('R124','ING205',120.0,'g','1 Sundried Tomato, chopped (optional)',60.0,180.0,'Carb',8),
('R124','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',9),
('R125','ING062',150.0,'g','150g Chicken Breast, diced',75.0,225.0,'Protein',1),
('R125','ING151',70.0,'g','70g Orzo (dry weight)',35.0,105.0,'Carb',2),
('R125','ING197',150.0,'ml','150ml Chicken Stock',75.0,225.0,'Protein',3),
('R125','ING155',100.0,'g','100g Chopped Tomatoes (tinned)',50.0,150.0,'Carb',4),
('R125','ING205',15.0,'g','15g Sundried Tomatoes, chopped',7.5,22.5,'Carb',5),
('R125','ING191',100.0,'ml','100ml Skimmed Milk',50.0,150.0,'Carb',6),
('R125','ING154',15.0,'g','15g Parmesan, grated',7.5,22.5,'Protein',7),
('R125','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',8),
('R125','ING149',75.0,'g','1/2 Onion, finely diced',37.5,112.5,'Carb',9),
('R125','ING099',5.0,'g','Handful Fresh Basil',2.5,7.5,'Carb',10),
('R125','ING184',1.0,'g','Salt & Black Pepper (to taste)',0.5,1.5,'Carb',11),
('R126','ING121',1.0,'each','1 Large Wholemeal Tortilla Wrap (70g)',null,2.0,'Carb',1),
('R126','ING062',100.0,'g','100g Chicken Breast, diced',50.0,150.0,'Protein',2),
('R126','ING030',40.0,'g','40g Fage Total 0% Greek Yoghurt',20.0,60.0,'Protein',3),
('R126','ING081',2.5,'g','1 tsp Tandoori Spice Mix',1.25,3.75,'Carb',4),
('R126','ING085',1.25,'g','1/2 tsp Smoked Paprika',0.62,1.88,'Carb',5),
('R126','ING155',40.0,'g','40g Passata',20.0,60.0,'Carb',6),
('R126','ING173',20.0,'g','20g Red Onion, thinly sliced',10.0,30.0,'Carb',7),
('R126','ING137',15.0,'g','15g Mango Chutney',7.5,22.5,'Carb',8),
('R126','ING176',25.0,'g','25g Reduced-Fat Mozzarella, grated',12.5,37.5,'Protein',9),
('R126','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',10),
('R126','ING129',1.0,'each','1 Lemon Wedge, to serve',null,2.0,'Carb',11),
('R127','ING121',1.0,'each','1 Large Wholemeal Tortilla Wrap (70g)',null,2.0,'Carb',1),
('R127','ING126',90.0,'g','90g Lamb Leg Steak, all visible fat trimmed, thinly sliced',45.0,135.0,'Protein',2),
('R127','ING085',1.25,'g','1/2 tsp Chinese Five Spice',0.62,1.88,'Carb',3),
('R127','ING113',25.0,'g','25g Hoisin Sauce',12.5,37.5,'Carb',4),
('R127','ING176',25.0,'g','25g Reduced-Fat Mozzarella, grated',12.5,37.5,'Protein',5),
('R127','ING080',30.0,'g','30g Cucumber, ribboned',15.0,45.0,'Carb',6),
('R127','ING194',1.0,'each','15g Spring Onion, sliced',null,2.0,'Carb',7),
('R127','ING188',5.0,'g','5g Sesame Seeds',2.5,7.5,'Fat',8),
('R127','ING085',1.0,'g','Pinch of Chilli Flakes',0.5,1.5,'Carb',9),
('R128','ING121',1.0,'each','1 Large Wholemeal Tortilla Wrap (70g)',null,2.0,'Carb',1),
('R128','ING123',80.0,'g','80g Lean Beef Mince (5% fat)',40.0,120.0,'Protein',2),
('R128','ING049',10.0,'g','10g Wholemeal Breadcrumbs',5.0,15.0,'Carb',3),
('R128','ING019',1.0,'each','1 tbsp Egg White',null,2.0,'Protein',4),
('R128','ING085',1.25,'g','1/2 tsp Dried Oregano',0.62,1.88,'Carb',5),
('R128','ING104',0.5,'each','1/2 Garlic Clove, crushed',null,1.5,'Carb',6),
('R128','ING155',100.0,'g','100g Passata',50.0,150.0,'Carb',7),
('R128','ING176',25.0,'g','25g Reduced-Fat Mozzarella, grated',12.5,37.5,'Protein',8),
('R128','ING099',5.0,'g','Fresh Basil, torn',2.5,7.5,'Carb',9),
('R128','ING184',1.0,'g','Black Pepper',0.5,1.5,'Carb',10),
('R129','ING121',1.0,'each','1 Large Wholemeal Tortilla Wrap (70g)',null,2.0,'Carb',1),
('R129','ING218',80.0,'g','80g White Crab Meat',40.0,120.0,'Protein',2),
('R129','ING155',60.0,'g','60g Passata',30.0,90.0,'Carb',3),
('R129','ING172',1.0,'each','1 Red Chilli, finely chopped',null,2.0,'Carb',4),
('R129','ING202',40.0,'g','40g Sweetcorn',20.0,60.0,'Carb',5),
('R129','ING176',25.0,'g','25g Reduced-Fat Mozzarella, grated',12.5,37.5,'Protein',6),
('R129','ING112',7.0,'g','1 tsp Chilli Oil',3.5,10.5,'Carb',7),
('R129','ING134',0.5,'each','1/2 Lime, zest and juice',null,1.5,'Carb',8),
('R129','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',9),
('R129','ING173',37.5,'g','1/4 Red Onion, finely sliced',18.75,56.25,'Carb',10),
('R130','ING121',1.0,'each','1 Large Wholemeal Tortilla Wrap (70g)',null,2.0,'Carb',1),
('R130','ING062',70.0,'g','70g Cooked Chicken Breast, shredded (or lean cooked Beef Brisket)',35.0,105.0,'Protein',2),
('R130','ING036',50.0,'g','50g Reduced-Sugar BBQ Sauce',25.0,75.0,'Carb',3),
('R130','ING176',25.0,'g','25g Reduced-Fat Mozzarella, grated',12.5,37.5,'Protein',4),
('R130','ING202',30.0,'g','30g Sweetcorn',15.0,45.0,'Carb',5),
('R130','ING173',37.5,'g','1/4 Red Onion, thinly sliced',18.75,56.25,'Carb',6),
('R130','ING115',0.5,'each','1/2 Jalapeño, sliced',null,1.5,'Carb',7),
('R130','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',8),
('R130','ING184',1.0,'g','Black Pepper',0.5,1.5,'Carb',9),
('R131','ING121',1.0,'each','1 Large Wholemeal Tortilla Wrap (70g)',null,2.0,'Carb',1),
('R131','ING127',80.0,'g','80g Lean Lamb Mince (10% fat)',40.0,120.0,'Protein',2),
('R131','ING085',2.5,'g','1 tsp Garam Masala',1.25,3.75,'Carb',3),
('R131','ING085',1.25,'g','1/2 tsp Ground Cumin',0.62,1.88,'Carb',4),
('R131','ING085',1.25,'g','1/2 tsp Turmeric',0.62,1.88,'Carb',5),
('R131','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',6),
('R131','ING098',1.0,'g','1cm piece Ginger, grated',null,2.0,'Carb',7),
('R131','ING149',30.0,'g','30g Onion, finely diced',15.0,45.0,'Carb',8),
('R131','ING155',40.0,'g','40g Passata',20.0,60.0,'Carb',9),
('R131','ING102',25.0,'g','25g Frozen Peas',12.5,37.5,'Carb',10),
('R131','ING167',20.0,'g','20g Potato, finely diced and par-cooked',10.0,30.0,'Carb',11),
('R131','ING176',15.0,'g','15g Reduced-Fat Mozzarella, grated',7.5,22.5,'Protein',12),
('R131','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',13),
('R131','ING130',1.0,'ml','Squeeze of Lemon Juice',null,2.0,'Carb',14),
('R132','ING123',100.0,'g','100g Lean Beef Mince (5% Fat)',50.0,150.0,'Protein',1),
('R132','ING053',1.0,'each','1 Burger Bun',null,2.0,'Carb',2),
('R132','ING175',30.0,'g','30g Reduced-Fat Cheddar, sliced',15.0,45.0,'Protein',3),
('R132','ING207',20.0,'g','20g Tomato Relish',10.0,30.0,'Carb',4),
('R132','ING143',600.0,'g','2 Little Gem Lettuce leaves',300.0,900.0,'Carb',5),
('R132','ING205',40.0,'g','2 slices Beef Tomato',1.0,3.0,'Carb',6),
('R132','ING173',15.0,'g','2 slices Red Onion',1.0,3.0,'Carb',7),
('R132','ING184',1.0,'g','Salt and black pepper, to season',0.5,1.5,'Carb',8),
('R133','ING117',120.0,'g','120g Raw King Prawns, peeled and deveined',60.0,180.0,'Protein',1),
('R133','ING049',15.0,'g','15g Panko Breadcrumbs',7.5,22.5,'Carb',2),
('R133','ING019',1.0,'each','1 Egg White, beaten',null,2.0,'Protein',3),
('R133','ING081',2.5,'g','1 tsp Cajun Seasoning',1.25,3.75,'Carb',4),
('R133','ING135',1.0,'g','Low-calorie cooking spray',0.5,1.5,'Fat',5),
('R133','ING053',1.0,'each','1 Burger Bun',null,2.0,'Carb',6),
('R133','ING070',80.0,'g','80g Coleslaw Mix (white cabbage, carrot, red onion)',40.0,120.0,'Carb',7),
('R133','ING133',20.0,'g','20g Light Mayonnaise',10.0,30.0,'Fat',8),
('R133','ING134',1.0,'each','1 Lime wedge',null,2.0,'Carb',9),
('R134','ING062',90.0,'g','90g Chicken Breast, butterflied and flattened',45.0,135.0,'Protein',1),
('R134','ING049',15.0,'g','15g Panko Breadcrumbs',7.5,22.5,'Carb',2),
('R134','ING018',1.0,'each','1 Egg, beaten',null,2.0,'Protein',3),
('R134','ING176',20.0,'g','20g Light Mozzarella, sliced',10.0,30.0,'Protein',4),
('R134','ING041',10.0,'g','10g Basil Pesto',5.0,15.0,'Fat',5),
('R134','ING053',1.0,'each','1 Burger Bun',null,2.0,'Carb',6),
('R134','ING099',5.0,'g','Handful Rocket Leaves',2.5,7.5,'Carb',7),
('R134','ING205',40.0,'g','2 slices Beef Tomato',1.0,3.0,'Carb',8),
('R135','ING062',90.0,'g','90g Chicken Breast, flattened',45.0,135.0,'Protein',1),
('R135','ING074',15.0,'g','15g Cornflake Crumb (or Panko), mixed with paprika and cayenne pepper',7.5,22.5,'Carb',2),
('R135','ING018',1.0,'each','1 Egg, beaten',null,2.0,'Protein',3),
('R135','ING053',1.0,'each','1 Burger Bun',null,2.0,'Carb',4),
('R135','ING133',20.0,'g','20g Light Mayonnaise, mixed with a dash of hot sauce',10.0,30.0,'Fat',5),
('R135','ING143',30.0,'g','Little Gem Lettuce, shredded',0.5,1.5,'Carb',6),
('R136','ING045',150.0,'g','150g Beef Cheek, trimmed of visible fat',75.0,225.0,'Protein',1),
('R136','ING036',20.0,'g','20g Reduced-Sugar BBQ Sauce',10.0,30.0,'Carb',2),
('R136','ING133',10.0,'g','10g Light Mayonnaise',5.0,15.0,'Fat',3),
('R136','ING053',1.0,'each','1 Burger Bun',null,2.0,'Carb',4),
('R136','ING105',1.0,'g','Sliced Pickles',0.5,1.5,'Carb',5),
('R136','ING143',30.0,'g','Shredded Lettuce',0.5,1.5,'Carb',6),
('R137','ING062',90.0,'g','90g Chicken Breast',45.0,135.0,'Protein',1),
('R137','ING195',25.0,'g','25g Buffalo Hot Sauce',12.5,37.5,'Carb',2),
('R137','ING030',25.0,'g','25g Fage Total 0% Greek Yoghurt',12.5,37.5,'Protein',3),
('R137','ING133',15.0,'g','15g Light Mayonnaise',7.5,22.5,'Fat',4),
('R137','ING085',1.25,'g','1/2 tsp each Garlic Powder, Chopped Chives and Dill (for the ranch)',0.62,1.88,'Carb',5),
('R137','ING053',1.0,'each','1 Burger Bun',null,2.0,'Carb',6),
('R137','ING020',0.25,'each','1/4 Avocado, sliced',null,1.25,'Fat',7),
('R137','ING143',30.0,'g','Little Gem Lettuce',0.5,1.5,'Carb',8),
('R138','ING123',70.0,'g','70g Lean Beef Mince (5% Fat), for the patty',35.0,105.0,'Protein',1),
('R138','ING123',35.0,'g','35g Lean Beef Mince (5% Fat), for the chilli',17.5,52.5,'Protein',2),
('R138','ING116',30.0,'g','30g Kidney Beans (canned, drained)',15.0,45.0,'Carb',3),
('R138','ING155',30.0,'g','30g Chopped Tomatoes',15.0,45.0,'Carb',4),
('R138','ING149',20.0,'g','20g Onion, finely diced',10.0,30.0,'Carb',5),
('R138','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',6),
('R138','ING085',1.25,'g','1/2 tsp each Chilli Powder, Cumin and Smoked Paprika',0.62,1.88,'Carb',7),
('R138','ING053',1.0,'each','1 Burger Bun',null,2.0,'Carb',8),
('R138','ING175',15.0,'g','15g Reduced-Fat Cheddar, grated',7.5,22.5,'Protein',9),
('R138','ING133',15.0,'g','15g Light Mayonnaise',7.5,22.5,'Fat',10),
('R138','ING143',30.0,'g','Little Gem Lettuce',0.5,1.5,'Carb',11),
('R139','ING117',130.0,'g','130g Raw King Prawns, peeled and deveined',65.0,195.0,'Protein',1),
('R139','ING030',30.0,'g','30g Fage Total 0% Greek Yoghurt (for marinade)',15.0,45.0,'Protein',2),
('R139','ING081',2.5,'g','1 tsp Tandoori Masala Spice Mix',1.25,3.75,'Carb',3),
('R139','ING170',6.75,'g','1.5 tsp Rapeseed Oil',3.38,10.12,'Fat',4),
('R139','ING149',40.0,'g','40g Onion, finely diced',20.0,60.0,'Carb',5),
('R139','ING104',2.0,'each','2 cloves Garlic, crushed',1.0,3.0,'Carb',6),
('R139','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',7),
('R139','ING155',100.0,'g','100g Tinned Chopped Tomatoes',50.0,150.0,'Carb',8),
('R139','ING085',2.5,'g','1 tsp Ground Cumin',1.25,3.75,'Carb',9),
('R139','ING085',2.5,'g','1 tsp Garam Masala',1.25,3.75,'Carb',10),
('R139','ING085',1.25,'g','1/2 tsp Ground Turmeric',0.62,1.88,'Carb',11),
('R139','ING085',1.25,'g','1/2 tsp Chilli Powder',0.62,1.88,'Carb',12),
('R139','ING030',20.0,'g','20g Fage Total 0% Greek Yoghurt (stirred through at the end)',10.0,30.0,'Protein',13),
('R139','ING042',35.0,'g','35g Basmati Rice (dry weight)',17.5,52.5,'Carb',14),
('R139','ING099',5.0,'g','Fresh Coriander, to garnish',2.5,7.5,'Carb',15),
('R139','ING129',0.25,'each','1/4 Lemon, to serve',null,1.25,'Carb',16),
('R140','ING126',100.0,'g','100g Lean Lamb Leg, diced (visible fat trimmed)',50.0,150.0,'Protein',1),
('R140','ING193',200.0,'g','200g Frozen Spinach, thawed (or fresh spinach, wilted)',100.0,300.0,'Protein',2),
('R140','ING149',40.0,'g','40g Onion, finely chopped',20.0,60.0,'Carb',3),
('R140','ING104',2.0,'each','2 cloves Garlic, crushed',1.0,3.0,'Carb',4),
('R140','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',5),
('R140','ING170',4.5,'g','1 tsp Rapeseed Oil (ghee replacement)',2.25,6.75,'Fat',6),
('R140','ING085',2.5,'g','1 tsp Ground Cumin',1.25,3.75,'Carb',7),
('R140','ING085',2.5,'g','1 tsp Ground Coriander',1.25,3.75,'Carb',8),
('R140','ING085',1.25,'g','1/2 tsp Garam Masala',0.62,1.88,'Carb',9),
('R140','ING085',0.625,'g','1/4 tsp Ground Turmeric',0.31,0.94,'Carb',10),
('R140','ING085',1.0,'g','Pinch Chilli Powder',0.5,1.5,'Carb',11),
('R140','ING030',30.0,'g','30g Fage Total 0% Greek Yoghurt',15.0,45.0,'Protein',12),
('R140','ING042',30.0,'g','30g Basmati Rice (dry weight)',15.0,45.0,'Carb',13),
('R140','ING099',5.0,'g','Fresh Coriander, to serve',2.5,7.5,'Carb',14),
('R141','ING062',120.0,'g','120g Chicken Breast, butterflied or cubed for skewers',60.0,180.0,'Protein',1),
('R141','ING030',50.0,'g','50g Fage Total 0% Greek Yoghurt (marinade)',25.0,75.0,'Protein',2),
('R141','ING081',7.5,'g','1 tbsp Tandoori Spice Mix',3.75,11.25,'Carb',3),
('R141','ING085',2.5,'g','1 tsp Ground Cumin',1.25,3.75,'Carb',4),
('R141','ING085',1.25,'g','1/2 tsp Smoked Paprika',0.62,1.88,'Carb',5),
('R141','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',6),
('R141','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',7),
('R141','ING130',1.0,'ml','Squeeze of Lemon Juice',null,2.0,'Carb',8),
('R141','ING170',4.5,'g','1 tsp Rapeseed Oil (for basting/grilling)',2.25,6.75,'Fat',9),
('R141','ING042',35.0,'g','35g Basmati Rice (dry weight)',17.5,52.5,'Carb',10),
('R141','ING080',50.0,'g','50g Cucumber, sliced',25.0,75.0,'Carb',11),
('R141','ING030',30.0,'g','30g Fage Total 0% Greek Yoghurt (for raita)',15.0,45.0,'Protein',12),
('R141','ING099',5.0,'g','Pinch Fresh Mint, chopped',2.5,7.5,'Carb',13),
('R141','ING129',0.25,'each','1/4 Lemon, to serve',null,1.25,'Carb',14),
('R142','ING219',180.0,'g','180g Monkfish Tail, cubed (or substitute firm white fish)',90.0,270.0,'Protein',1),
('R142','ING132',120.0,'ml','120ml Light Coconut Milk',60.0,180.0,'Fat',2),
('R142','ING204',31.5,'g','1.5 tbsp Thai Green Curry Paste',15.75,47.25,'Carb',3),
('R142','ING095',5.0,'ml','1 tsp Fish Sauce',2.5,7.5,'Protein',4),
('R142','ING109',50.0,'g','50g Green Beans, trimmed and halved',25.0,75.0,'Carb',5),
('R142','ING171',50.0,'g','50g Red Pepper, sliced',25.0,75.0,'Carb',6),
('R142','ING040',30.0,'g','30g Bamboo Shoots (tinned, drained)',15.0,45.0,'Carb',7),
('R142','ING043',1.0,'each','1 Kaffir Lime Leaf (or zest of 1/4 Lime)',0.5,1.5,'Carb',8),
('R142','ING099',5.0,'g','Handful of Thai Basil',2.5,7.5,'Carb',9),
('R142','ING042',25.0,'g','25g Basmati or Jasmine Rice (dry weight)',12.5,37.5,'Carb',10),
('R142','ING134',0.25,'each','1/4 Lime, to serve',null,1.25,'Carb',11),
('R143','ING219',160.0,'g','160g Cod Fillet, skinned and cubed',80.0,240.0,'Protein',1),
('R143','ING132',120.0,'ml','120ml Light Coconut Milk',60.0,180.0,'Fat',2),
('R143','ING204',31.5,'g','1.5 tbsp Thai Red Curry Paste',15.75,47.25,'Carb',3),
('R143','ING095',5.0,'ml','1 tsp Fish Sauce',2.5,7.5,'Protein',4),
('R143','ING109',50.0,'g','50g Mangetout',25.0,75.0,'Carb',5),
('R143','ING171',30.0,'g','30g Red Pepper, sliced',15.0,45.0,'Carb',6),
('R143','ING043',1.0,'each','1 Kaffir Lime Leaf (optional)',0.5,1.5,'Carb',7),
('R143','ING099',5.0,'g','Handful of Fresh Coriander',2.5,7.5,'Carb',8),
('R143','ING042',25.0,'g','25g Jasmine Rice (dry weight)',12.5,37.5,'Carb',9),
('R143','ING134',0.25,'each','1/4 Lime, to serve',null,1.25,'Carb',10),
('R144','ING063',140.0,'g','140g Chicken Thighs, skinless and boneless',70.0,210.0,'Protein',1);
insert into ri_stage values
('R144','ING192',30.0,'ml','2 tbsp Light Soy Sauce',15.0,45.0,'Protein',2),
('R144','ING011',7.0,'g','1 tsp Honey',3.5,10.5,'Carb',3),
('R144','ING197',100.0,'ml','100ml Chicken Stock (low salt)',50.0,150.0,'Protein',4),
('R144','ING104',2.0,'each','2 cloves Garlic, crushed',1.0,3.0,'Carb',5),
('R144','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',6),
('R144','ING043',1.0,'each','1 Star Anise (optional)',0.5,1.5,'Carb',7),
('R144','ING187',4.5,'g','1 tsp Sesame Oil',2.25,6.75,'Fat',8),
('R144','ING188',5.0,'g','1 tsp Sesame Seeds',2.5,7.5,'Fat',9),
('R144','ING194',1.0,'each','1 Spring Onion, sliced',null,2.0,'Carb',10),
('R144','ING042',30.0,'g','30g Basmati Rice (dry weight)',15.0,45.0,'Carb',11),
('R145','ING125',120.0,'g','120g Lean Chicken Breast Mince',60.0,180.0,'Protein',1),
('R145','ING049',15.0,'g','15g Wholemeal Breadcrumbs',7.5,22.5,'Carb',2),
('R145','ING019',1.0,'each','1 tbsp Egg White (or 1/4 Egg, beaten)',null,2.0,'Protein',3),
('R145','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',4),
('R145','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',5),
('R145','ING204',31.5,'g','1.5 tbsp Thai Yellow Curry Paste',15.75,47.25,'Carb',6),
('R145','ING132',120.0,'ml','120ml Light Coconut Milk',60.0,180.0,'Fat',7),
('R145','ING057',40.0,'g','40g Carrot, julienned or diced',20.0,60.0,'Carb',8),
('R145','ING102',30.0,'g','30g Frozen Peas',15.0,45.0,'Carb',9),
('R145','ING099',5.0,'g','Handful Fresh Coriander',2.5,7.5,'Carb',10),
('R145','ING042',20.0,'g','20g Jasmine Rice (dry weight)',10.0,30.0,'Carb',11),
('R145','ING134',0.25,'each','1/4 Lime, to serve',null,1.25,'Carb',12),
('R146','ING120',140.0,'g','140g Lamb Loin Chops, well-trimmed of visible fat (bone-in weight)',70.0,210.0,'Protein',1),
('R146','ING085',2.5,'g','1 tsp Ground Cumin',1.25,3.75,'Carb',2),
('R146','ING085',2.5,'g','1 tsp Ground Coriander',1.25,3.75,'Carb',3),
('R146','ING085',1.25,'g','1/2 tsp Smoked Paprika',0.62,1.88,'Carb',4),
('R146','ING085',1.25,'g','1/2 tsp Garam Masala',0.62,1.88,'Carb',5),
('R146','ING085',0.625,'g','1/4 tsp Chilli Powder',0.31,0.94,'Carb',6),
('R146','ING184',1.0,'g','Pinch Salt',0.5,1.5,'Carb',7),
('R146','ING104',2.0,'each','2 cloves Garlic, crushed',1.0,3.0,'Carb',8),
('R146','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',9),
('R146','ING042',35.0,'g','35g Basmati Rice (dry weight)',17.5,52.5,'Carb',10),
('R146','ING099',5.0,'g','Fresh Coriander, to serve',2.5,7.5,'Carb',11),
('R146','ING129',0.25,'each','1/4 Lemon, to serve',null,1.25,'Carb',12),
('R147','ING059',150.0,'g','150g Cauliflower, cut into small florets',75.0,225.0,'Carb',1),
('R147','ING167',100.0,'g','100g Potato, peeled and cubed',50.0,150.0,'Carb',2),
('R147','ING149',20.0,'g','20g Onion, finely sliced',10.0,30.0,'Carb',3),
('R147','ING102',20.0,'g','20g Frozen Peas',10.0,30.0,'Carb',4),
('R147','ING170',4.5,'g','1 tsp Rapeseed Oil (or oil spray)',2.25,6.75,'Fat',5),
('R147','ING085',1.25,'g','1/2 tsp Cumin Seeds',0.62,1.88,'Carb',6),
('R147','ING147',1.25,'g','1/2 tsp Mustard Seeds',0.62,1.88,'Fat',7),
('R147','ING085',0.625,'g','1/4 tsp Ground Turmeric',0.31,0.94,'Carb',8),
('R147','ING085',1.0,'g','Pinch Chilli Powder',0.5,1.5,'Carb',9),
('R147','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',10),
('R147','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',11),
('R147','ING099',5.0,'g','Fresh Coriander, to garnish',2.5,7.5,'Carb',12),
('R148','ING126',110.0,'g','110g Lean Lamb Leg, diced (fat trimmed)',55.0,165.0,'Protein',1),
('R148','ING030',30.0,'g','30g Fage Total 0% Greek Yoghurt (marinade)',15.0,45.0,'Protein',2),
('R148','ING081',2.5,'g','1 tsp Biryani Spice Mix (or Garam Masala)',1.25,3.75,'Carb',3),
('R148','ING085',1.25,'g','1/2 tsp Ground Turmeric',0.62,1.88,'Carb',4),
('R148','ING085',1.25,'g','1/2 tsp Chilli Powder',0.62,1.88,'Carb',5),
('R148','ING104',2.0,'each','2 cloves Garlic, crushed',1.0,3.0,'Carb',6),
('R148','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',7),
('R148','ING042',55.0,'g','55g Basmati Rice (dry weight)',27.5,82.5,'Carb',8),
('R148','ING170',6.75,'g','1.5 tsp Rapeseed Oil (ghee alternative)',3.38,10.12,'Fat',9),
('R148','ING149',40.0,'g','40g Onion, thinly sliced',20.0,60.0,'Carb',10),
('R148','ING169',10.0,'g','10g Raisins',5.0,15.0,'Carb',11),
('R148','ING043',2.0,'each','2 Green Cardamom Pods',1.0,3.0,'Carb',12),
('R148','ING043',1.0,'each','1 Cinnamon Stick',0.5,1.5,'Carb',13),
('R148','ING043',1.0,'each','2 Cloves (whole spice)',0.5,1.5,'Carb',14),
('R148','ING180',1.0,'g','Pinch Saffron strands soaked in 1 tbsp warm water (or turmeric for colour)',0.5,1.5,'Carb',15),
('R148','ING099',5.0,'g','Fresh Coriander and Mint, chopped, to layer and garnish',2.5,7.5,'Carb',16),
('R149','ING127',110.0,'g','110g Lean Minced Lamb (5% fat)',55.0,165.0,'Protein',1),
('R149','ING149',40.0,'g','40g Onion, finely diced',20.0,60.0,'Carb',2),
('R149','ING104',2.0,'each','2 cloves Garlic, crushed',1.0,3.0,'Carb',3),
('R149','ING098',1.0,'g','1cm Fresh Ginger, grated',null,2.0,'Carb',4),
('R149','ING205',80.0,'g','80g Tomato, finely chopped (or tinned chopped tomatoes)',40.0,120.0,'Carb',5),
('R149','ING102',20.0,'g','20g Frozen Peas',10.0,30.0,'Carb',6),
('R149','ING085',2.5,'g','1 tsp Ground Cumin',1.25,3.75,'Carb',7),
('R149','ING085',2.5,'g','1 tsp Ground Coriander',1.25,3.75,'Carb',8),
('R149','ING085',1.25,'g','1/2 tsp Garam Masala',0.62,1.88,'Carb',9),
('R149','ING085',0.625,'g','1/4 tsp Ground Turmeric',0.31,0.94,'Carb',10),
('R149','ING085',1.0,'g','Pinch Chilli Powder',0.5,1.5,'Carb',11),
('R149','ING048',1.0,'each','1 Soft Bread Roll (Pau/Bun), approx. 75g, halved',null,2.0,'Carb',12),
('R149','ING099',5.0,'g','Fresh Coriander, to serve',2.5,7.5,'Carb',13),
('R149','ING134',0.25,'each','1/4 Lime, to serve',null,1.25,'Carb',14),
('R150','ING126',110.0,'g','110g Lean Lamb Leg or Shoulder, diced (fat trimmed)',55.0,165.0,'Protein',1),
('R150','ING132',120.0,'ml','120ml Light Coconut Milk',60.0,180.0,'Fat',2),
('R150','ING204',31.5,'g','1.5 tbsp Massaman Curry Paste',15.75,47.25,'Carb',3),
('R150','ING167',130.0,'g','130g Potato, peeled and cubed',65.0,195.0,'Carb',4),
('R150','ING149',30.0,'g','30g Onion, sliced',15.0,45.0,'Carb',5),
('R150','ING178',5.0,'g','5g Crushed Roasted Peanuts',2.5,7.5,'Fat',6),
('R150','ING051',5.0,'g','5g Palm Sugar (or Light Brown Sugar)',2.5,7.5,'Carb',7),
('R150','ING095',5.0,'ml','1 tsp Fish Sauce',2.5,7.5,'Protein',8),
('R150','ING065',7.0,'g','1 tsp Tamarind Paste',3.5,10.5,'Carb',9),
('R150','ING043',1.0,'each','1 Bay Leaf or Cinnamon Stick (optional)',0.5,1.5,'Carb',10),
('R150','ING099',5.0,'g','Fresh Coriander, to garnish',2.5,7.5,'Carb',11),
('R151','ING124',130.0,'g','130g Lean Beef Strips (rump or sirloin, trimmed)',65.0,195.0,'Protein',1),
('R151','ING075',15.0,'g','15g Cornflour',7.5,22.5,'Carb',2),
('R151','ING187',4.5,'g','1 tsp Sesame Oil',2.25,6.75,'Fat',3),
('R151','ING200',42.0,'g','2 tbsp Reduced-Sugar Sweet Chilli Sauce',21.0,63.0,'Carb',4),
('R151','ING172',1.0,'each','1 Red Chilli, finely sliced',null,2.0,'Carb',5),
('R151','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',6),
('R151','ING098',1.0,'g','1cm Ginger, grated',null,2.0,'Carb',7),
('R151','ING194',2.0,'each','2 Spring Onions, sliced',1.0,3.0,'Carb',8),
('R151','ING042',30.0,'g','30g Jasmine Rice (dry weight)',15.0,45.0,'Carb',9),
('R152','ING088',70.0,'g','70g Duck Breast, skin removed and trimmed of fat',35.0,105.0,'Protein',1),
('R152','ING042',55.0,'g','55g Jasmine Rice (dry weight), cooked and cooled',27.5,82.5,'Carb',2),
('R152','ING018',1.0,'each','1 Egg',null,2.0,'Protein',3),
('R152','ING102',50.0,'g','50g Frozen Peas & Sweetcorn Mix',25.0,75.0,'Carb',4),
('R152','ING192',15.0,'ml','1 tbsp Light Soy Sauce',7.5,22.5,'Protein',5),
('R152','ING187',4.5,'g','1 tsp Sesame Oil',2.25,6.75,'Fat',6),
('R152','ING194',2.0,'each','2 Spring Onions, sliced',1.0,3.0,'Carb',7),
('R152','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',8),
('R152','ING098',1.0,'g','1cm Ginger, grated',null,2.0,'Carb',9),
('R153','ING119',100.0,'g','100g Lamb Breast, trimmed of visible fat, thinly sliced',50.0,150.0,'Fat',1),
('R153','ING064',4.0,'each','4 Chinese Pancakes (approx. 70g total)',3.0,5.0,'Carb',2),
('R153','ING113',42.0,'g','2 tbsp Reduced-Sugar Hoisin Sauce',21.0,63.0,'Carb',3),
('R153','ING080',75.0,'g','1/4 Cucumber, cut into matchsticks',37.5,112.5,'Carb',4),
('R153','ING194',2.0,'each','2 Spring Onions, shredded',1.0,3.0,'Carb',5),
('R154','ING117',170.0,'g','170g King Prawns, raw and peeled',85.0,255.0,'Protein',1),
('R154','ING042',25.0,'g','25g Jasmine Rice (dry weight)',12.5,37.5,'Carb',2),
('R154','ING171',75.0,'g','1/2 Red Pepper, chopped',37.5,112.5,'Carb',3),
('R154','ING149',37.5,'g','1/4 Onion, chopped',18.75,56.25,'Carb',4),
('R154','ING161',80.0,'g','80g Pineapple Chunks in Juice',40.0,120.0,'Carb',5),
('R154','ING206',21.0,'g','1 tbsp Tomato Ketchup',10.5,31.5,'Carb',6),
('R154','ING051',7.0,'g','1 tsp Light Brown Sugar',3.5,10.5,'Carb',7),
('R154','ING075',3.0,'g','1 tsp Cornflour',1.5,4.5,'Carb',8),
('R154','ING177',15.0,'ml','1 tbsp Rice Wine Vinegar',7.5,22.5,'Carb',9),
('R154','ING213',6.75,'g','1 1/2 tsp Vegetable Oil',3.38,10.12,'Fat',10),
('R154','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',11),
('R155','ING045',120.0,'g','120g Beef Cheek, trimmed of visible fat',60.0,180.0,'Protein',1),
('R155','ING210',65.0,'g','65g Udon Noodles (dry weight)',32.5,97.5,'Carb',2),
('R155','ING197',300.0,'ml','300ml Low-Sodium Beef Stock',150.0,450.0,'Protein',3),
('R155','ING192',15.0,'ml','1 tbsp Light Soy Sauce',7.5,22.5,'Protein',4),
('R155','ING141',5.0,'ml','1 tsp Mirin',2.5,7.5,'Carb',5),
('R155','ING153',50.0,'g','50g Pak Choi, halved',25.0,75.0,'Protein',6),
('R155','ING104',1.0,'each','1 Garlic Clove',null,2.0,'Carb',7),
('R155','ING098',1.0,'g','1cm Ginger, sliced',null,2.0,'Carb',8),
('R155','ING194',1.0,'each','1 Spring Onion, sliced',null,2.0,'Carb',9),
('R156','ING046',85.0,'g','85g Beef Short Rib',42.5,127.5,'Protein',1),
('R156','ING196',2.0,'each','2 Steamed Bao Buns (approx. 80g total)',1.0,3.0,'Carb',2),
('R156','ING113',52.5,'g','2 1/2 tbsp Reduced-Sugar Hoisin Sauce',26.25,78.75,'Carb',3),
('R156','ING080',75.0,'g','1/4 Cucumber, cut into matchsticks',37.5,112.5,'Carb',4),
('R156','ING194',1.0,'each','1 Spring Onion, shredded',null,2.0,'Carb',5),
('R156','ING104',1.0,'each','1 Garlic Clove',null,2.0,'Carb',6),
('R156','ING098',1.0,'g','1cm Ginger, sliced',null,2.0,'Carb',7),
('R157','ING126',130.0,'g','130g Lean Lamb Leg Steak, trimmed and cut into strips',65.0,195.0,'Protein',1),
('R157','ING042',30.0,'g','30g Basmati Rice (dry weight)',15.0,45.0,'Carb',2),
('R157','ING213',2.25,'g','1/2 tsp Vegetable Oil',1.12,3.38,'Fat',3),
('R157','ING171',75.0,'g','1/2 Red Pepper, sliced',37.5,112.5,'Carb',4),
('R157','ING149',37.5,'g','1/4 Onion, sliced',18.75,56.25,'Carb',5),
('R157','ING109',40.0,'g','40g Mangetout',20.0,60.0,'Carb',6),
('R157','ING085',1.25,'g','1/2 tsp Szechuan Peppercorns, crushed',0.62,1.88,'Carb',7),
('R157','ING172',1.0,'each','1 Red Chilli, sliced',null,2.0,'Carb',8),
('R157','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',9),
('R157','ING098',1.0,'g','1cm Ginger, grated',null,2.0,'Carb',10),
('R157','ING192',15.0,'ml','1 tbsp Light Soy Sauce',7.5,22.5,'Protein',11),
('R157','ING011',7.0,'g','1 tsp Honey',3.5,10.5,'Carb',12),
('R157','ING075',3.0,'g','1 tsp Cornflour',1.5,4.5,'Carb',13),
('R158','ING217',1.0,'each','1 Slice White Bread (30g), crusts removed',null,2.0,'Carb',1),
('R158','ING117',25.0,'g','25g Raw Prawns, peeled',12.5,37.5,'Protein',2),
('R158','ING019',1.0,'each','1 Egg White',null,2.0,'Protein',3),
('R158','ING188',7.5,'g','1 1/2 tsp Sesame Seeds',3.75,11.25,'Fat',4),
('R158','ING187',2.25,'g','1/2 tsp Sesame Oil',1.12,3.38,'Fat',5),
('R158','ING194',1.0,'each','1 Spring Onion, finely chopped',null,2.0,'Carb',6),
('R158','ING098',0.5,'g','1/2 tsp Ginger, grated',null,1.5,'Carb',7),
('R159','ING062',120.0,'g','120g Chicken Breast, cut into bite-size pieces',60.0,180.0,'Protein',1),
('R159','ING042',22.0,'g','22g Jasmine Rice (dry weight)',11.0,33.0,'Carb',2),
('R159','ING075',10.0,'g','10g Cornflour, for coating',5.0,15.0,'Carb',3),
('R159','ING075',3.0,'g','1 tsp Cornflour, mixed with water, for the glaze',1.5,4.5,'Carb',4),
('R159','ING011',21.0,'g','1 tbsp Honey',10.5,31.5,'Carb',5),
('R159','ING192',15.0,'ml','1 tbsp Light Soy Sauce',7.5,22.5,'Protein',6),
('R159','ING187',4.5,'g','1 tsp Sesame Oil',2.25,6.75,'Fat',7),
('R159','ING188',5.0,'g','1 tsp Sesame Seeds',2.5,7.5,'Fat',8),
('R159','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',9),
('R159','ING098',1.0,'g','1cm Ginger, grated',null,2.0,'Carb',10),
('R160','ING219',150.0,'g','150g Monkfish Tail (skin removed, cubed)',75.0,225.0,'Protein',1),
('R160','ING171',100.0,'g','100g Mixed Peppers (red & yellow), sliced',50.0,150.0,'Carb',2),
('R160','ING173',50.0,'g','50g Red Onion, sliced',25.0,75.0,'Carb',3),
('R160','ING072',2.0,'each','2 Corn Tortillas (small, approx. 30g each)',1.0,3.0,'Carb',4),
('R160','ING023',4.5,'g','1 tsp Olive Oil',2.25,6.75,'Fat',5),
('R160','ING081',2.5,'g','1 tsp Fajita Spice Mix (cumin, smoked paprika, chilli powder, garlic powder)',1.25,3.75,'Carb',6),
('R160','ING030',30.0,'g','30g Fage Total 0% Greek Yoghurt',15.0,45.0,'Protein',7),
('R160','ING134',0.25,'each','1/4 Lime',null,1.25,'Carb',8),
('R160','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',9),
('R161','ING122',120.0,'g','120g Lean Beef Brisket or Shin, trimmed of visible fat, cubed',60.0,180.0,'Protein',1),
('R161','ING023',4.5,'g','1 tsp Olive Oil',2.25,6.75,'Fat',2),
('R161','ING149',75.0,'g','1/2 Onion, chopped',37.5,112.5,'Carb',3),
('R161','ING104',2.0,'each','2 Garlic Cloves, crushed',1.0,3.0,'Carb',4),
('R161','ING065',15.0,'g','2 Dried Ancho or Guajillo Chillies, rehydrated and blended (or 1 tbsp Chipotle Paste)',7.5,22.5,'Carb',5),
('R161','ING155',100.0,'g','100g Tinned Chopped Tomatoes',50.0,150.0,'Carb',6),
('R161','ING197',200.0,'ml','200ml Beef Stock',100.0,300.0,'Protein',7),
('R161','ING085',1.25,'g','1/2 tsp Ground Cumin',0.62,1.88,'Carb',8),
('R161','ING085',1.25,'g','1/2 tsp Dried Oregano',0.62,1.88,'Carb',9),
('R161','ING043',1.0,'each','1 Bay Leaf',0.5,1.5,'Carb',10),
('R161','ING072',1.0,'each','1 Corn Tortilla, to serve',null,2.0,'Carb',11),
('R161','ING134',0.25,'each','1/4 Lime',null,1.25,'Carb',12),
('R161','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',13),
('R162','ING122',100.0,'g','100g Lean Beef Shin, trimmed of visible fat, diced',50.0,150.0,'Protein',1),
('R162','ING023',4.5,'g','1 tsp Olive Oil',2.25,6.75,'Fat',2),
('R162','ING149',75.0,'g','1/2 Onion, diced',37.5,112.5,'Carb',3),
('R162','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',4),
('R162','ING047',150.0,'g','150g Black Beans (tinned, drained weight) or mixed black/kidney beans',75.0,225.0,'Carb',5),
('R162','ING155',150.0,'g','150g Tinned Chopped Tomatoes',75.0,225.0,'Carb',6),
('R162','ING197',100.0,'ml','100ml Beef Stock',50.0,150.0,'Protein',7),
('R162','ING085',2.5,'g','1 tsp Ground Cumin',1.25,3.75,'Carb',8),
('R162','ING085',2.5,'g','1 tsp Smoked Paprika',1.25,3.75,'Carb',9),
('R162','ING085',1.25,'g','1/2 tsp Chilli Powder',0.62,1.88,'Carb',10),
('R162','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',11),
('R163','ING122',120.0,'g','120g Lean Beef Brisket or Chuck, trimmed of visible fat, cubed',60.0,180.0,'Protein',1),
('R163','ING023',4.5,'g','1 tsp Olive Oil',2.25,6.75,'Fat',2),
('R163','ING149',75.0,'g','1/2 Onion, chopped',37.5,112.5,'Carb',3),
('R163','ING104',2.0,'each','2 Garlic Cloves, crushed',1.0,3.0,'Carb',4),
('R163','ING065',14.0,'g','2 tsp Chipotle Paste (chipotle in adobo)',7.0,21.0,'Carb',5),
('R163','ING197',50.0,'ml','50ml Beef Stock',25.0,75.0,'Protein',6),
('R163','ING150',0.5,'each','Juice of 1/2 Orange',null,1.5,'Carb',7),
('R163','ING085',1.25,'g','1/2 tsp Ground Cumin',0.62,1.88,'Carb',8),
('R163','ING043',1.0,'each','1 Bay Leaf',0.5,1.5,'Carb',9),
('R163','ING072',2.0,'each','2 Corn Tortillas, to serve',1.0,3.0,'Carb',10),
('R163','ING134',0.25,'each','1/4 Lime',null,1.25,'Carb',11),
('R163','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',12),
('R164','ING072',2.0,'each','2 Corn Tortillas (approx. 65g total), cut into triangles',1.0,3.0,'Carb',1),
('R164','ING135',1.0,'g','Cooking Oil Spray',0.5,1.5,'Fat',2),
('R164','ING123',60.0,'g','60g Lean Beef Mince (5% fat) or Chicken Breast, cooked and seasoned',30.0,90.0,'Protein',3),
('R164','ING081',2.5,'g','1 tsp Taco Seasoning (cumin, paprika, garlic powder, chilli powder)',1.25,3.75,'Carb',4),
('R164','ING047',40.0,'g','40g Black Beans (tinned, drained weight)',20.0,60.0,'Carb',5),
('R164','ING175',20.0,'g','20g Reduced-Fat Cheddar, grated',10.0,30.0,'Protein',6),
('R164','ING101',40.0,'g','40g Fresh Tomato Salsa',20.0,60.0,'Carb',7),
('R164','ING030',40.0,'g','40g Fage Total 0% Greek Yoghurt',20.0,60.0,'Protein',8),
('R164','ING115',0.25,'each','1/4 Jalapeño, sliced',null,1.25,'Carb',9),
('R164','ING194',1.0,'each','1 Spring Onion, sliced',null,2.0,'Carb',10),
('R164','ING099',5.0,'g','Fresh Coriander, chopped',2.5,7.5,'Carb',11),
('R165','ING062',150.0,'g','1 Chicken Breast (approx. 100g), skin removed, butterflied/flattened',75.0,225.0,'Protein',1),
('R165','ING129',0.5,'each','Juice of 1/2 Lemon',null,1.5,'Carb',2),
('R165','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',3),
('R165','ING085',2.5,'g','1 tsp Smoked Paprika',1.25,3.75,'Carb',4),
('R165','ING085',1.25,'g','1/2 tsp Chilli Flakes',0.62,1.88,'Carb',5),
('R165','ING085',1.25,'g','1/2 tsp Dried Oregano',0.62,1.88,'Carb',6),
('R165','ING202',100.0,'g','100g Sweetcorn Kernels (or 1 Corn on the Cob)',50.0,150.0,'Carb',7),
('R165','ING143',100.0,'g','100g Mixed Salad Leaves, Tomato and Cucumber',50.0,150.0,'Carb',8),
('R165','ING020',0.25,'each','1/4 Avocado',null,1.25,'Fat',9),
('R165','ING134',0.25,'each','1/4 Lime',null,1.25,'Carb',10),
('R166','ING062',130.0,'g','130g Chicken Breast (skinless)',65.0,195.0,'Protein',1),
('R166','ING042',40.0,'g','40g Long Grain Rice (dry weight)',20.0,60.0,'Carb',2),
('R166','ING116',20.0,'g','20g Kidney Beans (canned, drained)',10.0,30.0,'Carb',3),
('R166','ING132',30.0,'ml','30ml Light Coconut Milk',15.0,45.0,'Fat',4),
('R166','ING170',4.5,'g','1 tsp Rapeseed Oil',2.25,6.75,'Fat',5),
('R166','ING185',0.5,'each','1/2 Scotch Bonnet Chilli, deseeded',null,1.5,'Carb',6),
('R166','ING104',1.0,'each','1 clove Garlic',null,2.0,'Carb',7),
('R166','ING098',1.0,'g','1 tsp Fresh Ginger, grated',null,2.0,'Carb',8),
('R166','ING194',1.0,'each','1 Spring Onion',null,2.0,'Carb',9),
('R166','ING085',1.25,'g','1/2 tsp Ground Allspice',0.62,1.88,'Carb',10),
('R166','ING085',1.25,'g','1/2 tsp Dried Thyme',0.62,1.88,'Carb',11),
('R166','ING134',0.5,'each','1/2 Lime',null,1.5,'Carb',12),
('R167','ING124',130.0,'g','130g Lean Beef Rump Steak (trimmed), cubed',65.0,195.0,'Protein',1),
('R167','ING201',140.0,'g','140g Sweet Potato, cut into wedges',70.0,210.0,'Carb',2),
('R167','ING178',10.0,'g','10g Ground Roasted Peanuts',5.0,15.0,'Fat',3),
('R167','ING170',4.5,'g','1 tsp Rapeseed Oil',2.25,6.75,'Fat',4),
('R167','ING085',1.25,'g','1/2 tsp Paprika',0.62,1.88,'Carb',5),
('R167','ING085',1.25,'g','1/2 tsp Cayenne Pepper',0.62,1.88,'Carb',6),
('R167','ING085',1.25,'g','1/2 tsp Ground Ginger',0.62,1.88,'Carb',7),
('R167','ING085',1.25,'g','1/2 tsp Garlic Powder',0.62,1.88,'Carb',8),
('R167','ING197',1.25,'ml','1/4 tsp Stock Powder/Bouillon',0.62,1.88,'Protein',9),
('R167','ING149',37.5,'g','1/4 Onion, cut into wedges',18.75,56.25,'Carb',10),
('R167','ING061',60.0,'g','4 Cherry Tomatoes',30.0,90.0,'Carb',11),
('R167','ING134',0.5,'each','1/2 Lime',null,1.5,'Carb',12),
('R168','ING106',130.0,'g','130g Goat Meat (diced, bone-in, excess fat trimmed)',65.0,195.0,'Protein',1),
('R168','ING225',65.0,'g','65g Yam (or White Potato), peeled and cubed',32.5,97.5,'Carb',2),
('R168','ING197',400.0,'ml','400ml Chicken or Vegetable Stock (low salt)',200.0,600.0,'Protein',3),
('R168','ING185',0.5,'each','1/2 Scotch Bonnet Chilli',null,1.5,'Carb',4),
('R168','ING098',1.0,'g','1 tsp Fresh Ginger, grated',null,2.0,'Carb',5),
('R168','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',6),
('R168','ING085',1.25,'g','1/2 tsp Ground Calabash Nutmeg (or Nutmeg)',0.62,1.88,'Carb',7),
('R168','ING085',0.625,'g','1/4 tsp Ground Uda (or Cayenne Pepper)',0.31,0.94,'Carb',8),
('R168','ING099',5.0,'g','Handful Scent Leaf or Basil, to serve',2.5,7.5,'Carb',9),
('R168','ING134',0.5,'each','1/2 Lime, to serve',null,1.5,'Carb',10),
('R169','ING062',115.0,'g','115g Chicken Breast (skinless)',57.5,172.5,'Protein',1),
('R169','ING042',55.0,'g','55g Long Grain Rice (dry weight)',27.5,82.5,'Carb',2),
('R169','ING155',80.0,'g','80g Tomato Passata (or Chopped Tomatoes)',40.0,120.0,'Carb',3),
('R169','ING170',6.75,'g','1.5 tsp Rapeseed Oil',3.38,10.12,'Fat',4),
('R169','ING149',37.5,'g','1/4 Onion, finely diced',18.75,56.25,'Carb',5),
('R169','ING171',75.0,'g','1/2 Red Pepper, diced',37.5,112.5,'Carb',6),
('R169','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',7),
('R169','ING098',1.0,'g','1 tsp Fresh Ginger, grated',null,2.0,'Carb',8),
('R169','ING185',0.25,'each','1/4 Scotch Bonnet Chilli',null,1.25,'Carb',9),
('R169','ING085',1.25,'g','1/2 tsp Dried Thyme',0.62,1.88,'Carb',10),
('R169','ING043',1.0,'each','1 Bay Leaf',0.5,1.5,'Carb',11),
('R169','ING198',0.25,'each','1/4 Chicken Stock Cube',null,1.25,'Carb',12),
('R170','ING117',150.0,'g','150g King Prawns (raw, peeled)',75.0,225.0,'Protein',1),
('R170','ING042',50.0,'g','50g Basmati Rice (dry weight)',25.0,75.0,'Carb',2),
('R170','ING132',95.0,'ml','95ml Light Coconut Milk',47.5,142.5,'Fat',3),
('R170','ING149',37.5,'g','1/4 Onion, sliced',18.75,56.25,'Carb',4),
('R170','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',5),
('R170','ING098',1.0,'g','1 tsp Fresh Ginger, grated',null,2.0,'Carb',6),
('R170','ING185',0.25,'each','1/4 Scotch Bonnet Chilli',null,1.25,'Carb',7),
('R170','ING081',2.5,'g','1 tsp Curry Powder',1.25,3.75,'Carb',8),
('R170','ING085',1.25,'g','1/2 tsp Ground Allspice',0.62,1.88,'Carb',9),
('R170','ING085',1.25,'g','1/2 tsp Dried Thyme',0.62,1.88,'Carb',10),
('R171','ING106',135.0,'g','135g Goat Meat (leg, trimmed of visible fat), diced',67.5,202.5,'Protein',1),
('R171','ING042',45.0,'g','45g Long Grain Rice (dry weight)',22.5,67.5,'Carb',2),
('R171','ING132',55.0,'ml','55ml Light Coconut Milk',27.5,82.5,'Fat',3),
('R171','ING170',4.5,'g','1 tsp Rapeseed Oil',2.25,6.75,'Fat',4),
('R171','ING149',37.5,'g','1/4 Onion, sliced',18.75,56.25,'Carb',5),
('R171','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',6),
('R171','ING098',1.0,'g','1 tsp Fresh Ginger, grated',null,2.0,'Carb',7),
('R171','ING185',0.25,'each','1/4 Scotch Bonnet Chilli',null,1.25,'Carb',8),
('R171','ING081',2.5,'g','1 tsp Curry Powder',1.25,3.75,'Carb',9),
('R171','ING085',1.25,'g','1/2 tsp Ground Allspice',0.62,1.88,'Carb',10),
('R171','ING085',1.25,'g','1/2 tsp Dried Thyme',0.62,1.88,'Carb',11),
('R172','ING183',50.0,'g','50g Salt Fish (dried salted cod), soaked and flaked',25.0,75.0,'Protein',1),
('R172','ING164',20.0,'g','20g Self-Raising Flour',10.0,30.0,'Carb',2),
('R172','ING018',0.25,'each','1/4 Egg, beaten',null,1.25,'Protein',3),
('R172','ING194',1.0,'each','1 Spring Onion, finely sliced',null,2.0,'Carb',4),
('R172','ING085',0.625,'g','1/4 tsp Dried Thyme',0.31,0.94,'Carb',5),
('R172','ING185',0.25,'each','1/4 Scotch Bonnet Chilli, finely chopped',null,1.25,'Carb',6),
('R172','ING170',2.25,'g','1/2 tsp Rapeseed Oil (for baking spray)',1.12,3.38,'Fat',7),
('R173','ING138',20.0,'g','20g Mango, finely diced (or Pineapple)',10.0,30.0,'Carb',1),
('R173','ING185',0.5,'each','1/2 Scotch Bonnet Chilli, deseeded and finely chopped',null,1.5,'Carb',2),
('R173','ING098',2.5,'g','5g Fresh Ginger, grated',1.5,3.5,'Carb',3),
('R173','ING051',7.0,'g','1 tsp Soft Brown Sugar',3.5,10.5,'Carb',4),
('R173','ING067',15.0,'ml','1 tbsp Cider Vinegar',7.5,22.5,'Carb',5),
('R173','ING134',0.25,'each','Juice of 1/4 Lime',null,1.25,'Carb',6),
('R173','ING184',1.0,'g','Pinch of Salt',0.5,1.5,'Carb',7),
('R174','ING062',115.0,'g','115g Chicken Breast (skinless), butterflied/flattened',57.5,172.5,'Protein',1),
('R174','ING164',25.0,'g','25g Plain Flour',12.5,37.5,'Carb',2),
('R174','ING049',20.0,'g','20g Panko Breadcrumbs',10.0,30.0,'Carb',3),
('R174','ING018',1.0,'each','1 Egg, beaten',null,2.0,'Protein',4),
('R174','ING170',4.5,'g','1 tsp Rapeseed Oil (for baking spray)',2.25,6.75,'Fat',5),
('R174','ING085',1.25,'g','1/2 tsp Paprika',0.62,1.88,'Carb',6),
('R174','ING085',0.625,'g','1/4 tsp Ground Allspice',0.31,0.94,'Carb',7),
('R174','ING085',0.625,'g','1/4 tsp Garlic Powder',0.31,0.94,'Carb',8),
('R174','ING085',0.625,'g','1/4 tsp Onion Powder',0.31,0.94,'Carb',9),
('R174','ING085',0.625,'g','1/4 tsp Dried Thyme',0.31,0.94,'Carb',10),
('R174','ING184',1.0,'g','Pinch of Cayenne Pepper',0.5,1.5,'Carb',11),
('R175','ING062',100.0,'g','100g Chicken Breast, cubed',50.0,150.0,'Protein',1),
('R175','ING023',6.75,'g','1 1/2 tsp Olive Oil',3.38,10.12,'Fat',2),
('R175','ING129',0.5,'each','1/2 Lemon (juiced)',null,1.5,'Carb',3),
('R175','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',4),
('R175','ING085',1.25,'g','1/2 tsp Dried Oregano',0.62,1.88,'Carb',5),
('R175','ING162',1.0,'each','1 Pitta Bread',null,2.0,'Carb',6),
('R175','ING030',40.0,'g','40g Fage Total 0% Greek Yoghurt',20.0,60.0,'Protein',7),
('R175','ING080',50.0,'g','50g Cucumber (30g grated for tzatziki, 20g sliced for salad)',25.0,75.0,'Carb',8),
('R175','ING099',5.0,'g','1 tsp Fresh Dill, chopped',2.5,7.5,'Carb',9),
('R175','ING061',40.0,'g','40g Cherry Tomatoes, halved',20.0,60.0,'Carb',10),
('R175','ING173',20.0,'g','20g Red Onion, sliced',10.0,30.0,'Carb',11),
('R176','ING126',100.0,'g','100g Lamb Leg Steak, thinly sliced',50.0,150.0,'Protein',1),
('R176','ING023',6.75,'g','1 1/2 tsp Olive Oil',3.38,10.12,'Fat',2),
('R176','ING085',1.25,'g','1/2 tsp Ground Cumin',0.62,1.88,'Carb',3),
('R176','ING085',1.25,'g','1/2 tsp Smoked Paprika',0.62,1.88,'Carb',4),
('R176','ING085',1.25,'g','1/2 tsp Dried Oregano',0.62,1.88,'Carb',5),
('R176','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',6),
('R176','ING108',1.0,'each','1 Greek Flatbread',null,2.0,'Carb',7),
('R176','ING030',50.0,'g','50g Fage Total 0% Greek Yoghurt',25.0,75.0,'Protein',8),
('R176','ING080',20.0,'g','20g Cucumber, grated',10.0,30.0,'Carb',9),
('R176','ING099',5.0,'g','1 tsp Fresh Mint or Dill, chopped',2.5,7.5,'Carb',10),
('R176','ING173',20.0,'g','20g Red Onion, sliced',10.0,30.0,'Carb',11),
('R176','ING205',20.0,'g','20g Tomato, sliced',10.0,30.0,'Carb',12),
('R177','ING126',120.0,'g','120g Lamb Shoulder, lean-trimmed, cubed',60.0,180.0,'Protein',1),
('R177','ING167',200.0,'g','200g Potatoes, peeled and cut into chunks',100.0,300.0,'Carb',2),
('R177','ING023',4.5,'g','1 tsp Olive Oil',2.25,6.75,'Fat',3),
('R177','ING149',30.0,'g','30g Onion, sliced',15.0,45.0,'Carb',4),
('R177','ING205',30.0,'g','30g Tomato, chopped',15.0,45.0,'Carb',5),
('R177','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',6),
('R177','ING129',0.5,'each','1/2 Lemon (juice and zest)',null,1.5,'Carb',7),
('R177','ING085',1.25,'g','1/2 tsp Dried Oregano',0.62,1.88,'Carb',8),
('R177','ING043',1.0,'each','1 Bay Leaf',0.5,1.5,'Carb',9),
('R177','ING197',100.0,'ml','100ml Chicken Stock',50.0,150.0,'Protein',10),
('R178','ING117',60.0,'g','60g Raw King Prawns, peeled',30.0,90.0,'Protein',1),
('R178','ING146',35.0,'g','35g Mussels, cooked (meat only)',17.5,52.5,'Protein',2),
('R178','ING151',55.0,'g','55g Orzo Pasta (dry weight)',27.5,82.5,'Carb',3),
('R178','ING023',4.5,'g','1 tsp Olive Oil',2.25,6.75,'Fat',4),
('R178','ING155',100.0,'g','100g Chopped Tomatoes (tinned)',50.0,150.0,'Carb',5),
('R178','ING149',25.0,'g','25g Onion, finely diced',12.5,37.5,'Carb',6),
('R178','ING104',1.0,'each','1 clove Garlic, crushed',null,2.0,'Carb',7),
('R178','ING099',15.0,'g','1 tbsp Fresh Parsley, chopped',7.5,22.5,'Carb',8),
('R178','ING129',0.25,'each','1/4 Lemon (juice)',null,1.25,'Carb',9),
('R178','ING197',50.0,'ml','50ml Fish or Vegetable Stock',25.0,75.0,'Protein',10),
('R179','ING126',140.0,'g','140g Lamb Shoulder, lean-trimmed',70.0,210.0,'Protein',1),
('R179','ING167',100.0,'g','100g Potato, peeled',50.0,150.0,'Carb',2),
('R179','ING006',15.0,'ml','1 tbsp Semi-Skimmed Milk (for the mash)',7.5,22.5,'Carb',3),
('R179','ING057',80.0,'g','80g Carrot, cut into batons',40.0,120.0,'Carb',4),
('R179','ING023',4.5,'g','1 tsp Olive Oil',2.25,6.75,'Fat',5),
('R179','ING104',1.0,'each','1 clove Garlic',null,2.0,'Carb',6),
('R179','ING099',1.0,'g','1 sprig Rosemary',0.5,1.5,'Carb',7),
('R179','ING197',100.0,'ml','100ml Lamb or Beef Stock',50.0,150.0,'Protein',8),
('R179','ING174',50.0,'ml','50ml Red Wine (optional, for the jus)',25.0,75.0,'Carb',9),
('R180','ING167',180.0,'g','1 large Baking Potato (220g)',90.0,270.0,'Carb',1),
('R180','ING023',4.5,'g','1 tsp Olive Oil',2.25,6.75,'Fat',2),
('R180','ING062',50.0,'g','50g Chicken Breast, cooked and shredded',25.0,75.0,'Protein',3),
('R180','ING139',20.0,'g','20g Mature Cheddar, grated',10.0,30.0,'Fat',4),
('R180','ING030',30.0,'g','30g Fage Total 0% Greek Yoghurt',15.0,45.0,'Protein',5),
('R180','ING099',5.0,'g','1 tsp Chives, chopped',2.5,7.5,'Carb',6),
('R180','ING184',1.0,'g','Black Pepper, to season',0.5,1.5,'Carb',7),
('R181','ING102',70.0,'g','70g Frozen Peas',35.0,105.0,'Carb',1),
('R181','ING168',5.0,'g','5g Toasted Pumpkin Seeds',2.5,7.5,'Fat',2),
('R181','ING099',5.0,'g','Small handful Fresh Mint, finely chopped',2.5,7.5,'Carb',3),
('R181','ING197',50.0,'ml','50ml Vegetable Stock',25.0,75.0,'Protein',4),
('R181','ING184',1.0,'g','Black Pepper, to taste',0.5,1.5,'Carb',5),
('R182','ING050',150.0,'g','150g Tenderstem Broccoli',75.0,225.0,'Protein',1),
('R182','ING032',4.0,'g','4g Flaked Almonds, toasted',2.0,6.0,'Fat',2),
('R182','ING129',0.25,'each','1/4 Lemon, zest and juice',null,1.25,'Carb',3),
('R182','ING085',1.0,'g','Pinch of Chilli Flakes',0.5,1.5,'Carb',4),
('R182','ING184',1.0,'g','Sea Salt, to taste',0.5,1.5,'Carb',5),
('R183','ING109',120.0,'g','120g Green Beans, trimmed',60.0,180.0,'Carb',1),
('R183','ING154',8.0,'g','8g Parmesan, finely shaved',4.0,12.0,'Protein',2),
('R183','ING184',1.0,'g','Black Pepper, to taste',0.5,1.5,'Carb',3),
('R183','ING184',1.0,'g','Pinch of Sea Salt',0.5,1.5,'Carb',4),
('R184','ING059',200.0,'g','200g Cauliflower, cut into florets',100.0,300.0,'Carb',1),
('R184','ING075',10.0,'g','10g Cornflour',5.0,15.0,'Carb',2),
('R184','ING135',1.0,'g','Low-calorie Olive Oil Spray',0.5,1.5,'Fat',3),
('R184','ING030',20.0,'g','20g Fage Total 0% Greek Yoghurt',10.0,30.0,'Protein',4),
('R184','ING195',7.0,'g','1 Tsp Sriracha (or hot sauce)',3.5,10.5,'Carb',5),
('R184','ING085',0.625,'g','1/4 Tsp Smoked Paprika',0.31,0.94,'Carb',6),
('R184','ING085',0.625,'g','1/4 Tsp Garlic Powder',0.31,0.94,'Carb',7),
('R184','ING194',1.0,'each','1 Spring Onion, sliced, to garnish',null,2.0,'Carb',8),
('R185','ING205',150.0,'g','150g Tomatoes, finely diced',75.0,225.0,'Carb',1),
('R185','ING173',20.0,'g','20g Red Onion, finely diced',10.0,30.0,'Carb',2),
('R185','ING134',0.25,'each','1/4 Lime, juice',null,1.25,'Carb',3),
('R185','ING099',5.0,'g','Small handful Fresh Coriander, chopped',2.5,7.5,'Carb',4),
('R185','ING085',1.0,'g','Pinch of Chilli Flakes',0.5,1.5,'Carb',5),
('R185','ING184',1.0,'g','Pinch of Sea Salt',0.5,1.5,'Carb',6),
('R186','ING167',120.0,'g','120g Potato, peeled and cubed',60.0,180.0,'Carb',1),
('R186','ING149',37.5,'g','1/4 Onion, finely diced',18.75,56.25,'Carb',2),
('R186','ING213',4.5,'g','1 Tsp Vegetable Oil',2.25,6.75,'Fat',3),
('R186','ING147',1.25,'g','1/2 Tsp Mustard Seeds',0.62,1.88,'Fat',4),
('R186','ING085',1.25,'g','1/2 Tsp Cumin Seeds',0.62,1.88,'Carb',5),
('R186','ING085',0.625,'g','1/4 Tsp Turmeric',0.31,0.94,'Carb',6),
('R186','ING085',0.625,'g','1/4 Tsp Chilli Powder',0.31,0.94,'Carb',7),
('R186','ING043',1.0,'each','Few Curry Leaves',0.5,1.5,'Carb',8),
('R186','ING184',1.0,'g','Pinch of Sea Salt',0.5,1.5,'Carb',9),
('R187','ING193',200.0,'g','200g Spinach, fresh',100.0,300.0,'Protein',1),
('R187','ING149',37.5,'g','1/4 Onion, finely chopped',18.75,56.25,'Carb',2),
('R187','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',3),
('R187','ING098',1.0,'g','1cm Ginger, grated',null,2.0,'Carb',4),
('R187','ING213',4.5,'g','1 Tsp Vegetable Oil',2.25,6.75,'Fat',5),
('R187','ING085',1.25,'g','1/2 Tsp Cumin Seeds',0.62,1.88,'Carb',6),
('R187','ING085',1.25,'g','1/2 Tsp Garam Masala',0.62,1.88,'Carb',7),
('R187','ING085',1.0,'g','Pinch of Chilli Powder',0.5,1.5,'Carb',8),
('R187','ING030',15.0,'g','1 Tbsp Fage Total 0% Greek Yoghurt',7.5,22.5,'Protein',9),
('R188','ING057',150.0,'g','150g Carrots, halved lengthways',75.0,225.0,'Carb',1),
('R188','ING023',2.25,'g','1/2 Tsp Olive Oil',1.12,3.38,'Fat',2),
('R188','ING011',7.0,'g','1 Tsp Honey',3.5,10.5,'Carb',3),
('R188','ING099',5.0,'g','Few Thyme Sprigs',2.5,7.5,'Carb',4),
('R188','ING184',1.0,'g','Sea Salt and Black Pepper',0.5,1.5,'Carb',5),
('R189','ING167',140.0,'g','140g Baby Potatoes',70.0,210.0,'Carb',1),
('R189','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',2),
('R189','ING154',5.0,'g','5g Parmesan, grated',2.5,7.5,'Protein',3),
('R189','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',4),
('R189','ING099',5.0,'g','Few Rosemary Sprigs',2.5,7.5,'Carb',5),
('R189','ING184',1.0,'g','Sea Salt, to taste',0.5,1.5,'Carb',6),
('R190','ING167',90.0,'g','90g Potato, peeled and chopped',45.0,135.0,'Carb',1),
('R190','ING057',50.0,'g','50g Carrot, peeled and chopped',25.0,75.0,'Carb',2),
('R190','ING191',20.0,'ml','20ml Skimmed Milk',10.0,30.0,'Carb',3),
('R190','ING023',4.5,'g','1 Tsp Olive Oil',2.25,6.75,'Fat',4),
('R190','ING184',1.0,'g','Pinch of White Pepper',0.5,1.5,'Carb',5),
('R190','ING099',5.0,'g','Chives, chopped, to garnish',2.5,7.5,'Carb',6),
('R191','ING015',50.0,'g','50g Chickpeas, cooked and drained',25.0,75.0,'Carb',1),
('R191','ING203',10.0,'g','10g Tahini',5.0,15.0,'Fat',2),
('R191','ING129',0.25,'each','1/4 Lemon, juice',null,1.25,'Carb',3),
('R191','ING104',0.5,'each','1/2 Garlic Clove',null,1.5,'Carb',4),
('R191','ING085',0.625,'g','1/4 Tsp Ground Cumin',0.31,0.94,'Carb',5),
('R191','ING028',1.0,'ml','Splash of Cold Water, to loosen',0.5,1.5,'Carb',6),
('R191','ING184',1.0,'g','Pinch of Sea Salt',0.5,1.5,'Carb',7),
('R192','ING073',1.0,'each','1 Corn on the Cob (approx. 125g kernels)',null,2.0,'Carb',1),
('R192','ING134',0.25,'each','1/4 Lime, juice',null,1.25,'Carb',2),
('R192','ING085',1.0,'g','Pinch of Chilli Powder',0.5,1.5,'Carb',3),
('R192','ING099',5.0,'g','Small handful Fresh Coriander, chopped',2.5,7.5,'Carb',4),
('R192','ING184',1.0,'g','Pinch of Sea Salt',0.5,1.5,'Carb',5),
('R193','ING143',50.0,'g','50g Mixed Salad Leaves',25.0,75.0,'Carb',1),
('R193','ING061',40.0,'g','40g Cherry Tomatoes, halved',20.0,60.0,'Carb',2),
('R193','ING080',30.0,'g','30g Cucumber, sliced',15.0,45.0,'Carb',3),
('R193','ING023',1.125,'g','1/4 Tsp Olive Oil',0.56,1.69,'Fat',4),
('R193','ING039',5.0,'ml','1 Tsp Balsamic Vinegar',2.5,7.5,'Carb',5),
('R193','ING184',1.0,'g','Sea Salt and Black Pepper',0.5,1.5,'Carb',6),
('R194','ING020',0.433,'each','65g Avocado (approx. 1/2 medium)',null,1.43333333333333,'Fat',1),
('R194','ING205',20.0,'g','20g Tomato, deseeded and finely diced',10.0,30.0,'Carb',2),
('R194','ING173',10.0,'g','10g Red Onion, finely diced',5.0,15.0,'Carb',3),
('R194','ING134',0.25,'each','1/4 Lime, juice',null,1.25,'Carb',4),
('R194','ING099',5.0,'g','Small handful Fresh Coriander, chopped',2.5,7.5,'Carb',5),
('R194','ING085',1.0,'g','Pinch of Chilli Flakes',0.5,1.5,'Carb',6),
('R194','ING184',1.0,'g','Pinch of Sea Salt',0.5,1.5,'Carb',7),
('R195','ING062',250.0,'g','250g Chicken Breast Mini Fillets',125.0,375.0,'Protein',1),
('R195','ING018',1.0,'each','1 Egg',null,2.0,'Protein',2),
('R195','ING008',90.0,'g','1 cup Oats (~90g)',45.0,135.0,'Carb',3),
('R195','ING006',15.0,'ml','1 tbsp Milk, Semi-Skimmed',7.5,22.5,'Carb',4),
('R195','ING081',10.0,'g','2 tsp Paprika/Cajun/Fajita Spice',5.0,15.0,'Carb',5),
('R195','ING023',15.0,'g','1 tbsp Olive Oil',7.5,22.5,'Fat',6),
('R195','ING193',60.0,'g','2 handfuls Lambs Lettuce/Spinach',30.0,90.0,'Protein',7),
('R195','ING061',30.0,'g','1 handful Cherry Tomatoes, chopped',15.0,45.0,'Carb',8),
('R195','ING201',300.0,'g','2 medium Sweet Potatoes',150.0,450.0,'Carb',9),
('R195','ING011',15.0,'g','1 tbsp Honey',7.5,22.5,'Carb',10),
('R196','ING008',180.0,'g','2 cups Oats',90.0,270.0,'Carb',1),
('R196','ING005',120.0,'g','1 cup Vanilla Whey Protein',60.0,180.0,'Protein',2),
('R196','ING006',120.0,'ml','1/2 cup Semi-Skimmed Milk',60.0,180.0,'Carb',3),
('R196','ING011',22.5,'g','1.5 tbsp Honey',11.25,33.75,'Carb',4),
('R196','ING009',30.0,'g','2 tbsp Peanut Butter',15.0,45.0,'Fat',5),
('R196','ING169',15.0,'g','1 tbsp Dried Fruit (Raisins)',7.5,22.5,'Carb',6),
('R196','ING229',45.0,'g','3 tbsp Mixed Nuts, chopped',22.5,67.5,'Fat',7),
('R196','ING212',80.0,'g','1 cup Desiccated Coconut',40.0,120.0,'Fat',8),
('R197','ING182',150.0,'g','1 Salmon Darne, baked',75.0,225.0,'Protein',1),
('R197','ING149',25.0,'g','1/4 Onion, sliced',12.5,37.5,'Carb',2),
('R197','ING073',1.0,'each','1 Sweetcorn on the Cob, boiled',null,2.0,'Carb',3),
('R197','ING201',200.0,'g','1 Sweet Potato, sliced',100.0,300.0,'Carb',4),
('R197','ING085',1.0,'g','1 pinch Chilli Flakes',0.5,1.5,'Carb',5),
('R197','ING023',5.0,'g','1 tsp Extra Virgin Olive Oil',2.5,7.5,'Fat',6),
('R197','ING085',1.0,'g','1/2 tsp Cumin',0.5,1.5,'Carb',7),
('R197','ING129',1.0,'each','1 Lemon, juiced',null,2.0,'Carb',8),
('R198','ING117',300.0,'g','300g Prawns, raw',150.0,450.0,'Protein',1),
('R198','ING140',100.0,'g','100g Noodles, dry',50.0,150.0,'Carb',2);
insert into ri_stage values
('R198','ING044',100.0,'g','1 cup Beansprouts',50.0,150.0,'Carb',3),
('R198','ING216',90.0,'g','1 cup Red Cabbage, sliced thinly',45.0,135.0,'Carb',4),
('R198','ING057',120.0,'g','2 Carrots, ribboned',60.0,180.0,'Carb',5),
('R198','ING194',2.0,'each','2 Spring Onions, sliced',1.0,3.0,'Carb',6),
('R198','ING171',120.0,'g','1 Pepper, sliced thinly',60.0,180.0,'Carb',7),
('R198','ING193',60.0,'g','2 handfuls Spinach',30.0,90.0,'Protein',8),
('R198','ING009',15.0,'g','1 tbsp Peanut Butter',7.5,22.5,'Fat',9),
('R198','ING192',30.0,'ml','2 tbsp Soy Sauce',15.0,45.0,'Protein',10),
('R198','ING011',15.0,'g','1 tbsp Honey',7.5,22.5,'Carb',11),
('R198','ING172',0.5,'each','1/2 Chilli, diced',null,1.5,'Carb',12),
('R198','ING187',15.0,'g','1 tbsp Sesame Oil',7.5,22.5,'Fat',13),
('R198','ING028',30.0,'ml','2 tbsp Boiling Water',15.0,45.0,'Carb',14),
('R198','ING099',15.0,'g','1 handful Coriander',7.5,22.5,'Carb',15),
('R198','ING099',15.0,'g','1 handful Mint',7.5,22.5,'Carb',16),
('R200','ING001',1.0,'each','1 Banana, peeled',null,2.0,'Carb',1),
('R200','ING118',1.0,'each','1 Kiwi, peeled',null,2.0,'Carb',2),
('R200','ING142',60.0,'g','1/2 cup Mixed Berries, frozen',30.0,90.0,'Carb',3),
('R200','ING211',250.0,'ml','250ml Almond Milk',125.0,375.0,'Fat',4),
('R200','ING005',30.0,'g','30g Vanilla Whey or Plant Protein',15.0,45.0,'Protein',5),
('R201','ING128',500.0,'g','500g Turkey Mince',250.0,750.0,'Protein',1),
('R201','ING023',15.0,'g','1 tbsp Extra Virgin Olive Oil',7.5,22.5,'Fat',2),
('R201','ING149',80.0,'g','1 Onion, chopped',40.0,120.0,'Carb',3),
('R201','ING060',80.0,'g','2 Celery Stalks, chopped',40.0,120.0,'Carb',4),
('R201','ING104',2.0,'each','2 Garlic Cloves, crushed',1.0,3.0,'Carb',5),
('R201','ING057',120.0,'g','2 Carrots, diced',60.0,180.0,'Carb',6),
('R201','ING155',800.0,'g','2 Tins of Chopped Tomatoes',400.0,1200.0,'Carb',7),
('R201','ING206',30.0,'g','2 tbsp Tomato Puree',15.0,45.0,'Carb',8),
('R201','ING085',4.0,'g','2 tsp Oregano, dried',2.0,6.0,'Carb',9),
('R201','ING224',5.0,'ml','1 tsp Worcestershire Sauce',2.5,7.5,'Carb',10),
('R201','ING156',500.0,'g','500g Spaghetti, uncooked',250.0,750.0,'Carb',11),
('R201','ING154',15.0,'g','2 tbsp Parmesan Cheese, grated',7.5,22.5,'Protein',12),
('R201','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',13),
('R202','ING005',30.0,'g','30g Choc Whey or Plant Protein (1 Scoop)',15.0,45.0,'Protein',1),
('R202','ING001',1.5,'each','1.5 Bananas',0.5,2.5,'Carb',2),
('R202','ING018',2.0,'each','2 Eggs',1.0,3.0,'Protein',3),
('R202','ING068',5.0,'g','1 tsp Coconut Oil',2.5,7.5,'Fat',4),
('R202','ING012',15.0,'g','1 tbsp Chocolate Chips',7.5,22.5,'Carb',5),
('R202','ING002',40.0,'g','1 handful Blueberries',20.0,60.0,'Carb',6),
('R202','ING011',5.0,'g','1 tsp Honey',2.5,7.5,'Carb',7),
('R203','ING023',15.0,'g','1 tbsp Extra Virgin Olive Oil',7.5,22.5,'Fat',1),
('R203','ING149',80.0,'g','1 Onion, diced',40.0,120.0,'Carb',2),
('R203','ING104',2.0,'each','2 Garlic Cloves, crushed',1.0,3.0,'Carb',3),
('R203','ING008',75.0,'g','75g Oats',37.5,112.5,'Carb',4),
('R203','ING128',400.0,'g','400g Turkey Mince',200.0,600.0,'Protein',5),
('R203','ING228',75.0,'g','75g Dried Apricots, diced',37.5,112.5,'Carb',6),
('R203','ING057',60.0,'g','1 Carrot, grated',30.0,90.0,'Carb',7),
('R203','ING018',1.0,'each','1 Egg',null,2.0,'Protein',8),
('R203','ING143',50.0,'g','5 Lettuce leaves',25.0,75.0,'Carb',9),
('R203','ING205',90.0,'g','1.5 Tomato, sliced',45.0,135.0,'Carb',10),
('R203','ING207',37.5,'g','2.5 tbsp Tomato Relish',18.75,56.25,'Carb',11),
('R203','ING020',1.5,'each','1.5 Avocado, mashed',0.5,2.5,'Fat',12),
('R203','ING053',5.0,'each','5 Wholemeal Burger Buns',4.0,6.0,'Carb',13),
('R204','ING006',100.0,'ml','100ml Semi-Skimmed Milk',50.0,150.0,'Carb',1),
('R204','ING030',50.0,'g','50g Low Fat Greek Yogurt',25.0,75.0,'Protein',2),
('R204','ING008',50.0,'g','50g Rolled Oats',25.0,75.0,'Carb',3),
('R204','ING215',20.0,'g','20g Walnuts, crushed',10.0,30.0,'Fat',4),
('R204','ING169',20.0,'g','20g Sultanas',10.0,30.0,'Carb',5),
('R204','ING011',5.0,'g','1 tsp Honey',2.5,7.5,'Carb',6),
('R204','ING057',50.0,'g','1/2 Carrot, grated',25.0,75.0,'Carb',7),
('R204','ING085',2.0,'g','1 tsp Cinnamon, ground',1.0,3.0,'Carb',8),
('R204','ING085',2.0,'g','1 tsp Nutmeg, ground',1.0,3.0,'Carb',9),
('R205','ING018',3.0,'each','3 Medium Eggs',2.0,4.0,'Protein',1),
('R205','ING205',100.0,'g','1 Medium Tomato, chopped',50.0,150.0,'Carb',2),
('R205','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',3),
('R205','ING093',40.0,'g','5 Low Fat Feta Cheese Cubes',20.0,60.0,'Fat',4),
('R205','ING085',1.0,'g','1/2 tsp Mixed Herbs, dried',0.5,1.5,'Carb',5),
('R206','ING104',2.0,'each','2 Garlic Cloves',1.0,3.0,'Carb',1),
('R206','ING094',440.0,'g','2 cups Tofu, Raw',220.0,660.0,'Protein',2),
('R206','ING015',480.0,'g','2 Tins Chickpeas, drained',240.0,720.0,'Carb',3),
('R206','ING132',400.0,'ml','1 Low Fat Coconut Milk can (400g)',200.0,600.0,'Fat',4),
('R206','ING204',20.0,'g','4 tsp Green Curry Paste',10.0,30.0,'Carb',5),
('R206','ING172',3.0,'each','3 Red Chilli Peppers',2.0,4.0,'Carb',6),
('R206','ING098',5.0,'g','1 Ginger (Thumb)',4.0,6.0,'Carb',7),
('R206','ING192',15.0,'ml','1 tbsp Soy Sauce, reduced sodium',7.5,22.5,'Protein',8),
('R206','ING130',3.0,'ml','1 tbsp Lime Juice',2.0,4.0,'Carb',9),
('R206','ING023',30.0,'g','2 tbsp Olive Oil',15.0,45.0,'Fat',10),
('R206','ING009',30.0,'g','2 tbsp Peanut Butter, wholegrain',15.0,45.0,'Fat',11),
('R206','ING085',2.0,'g','1 tsp Cayenne Pepper',1.0,3.0,'Carb',12),
('R206','ING042',190.0,'g','190g Basmati Rice, uncooked',95.0,285.0,'Carb',13),
('R207','ING120',150.0,'g','150g Lamb Chops',75.0,225.0,'Protein',1),
('R207','ING201',200.0,'g','200g Sweet Potato, peeled and cubed',100.0,300.0,'Carb',2),
('R207','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',3),
('R207','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',4),
('R207','ING085',1.0,'g','1/2 tsp Ground Cinnamon',0.5,1.5,'Carb',5),
('R207','ING085',1.0,'g','1/2 tsp Ground Cumin',0.5,1.5,'Carb',6),
('R207','ING085',1.0,'g','1/2 tsp Smoked Paprika',0.5,1.5,'Carb',7),
('R207','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',8),
('R207','ING030',15.0,'g','1 tbsp Greek Yogurt',7.5,22.5,'Protein',9),
('R207','ING109',100.0,'g','1 cup Steamed Green Beans',50.0,150.0,'Carb',10),
('R208','ING182',150.0,'g','1 Salmon Fillet',75.0,225.0,'Protein',1),
('R208','ING042',30.0,'g','Jasmine or Basmati Rice, uncooked',15.0,45.0,'Carb',2),
('R208','ING132',15.0,'ml','Light Coconut Milk',7.5,22.5,'Fat',3),
('R208','ING171',150.0,'g','Mixed Vegetables',75.0,225.0,'Carb',4),
('R208','ING187',5.0,'g','1 tsp Sesame Oil, for stir-frying',2.5,7.5,'Fat',5),
('R208','ING192',5.0,'ml','1 tsp Soy Sauce, for glaze',2.5,7.5,'Protein',6),
('R208','ING011',5.0,'g','1 tsp Honey',2.5,7.5,'Carb',7),
('R208','ING098',1.0,'g','1/2 tsp Fresh Ginger, grated',null,2.0,'Carb',8),
('R208','ING104',1.0,'each','1 small Garlic Clove, minced',null,2.0,'Carb',9),
('R208','ING177',5.0,'ml','1 tsp Rice Vinegar',2.5,7.5,'Carb',10),
('R208','ING188',1.0,'g','1/2 tsp Sesame Seeds, for garnish',0.5,1.5,'Fat',11),
('R208','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',12),
('R208','ING134',0.25,'each','1 Lime Wedge, for serving',null,1.25,'Carb',13),
('R209','ING120',150.0,'g','1 Lamb Steak',75.0,225.0,'Protein',1),
('R209','ING167',100.0,'g','100g Potatoes, cut into wedges',50.0,150.0,'Carb',2),
('R209','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',3),
('R209','ING104',1.0,'each','1 clove Garlic, minced',null,2.0,'Carb',4),
('R209','ING085',2.0,'g','1 tsp Mixed Dried Herbs',1.0,3.0,'Carb',5),
('R209','ING171',75.0,'g','1/2 cup Mixed Roasted Vegetables',37.5,112.5,'Carb',6),
('R209','ING109',75.0,'g','1/2 cup Steamed Green Vegetables',37.5,112.5,'Carb',7),
('R209','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',8),
('R209','ING129',0.25,'each','Lemon Wedge, for serving',null,1.25,'Carb',9),
('R210','ING201',200.0,'g','1 medium Sweet Potato, washed and cut into wedges',100.0,300.0,'Carb',1),
('R210','ING023',22.5,'g','1.5 tbsp Olive Oil',11.25,33.75,'Fat',2),
('R210','ING085',1.0,'g','1/2 tsp Chilli Flakes',0.5,1.5,'Carb',3),
('R210','ING130',2.0,'ml','3/4 tbsp Lemon Juice',1.0,3.0,'Carb',4),
('R210','ING184',1.0,'g','1/2 tsp Black Pepper',0.5,1.5,'Carb',5),
('R210','ING184',1.0,'g','1/4 tsp Salt',0.5,1.5,'Carb',6),
('R210','ING182',150.0,'g','1 Salmon Fillet',75.0,225.0,'Protein',7),
('R210','ING171',125.0,'g','100-150g Mixed Vegetables',62.5,187.5,'Carb',8),
('R211','ING062',160.0,'g','1 large Chicken Breast',80.0,240.0,'Protein',1),
('R211','ING077',50.0,'g','50g Cous Cous, uncooked',25.0,75.0,'Carb',2),
('R211','ING085',3.0,'g','Jamaican Jerk Seasoning',1.5,4.5,'Carb',3),
('R211','ING076',100.0,'g','1/2 Courgette',50.0,150.0,'Carb',4),
('R212','ING127',500.0,'g','500g Mince Lamb',250.0,750.0,'Protein',1),
('R212','ING155',400.0,'g','1 can Chopped Tomatoes',200.0,600.0,'Carb',2),
('R212','ING173',100.0,'g','1 Red Onion',50.0,150.0,'Carb',3),
('R212','ING099',15.0,'g','1/2 cup Chopped Parsley',7.5,22.5,'Carb',4),
('R212','ING130',2.0,'ml','1/2 Lemon, juice',1.0,3.0,'Carb',5),
('R212','ING099',15.0,'g','1 cup Fresh Coriander',7.5,22.5,'Carb',6),
('R212','ING104',2.0,'each','2 Garlic Cloves',1.0,3.0,'Carb',7),
('R212','ING085',7.0,'g','1 tbsp Paprika',3.5,10.5,'Carb',8),
('R212','ING085',7.0,'g','1 tbsp Ground Cumin',3.5,10.5,'Carb',9),
('R212','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',10),
('R212','ING085',4.0,'g','2 tsp Chilli Flakes',2.0,6.0,'Carb',11),
('R212','ING172',1.0,'each','1 Red Chilli',null,2.0,'Carb',12),
('R212','ING042',240.0,'g','240g Basmati Rice, dried',120.0,360.0,'Carb',13),
('R213','ING005',30.0,'g','1 scoop Vanilla Whey (batch tested)',15.0,45.0,'Protein',1),
('R213','ING004',100.0,'g','100g 0% Greek Yoghurt',50.0,150.0,'Protein',2),
('R213','ING020',0.33,'each','50g Avocado',null,1.33,'Fat',3),
('R213','ING193',20.0,'g','handful Spinach',10.0,30.0,'Protein',4),
('R213','ING211',100.0,'ml','100ml Unsweetened Almond Milk',50.0,150.0,'Fat',5),
('R213','ING085',1.0,'g','1/2 tsp Turmeric',0.5,1.5,'Carb',6),
('R213','ING029',1.0,'g','Ice cubes',null,2.0,'Carb',7),
('R214','ING005',30.0,'g','1 scoop Chocolate Whey (batch tested)',15.0,45.0,'Protein',1),
('R214','ING004',100.0,'g','100g 0% Greek Yoghurt',50.0,150.0,'Protein',2),
('R214','ING009',15.0,'g','1 tbsp Natural Smooth Peanut Butter',7.5,22.5,'Fat',3),
('R214','ING013',3.0,'g','1 tsp Unsweetened Cocoa Powder',1.5,4.5,'Carb',4),
('R214','ING211',100.0,'ml','100ml Unsweetened Almond Milk',50.0,150.0,'Fat',5),
('R214','ING029',1.0,'g','Ice cubes',null,2.0,'Carb',6),
('R215','ING005',30.0,'g','1 scoop Vanilla Whey (batch tested)',15.0,45.0,'Protein',1),
('R215','ING004',100.0,'g','100g 0% Greek Yoghurt',50.0,150.0,'Protein',2),
('R215','ING003',50.0,'g','50g Frozen Raspberries',25.0,75.0,'Carb',3),
('R215','ING211',100.0,'ml','100ml Unsweetened Almond Milk',50.0,150.0,'Fat',4),
('R215','ING010',15.0,'g','1 tbsp Chia Seeds',7.5,22.5,'Carb',5),
('R215','ING029',1.0,'g','Ice cubes',null,2.0,'Carb',6),
('R216','ING182',150.0,'g','1 Salmon Fillet, raw',75.0,225.0,'Protein',1),
('R216','ING077',50.0,'g','50g Cous Cous, dry',25.0,75.0,'Carb',2),
('R216','ING179',15.0,'g','1 handful Rocket',7.5,22.5,'Protein',3),
('R216','ING002',40.0,'g','1 handful Blueberries',20.0,60.0,'Carb',4),
('R216','ING099',15.0,'g','1 tbsp Fresh Mint, chopped',7.5,22.5,'Carb',5),
('R216','ING172',0.5,'each','1/2 Chilli, diced & deseeded',null,1.5,'Carb',6),
('R216','ING130',2.0,'ml','1/2 Lime, juice',1.0,3.0,'Carb',7),
('R216','ING023',5.0,'g','1 tsp Extra Virgin Olive Oil',2.5,7.5,'Fat',8),
('R216','ING039',7.5,'ml','1/2 tbsp Balsamic Glaze',3.75,11.25,'Carb',9),
('R217','ING149',100.0,'g','1 Onion, chopped',50.0,150.0,'Carb',1),
('R217','ING104',1.0,'each','1 Garlic Clove, crushed',null,2.0,'Carb',2),
('R217','ING227',250.0,'g','1/2 Butternut Squash, cubed',125.0,375.0,'Carb',3),
('R217','ING171',120.0,'g','1 Red Pepper, sliced',60.0,180.0,'Carb',4),
('R217','ING015',400.0,'g','1 Tin Chickpeas, drained',200.0,600.0,'Carb',5),
('R217','ING155',200.0,'g','1/2 Tin Chopped Tomatoes',100.0,300.0,'Carb',6),
('R217','ING226',180.0,'g','180g Quinoa, uncooked',90.0,270.0,'Carb',7),
('R217','ING197',360.0,'ml','1.5 cups Vegetable Stock',180.0,540.0,'Protein',8),
('R217','ING085',7.0,'g','1 tbsp Moroccan Spice Blend',3.5,10.5,'Carb',9),
('R217','ING228',40.0,'g','5 Dried Apricots, chopped',20.0,60.0,'Carb',10),
('R217','ING203',30.0,'g','2 tbsp Tahini',15.0,45.0,'Fat',11),
('R217','ING130',3.0,'ml','1 tbsp Lemon Juice',2.0,4.0,'Carb',12),
('R217','ING023',15.0,'g','1 tbsp Extra Virgin Olive Oil',7.5,22.5,'Fat',13),
('R217','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',14),
('R217','ING032',15.0,'g','1 handful Flaked Almonds',7.5,22.5,'Fat',15),
('R218','ING008',30.0,'g','30g Rolled Oats',15.0,45.0,'Carb',1),
('R218','ING006',100.0,'ml','100ml Semi-Skimmed Milk',50.0,150.0,'Carb',2),
('R218','ING004',100.0,'g','100g 0% Greek Yogurt',50.0,150.0,'Protein',3),
('R218','ING010',10.0,'g','10g Chia Seeds',5.0,15.0,'Carb',4),
('R218','ING009',10.0,'g','10g Peanut Butter',5.0,15.0,'Fat',5),
('R218','ING142',40.0,'g','40g Mixed Berries, fresh or frozen',20.0,60.0,'Carb',6),
('R218','ING014',1.0,'g','1/2 tsp Vanilla Extract',0.5,1.5,'Carb',7),
('R218','ING085',1.0,'g','1/2 tsp Cinnamon',0.5,1.5,'Carb',8),
('R219','ING032',15.0,'g','12 Almonds',7.5,22.5,'Fat',1),
('R219','ING142',60.0,'g','4 tbsp Mixed Berries',30.0,90.0,'Carb',2),
('R219','ING008',20.0,'g','2 tbsp Oats',10.0,30.0,'Carb',3),
('R219','ING006',100.0,'ml','100ml Semi-Skimmed Milk',50.0,150.0,'Carb',4),
('R219','ING004',60.0,'g','4 tbsp 0% Greek Yoghurt',30.0,90.0,'Protein',5),
('R220','ING246',150.0,'ml','150ml Apple Juice',75.0,225.0,'Carb',1),
('R220','ING002',45.0,'g','3 tbsp Blueberries',22.5,67.5,'Carb',2),
('R220','ING193',20.0,'g','handful Kale & Spinach',10.0,30.0,'Protein',3),
('R220','ING003',30.0,'g','2 tbsp Raspberries',15.0,45.0,'Carb',4),
('R220','ING008',20.0,'g','2 tbsp Oats',10.0,30.0,'Carb',5),
('R220','ING006',100.0,'ml','100ml Semi-Skimmed Milk',50.0,150.0,'Carb',6),
('R220','ING004',60.0,'g','4 tbsp 0% Greek Yoghurt',30.0,90.0,'Protein',7),
('R221','ING001',1.0,'each','1 Medium Banana, ripe',null,2.0,'Carb',1),
('R221','ING008',40.0,'g','40g Oats',20.0,60.0,'Carb',2),
('R221','ING009',10.0,'g','1 dessert spoon Peanut Butter',5.0,15.0,'Fat',3),
('R221','ING006',100.0,'ml','100ml Semi-Skimmed Milk',50.0,150.0,'Carb',4),
('R221','ING004',60.0,'g','4 tbsp 0% Greek Yoghurt',30.0,90.0,'Protein',5),
('R222','ING233',3.0,'each','3 Weetabix Protein biscuits',2.0,4.0,'Carb',1),
('R222','ING006',250.0,'ml','250ml Full Fat Milk',125.0,375.0,'Carb',2),
('R222','ING001',1.0,'each','1 Banana',null,2.0,'Carb',3),
('R222','ING010',5.0,'g','1 tsp Chia Seeds',2.5,7.5,'Carb',4),
('R223','ING234',2.0,'each','2 High Protein Pancakes, M&S',1.0,3.0,'Carb',1),
('R223','ING004',100.0,'g','100g 0% Greek Yoghurt',50.0,150.0,'Protein',2),
('R223','ING001',1.0,'each','1 Banana',null,2.0,'Carb',3),
('R224','ING230',150.0,'g','150g White Fish (Haddock)',75.0,225.0,'Protein',1),
('R224','ING042',110.0,'g','White Rice, cooked (~277g / 110g dry)',55.0,165.0,'Carb',2),
('R224','ING089',75.0,'g','75g Edamame Beans, cooked',37.5,112.5,'Protein',3),
('R224','ING193',50.0,'g','50g Spinach, lightly sautéed',25.0,75.0,'Protein',4),
('R224','ING004',60.0,'g','60g Greek Yogurt, for the sauce',30.0,90.0,'Protein',5),
('R224','ING085',2.0,'g','1 tsp Turmeric',1.0,3.0,'Carb',6),
('R225','ING124',150.0,'g','150g Sirloin Steak, grilled',75.0,225.0,'Protein',1),
('R225','ING226',75.0,'g','Quinoa, cooked (~185g / 75g dry)',37.5,112.5,'Carb',2),
('R225','ING201',150.0,'g','150g Sweet Potatoes, roasted',75.0,225.0,'Carb',3),
('R225','ING050',100.0,'g','100g Broccoli, steamed',50.0,150.0,'Protein',4),
('R226','ING062',150.0,'g','150g Chicken Breast, grilled',75.0,225.0,'Protein',1),
('R226','ING042',75.0,'g','White Rice, cooked (~185g / 75g dry)',37.5,112.5,'Carb',2),
('R226','ING235',50.0,'g','50g Kimchi',25.0,75.0,'Carb',3),
('R226','ING193',50.0,'g','50g Spinach, steamed',25.0,75.0,'Protein',4),
('R226','ING112',15.0,'g','1 tbsp Gochujang Sauce',7.5,22.5,'Carb',5),
('R226','ING187',5.0,'g','1 tsp Sesame Oil',2.5,7.5,'Fat',6),
('R226','ING188',2.0,'g','1 tsp Sesame Seeds, to top',1.0,3.0,'Fat',7),
('R227','ING182',150.0,'g','150g Salmon, grilled',75.0,225.0,'Protein',1),
('R227','ING201',200.0,'g','200g Sweet Potatoes, roasted',100.0,300.0,'Carb',2),
('R227','ING245',100.0,'g','100g Beetroot, roasted',50.0,150.0,'Carb',3),
('R227','ING179',50.0,'g','50g Rocket, fresh',25.0,75.0,'Protein',4),
('R227','ING193',100.0,'g','100g Spinach, sautéed with garlic',50.0,150.0,'Protein',5),
('R227','ING104',1.0,'each','1 Garlic Clove',null,2.0,'Carb',6),
('R227','ING023',10.0,'g','2 tsp Olive Oil',5.0,15.0,'Fat',7),
('R227','ING048',1.0,'each','1 Whole-Grain Bread Roll',null,2.0,'Carb',8),
('R228','ING238',250.0,'g','250g Rhubarb, chopped',125.0,375.0,'Carb',1),
('R228','ING239',200.0,'g','200g Pears, peeled and diced',100.0,300.0,'Carb',2),
('R228','ING199',100.0,'g','100g Strawberries, hulled and halved',50.0,150.0,'Carb',3),
('R228','ING011',15.0,'g','1 tbsp Honey or Maple Syrup',7.5,22.5,'Carb',4),
('R228','ING014',2.0,'g','1 tsp Vanilla Extract, fruit base',1.0,3.0,'Carb',5),
('R228','ING075',8.0,'g','1 tbsp Cornflour, fruit base',4.0,12.0,'Carb',6),
('R228','ING008',50.0,'g','50g Rolled Oats',25.0,75.0,'Carb',7),
('R228','ING110',30.0,'g','30g Ground Almonds',15.0,45.0,'Fat',8),
('R228','ING096',10.0,'g','10g Ground Flaxseeds',5.0,15.0,'Fat',9),
('R228','ING051',15.0,'g','15g Light Brown Sugar',7.5,22.5,'Carb',10),
('R228','ING085',2.0,'g','1 tsp Cinnamon',1.0,3.0,'Carb',11),
('R228','ING030',30.0,'g','2 tbsp Low-Fat Greek Yogurt',15.0,45.0,'Protein',12),
('R228','ING191',200.0,'ml','200ml Skimmed Milk',100.0,300.0,'Carb',13),
('R228','ING014',2.0,'g','1 tsp Vanilla Extract, custard',1.0,3.0,'Carb',14),
('R228','ING075',8.0,'g','1 tbsp Cornflour, custard',4.0,12.0,'Carb',15),
('R228','ING090',2.0,'each','2 Egg Yolks',1.0,3.0,'Fat',16),
('R228','ING051',15.0,'g','1 tbsp Sugar',7.5,22.5,'Carb',17),
('R229','ING124',140.0,'g','Beef',70.0,210.0,'Protein',1),
('R229','ING210',50.0,'g','Udon Noodles, cooked (~100g / 50g dry)',25.0,75.0,'Carb',2),
('R229','ING042',35.0,'g','White Rice, cooked (~90g / 35g dry)',17.5,52.5,'Carb',3),
('R229','ING201',75.0,'g','Sweet Potatoes, cooked',37.5,112.5,'Carb',4),
('R229','ING171',25.0,'g','Bell Peppers',12.5,37.5,'Carb',5),
('R229','ING057',25.0,'g','Carrots',12.5,37.5,'Carb',6),
('R229','ING089',25.0,'g','Edamame',12.5,37.5,'Protein',7),
('R229','ING244',30.0,'ml','2 tbsp Teriyaki Sauce',15.0,45.0,'Carb',8),
('R229','ING192',15.0,'ml','1 tbsp Soy Sauce',7.5,22.5,'Protein',9),
('R229','ING187',5.0,'g','1 tsp Sesame Oil',2.5,7.5,'Fat',10),
('R229','ING020',0.5,'each','1/2 Avocado',null,1.5,'Fat',11),
('R229','ING010',15.0,'g','1 tbsp Chia Seeds',7.5,22.5,'Carb',12),
('R229','ING193',20.0,'g','Leafy Greens',10.0,30.0,'Protein',13),
('R230','ING062',150.0,'g','1 Chicken Breast, cut into strips',75.0,225.0,'Protein',1),
('R230','ING236',45.0,'g','Brown Rice, cooked (~1/2 cup / 45g dry)',22.5,67.5,'Carb',2),
('R230','ING171',150.0,'g','1 cup Mixed Colourful Vegetables',75.0,225.0,'Carb',3),
('R230','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',4),
('R230','ING192',15.0,'ml','1 tbsp Soy Sauce',7.5,22.5,'Protein',5),
('R230','ING187',5.0,'g','1 tsp Sesame Oil',2.5,7.5,'Fat',6),
('R230','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',7),
('R230','ING098',1.0,'g','1/2 tsp Grated Ginger',null,2.0,'Carb',8),
('R230','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',9),
('R231','ING128',100.0,'g','100g Turkey Breast, thinly sliced',50.0,150.0,'Protein',1),
('R231','ING018',2.0,'each','2 Eggs',1.0,3.0,'Protein',2),
('R231','ING241',60.0,'g','60g Dry Rice Noodles',40.0,120.0,'Carb',3),
('R231','ING171',150.0,'g','1 cup Colourful Vegetables (peppers, mangetout, mushrooms, carrots, broccoli)',75.0,225.0,'Carb',4),
('R231','ING104',2.0,'each','2 Garlic Cloves, minced',1.0,3.0,'Carb',5),
('R231','ING192',30.0,'ml','2 tbsp Soy Sauce',15.0,45.0,'Protein',6),
('R231','ING152',15.0,'g','1 tbsp Oyster Sauce',7.5,22.5,'Carb',7),
('R231','ING187',5.0,'g','1 tsp Sesame Oil',7.5,22.5,'Fat',8),
('R231','ING023',5.0,'g','1 tsp Olive Oil',7.5,22.5,'Fat',9),
('R231','ING085',1.0,'g','1/2 tsp Chilli Flakes',0.5,1.5,'Carb',10),
('R231','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',11),
('R232','ING062',150.0,'g','1 Chicken Breast',75.0,225.0,'Protein',1),
('R232','ING226',45.0,'g','Quinoa, cooked (~1/2 cup / 45g dry)',22.5,67.5,'Carb',2),
('R232','ING171',150.0,'g','1 cup Mixed Colourful Vegetables (peppers, broccoli, mushrooms, mangetout, carrots)',75.0,225.0,'Carb',3),
('R232','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',4),
('R232','ING085',1.0,'g','1/2 tsp Garlic Powder',0.5,1.5,'Carb',5),
('R232','ING085',1.0,'g','1/2 tsp Paprika',0.5,1.5,'Carb',6),
('R232','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',7),
('R233','ING209',145.0,'g','1 can Tuna in Spring Water, drained',72.5,217.5,'Protein',1),
('R233','ING143',30.0,'g','2 large Lettuce Leaves (Romaine or Baby Gem)',15.0,45.0,'Carb',2),
('R233','ING004',15.0,'g','1 tbsp 0% Greek Yogurt',7.5,22.5,'Protein',3),
('R233','ING173',15.0,'g','1 tbsp Red Onion, diced',7.5,22.5,'Carb',4),
('R233','ING060',15.0,'g','1 tbsp Celery, diced',7.5,22.5,'Carb',5),
('R233','ING099',15.0,'g','1 tbsp Fresh Parsley, chopped',7.5,22.5,'Carb',6),
('R233','ING084',5.0,'g','1 tsp Dijon Mustard',2.5,7.5,'Protein',7),
('R233','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',8),
('R234','ING008',160.0,'g','160g Porridge Oats',80.0,240.0,'Carb',1),
('R234','ING010',20.0,'g','20g Chia Seeds',10.0,30.0,'Carb',2),
('R234','ING006',250.0,'ml','250ml Semi-Skimmed Milk',125.0,375.0,'Carb',3),
('R234','ING004',200.0,'g','200g 0% Fat Greek Yoghurt',100.0,300.0,'Protein',4),
('R234','ING085',1.0,'g','1/2 tsp Ground Cinnamon',0.5,1.5,'Carb',5),
('R234','ING005',60.0,'g','60g Vanilla Whey (2 Scoops)',30.0,90.0,'Protein',6),
('R234','ING001',0.85,'each','100g Banana',null,1.85,'Carb',7),
('R234','ING002',80.0,'g','80g Blueberries, fresh or frozen',40.0,120.0,'Carb',8),
('R234','ING232',24.0,'g','24g Goji Berries, dried',12.0,36.0,'Carb',9),
('R235','ING082',100.0,'g','100g 70% Dark Chocolate',50.0,150.0,'Carb',1),
('R235','ING229',100.0,'g','100g Mixed Nuts',50.0,150.0,'Fat',2),
('R235','ING011',45.0,'g','3 tbsp Honey',22.5,67.5,'Carb',3),
('R235','ING232',9.0,'g','3 tsp Goji Berries',4.5,13.5,'Carb',4),
('R236','ING062',150.0,'g','150g Chicken Breast, diced',75.0,225.0,'Protein',1),
('R236','ING015',80.0,'g','80g Chickpeas, canned, drained',40.0,120.0,'Carb',2),
('R236','ING155',120.0,'g','120g Chopped Tomatoes',60.0,180.0,'Carb',3),
('R236','ING132',60.0,'ml','60ml Light Coconut Milk',30.0,90.0,'Fat',4),
('R236','ING149',50.0,'g','50g Onion, diced',25.0,75.0,'Carb',5),
('R236','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',6),
('R236','ING098',1.0,'g','1/2 tsp Grated Ginger',null,2.0,'Carb',7),
('R236','ING081',3.0,'g','1 tsp Curry Powder',1.5,4.5,'Carb',8),
('R236','ING085',1.0,'g','1/2 tsp Ground Cumin',0.5,1.5,'Carb',9),
('R236','ING023',15.0,'g','1 tbsp Olive Oil',7.5,22.5,'Fat',10),
('R236','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',11),
('R236','ING042',30.0,'g','Basmati Rice, cooked (~1/2 cup / 30g dry)',15.0,45.0,'Carb',12),
('R237','ING156',70.0,'g','70g Spaghetti, dry',35.0,105.0,'Carb',1),
('R237','ING062',100.0,'g','100g Chicken Breast, cooked',50.0,150.0,'Protein',2),
('R237','ING090',1.0,'each','1 large Egg Yolk',null,2.0,'Fat',3),
('R237','ING154',15.0,'g','15g Parmesan Cheese, grated',7.5,22.5,'Protein',4),
('R237','ING240',30.0,'ml','30g Light Cream (15% fat)',15.0,45.0,'Fat',5),
('R237','ING023',5.0,'g','5g Olive Oil',2.5,7.5,'Fat',6),
('R237','ING102',40.0,'g','40g Peas, cooked',20.0,60.0,'Carb',7),
('R237','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',8),
('R238','ING062',150.0,'g','150g Chicken Breast, diced',75.0,225.0,'Protein',1),
('R238','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',2),
('R238','ING149',50.0,'g','1/2 Onion, finely chopped',25.0,75.0,'Carb',3),
('R238','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',4),
('R238','ING145',100.0,'g','100g Chestnut Mushrooms, sliced',50.0,150.0,'Protein',5),
('R238','ING085',1.0,'g','1/2 tsp Smoked Paprika',0.5,1.5,'Carb',6),
('R238','ING085',1.0,'g','1/2 tsp Dried Thyme',0.5,1.5,'Carb',7),
('R238','ING084',3.0,'g','1/2 tsp Dijon Mustard',1.5,4.5,'Protein',8),
('R238','ING030',100.0,'g','100g Low-Fat Greek Yoghurt',50.0,150.0,'Protein',9),
('R238','ING197',100.0,'ml','100ml Chicken Stock',50.0,150.0,'Protein',10),
('R238','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',11),
('R238','ING042',70.0,'g','70g White Rice, dry weight',35.0,105.0,'Carb',12),
('R238','ING099',15.0,'g','1 tbsp Fresh Parsley, chopped',7.5,22.5,'Carb',13),
('R239','ING156',100.0,'g','100g Linguini, dried weight',50.0,150.0,'Carb',1),
('R239','ING062',100.0,'g','100g Chicken Breast, sliced',50.0,150.0,'Protein',2),
('R239','ING023',15.0,'g','1 tbsp Olive Oil',7.5,22.5,'Fat',3),
('R239','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',4),
('R239','ING154',15.0,'g','15g Parmesan Cheese, grated',7.5,22.5,'Protein',5),
('R239','ING240',30.0,'ml','30ml Cream',15.0,45.0,'Fat',6),
('R239','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',7),
('R240','ING018',4.0,'each','4 large Eggs',3.0,5.0,'Protein',1),
('R240','ING211',50.0,'ml','50ml Unsweetened Almond Milk',25.0,75.0,'Fat',2),
('R240','ING139',30.0,'g','30g Shredded Cheese (Cheddar)',15.0,45.0,'Fat',3),
('R240','ING193',50.0,'g','50g Fresh Spinach, chopped',25.0,75.0,'Protein',4),
('R240','ING184',1.0,'g','1/4 tsp Salt',0.5,1.5,'Carb',5),
('R240','ING184',1.0,'g','1/4 tsp Black Pepper',0.5,1.5,'Carb',6),
('R240','ING085',1.0,'g','1/4 tsp Garlic Powder',0.5,1.5,'Carb',7),
('R240','ING023',2.0,'g','1/2 tsp Olive Oil, for greasing',1.0,3.0,'Fat',8),
('R241','ING219',150.0,'g','1 Tilapia Fillet',75.0,225.0,'Protein',1),
('R241','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',2),
('R241','ING173',40.0,'g','1/2 small Red Onion, sliced',20.0,60.0,'Carb',3),
('R241','ING171',75.0,'g','1/2 Red Bell Pepper, sliced',37.5,112.5,'Carb',4),
('R241','ING171',75.0,'g','1/2 Yellow Bell Pepper, sliced',37.5,112.5,'Carb',5),
('R241','ING076',75.0,'g','1/2 small Courgette, sliced',37.5,112.5,'Carb',6),
('R241','ING085',1.0,'g','1/2 tsp Dried Oregano',0.5,1.5,'Carb',7),
('R241','ING085',1.0,'g','1/2 tsp Dried Basil',0.5,1.5,'Carb',8),
('R241','ING085',1.0,'g','1/2 tsp Smoked Paprika',0.5,1.5,'Carb',9),
('R241','ING130',1.0,'ml','1/2 tsp Lemon Juice',null,2.0,'Carb',10),
('R241','ING155',200.0,'g','200g Chopped Tomatoes, tinned',100.0,300.0,'Carb',11),
('R241','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',12),
('R241','ING039',3.0,'ml','1/2 tsp Balsamic Vinegar',1.5,4.5,'Carb',13),
('R241','ING085',1.0,'g','1/2 tsp Chilli Flakes',0.5,1.5,'Carb',14),
('R241','ING201',110.0,'g','110g Sweet Potato, peeled and diced',55.0,165.0,'Carb',15),
('R241','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',16),
('R242','ING231',150.0,'g','1 Mackerel Fillet',75.0,225.0,'Protein',1),
('R242','ING023',5.0,'g','1 tsp Extra Virgin Olive Oil',2.5,7.5,'Fat',2),
('R242','ING130',2.0,'ml','1/2 Lemon, juiced',1.0,3.0,'Carb',3),
('R242','ING143',60.0,'g','2 cups Mixed Salad Leaves',30.0,90.0,'Carb',4),
('R242','ING020',0.5,'each','1/2 Avocado, diced',null,1.5,'Fat',5),
('R242','ING171',30.0,'g','1/4 Red Pepper, thinly sliced',15.0,45.0,'Carb',6),
('R242','ING080',30.0,'g','Cucumber, a few slices',15.0,45.0,'Carb',7),
('R242','ING173',15.0,'g','Red Onion, 2-3 thin slices (optional)',7.5,22.5,'Carb',8),
('R242','ING098',2.0,'g','1 tsp Fresh Ginger, grated',1.0,3.0,'Carb',9),
('R242','ING085',1.0,'g','1/4 tsp Turmeric Powder',0.5,1.5,'Carb',10),
('R242','ING067',5.0,'ml','1 tsp Apple Cider Vinegar',2.5,7.5,'Carb',11),
('R242','ING023',5.0,'g','1 tsp Extra Virgin Olive Oil, for dressing',2.5,7.5,'Fat',12),
('R242','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',13),
('R243','ING167',300.0,'g','300g Baby Potatoes, sliced into wedges',150.0,450.0,'Carb',1),
('R243','ING023',15.0,'g','1 tbsp Olive Oil, for wedges',7.5,22.5,'Fat',2),
('R243','ING085',1.0,'g','1/2 tsp Paprika',0.5,1.5,'Carb',3),
('R243','ING085',1.0,'g','1/2 tsp Garlic Powder',0.5,1.5,'Carb',4),
('R243','ING024',1.0,'g','1/4 tsp Salt & Black Pepper',0.5,1.5,'Carb',5),
('R243','ING182',135.0,'g','1 Salmon fillet (120-150g)',67.5,202.5,'Protein',6),
('R243','ING098',8.0,'g','1 tbsp Fresh Ginger, grated',7.0,9.0,'Carb',7),
('R243','ING104',2.0,'each','2 Garlic Cloves, minced',1.0,3.0,'Carb',8),
('R243','ING192',15.0,'ml','1 tbsp Soy Sauce',7.5,22.5,'Protein',9),
('R243','ING011',5.0,'g','1 tsp Honey',2.5,7.5,'Carb',10),
('R243','ING130',3.0,'ml','1 tbsp Lemon Juice',2.0,4.0,'Carb',11),
('R243','ING023',7.5,'g','1/2 tbsp Olive Oil, for salmon',3.75,11.25,'Fat',12),
('R243','ING188',1.0,'g','1/2 tsp Sesame Seeds',0.5,1.5,'Fat',13),
('R243','ING193',60.0,'g','2 cups Spinach or Kale',30.0,90.0,'Protein',14),
('R243','ING023',5.0,'g','1 tsp Olive Oil, for greens',2.5,7.5,'Fat',15),
('R243','ING104',1.0,'each','1 Garlic Clove, minced, for greens',null,2.0,'Carb',16),
('R243','ING130',1.0,'ml','1 tsp Lemon Juice, for greens',null,2.0,'Carb',17),
('R243','ING024',1.0,'g','1 pinch Salt & Pepper, for greens',0.5,1.5,'Carb',18),
('R244','ING120',150.0,'g','1 Lamb Chop',75.0,225.0,'Protein',1),
('R244','ING023',5.0,'g','1 tsp Olive Oil, for lamb',2.5,7.5,'Fat',2),
('R244','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',3),
('R244','ING085',1.0,'g','1/2 tsp Dried Rosemary',0.5,1.5,'Carb',4),
('R244','ING130',2.0,'ml','1/2 Lemon, juiced',1.0,3.0,'Carb',5),
('R244','ING201',100.0,'g','100g Sweet Potato, peeled and cut into wedges',50.0,150.0,'Carb',6),
('R244','ING023',2.0,'g','1/2 tsp Olive Oil, for sweet potato',1.0,3.0,'Fat',7),
('R244','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',8),
('R244','ING171',50.0,'g','50g Red Bell Pepper, deseeded and sliced',25.0,75.0,'Carb',9),
('R244','ING050',50.0,'g','50g Broccoli Florets',25.0,75.0,'Protein',10),
('R244','ING023',2.0,'g','1/2 tsp Olive Oil, for veggies',1.0,3.0,'Fat',11),
('R245','ING219',200.0,'g','Cod Fillet, grilled',100.0,300.0,'Protein',1),
('R245','ING054',15.0,'g','1 tbsp Butter',7.5,22.5,'Fat',2),
('R245','ING050',100.0,'g','100g Steamed Broccoli & Carrots',50.0,150.0,'Protein',3),
('R245','ING226',40.0,'g','Quinoa, cooked (~100g / 40g dry)',20.0,60.0,'Carb',4),
('R245','ING023',15.0,'g','1 tbsp Olive Oil',7.5,22.5,'Fat',5),
('R246','ING006',100.0,'ml','100ml Semi-Skimmed Milk',50.0,150.0,'Carb',1),
('R246','ING001',1.0,'each','1 Medium Banana',null,2.0,'Carb',2),
('R246','ING008',30.0,'g','30g Oats',15.0,45.0,'Carb',3),
('R246','ING091',50.0,'g','50g Fat Free Skyr Yogurt',25.0,75.0,'Protein',4),
('R246','ING009',25.0,'g','25g Peanut Butter',12.5,37.5,'Fat',5),
('R246','ING010',15.0,'g','1 tbsp Chia Seeds',7.5,22.5,'Carb',6),
('R247','ING047',240.0,'g','1 can Black Beans, drained',120.0,360.0,'Carb',1),
('R247','ING062',300.0,'g','2 Chicken Breasts',150.0,450.0,'Protein',2),
('R247','ING202',165.0,'g','1 tin Sweetcorn, drained',82.5,247.5,'Carb',3),
('R247','ING171',120.0,'g','1 Red Pepper',60.0,180.0,'Carb',4),
('R247','ING097',2.0,'each','2 Tortillas',1.0,3.0,'Carb',5),
('R247','ING175',20.0,'g','20g Low Fat Cheddar Cheese',10.0,30.0,'Protein',6),
('R247','ING134',0.25,'each','1 Lime Wedge',null,1.25,'Carb',7),
('R247','ING172',1.0,'each','1 Red Chilli',null,2.0,'Carb',8),
('R247','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',9),
('R247','ING085',2.0,'g','1 tsp Ground Cumin',1.0,3.0,'Carb',10),
('R247','ING085',2.0,'g','1 tsp Paprika',1.0,3.0,'Carb',11),
('R247','ING085',2.0,'g','1 tsp Oregano',1.0,3.0,'Carb',12),
('R248','ING062',300.0,'g','300g Chicken Breast',150.0,450.0,'Protein',1),
('R248','ING042',200.0,'g','200g White Basmati Rice, raw',100.0,300.0,'Carb',2),
('R248','ING050',300.0,'g','2 Broccoli heads',150.0,450.0,'Protein',3),
('R248','ING047',120.0,'g','1/2 can Black Beans, drained',60.0,180.0,'Carb',4),
('R248','ING073',1.0,'each','1 Corn on the Cob',null,2.0,'Carb',5),
('R248','ING134',1.0,'each','1 Lime',null,2.0,'Carb',6),
('R248','ING195',15.0,'g','1 tbsp Sriracha Seasoning',7.5,22.5,'Carb',7),
('R249','ING018',2.0,'each','2 Eggs',1.0,3.0,'Protein',1),
('R249','ING006',20.0,'ml','20ml Semi-Skimmed Milk',10.0,30.0,'Carb',2),
('R249','ING020',0.5,'each','1/2 Avocado',null,1.5,'Fat',3),
('R249','ING021',1.0,'each','1 slice Sourdough Toast',null,2.0,'Carb',4),
('R249','ING022',2.0,'each','2 slices Smoked Salmon',1.0,3.0,'Protein',5),
('R249','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',6),
('R249','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',7),
('R250','ING231',75.0,'g','1 Smoked Mackerel fillet',37.5,112.5,'Protein',1),
('R250','ING209',72.0,'g','1/2 can Tuna, in brine or spring water',36.0,108.0,'Protein',2),
('R250','ING173',50.0,'g','1/2 Red Onion',25.0,75.0,'Carb',3),
('R250','ING018',1.0,'each','1 medium Egg',null,2.0,'Protein',4),
('R250','ING221',1.0,'each','small slice Seeded Bread',null,2.0,'Carb',5),
('R250','ING237',7.5,'g','1/2 tbsp Reduced Fat Cottage Cheese',3.75,11.25,'Protein',6),
('R250','ING195',7.5,'g','1/2 tbsp Red Pepper Sauce',3.75,11.25,'Carb',7),
('R250','ING213',7.5,'g','1/2 tbsp Vegetable Oil',3.75,11.25,'Fat',8),
('R250','ING099',15.0,'g','1/2 cup fresh Coriander',7.5,22.5,'Carb',9),
('R250','ING084',2.5,'g','1/2 tsp Smooth Mustard',1.25,3.75,'Protein',10),
('R250','ING184',1.0,'g','1 pinch Black Pepper',0.5,1.5,'Carb',11),
('R250','ING143',50.0,'g','Colourful salad of your choice',25.0,75.0,'Carb',12),
('R251','ING062',150.0,'g','150g Chicken Breast, shredded',75.0,225.0,'Protein',1),
('R251','ING197',300.0,'ml','300ml Bone Broth',150.0,450.0,'Protein',2),
('R251','ING057',34.0,'g','Carrots',17.0,51.0,'Carb',3),
('R251','ING060',33.0,'g','Celery',16.5,49.5,'Carb',4),
('R251','ING149',33.0,'g','Onion',16.5,49.5,'Carb',5),
('R251','ING226',30.0,'g','30g Quinoa',15.0,45.0,'Carb',6),
('R252','ING182',150.0,'g','1 Salmon fillet',75.0,225.0,'Protein',1),
('R252','ING023',5.0,'g','1 tsp Extra Virgin Olive Oil',2.5,7.5,'Fat',2),
('R252','ING085',1.0,'g','1/2 tsp Paprika',0.5,1.5,'Carb',3),
('R252','ING085',1.0,'g','1/2 tsp Garlic Powder',0.5,1.5,'Carb',4),
('R252','ING130',2.0,'ml','1/2 Lemon, juiced',1.0,3.0,'Carb',5),
('R252','ING020',0.33,'each','50g ripe Avocado, diced',null,1.33,'Fat',6),
('R252','ING173',25.0,'g','25g Red Onion, finely chopped',12.5,37.5,'Carb',7),
('R252','ING205',50.0,'g','50g Tomato, deseeded and diced',25.0,75.0,'Carb',8),
('R252','ING099',10.0,'g','fresh Coriander leaves, a few',5.0,15.0,'Carb',9),
('R252','ING130',2.0,'ml','1/2 Lime, juiced',1.0,3.0,'Carb',10),
('R252','ING024',1.0,'g','1 pinch Salt & Pepper (salsa)',0.5,1.5,'Carb',11),
('R252','ING059',150.0,'g','150g Cauliflower Rice',75.0,225.0,'Carb',12),
('R252','ING023',5.0,'g','1 tsp Olive Oil or Coconut Oil',2.5,7.5,'Fat',13),
('R252','ING104',1.0,'each','1 small Garlic Clove, minced',null,2.0,'Carb',14),
('R252','ING024',1.0,'g','1 pinch Salt & Pepper (cauliflower rice)',0.5,1.5,'Carb',15),
('R253','ING120',150.0,'g','1 Lamb Chop',75.0,225.0,'Protein',1),
('R253','ING023',5.0,'g','1 tsp Olive Oil, for lamb',2.5,7.5,'Fat',2),
('R253','ING104',1.0,'each','1 Garlic Clove, minced',null,2.0,'Carb',3),
('R253','ING085',2.0,'g','1 tsp Dried Mixed Herbs (or fresh rosemary)',1.0,3.0,'Carb',4),
('R253','ING130',2.0,'ml','1/2 Lemon, juiced',1.0,3.0,'Carb',5),
('R253','ING057',50.0,'g','50g Carrots, peeled and sliced',25.0,75.0,'Carb',6),
('R253','ING109',50.0,'g','50g Green Beans, trimmed',25.0,75.0,'Carb',7),
('R253','ING023',5.0,'g','1 tsp Olive Oil, for veg',2.5,7.5,'Fat',8),
('R253','ING167',100.0,'g','100g New/Baby Potatoes, halved or quartered',50.0,150.0,'Carb',9),
('R253','ING023',5.0,'g','1 tsp Olive Oil, for potatoes',2.5,7.5,'Fat',10);
insert into ri_stage values
('R253','ING024',1.0,'g','1 pinch Salt & Pepper',0.5,1.5,'Carb',11),
('R254','ING062',150.0,'g','150g Chicken Breast, sliced',75.0,225.0,'Protein',1),
('R254','ING171',120.0,'g','1 medium Red Bell Pepper',60.0,180.0,'Carb',2),
('R254','ING171',120.0,'g','1 medium Green Bell Pepper',60.0,180.0,'Carb',3),
('R254','ING149',70.0,'g','1 small Onion',35.0,105.0,'Carb',4),
('R254','ING121',1.0,'each','1 large Flour Tortilla',null,2.0,'Carb',5),
('R254','ING023',15.0,'g','1 tbsp Olive Oil',7.5,22.5,'Fat',6),
('R254','ING081',3.0,'g','1 tsp Fajita Seasoning',1.5,4.5,'Carb',7),
('R254','ING101',15.0,'g','1 tbsp Salsa',7.5,22.5,'Carb',8),
('R254','ING030',15.0,'g','1 tbsp Low-Fat Greek Yogurt or Guacamole',7.5,22.5,'Protein',9),
('R255','ING123',500.0,'g','500g Extra Lean Beef Mince',250.0,750.0,'Protein',1),
('R255','ING156',400.0,'g','400g Spaghetti, dried',200.0,600.0,'Carb',2),
('R255','ING155',400.0,'g','1 tin Chopped Tomatoes',200.0,600.0,'Carb',3),
('R255','ING149',100.0,'g','1 Onion',50.0,150.0,'Carb',4),
('R255','ING171',160.0,'g','2 whole Roasted Red Peppers',80.0,240.0,'Carb',5),
('R255','ING099',8.0,'g','4 sprigs Fresh Basil',4.0,12.0,'Carb',6),
('R255','ING206',15.0,'g','1 tbsp Tomato Puree',7.5,22.5,'Carb',7),
('R255','ING104',2.0,'each','2 Cloves Garlic',1.0,3.0,'Carb',8),
('R255','ING084',5.0,'g','1 tsp Smooth Mustard',2.5,7.5,'Protein',9),
('R255','ING023',5.0,'g','1 tsp Olive Oil',2.5,7.5,'Fat',10),
('R255','ING184',2.0,'g','1 tsp Black Pepper',1.0,3.0,'Carb',11),
('R256','ING231',75.0,'g','1 Smoked Mackerel fillet',37.5,112.5,'Protein',1),
('R256','ING209',72.0,'g','1/2 can Tuna, in brine or spring water',36.0,108.0,'Protein',2),
('R256','ING173',50.0,'g','1/2 Red Onion',25.0,75.0,'Carb',3),
('R256','ING018',1.0,'each','1 medium Egg',null,2.0,'Protein',4),
('R256','ING221',1.0,'each','small slice Seeded Bread',null,2.0,'Carb',5),
('R256','ING237',7.5,'g','1/2 tbsp Reduced Fat Cottage Cheese',3.75,11.25,'Protein',6),
('R256','ING195',7.5,'g','1/2 tbsp Red Pepper Sauce',3.75,11.25,'Carb',7),
('R256','ING213',7.5,'g','1/2 tbsp Vegetable Oil',3.75,11.25,'Fat',8),
('R256','ING099',15.0,'g','1/2 cup fresh Coriander',7.5,22.5,'Carb',9),
('R256','ING084',2.5,'g','1/2 tsp Smooth Mustard',1.25,3.75,'Protein',10),
('R256','ING184',1.0,'g','1 pinch Black Pepper',0.5,1.5,'Carb',11),
('R256','ING143',50.0,'g','Colourful salad of your choice',25.0,75.0,'Carb',12),
('R257','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',1),
('R257','ING142',45.0,'g','3 tablespoons mixed berries',22.5,67.5,'Carb',2),
('R257','ING005',30.0,'g','1 scoop vanilla whey protein',15.0,45.0,'Protein',3),
('R257','ING008',15.0,'g','1 tablespoon oats',7.5,22.5,'Carb',4),
('R257','ING029',6.0,'g','6 chunks ice',5.0,7.0,'Carb',5),
('R258','ING246',150.0,'ml','150ml apple juice',75.0,225.0,'Carb',1),
('R258','ING005',30.0,'g','1 scoop chocolate whey protein',15.0,45.0,'Protein',2),
('R258','ING004',30.0,'g','2 tablespoons Greek Yoghurt',15.0,45.0,'Protein',3),
('R258','ING142',45.0,'g','3 tablespoons berries',22.5,67.5,'Carb',4),
('R259','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',1),
('R259','ING005',30.0,'g','1 scoop chocolate whey protein',15.0,45.0,'Protein',2),
('R259','ING239',170.0,'g','1 medium pear',85.0,255.0,'Carb',3),
('R259','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',4),
('R259','ING007',10.0,'g','1 dessert spoon Wyldsson nut butter (hazelnut & cocoa)',5.0,15.0,'Fat',5),
('R259','ING004',30.0,'g','2 tablespoons Greek Yoghurt',15.0,45.0,'Protein',6),
('R260','ING002',45.0,'g','3 tablespoons blueberries',22.5,67.5,'Carb',1),
('R260','ING003',45.0,'g','3 tablespoons raspberries',22.5,67.5,'Carb',2),
('R260','ING004',30.0,'g','2 tablespoons Greek yoghurt',15.0,45.0,'Protein',3),
('R260','ING005',30.0,'g','1 scoop vanilla whey protein',15.0,45.0,'Protein',4),
('R260','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',5),
('R260','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',6),
('R261','ING032',15.0,'g','1 tablespoon almonds',7.5,22.5,'Fat',1),
('R261','ING169',15.0,'g','1 tablespoon raisins',7.5,22.5,'Carb',2),
('R261','ING085',1.0,'g','¼ teaspoon ground cinnamon',0.5,1.5,'Carb',3),
('R261','ING199',75.0,'g','5 large strawberries',37.5,112.5,'Carb',4),
('R261','ING005',30.0,'g','1 scoop strawberry whey protein',15.0,45.0,'Protein',5),
('R261','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',6),
('R261','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',7),
('R262','ING002',30.0,'g','2 tablespoons blueberries',15.0,45.0,'Carb',1),
('R262','ING199',45.0,'g','3 large strawberries',22.5,67.5,'Carb',2),
('R262','ING004',30.0,'g','2 tablespoons Greek Yoghurt',15.0,45.0,'Protein',3),
('R262','ING193',30.0,'g','1 decent handful spinach',15.0,45.0,'Protein',4),
('R262','ING098',2.0,'g','Small piece of ginger',1.0,3.0,'Carb',5),
('R262','ING011',10.0,'g','2 teaspoons honey',5.0,15.0,'Carb',6),
('R262','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',7),
('R263','ING001',1.0,'each','1 medium banana',null,2.0,'Carb',1),
('R263','ING004',15.0,'g','1 tablespoon Greek Yoghurt',7.5,22.5,'Protein',2),
('R263','ING007',10.0,'g','1 dessert spoon Wyldsson nut butter',5.0,15.0,'Fat',3),
('R263','ING005',30.0,'g','1 scoop vanilla whey protein',15.0,45.0,'Protein',4),
('R263','ING008',40.0,'g','40g oats',20.0,60.0,'Carb',5),
('R263','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',6),
('R263','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',7),
('R264','ING001',1.0,'each','1 banana',null,2.0,'Carb',1),
('R264','ING066',30.0,'g','2 tablespoons Wyldsson Nutella',15.0,45.0,'Carb',2),
('R264','ING005',30.0,'g','1 scoop chocolate whey protein',15.0,45.0,'Protein',3),
('R264','ING004',45.0,'g','3 tablespoons Greek Yoghurt',22.5,67.5,'Protein',4),
('R264','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',5),
('R264','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',6),
('R265','ING001',1.0,'each','1 large banana',null,2.0,'Carb',1),
('R265','ING004',30.0,'g','2 tablespoons Greek Yoghurt',15.0,45.0,'Protein',2),
('R265','ING258',150.0,'ml','150ml full-fat milk',75.0,225.0,'Carb',3),
('R265','ING005',30.0,'g','1 scoop chocolate whey protein',15.0,45.0,'Protein',4),
('R265','ING007',20.0,'g','2 desert spoons Wyldsson nut butter',10.0,30.0,'Fat',5),
('R265','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',6),
('R266','ING001',1.0,'each','1 medium banana',null,2.0,'Carb',1),
('R266','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',2),
('R266','ING007',10.0,'g','1 desert spoon Wyldsson nut butter',5.0,15.0,'Fat',3),
('R266','ING011',5.0,'g','1 teaspoon honey',2.5,7.5,'Carb',4),
('R266','ING008',30.0,'g','2 tablespoons oats',15.0,45.0,'Carb',5),
('R266','ING005',30.0,'g','1 scoop vanilla whey protein',15.0,45.0,'Protein',6),
('R266','ING029',6.0,'g','6 chunks ice',5.0,7.0,'Carb',7),
('R267','ING003',30.0,'g','2 tablespoons raspberries',15.0,45.0,'Carb',1),
('R267','ING199',45.0,'g','3 large strawberries',22.5,67.5,'Carb',2),
('R267','ING193',30.0,'g','1 handful spinach',15.0,45.0,'Protein',3),
('R267','ING004',30.0,'g','2 tablespoons Greek Yoghurt',15.0,45.0,'Protein',4),
('R267','ING253',1.0,'ml','1 sachet ''Cherry Active''',null,2.0,'Carb',5),
('R267','ING005',30.0,'g','1 scoop vanilla whey protein',15.0,45.0,'Protein',6),
('R267','ING011',10.0,'g','2 teaspoons honey',5.0,15.0,'Carb',7),
('R267','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',8),
('R267','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',9),
('R268','ING001',1.0,'each','1 medium banana',null,2.0,'Carb',1),
('R268','ING004',30.0,'g','2 tablespoons Greek Yoghurt',15.0,45.0,'Protein',2),
('R268','ING193',30.0,'g','1 decent handful spinach',15.0,45.0,'Protein',3),
('R268','ING007',10.0,'g','1 desert spoon Wyldsson nut butter',5.0,15.0,'Fat',4),
('R268','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',5),
('R268','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',6),
('R269','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',1),
('R269','ING157',1.0,'each','1 large peach',null,2.0,'Carb',2),
('R269','ING098',2.0,'g','1 chunk of ginger',1.0,3.0,'Carb',3),
('R269','ING011',10.0,'g','2 teaspoons honey',5.0,15.0,'Carb',4),
('R269','ING193',30.0,'g','1 handful spinach',15.0,45.0,'Protein',5),
('R269','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',6),
('R270','ING169',30.0,'g','2 tablespoons cranberries (dried)',15.0,45.0,'Carb',1),
('R270','ING098',2.0,'g','1 chunk of ginger',1.0,3.0,'Carb',2),
('R270','ING011',10.0,'g','2 teaspoons honey',5.0,15.0,'Carb',3),
('R270','ING028',150.0,'ml','150ml water',75.0,225.0,'Carb',4),
('R270','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',5),
('R271','ING118',1.0,'each','1 kiwi fruit',null,2.0,'Carb',1),
('R271','ING005',30.0,'g','1 scoop strawberry whey protein',15.0,45.0,'Protein',2),
('R271','ING004',15.0,'g','1 tablespoon Greek Yoghurt',7.5,22.5,'Protein',3),
('R271','ING199',75.0,'g','5 large strawberries',37.5,112.5,'Carb',4),
('R271','ING011',10.0,'g','2 teaspoons honey',5.0,15.0,'Carb',5),
('R271','ING029',6.0,'g','6 chunks of ice',5.0,7.0,'Carb',6),
('R271','ING006',150.0,'ml','150ml semi-skimmed milk',75.0,225.0,'Carb',7),
('R272','ING257',150.0,'ml','150ml orange juice',75.0,225.0,'Carb',1),
('R272','ING004',30.0,'g','2 tablespoons Greek Yoghurt',15.0,45.0,'Protein',2),
('R272','ING003',45.0,'g','3 tablespoons raspberries',22.5,67.5,'Carb',3),
('R272','ING001',1.0,'each','1 banana',null,2.0,'Carb',4),
('R272','ING005',30.0,'g','1 scoop vanilla whey protein',15.0,45.0,'Protein',5),
('R273','ING010',40.0,'g','40g chia seeds',20.0,60.0,'Carb',1),
('R273','ING211',250.0,'ml','250ml unsweetened almond milk',125.0,375.0,'Fat',2),
('R273','ING005',25.0,'g','1 scoop (~25g) unflavoured or vanilla protein powder',12.5,37.5,'Protein',3),
('R273','ING014',2.5,'g','½ tsp vanilla extract',1.25,3.75,'Carb',4),
('R273','ING085',1.0,'g','¼ tsp cinnamon',0.5,1.5,'Carb',5),
('R273','ING096',5.0,'g','1 tsp flaxseeds',2.5,7.5,'Fat',6),
('R274','ING008',50.0,'g','50g rolled oats',25.0,75.0,'Carb',1),
('R274','ING211',200.0,'ml','200ml unsweetened almond milk',100.0,300.0,'Fat',2),
('R274','ING005',25.0,'g','1 scoop (~25g) unflavoured or vanilla protein powder',12.5,37.5,'Protein',3),
('R274','ING010',15.0,'g','1 tbsp chia seeds',7.5,22.5,'Carb',4),
('R274','ING085',1.0,'g','½ tsp cinnamon',0.5,1.5,'Carb',5),
('R274','ING014',2.5,'g','½ tsp vanilla extract',1.25,3.75,'Carb',6),
('R274','ING096',5.0,'g','1 tsp ground flaxseeds',2.5,7.5,'Fat',7),
('R275','ING018',4.0,'each','4 large eggs',3.0,5.0,'Protein',1),
('R275','ING211',50.0,'ml','50ml unsweetened almond milk',25.0,75.0,'Fat',2),
('R275','ING139',30.0,'g','30g shredded cheese',15.0,45.0,'Fat',3),
('R275','ING193',50.0,'g','50g fresh spinach, chopped',25.0,75.0,'Protein',4),
('R275','ING184',1.0,'g','¼ tsp salt',0.5,1.5,'Carb',5),
('R275','ING184',1.0,'g','¼ tsp black pepper',0.5,1.5,'Carb',6),
('R275','ING085',1.0,'g','¼ tsp garlic powder',0.5,1.5,'Carb',7),
('R275','ING135',1.0,'g','½ tsp olive oil or non-stick spray',0.5,1.5,'Fat',8),
('R276','ING001',1.0,'each','1 banana',null,2.0,'Carb',1),
('R276','ING018',1.0,'each','1 small egg',null,2.0,'Protein',2),
('R276','ING251',60.0,'g','¼ cup apple sauce',30.0,90.0,'Carb',3),
('R276','ING250',60.0,'g','¼ cup stevia',30.0,90.0,'Carb',4),
('R276','ING164',60.0,'g','½ cup whole-wheat flour',30.0,90.0,'Carb',5),
('R276','ING164',60.0,'g','½ cup plain flour',30.0,90.0,'Carb',6),
('R276','ING006',30.0,'ml','⅛ cup milk',15.0,45.0,'Carb',7),
('R276','ING014',2.5,'g','½ tsp vanilla extract',1.25,3.75,'Carb',8),
('R276','ING017',10.0,'g','2 tsp baking powder',5.0,15.0,'Carb',9),
('R276','ING012',15.0,'g','1 tablespoon chocolate chips',7.5,22.5,'Carb',10),
('R277','ING083',1.5,'each','1 ½ digestive biscuits',0.5,2.5,'Carb',1),
('R277','ING001',1.0,'each','1 medium banana',null,2.0,'Carb',2),
('R277','ING004',45.0,'g','3 tablespoons 0% Total Fage Greek yoghurt',22.5,67.5,'Protein',3),
('R277','ING011',5.0,'g','1 tsp honey',2.5,7.5,'Carb',4),
('R278','ING245',400.0,'g','400g beetroot (pre-cooked)',200.0,600.0,'Carb',1),
('R278','ING082',200.0,'g','200g dark chocolate (70% cocoa)',100.0,300.0,'Carb',2),
('R278','ING011',150.0,'g','150g honey',75.0,225.0,'Carb',3),
('R278','ING008',100.0,'g','100g oats',50.0,150.0,'Carb',4),
('R278','ING054',90.0,'g','90g butter',45.0,135.0,'Fat',5),
('R278','ING018',3.0,'each','3 eggs',2.0,4.0,'Protein',6),
('R278','ING013',25.0,'g','25g cocoa powder',12.5,37.5,'Carb',7),
('R278','ING014',5.0,'g','1 teaspoon vanilla essence',2.5,7.5,'Carb',8),
('R278','ING017',2.5,'g','½ teaspoon baking powder',1.25,3.75,'Carb',9),
('R279','ING008',300.0,'g','300g Oats',150.0,450.0,'Carb',1),
('R279','ING004',500.0,'g','500g Greek Yoghurt',250.0,750.0,'Protein',2),
('R279','ING168',60.0,'g','4 Tbsp Pumpkin Seeds',30.0,90.0,'Fat',3),
('R279','ING169',90.0,'g','6 Tbsp Raisins',45.0,135.0,'Carb',4),
('R279','ING085',15.0,'g','1 Tbsp Ground Cinnamon',7.5,22.5,'Carb',5),
('R279','ING017',15.0,'g','1 Tbsp Baking soda',7.5,22.5,'Carb',6),
('R279','ING096',15.0,'g','1 Tbsp Flax Seeds',7.5,22.5,'Fat',7),
('R279','ING184',1.0,'g','½ Tsp Salt',0.5,1.5,'Carb',8),
('R280','ING008',160.0,'g','160g Porridge Oats',80.0,240.0,'Carb',1),
('R280','ING010',20.0,'g','20g Chia Seeds',10.0,30.0,'Carb',2),
('R280','ING006',250.0,'ml','250ml Semi-Skimmed Milk',125.0,375.0,'Carb',3),
('R280','ING004',200.0,'g','200g 0% Fat Greek Yoghurt',100.0,300.0,'Protein',4),
('R280','ING085',2.5,'g','½ tsp Ground Cinnamon',1.25,3.75,'Carb',5),
('R280','ING005',60.0,'g','60g (2 Scoops) Vanilla Whey',30.0,90.0,'Protein',6),
('R280','ING001',1.0,'each','100g Banana',null,2.0,'Carb',7),
('R280','ING002',80.0,'g','80g Blueberries',40.0,120.0,'Carb',8),
('R280','ING232',24.0,'g','24g Goji Berries',12.0,36.0,'Carb',9),
('R281','ING008',300.0,'g','300g Oats',150.0,450.0,'Carb',1),
('R281','ING018',2.0,'each','2 Eggs',1.0,3.0,'Protein',2),
('R281','ING001',3.0,'each','3 Ripe Bananas',2.0,4.0,'Carb',3),
('R281','ING004',60.0,'g','4 Tbsp 0% Fat Greek Yoghurt',30.0,90.0,'Protein',4),
('R281','ING068',15.0,'g','1 Tbsp Coconut Oil',7.5,22.5,'Fat',5),
('R281','ING085',15.0,'g','1 Tbsp Cinnamon',7.5,22.5,'Carb',6),
('R281','ING011',45.0,'g','3 Tbsp Honey',22.5,67.5,'Carb',7),
('R281','ING215',30.0,'g','2 Tbsp Walnuts',15.0,45.0,'Fat',8),
('R282','ING034',3.2,'each','400g Apples',399.0,401.0,'Carb',1),
('R282','ING011',10.0,'g','2 tsp Honey',5.0,15.0,'Carb',2),
('R282','ING164',35.0,'g','35g Wholemeal Flour',17.5,52.5,'Carb',3),
('R282','ING008',35.0,'g','35g Oats',17.5,52.5,'Carb',4),
('R282','ING051',10.0,'g','10g Caster sugar',5.0,15.0,'Carb',5),
('R282','ING054',35.0,'g','35g Butter',17.5,52.5,'Fat',6),
('R283','ING062',150.0,'g','1 chicken breast, cut into strips',75.0,225.0,'Protein',1),
('R283','ING236',50.0,'g','½ cup brown rice (dry weight)',25.0,75.0,'Carb',2),
('R283','ING171',100.0,'g','1 cup chopped mixed colourful vegetables',50.0,150.0,'Carb',3),
('R283','ING104',1.0,'each','1 clove garlic, minced',null,2.0,'Carb',4),
('R283','ING192',15.0,'ml','1 tablespoon soy sauce',7.5,22.5,'Protein',5),
('R283','ING187',5.0,'g','1 teaspoon sesame oil',2.5,7.5,'Fat',6),
('R283','ING023',5.0,'g','1 teaspoon olive oil',2.5,7.5,'Fat',7),
('R283','ING098',1.0,'g','½ teaspoon grated ginger',null,2.0,'Carb',8),
('R283','ING184',1.0,'g','Salt and pepper to taste',0.5,1.5,'Carb',9),
('R284','ING023',30.0,'g','2 tbsp olive oil',15.0,45.0,'Fat',1),
('R284','ING149',100.0,'g','1 onion',50.0,150.0,'Carb',2),
('R284','ING256',30.0,'g','2 tablespoons Patak''s korma paste',15.0,45.0,'Fat',3),
('R284','ING104',1.0,'each','1 tsp chopped garlic',null,2.0,'Carb',4),
('R284','ING098',2.0,'g','1 tsp chopped ginger',1.0,3.0,'Carb',5),
('R284','ING062',450.0,'g','3 large chicken breasts, diced',225.0,675.0,'Protein',6),
('R284','ING004',100.0,'g','100g Total Fage 0% Greek Yoghurt',50.0,150.0,'Protein',7),
('R284','ING172',1.0,'each','½ fresh red chilli pepper',null,2.0,'Carb',8),
('R284','ING032',15.0,'g','Toasted flaked almonds',7.5,22.5,'Fat',9),
('R284','ING103',50.0,'ml','50ml coconut milk',25.0,75.0,'Fat',10),
('R284','ING171',50.0,'g','Sweet red peppers',25.0,75.0,'Carb',11),
('R284','ING193',30.0,'g','Spinach',15.0,45.0,'Protein',12),
('R284','ING042',170.0,'g','Wild or basmati rice (140g per person)',280.0,840.0,'Carb',13),
('R285','ING054',10.0,'g','10g butter',5.0,15.0,'Fat',1),
('R285','ING172',1.0,'each','½ red chili pepper',null,2.0,'Carb',2),
('R285','ING248',30.0,'g','2 slices bacon',15.0,45.0,'Fat',3),
('R285','ING149',100.0,'g','1 finely chopped onion',50.0,150.0,'Carb',4),
('R285','ING104',1.0,'each','1 clove garlic',null,2.0,'Carb',5),
('R285','ING099',2.0,'g','1 teaspoon thyme leaves',1.0,3.0,'Carb',6),
('R285','ING201',200.0,'g','1 large peeled and chopped sweet potato',100.0,300.0,'Carb',7),
('R285','ING062',450.0,'g','3 chopped chicken breasts',225.0,675.0,'Protein',8),
('R285','ING202',250.0,'g','250g frozen sweetcorn',125.0,375.0,'Carb',9),
('R285','ING197',1136.0,'ml','2 pints chicken stock',568.0,1704.0,'Protein',10),
('R285','ING184',1.0,'g','Black pepper to taste',0.5,1.5,'Carb',11),
('R286','ING182',150.0,'g','150g salmon fillet',75.0,225.0,'Protein',1),
('R286','ING167',200.0,'g','200g baby new potatoes',100.0,300.0,'Carb',2),
('R286','ING102',50.0,'g','50g peas',25.0,75.0,'Carb',3),
('R286','ING254',50.0,'g','50g broad beans',25.0,75.0,'Carb',4),
('R286','ING057',50.0,'g','50g steamed carrots',25.0,75.0,'Carb',5),
('R286','ING011',15.0,'g','1 tbsp honey',7.5,22.5,'Carb',6),
('R286','ING084',15.0,'g','1 tbsp wholegrain mustard',7.5,22.5,'Protein',7),
('R286','ING224',15.0,'ml','1 tbsp Worcestershire sauce',7.5,22.5,'Carb',8),
('R286','ING067',7.5,'ml','½ tbsp apple cider vinegar',3.75,11.25,'Carb',9),
('R286','ING104',1.0,'each','1 clove garlic',null,2.0,'Carb',10),
('R286','ING085',2.5,'g','½ tsp smoked paprika',1.25,3.75,'Carb',11),
('R286','ING023',5.0,'g','Salt & olive oil',2.5,7.5,'Fat',12),
('R286','ING054',5.0,'g','1 tsp butter',2.5,7.5,'Fat',13),
('R286','ING099',3.0,'g','1 tbsp fresh parsley',1.5,4.5,'Carb',14),
('R286','ING085',1.0,'g','½ tsp dried thyme',0.5,1.5,'Carb',15),
('R286','ING099',1.0,'g','½ tsp fresh mint',0.5,1.5,'Carb',16),
('R287','ING231',75.0,'g','1 Smoked Mackerel fillet',37.5,112.5,'Protein',1),
('R287','ING209',72.0,'g','½ can Tuna, in brine or spring water',36.0,108.0,'Protein',2),
('R287','ING173',50.0,'g','½ Red Onion',25.0,75.0,'Carb',3),
('R287','ING018',1.0,'each','1 medium Egg',null,2.0,'Protein',4),
('R287','ING255',1.0,'each','small slice Seeded Bread',null,2.0,'Carb',5),
('R287','ING237',7.5,'g','½ tbsp Reduced Fat Cottage Cheese',3.75,11.25,'Protein',6),
('R287','ING195',7.5,'g','½ tbsp Red Pepper Sauce',3.75,11.25,'Carb',7),
('R287','ING213',7.5,'g','½ tbsp Vegetable Oil',3.75,11.25,'Fat',8),
('R287','ING099',15.0,'g','½ cup fresh Coriander',7.5,22.5,'Carb',9),
('R287','ING084',2.5,'g','½ tsp Smooth Mustard',1.25,3.75,'Protein',10),
('R287','ING184',1.0,'g','1 pinch Black Pepper',0.5,1.5,'Carb',11),
('R287','ING143',50.0,'g','Colourful salad of your choice',25.0,75.0,'Carb',12),
('R288','ING018',3.0,'each','3 Eggs',2.0,4.0,'Protein',1),
('R288','ING249',60.0,'g','3 Slices of Ham',30.0,90.0,'Protein',2),
('R288','ING061',40.0,'g','4 Cherry Tomatoes',20.0,60.0,'Carb',3),
('R288','ING176',30.0,'g','30g Mozzarella',15.0,45.0,'Protein',4),
('R288','ING171',50.0,'g','½ Pepper',25.0,75.0,'Carb',5),
('R288','ING149',25.0,'g','¼ Onion',12.5,37.5,'Carb',6),
('R288','ING097',1.0,'each','1 Tortilla Wrap',null,2.0,'Carb',7),
('R288','ING006',20.0,'ml','20ml Semi Skimmed Milk',10.0,30.0,'Carb',8),
('R288','ING023',5.0,'g','1 teaspoon Olive Oil',2.5,7.5,'Fat',9),
('R288','ING184',1.0,'g','Salt',0.5,1.5,'Carb',10),
('R288','ING184',1.0,'g','Pepper',0.5,1.5,'Carb',11),
('R289','ING042',100.0,'g','2 cups basmati rice',50.0,150.0,'Carb',1),
('R289','ING068',10.0,'g','2 tsp coconut oil',5.0,15.0,'Fat',2),
('R289','ING124',500.0,'g','500g rump steak, cut into thin strips',250.0,750.0,'Protein',3),
('R289','ING184',2.0,'g','2 teaspoons freshly cracked black pepper',1.0,3.0,'Carb',4),
('R289','ING104',1.0,'each','1 fresh garlic clove',null,2.0,'Carb',5),
('R289','ING172',1.0,'each','1 fresh red chilli pepper',null,2.0,'Carb',6),
('R289','ING194',3.0,'each','3 spring onions, sliced',2.0,4.0,'Carb',7),
('R289','ING050',100.0,'g','Vegetables of your choice, sliced (e.g. broccoli)',50.0,150.0,'Protein',8),
('R289','ING152',45.0,'g','3 tablespoons Oyster Sauce',22.5,67.5,'Carb',9),
('R289','ING011',5.0,'g','1 tsp honey',2.5,7.5,'Carb',10),
('R289','ING099',10.0,'g','Handful of fresh coriander leaves',5.0,15.0,'Carb',11),
('R290','ING219',85.0,'g','85g fresh cod fillet',42.5,127.5,'Protein',1),
('R290','ING197',120.0,'ml','120ml fish or vegetable stock',60.0,180.0,'Protein',2),
('R290','ING130',15.0,'ml','1 tbsp fresh lemon juice',14.0,16.0,'Carb',3),
('R290','ING184',1.0,'g','Pinch of salt',0.5,1.5,'Carb',4),
('R290','ING184',1.0,'g','Pinch of white pepper',0.5,1.5,'Carb',5),
('R290','ING099',1.0,'g','¼ tsp dried parsley or dill',0.5,1.5,'Carb',6),
('R290','ING167',150.0,'g','1 medium Maris Piper potato (150g), peeled and cut into wedges',75.0,225.0,'Carb',7),
('R290','ING023',7.5,'g','½ tbsp olive oil',3.75,11.25,'Fat',8),
('R290','ING057',30.0,'g','¼ cup (30g) peeled, steamed carrots',15.0,45.0,'Carb',9),
('R290','ING076',30.0,'g','¼ cup (30g) peeled, steamed courgette',15.0,45.0,'Carb',10),
('R290','ING054',5.0,'g','1 tsp butter',2.5,7.5,'Fat',11),
('R291','ING247',40.0,'g','4 slices prosciutto',20.0,60.0,'Protein',1),
('R291','ING019',2.0,'each','2 egg whites',1.0,3.0,'Protein',2),
('R291','ING018',1.0,'each','1 whole egg',null,2.0,'Protein',3),
('R291','ING004',45.0,'g','3 tablespoons Greek yoghurt (0%)',22.5,67.5,'Protein',4),
('R291','ING056',15.0,'g','1 tablespoon black olives',7.5,22.5,'Carb',5),
('R291','ING099',1.0,'g','½ teaspoon rosemary',0.5,1.5,'Carb',6),
('R291','ING184',1.0,'g','Salt and pepper to taste',0.5,1.5,'Carb',7),
('R292','ING062',150.0,'g','1 chicken breast',75.0,225.0,'Protein',1),
('R292','ING042',90.0,'g','200g cooked white rice',45.0,135.0,'Carb',2),
('R292','ING192',15.0,'ml','1 tbsp light soy sauce',7.5,22.5,'Protein',3),
('R292','ING098',1.0,'g','½ tsp grated fresh ginger',null,2.0,'Carb',4),
('R292','ING054',15.0,'g','1 tbsp butter',7.5,22.5,'Fat',5),
('R292','ING057',30.0,'g','¼ cup carrots',15.0,45.0,'Carb',6),
('R292','ING076',30.0,'g','¼ cup courgette',15.0,45.0,'Carb',7),
('R292','ING011',15.0,'g','1 tbsp mild honey',7.5,22.5,'Carb',8),
('R292','ING184',1.0,'g','Salt & white pepper to taste',0.5,1.5,'Carb',9),
('R293','ING209',145.0,'g','1 can tuna in spring water, drained',72.5,217.5,'Protein',1),
('R293','ING143',30.0,'g','2 large lettuce leaves (Romaine or 4x Baby Gem)',15.0,45.0,'Carb',2),
('R293','ING004',15.0,'g','1 tablespoon 0% Greek Yogurt',7.5,22.5,'Protein',3),
('R293','ING173',15.0,'g','1 tablespoon diced red onion',7.5,22.5,'Carb',4),
('R293','ING060',15.0,'g','1 tablespoon diced celery',7.5,22.5,'Carb',5),
('R293','ING099',3.0,'g','1 tablespoon chopped fresh parsley',1.5,4.5,'Carb',6),
('R293','ING084',5.0,'g','1 teaspoon Dijon mustard',2.5,7.5,'Protein',7),
('R293','ING184',1.0,'g','Salt and pepper to taste',0.5,1.5,'Carb',8),
('R294','ING128',450.0,'g','450g minced turkey breast',225.0,675.0,'Protein',1),
('R294','ING049',30.0,'g','¼ cup dried bread crumbs',15.0,45.0,'Carb',2),
('R294','ING149',30.0,'g','¼ cup chopped onion',15.0,45.0,'Carb',3),
('R294','ING099',6.0,'g','2 tablespoons fresh parsley, chopped',3.0,9.0,'Carb',4),
('R294','ING224',22.5,'ml','1 ½ tablespoons Worcestershire sauce',11.25,33.75,'Carb',5),
('R294','ING195',5.0,'g','1 teaspoon Tabasco sauce',2.5,7.5,'Carb',6),
('R294','ING053',4.0,'each','4 whole-grain buns',3.0,5.0,'Carb',7),
('R294','ING205',60.0,'g','4 slices tomato',30.0,90.0,'Carb',8),
('R294','ING173',40.0,'g','4 slices red onion',20.0,60.0,'Carb',9),
('R294','ING143',20.0,'g','Lettuce leaves',10.0,30.0,'Carb',10),
('R294','ING206',60.0,'g','4 tablespoons ketchup',30.0,90.0,'Carb',11),
('R294','ING201',800.0,'g','4 large sweet potatoes',400.0,1200.0,'Carb',12),
('R295','ING252',100.0,'g','100g turkey breast, thinly sliced',50.0,150.0,'Protein',1),
('R295','ING018',2.0,'each','2 eggs',1.0,3.0,'Protein',2),
('R295','ING241',50.0,'g','50g rice noodles',25.0,75.0,'Carb',3),
('R295','ING171',100.0,'g','1 cup colourful vegetables',50.0,150.0,'Carb',4),
('R295','ING104',2.0,'each','2 cloves garlic, minced',1.0,3.0,'Carb',5),
('R295','ING192',30.0,'ml','2 tablespoons soy sauce',15.0,45.0,'Protein',6),
('R295','ING152',15.0,'g','1 tablespoon oyster sauce',7.5,22.5,'Carb',7),
('R295','ING187',15.0,'g','1 tablespoon sesame oil',7.5,22.5,'Fat',8),
('R295','ING023',15.0,'g','1 tablespoon olive oil',7.5,22.5,'Fat',9),
('R295','ING184',1.0,'g','Salt and pepper to taste',0.5,1.5,'Carb',10),
('R295','ING085',1.0,'g','½ teaspoon chilli flakes',0.5,1.5,'Carb',11),
('R296','ING018',2.0,'each','2 Eggs',1.0,3.0,'Protein',1),
('R296','ING001',1.0,'each','1 Banana',null,2.0,'Carb',2),
('R296','ING005',30.0,'g','1 scoop Vanilla Whey',15.0,45.0,'Protein',3),
('R296','ING142',30.0,'g','Handful Fresh berries',15.0,45.0,'Carb',4),
('R296','ING004',30.0,'g','2 tablespoons Greek yoghurt (0%)',15.0,45.0,'Protein',5),
('R296','ING068',5.0,'g','1 teaspoon coconut oil',2.5,7.5,'Fat',6),
('R262','ING006',150.0,'ml','150ml Semi-Skimmed Milk',75.0,225.0,'Carb',8),
('R262','ING005',30.0,'g','1 scoop (30g) NX Big Whey (Vanilla or Strawberry)',15.0,45.0,'Protein',9);

insert into recipe_ingredients
  (recipe_id, food_id, qty, unit, display_text, min_qty, max_qty, macro_role, sort_order)
select r.id, f.id, s.qty, s.unit, s.display_text, s.min_qty, s.max_qty,
       s.macro_role, s.sort_order
from ri_stage s
join recipes r on r.ext_id = s.recipe_ext
join foods   f on f.ext_id = s.food_ext
-- skip any recipe that already has its ingredients, so running this file
-- a second time cannot double every recipe up
where not exists (
  select 1 from recipe_ingredients x where x.recipe_id = r.id
);

commit;

-- ---------- what landed ----------
select 'foods' as loaded, count(*) from foods
union all select 'recipes', count(*) from recipes
union all select 'ingredients', count(*) from recipe_ingredients
union all select 'flagged for review', count(*) from needs_review;
