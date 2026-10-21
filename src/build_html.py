#!/usr/bin/env python3
import json
tpl=open('/tmp/build/template.html').read()
recipes=json.load(open('/tmp/build/recipes_v2.json'))
app=open('/tmp/build/app.js').read()
foodjs=open('/tmp/build/foodjs.js').read()
sbjs=open('/tmp/build/sb.js').read()
food_rules=open('/tmp/build/food_rules.json').read()
food_table=open('/tmp/build/food_table.txt').read()
pdf=open('/tmp/build/pdf.js').read()
logo_white=open('/tmp/logo_white_b64.txt').read().strip()
logo_black=open('/tmp/logo_black_b64.txt').read().strip()

data = ("window.__RECIPES__=" + json.dumps(recipes, ensure_ascii=False) + ";\n"
        + 'window.__LOGO_WHITE__=' + json.dumps(logo_white) + ";\n"
        + 'window.__LOGO_BLACK__=' + json.dumps(logo_black) + ";\n"
        + 'window.__FOOD_RULES__=' + food_rules + ";\n"
        + 'window.__FOOD_TABLE__=' + json.dumps(food_table) + ";\n"
        + foodjs + "\n" + sbjs + "\n" + app + "\n" + pdf + "\n")

out = tpl.replace('/*__DATA__*/', data)
open('/mnt/user-data/outputs/close-nutrition-plan-builder.html','w').write(out)
print("written /mnt/user-data/outputs/close-nutrition-plan-builder.html")
print("size KB:", round(len(out)/1024,1), "| recipes:", len(recipes))
