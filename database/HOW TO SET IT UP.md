# Setting up the database — step by step

You do not need to understand any of the code. You are copying text into a box
and pressing a button, six times.

Set aside twenty minutes. Do it in one sitting.

---

## Before you start

Open **supabase.com** in a browser and sign in. Open your project.

Down the left-hand side there is a list of icons. Find the one called
**SQL Editor**. Click it. You'll see a big empty box with a **Run** button.

That box is where everything below goes.

---

## Step 1 — Build the tables

Open **`01_schema.sql`**. Select all of it (Ctrl+A, or Cmd+A on a Mac) and copy
it. Click into the Supabase box, paste, press **Run**.

Wait. It takes a few seconds.

**You should see:** `structure built`

> ⚠️ This file deletes everything and starts fresh. That's what you want right
> now, on an empty project. Once there's real work in there, never run this file
> again. The other five are safe to re-run any time.

---

## Step 2 — Add the import functions

Same again with **`02_api.sql`**. Select all, copy, paste over the top of what's
in the box, press **Run**.

**You should see:** `import API built`

---

## Step 3 — Load the recipe book

Same again with **`03_seed.sql`**. This one is much bigger and takes longer —
maybe thirty seconds. Don't click Run twice.

**You should see a small table:**

| loaded | count |
|---|---|
| foods | 258 |
| recipes | 292 |
| ingredients | 2856 |
| flagged for review | 129 |

If those four numbers match, it worked.

---

## Step 4 — Supplements and swapping rules

Same again with **`04_extend.sql`**, then **`05_swap_rules.sql`**.

**You should see:** `supplements, player detail and swap rules added`, then a
small table showing 258 foods with a swap group, 2,856 ingredients with a role,
and 12 supplements.

---

## Step 5 — Check it

Same again with **`06_verify.sql`**. Everything comes back as one table.

The line that matters says **anything broken?** — it should read
**no - all clear**. That means no recipe is missing its ingredients, no food has
impossible numbers, and there are no duplicate names.

Underneath you'll see the worst calorie mismatches. Those are expected — they're
what Graeme needs to look at, not a fault in the setup.

---

## If something goes wrong

**Red error message.** Copy the whole thing and send it to me. Nothing will have
been half-saved — each file either works completely or changes nothing.

**Numbers don't match Step 3.** Run `03_seed.sql` again — it skips anything
already loaded, so it will fill in whatever is missing without duplicating what
is already there.

**You accidentally ran `01_schema.sql` a second time.** Everything's gone, but
nothing is lost. Just run steps 2, 3 and 4 again and you're back where you were.

---

## What you've got when it's finished

- **258 foods** — every ingredient, with its nutrition per 100g
- **292 recipes** — every recipe, with its ingredients broken out properly
- **Rules the database enforces itself** — impossible nutrition values can't be
  saved by anyone, through any route, including someone typing directly into
  Supabase
- **A review list** — 129 things wanting Graeme's eye, in one place

---

# For Graeme

Two spreadsheets, and they're independent — he can do them in either order, and
neither blocks you from getting on with the app.

### `Close Nutrition - swap rules for review.xlsx`

Six tabs. The **Start here** tab explains it. In short:

**Quantity problems** — do this one first. 23 ingredient amounts that look like
typing errors, mostly a count typed into a grams box. I've already corrected the
12 that were unambiguous; this tab shows all of them so he can confirm.

**Roles to check** — 716 ingredients where the rules weren't fully confident
whether something is the point of the dish or just seasoning. Dropdown in the
yellow column, so nothing can be mistyped.

**Roles (confident)** — 2,185 more. Skim, don't work through.

**Swap groups** — all 258 foods sorted into groups like poultry, rice, leafy
greens. Sorted by group, so a wrong one stands out next to its neighbours.

**Substitutions** — every food with its three suggested replacements already
filled in. Chicken suggests turkey. Beef mince suggests beef steak. Pork
suggests chicken. He only changes the ones he disagrees with.

### `Close Nutrition - MASTER database (checked).xlsx`

The **Recipe check** tab — 117 recipes where the book's calorie figure disagrees
with the recipe's own ingredients by more than 15%. Sorted worst first, with a
column for his decision.

This is the one that actually matters. The app never uses the printed figure —
it adds up the ingredients itself, because that's the only way to scale a meal
to a player's targets. So where the two disagree, **the ingredients are what the
player gets handed**, and the printed number is just a witness saying something
is wrong.

The usual causes are a marinade counted in full when only some is eaten, or
batch quantities sitting next to per-serving calories. Both need a nutritionist
to say which number is true.
