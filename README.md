# Close Nutrition — Performance Plan Builder

## Deploying

`index.html` is the whole app — code, recipes, logo, everything in one file.
Vercel serves it as-is. There is no build step and nothing to install.

Push to GitHub, import the repo in Vercel, deploy. That's it.

## What's in here

```
index.html        the app. This is the only file Vercel needs.
src/              the pieces index.html is built from (see below)
database/         the Supabase setup, numbered in the order you run them
spreadsheets/     the master database and the sheets for Graeme
```

## Changing the app

Don't edit `index.html` by hand — it's generated, and your change would be
overwritten next time. Edit the file in `src/` instead, then rebuild:

```
python3 src/build_html.py
```

Which file does what:

| File | What it handles |
|---|---|
| `src/app.js` | the plan builder — generating, scaling, players, weeks |
| `src/sb.js` | everything that talks to the Supabase database |
| `src/pdf.js` | the branded PDF export |
| `src/foodjs.js` | ingredient matching and the custom meal builder |
| `src/template.html` | the page layout and styling |

## Setting up the database

See `database/HOW TO SET IT UP.md`. Six files, run in order in the Supabase
SQL editor. Takes about twenty minutes.

The app will run without it, falling back to 74 built-in recipes, but the
shared library, saved weeks and player profiles all need the database.

## Where things stand

Working: plan generation, per-ingredient scaling, saved weeks, recipe and food
library, bulk import, PDF export.

Player profile — a "Player data" button opens everything about a player:
height, weight and when it was taken, targets in g/kg for each of the four day
types, foods and whole categories they avoid with allergy/intolerance/dislike,
and free-text notes. Choosing a day type in the plan fills that day's targets
from the player's own figures, and they stay editable.

The PDF opens with a landscape kitchen timetable — meals down, days across,
with times, macros and day totals.

Built but switched off: sign-in. `AUTH_REQUIRED` is false until testing is
finished.

Still to build: add-recipe and add-supplement forms, the upload review screen,
favourites, and day-type targets filling from the player's profile.
