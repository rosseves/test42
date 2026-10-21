/* ============ PDF EXPORT ============ */
function exportPDF(){
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF({unit:'pt', format:'a4'});
  const W=doc.internal.pageSize.getWidth(), H=doc.internal.pageSize.getHeight();
  const M=44;
  const C={bg:[244,247,242], bg2:[255,255,255], line:[219,226,213], ink:[23,35,27], muted:[88,97,88],
    faint:[139,150,139], teal:[0,121,52], amber:[201,138,0], red:[239,109,0], green_d:[0,97,31], white:[255,255,255]};
  const STATUS=c=> c<40?C.red : (c<=70?C.amber:C.teal);
  const STATUSLBL=c=> c<40?'LOW CARB' : (c<=70?'MEDIUM CARB':'HIGH CARB');
  // pale tints (behind the header row) that echo the carb status colour on white
  const STATUS_TINT=c=> c<40?[253,238,226] : (c<=70?[250,242,220]:[232,244,228]);

  // jsPDF carries the last orientation forward, so a bare addPage() after a
  // landscape page is landscape as well. Every portrait page asks for portrait.
  function newPage(){ doc.addPage([W,H],'portrait'); }
  function pageBg(){ doc.setFillColor(...C.bg); doc.rect(0,0,W,H,'F');
    // brand-green top rule
    doc.setFillColor(...C.teal); doc.rect(0,0,W,4,'F'); }
  function footer(pageLabel){
    // black logo bottom-left (small, sits inside the footer band)
    try{ const lw=40, lh=lw*1.216; doc.addImage(LOGO_BLACK,'PNG',M,H-lh-16,lw,lh); }catch(e){}
    doc.setTextColor(...C.faint); doc.setFontSize(8); doc.setFont('helvetica','normal');
    doc.text('CLOSE NUTRITION · PERFORMANCE PLAN', W-M, H-30, {align:'right'});
    if(pageLabel){ doc.text(pageLabel, W-M, H-20, {align:'right'}); }
  }

  /* ---------- COVER ---------- */
  pageBg();
  // big centered logo
  try{ const lw=150, lh=lw*1.216; doc.addImage(LOGO_BLACK,'PNG',(W-lw)/2, 150, lw, lh); }catch(e){}
  doc.setTextColor(...C.ink);
  doc.setFont('helvetica','normal'); doc.setFontSize(30);
  const player=(S.player||'Athlete').toUpperCase();
  doc.text(player, W/2, 400, {align:'center'});
  doc.setDrawColor(...C.teal); doc.setLineWidth(1.2);
  doc.line(W/2-60, 418, W/2+60, 418);
  doc.setTextColor(...C.muted); doc.setFontSize(13);
  doc.text('PERFORMANCE NUTRITION PLAN', W/2, 446, {align:'center'});
  const mth=new Date().toLocaleDateString('en-GB',{month:'long',year:'numeric'}).toUpperCase();
  doc.setTextColor(...C.faint); doc.setFontSize(11);
  doc.text(mth, W/2, 468, {align:'center'});
  // (daily-average overview removed — each day page carries its own targets)
  doc.setFontSize(10); doc.setTextColor(...C.muted);
  doc.text(`${S.bw}kg`, W/2, 620, {align:'center'});
  footer('');

  /* ---------- THE WEEK — a landscape timetable for the kitchen ----------
     Rows are the meals in time order, columns are the days, so the kitchen can
     read straight across a row and see the same sitting for all seven days.  */
  function weekTimetable(){
    doc.addPage([W, H], 'landscape');
    const PW = doc.internal.pageSize.getWidth(), PH = doc.internal.pageSize.getHeight();
    doc.setFillColor(...C.bg); doc.rect(0,0,PW,PH,'F');
    doc.setFillColor(...C.teal); doc.rect(0,0,PW,4,'F');

    const pad = 30;
    // ---- heading ----
    doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(22);
    doc.text('The Week', pad, 44);
    doc.setFontSize(10); doc.setTextColor(...C.faint);
    doc.text('KITCHEN OVERVIEW', pad, 60);
    doc.setFontSize(11); doc.setTextColor(...C.muted);
    doc.text((S.player||'Athlete') + '  ·  ' + (S.bw||'') + 'kg', PW-pad, 44, {align:'right'});
    doc.setFontSize(9); doc.setTextColor(...C.faint);
    doc.text('Macros are per serving. Full recipes and methods follow.', PW-pad, 60, {align:'right'});

    // ---- work out the grid ----
    const days = DAYS.filter(d=>S.days[d]);
    if(!days.length) return;
    /* "10pm" and "22:00" are the same time, and were landing in two rows that
       then repeated down the whole grid. Everything is read into minutes the
       same way before anything is grouped. */
    const mins = t => {
      const s0 = String(t||'').trim().toLowerCase();
      let m = /^(\d{1,2})[:.](\d{2})\s*(am|pm)?/.exec(s0);
      if(m){
        let h = +m[1];
        if(m[3] === 'pm' && h < 12) h += 12;
        if(m[3] === 'am' && h === 12) h = 0;
        return h*60 + (+m[2]);
      }
      m = /^(\d{1,2})\s*(am|pm)$/.exec(s0);         // "10pm", "7am"
      if(m){
        let h = +m[1];
        if(m[2] === 'pm' && h < 12) h += 12;
        if(m[2] === 'am' && h === 12) h = 0;
        return h*60;
      }
      // "FT", "post-match" and the like mean after the match, so late evening
      return 1230;
    };
    // roughly when each non-meal slot happens, so a supplement lands in the
    // right place in the day rather than in a block of its own
    const SLOT_TIME = {waking:'07:00', breakfast:'08:00', pre_training:'11:00',
                       post_training:'15:00', snack:'16:00', lunchdinner:'13:00',
                       smoothie:'11:30', bed:'22:00'};
    const SLOT_LABEL = {waking:'On waking', pre_training:'Pre-training',
                        post_training:'Post-training', bed:'Before bed',
                        breakfast:'With breakfast', snack:'With a snack',
                        lunchdinner:'With lunch or dinner', smoothie:'With a smoothie'};

    // Rows are time bands, not positions. Aligning by position would slide a
    // short day's meals up into another day's rows — so Saturday's breakfast
    // would sit on the same line as Monday's supplement.
    let BAND = 80;                         // minutes per band
    let perDay = {}, bandSeen = {}, bands = [];
    const build = () => {
    const asClockTime = t => {
      const v = mins(t);
      return String(Math.floor(v/60)%24).padStart(2,'0') + ':' + String(v%60).padStart(2,'0');
    };
    const bandOf = at => at < 0 ? -1 : Math.floor(at / BAND);
    perDay = {}; bandSeen = {};
    days.forEach(d=>{
      // Food only. Supplements have their own page — reading doses in among
      // the cooking was the thing to avoid.
      // a day deliberately left empty is marked, not just blank
      if(S.days[d].cleared){ perDay[d] = {}; return; }
      // dishes sharing a sitting become one cell, listed together
      const grouped = [];
      (S.days[d].meals||[]).forEach(m=>{
        const key=String(m.name||'')+'|'+String(m.time||'');
        const last=grouped[grouped.length-1];
        if(last && last.key===key) last.list.push(m);
        else grouped.push({key, list:[m], m, time:m.time});
      });
      const meals = grouped.map(g=>({kind:'meal', m:g.m, group:g.list, at:mins(g.time)}));
      // Key on the band AND what it is, so short days stay in line with the rest.
      const byBand = {}, seenInBand = {};
      meals.sort((a,b)=>a.at-b.at).forEach(it=>{
        const b = bandOf(it.at);
        const lane = it.kind === 'supp' ? 0 : 50;
        const n = (seenInBand[b + ':' + it.kind] || 0);
        seenInBand[b + ':' + it.kind] = n + 1;
        const key = b * 100 + lane + n;
        byBand[key] = it; bandSeen[key] = true;
      });
      perDay[d] = byBand;
    });
    bands = Object.keys(bandSeen).map(Number).sort((a,b)=>a-b);
    };
    // widen the bands until the grid is a sensible height. Nine rows on a
    // landscape page is about the limit before the cards stop being readable.
    build();
    while(bands.length > 9 && BAND < 400){ BAND += 40; build(); }
    const rows = bands.length;
    if(!rows) return;

    // a label for each row, taken from whichever name turns up most often at
    // that position, so the row reads "Breakfast" rather than "Meal 1"
    // Rows are time bands. Naming them after the most common dish meant that
    // adding one meal to one day produced a row called "Scrambled eggs on
    // toast". The time is always true; the sitting name only goes underneath
    // when most of the days actually agree on it.
    const rowLabel = i => {
      const times = {}, names = {};
      let n = 0;
      // everything is shown as a clock time, so "FT" and "post-match" are
      // turned into the time they actually mean before anything is counted
      const asClock = t => {
        const v = mins(t);
        const hh = String(Math.floor(v/60)%24).padStart(2,'0');
        const mm = String(v%60).padStart(2,'0');
        return hh + ':' + mm;
      };
      days.forEach(d=>{
        const it = perDay[d][bands[i]]; if(!it) return;
        n++;
        const t = asClock(it.m && it.m.time);
        if(t) times[t] = (times[t]||0) + 1;
        const nm = it.m && it.m.name;
        if(nm) names[nm] = (names[nm]||0) + 1;
      });
      const time = Object.keys(times).sort((a,b)=>times[b]-times[a])[0] || '';
      const nm   = Object.keys(names).sort((a,b)=>names[b]-names[a])[0] || '';
      // only show the sitting name if it holds for at least half the days here
      const agreed = nm && names[nm] >= Math.max(2, Math.ceil(n/2)) ? nm : '';
      return {time, name: agreed};
    };

    const labW = 92;
    const gridX = pad + labW, gridY = 84;
    const colW = (PW - pad*2 - labW) / days.length;
    const headH = 34, footH = 40;
    const avail = PH - gridY - headH - footH - 54;   // the totals row is taller now
    const rowH = Math.min(78, avail / rows);
    // with a lot of sittings the cards get short, so the contents step down
    // rather than overlapping: fewer name lines first, then the macro line goes
    // Work out what actually fits rather than guessing from the row height:
    // the time sits at the top, the macros at the bottom, and the name gets
    // whatever is left. With a lot of sittings the macros fold onto one line.
    // smaller type buys more of the dish name before it has to be cut
    const fName  = rowH < 56 ? 6.6 : 7.4;
    const fSmall = rowH < 56 ? 5.8 : 6.6;
    // the meal cells hold only a name now, so it can be read from across a kitchen
    const fBig   = rowH < 40 ? 7.5 : (rowH < 56 ? 8.5 : 9.5);
    const lineH  = fName * 1.18;
    const nameTop = 9 + fSmall;                        // sits below the time
    // Try the roomy version first: calories and macros on their own lines.
    // If that leaves no room for even one line of the dish name, fold them
    // onto one line and try again. The name always wins.
    let veryTight = false;
    let macroTop  = (rowH - 6) - (2*fSmall + 6);
    let nameLines = Math.floor((macroTop - nameTop - 2) / lineH);
    if(nameLines < 1){
      veryTight = true;
      macroTop  = (rowH - 6) - (fSmall + 2);
      nameLines = Math.floor((macroTop - nameTop - 2) / lineH);
    }
    // still nothing? Then the row is too short for both. Drop the macro line
    // rather than printing it through the dish name.
    const showMacros = nameLines >= 1;
    if(!showMacros){ nameLines = 1; }

    // ---- day headers ----
    days.forEach((d,i)=>{
      const x = gridX + i*colW;
      const dtype = String((S.days[d]&&S.days[d].type)||'Normal');
      // Match day used to be orange — but orange means LOW CARB in the key at
      // the foot of this page, and game day is a high carb day. Colour cannot
      // be used here at all without contradicting the key, so match day is
      // marked with a band and heavier type instead.
      const isMatch = /^game day$/i.test(dtype);
      doc.setFillColor(...C.teal);
      doc.roundedRect(x+2, gridY, colW-4, headH, 5,5,'F');
      if(isMatch){
        doc.setFillColor(...C.white);
        doc.roundedRect(x+2, gridY, colW-4, 3, 1.5,1.5,'F');
        doc.setFillColor(...C.white);
        doc.roundedRect(x+2, gridY+headH-3, colW-4, 3, 1.5,1.5,'F');
      }
      doc.setTextColor(...C.white); doc.setFont('helvetica','bold'); doc.setFontSize(10);
      doc.text(DAYFULL[d].toUpperCase(), x+10, gridY+14);
      doc.setFont('helvetica','normal'); doc.setFontSize(8);
      doc.setFont('helvetica', isMatch ? 'bold' : 'normal');
      doc.setTextColor(...(isMatch ? C.white : [210,230,215]));
      doc.text(dtype.toUpperCase(), x+10, gridY+26);
      doc.setFont('helvetica','normal');
    });

    // ---- the rows ----
    for(let r=0; r<rows; r++){
      const y = gridY + headH + 6 + r*rowH;
      const lb = rowLabel(r);
      doc.setTextColor(...C.ink); doc.setFont('helvetica','bold'); doc.setFontSize(10);
      doc.text(lb.time || '—', pad, y+15);
      if(lb.name){
        doc.setFont('helvetica','normal'); doc.setFontSize(7.5); doc.setTextColor(...C.faint);
        doc.text(doc.splitTextToSize(lb.name, labW-10).slice(0,2), pad, y+27);
      }

      days.forEach((d,i)=>{
        const x = gridX + i*colW, it = perDay[d][bands[r]];

        if(it && it.kind === 'supp'){
          const sp = it.sp;
          doc.setFillColor(246,244,251); doc.setDrawColor(221,214,238); doc.setLineWidth(.6);
          doc.roundedRect(x+2, y, colW-4, rowH-6, 5,5,'FD');
          doc.setFillColor(122,91,181); doc.roundedRect(x+2, y, 4, rowH-6, 2,2,'F');
          doc.setTextColor(107,87,160); doc.setFont('helvetica','bold'); doc.setFontSize(fSmall);
          doc.text((sp.slot ? (SLOT_LABEL[sp.slot]||'') : 'ANY TIME').toUpperCase(),
                   x+11, y+10+fSmall*0.4);
          doc.setFont('helvetica','normal'); doc.setFontSize(fName);
          doc.setTextColor(...C.ink);
          let sn = doc.splitTextToSize(String(sp.name||''), colW-16);
          if(sn.length > nameLines){ sn = sn.slice(0,nameLines);
            sn[nameLines-1] = sn[nameLines-1].replace(/[\s,&]+\S*$/,'') + '…'; }
          doc.text(sn, x+11, y+nameTop+fName*0.8, {lineHeightFactor:1.18});
          if(sp.dose != null && showMacros){
            doc.setTextColor(107,87,160); doc.setFontSize(fSmall);
            doc.text(sp.dose + ' ' + (sp.unit||''), x+11, y+macroTop+fSmall);
          }
          return;
        }

        const m = it && it.m;
        if(!m){                                   // nothing at this sitting
          doc.setDrawColor(...C.line); doc.setLineWidth(.6);
          doc.setFillColor(249,251,248);
          doc.roundedRect(x+2, y, colW-4, rowH-6, 5,5,'FD');
          doc.setTextColor(...C.faint); doc.setFontSize(8); doc.setFont('helvetica','normal');
          doc.text('—', x+colW/2, y+rowH/2-2, {align:'center'});
          return;
        }
        // the meal's own targets are the figures; a chef wants the dish name,
        // not the sitting name, whenever a recipe has been chosen
        const rec = RECIPES.find(x=>x.id===m.recipeId);
        const sc  = rec ? scaledRecipe(applySwapsToRecipe(rec, m), {cho:m.cho, pro:m.pro, fat:m.fat}, m.ovr) : null;
        const pro = Math.round((sc&&sc.pro!=null?sc.pro:m.pro)||0);
        const cho = Math.round((sc&&sc.cho!=null?sc.cho:m.cho)||0);
        const fat = Math.round((sc&&sc.fat!=null?sc.fat:m.fat)||0);
        const kcal = Math.round(4*pro + 4*cho + 9*fat);
        // a meal renamed inside this plan shows its new name everywhere
        const title = m.alias || (rec ? rec.name : (m.name||''));
        const st = STATUS(cho);
        // Just the dish and whether it is a low, medium or high carb meal.
        // Times, calories and macros are all on the day pages — squeezing them
        // in here left no room for the one thing the kitchen actually reads.
        doc.setFillColor(...STATUS_TINT(cho));
        doc.setDrawColor(...C.line); doc.setLineWidth(.6);
        doc.roundedRect(x+2, y, colW-4, rowH-6, 5,5,'FD');
        doc.setFillColor(...st); doc.roundedRect(x+2, y, 4, rowH-6, 2,2,'F');

        doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(fBig);
        // both dishes named, so the kitchen sees the whole sitting
        const names = (it.group && it.group.length>1)
          ? it.group.map(mm=>{ const rr=RECIPES.find(x=>x.id===mm.recipeId);
                               return mm.alias || (rr?rr.name:(mm.name||'')); })
                    .filter(Boolean).join('  +  ')
          : String(title);
        let nm = doc.splitTextToSize(names, colW-18);
        const maxL = Math.max(1, Math.floor((rowH-14) / (fBig*1.2)));
        if(nm.length > maxL){
          nm = nm.slice(0, maxL);
          nm[maxL-1] = nm[maxL-1].replace(/[\s,&]+\S*$/,'') + '\u2026';
        }
        const th = nm.length * fBig * 1.2;                 // centre it in the card
        doc.text(nm, x+12, y + (rowH-6-th)/2 + fBig*0.95, {lineHeightFactor:1.2});
      });
    }

    // ---- day totals along the bottom ----
    const ty = gridY + headH + 6 + rows*rowH + 6;
    doc.setTextColor(...C.muted); doc.setFont('helvetica','bold'); doc.setFontSize(8);
    doc.text('DAY TOTAL', pad, ty+16);
    days.forEach((d,i)=>{
      const x = gridX + i*colW, dd = S.days[d];
      /* This showed the TARGET and called it the day total, so a chef reading
         it would believe Saturday delivers 450g of carbohydrate when the food
         on the page comes to 390g. Both are shown now, and the delivered
         figure leads, because that is what is actually being cooked. */
      let gp=0, gc=0, gf=0;
      (dd.meals||[]).forEach(m=>{
        const rec = RECIPES.find(x=>x.id===m.recipeId);
        const ss = rec ? scaledRecipe(applySwapsToRecipe(rec, m),
                          {cho:m.cho, pro:m.pro, fat:m.fat}, m.ovr) : null;
        if(ss){ gp+=ss.pro; gc+=ss.cho; gf+=ss.fat; }
      });
      const gk = Math.round(4*gp + 4*gc + 9*gf);
      const tk = Math.round(4*(dd.pro||0) + 4*(dd.cho||0) + 9*(dd.fat||0));
      const near = Math.abs(gk-tk) <= Math.max(80, tk*0.05);

      doc.setFillColor(238,244,236); doc.roundedRect(x+2, ty, colW-4, 38, 5,5,'F');
      doc.setTextColor(...C.ink); doc.setFont('helvetica','bold'); doc.setFontSize(9);
      doc.text((dd.cleared ? '—' : gk + ' kcal'), x+11, ty+13);
      if(!dd.cleared){
        doc.setFont('helvetica','normal'); doc.setFontSize(7.5);
        doc.setTextColor(...(near ? C.muted : C.red));
        doc.text('P ' + Math.round(gp) + '   C ' + Math.round(gc) +
                 '   F ' + Math.round(gf), x+11, ty+23);
        doc.setFontSize(6.8); doc.setTextColor(...C.faint);
        doc.text('target ' + tk + ' · C ' + Math.round(dd.cho||0), x+11, ty+33);
      }
    });

    // ---- carb key, bottom left ----
    let kx = pad;
    [['LOW', C.red], ['MEDIUM', C.amber], ['HIGH', C.teal]].forEach(([t,col])=>{
      doc.setFillColor(...col); doc.roundedRect(kx, PH-30, 4, 9, 2,2,'F');
      doc.setTextColor(...C.faint); doc.setFont('helvetica','normal'); doc.setFontSize(7.5);
      doc.text(t + ' CARB', kx+9, PH-22);
      kx += doc.getTextWidth(t + ' CARB') + 26;
    });
    doc.setTextColor(...C.faint); doc.setFontSize(8);
    doc.text('CLOSE NUTRITION · PERFORMANCE PLAN', PW-pad, PH-22, {align:'right'});
  }
  weekTimetable();

  /* ---------- SUPPLEMENTS ----------
     A short brief of what is taken and why, then a compact week grid.       */
  function supplementPage(){
    const SLOT_LABEL = {waking:'On waking', breakfast:'With breakfast',
      pre_training:'Pre-training', post_training:'Post-training', snack:'With a snack',
      lunchdinner:'With lunch or dinner', smoothie:'With a smoothie', bed:'Before bed'};
    const ORDER = ['waking','breakfast','pre_training','post_training','snack',
                   'lunchdinner','smoothie','bed'];
    const slotRank = sl => { const i = ORDER.indexOf(sl); return i < 0 ? -1 : i; };

    const days = DAYS.filter(d=>S.days[d]);
    if(!days.length) return;

    // one entry per supplement, for the list at the top
    const seen = {};
    days.forEach(d=>{
      (S.days[d].supps||[]).forEach(sp=>{
        const k = sp.name + '|' + (sp.slot||'');
        if(!seen[k]) seen[k] = {name:sp.name, slot:sp.slot||'', doses:new Set()};
        if(sp.dose != null) seen[k].doses.add(sp.dose + ' ' + (sp.unit||''));
      });
    });
    const brief = Object.keys(seen).map(k=>seen[k]);
    if(!brief.length) return;
    brief.sort((a,b)=>(slotRank(a.slot)-slotRank(b.slot)) || a.name.localeCompare(b.name));

    newPage(); pageBg();
    doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(20);
    doc.text('Supplements', 40, 56);
    doc.setFontSize(10); doc.setTextColor(...C.faint);
    doc.text('WHAT TO TAKE, AND WHEN', 40, 71);
    doc.setFontSize(9); doc.setTextColor(...C.muted);
    doc.text((S.player||'Athlete') + '  ·  these sit alongside the food, not instead of it.',
             40, 86);

    // ---- the list, two to a row to keep it tight ----
    let y = 108;
    const cw2 = (W - 80 - 12) / 2;
    brief.forEach((r,i)=>{
      const col = i % 2, x = 40 + col*(cw2+12);
      if(col === 0 && y > H-150){ newPage(); pageBg(); y = 60; }
      doc.setFillColor(246,244,251); doc.setDrawColor(221,214,238); doc.setLineWidth(.6);
      doc.roundedRect(x, y, cw2, 30, 6,6,'FD');
      doc.setFillColor(122,91,181); doc.roundedRect(x, y, 3.5, 30, 2,2,'F');
      doc.setTextColor(...C.ink); doc.setFont('helvetica','bold'); doc.setFontSize(10);
      const nm = doc.splitTextToSize(r.name, cw2-100);
      doc.text(nm[0] + (nm.length>1?'…':''), x+12, y+13);
      doc.setFont('helvetica','normal'); doc.setFontSize(7.5);
      doc.setTextColor(107,87,160);
      doc.text(SLOT_LABEL[r.slot] || 'Any time', x+12, y+23);
      const dz = [...r.doses];
      if(dz.length){
        doc.setFont('helvetica','bold'); doc.setFontSize(9); doc.setTextColor(...C.ink);
        doc.text(dz.join(' / '), x+cw2-10, y+18, {align:'right'});
      }
      if(col === 1) y += 38;
    });
    if(brief.length % 2 === 1) y += 38;

    // ---- the week, laid out the same way as the food timetable:
    //      times down the left, days across the top ----
    y += 14;
    if(y > H-160){ newPage(); pageBg(); y = 60; }
    doc.setTextColor(...C.muted); doc.setFont('helvetica','bold'); doc.setFontSize(9);
    doc.text('THE WEEK', 40, y);
    y += 14;

    // which slots are actually used
    const usedSlots = [];
    ORDER.concat(['']).forEach(sl=>{
      const any = days.some(d=>(S.days[d].supps||[]).some(sp=>(sp.slot||'')===sl));
      if(any) usedSlots.push(sl);
    });

    const labW = 116, gx = 40 + labW, cw = (W - 80 - labW) / days.length;
    days.forEach((d,i)=>{
      doc.setFillColor(...C.teal);
      doc.roundedRect(gx+i*cw+1, y, cw-2, 17, 3,3,'F');
      doc.setTextColor(...C.white); doc.setFont('helvetica','bold'); doc.setFontSize(7.5);
      doc.text(d.toUpperCase(), gx+i*cw+cw/2, y+11.5, {align:'center'});
    });
    y += 21;

    usedSlots.forEach(sl=>{
      // how tall this row needs to be
      const most = Math.max.apply(null, days.map(d=>
        (S.days[d].supps||[]).filter(sp=>(sp.slot||'')===sl).length));
      // name and dose need a line each — side by side they collide in a
      // column this narrow and read as "Vitamin2000IU"
      const rowH = Math.max(32, 12 + most*21);
      if(y + rowH > H-56){ newPage(); pageBg(); y = 60; }

      doc.setTextColor(...C.muted); doc.setFont('helvetica','bold'); doc.setFontSize(7.5);
      const lb = doc.splitTextToSize((SLOT_LABEL[sl] || 'Any time').toUpperCase(), labW-10);
      doc.text(lb.slice(0,2), 40, y+13);

      days.forEach((d,i)=>{
        const here = (S.days[d].supps||[]).filter(sp=>(sp.slot||'')===sl);
        doc.setDrawColor(...C.line); doc.setLineWidth(.5);
        doc.setFillColor(...(here.length ? [246,244,251] : [250,251,249]));
        doc.roundedRect(gx+i*cw+1, y, cw-2, rowH-4, 4,4,'FD');
        if(!here.length){
          doc.setTextColor(...C.faint); doc.setFont('helvetica','normal'); doc.setFontSize(7);
          doc.text('\u2014', gx+i*cw+cw/2, y+rowH/2, {align:'center'});
          return;
        }
        if(here.length) { doc.setFillColor(122,91,181);
          doc.roundedRect(gx+i*cw+1, y, 3, rowH-4, 1.5,1.5,'F'); }
        let ly = y + 11;
        here.forEach(sp=>{
          doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(6.8);
          const n = doc.splitTextToSize(sp.name, cw-16);
          doc.text(n[0] + (n.length>1?'…':''), gx+i*cw+8, ly);
          if(sp.dose != null){
            doc.setFont('helvetica','bold'); doc.setFontSize(7.4);
            doc.setTextColor(107,87,160);
            doc.text(sp.dose + ' ' + (sp.unit||''), gx+i*cw+8, ly+9);
          }
          ly += 21;
        });
      });
      y += rowH;
    });

    footer('Supplements');
  }
  supplementPage();

  /* ---------- SHOPPING LIST ----------
     Everything in the week added up, grouped the way a shop is laid out.     */
  function shoppingList(){
    // where each swap group sits in a supermarket
    const AISLE = [
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
    // the same rules the builder uses, so the two lists never disagree
    const aisleOf = (g, nm) => (typeof shopAisle === 'function')
      ? shopAisle(g, nm)
      : (function(){ for(const [name, groups] of AISLE)
                       if(groups.indexOf(g) >= 0) return name;
                     return 'Store cupboard'; })();

    // add up every ingredient across every day
    const tally = {};
    DAYS.filter(d=>S.days[d]).forEach(d=>{
      (S.days[d].meals||[]).forEach(m=>{
        const rec = RECIPES.find(x=>x.id===m.recipeId);
        if(!rec) return;
        const sc = scaledRecipe(applySwapsToRecipe(rec, m), {cho:m.cho, pro:m.pro, fat:m.fat}, m.ovr);
        if(!sc || !sc.ings) return;
        sc.ings.forEach(i=>{
          if(i.header || !i.grams) return;
          const raw = (i.name || i.text || '').trim();
          if(!raw) return;
          /* One line per food, not one per spelling. "Greek Yoghurt",
             "0% Greek yoghurt" and "Greek yoghurt — for soaking" were three
             separate entries on the list. Merge on the food it came from
             where we have it, and on a tidied name where we do not. */
          /* Merging on the food's id kept two "melon" rows apart whenever the
             library held two melon entries. What matters is what a person
             reads on the list, so the tidied NAME is the key. */
          const key = raw.toLowerCase()
                 .replace(/\s*—.*$/, '')            // drop "— for soaking"
                 .replace(/\([^)]*\)/g, '')         // and any bracketed note
                 .replace(/\b(raw|dry|dried|fresh|cooked|skinless|lean|trimmed|chopped|diced|sliced|grated)\b/g, '')
                 .replace(/[^a-z0-9 ]/g, ' ')
                 .replace(/\s+/g, ' ').trim();
          if(!tally[key]) tally[key] = {name:raw.replace(/\s*—.*$/, ''), grams:0,
                                        aisle:aisleOf(i.swapGroup, raw),
                                        negligible:i.negligible, unit:i.dunit||'g',
                                        dens:i.dens||1};
          tally[key].grams += i.grams;
        });
      });
    });
    const items = Object.keys(tally).map(k=>tally[k]).filter(x=>x.grams > 0);
    if(!items.length) return;

    // seasonings in gram-or-two amounts are noise on a shopping list
    const MAIN = items.filter(x=>!x.negligible && x.grams >= 15);
    const CUPBOARD = items.filter(x=>x.negligible || x.grams < 15);

    newPage(); pageBg();
    doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(20);
    doc.text('Shopping list', 40, 56);
    // Build the sections first, then split them down the middle, so the list
    // fills both columns evenly instead of running down the left and leaving
    // half the page blank.
    const sections = [];
    AISLE.map(a=>a[0]).forEach(aisle=>{
      const list = MAIN.filter(i=>i.aisle===aisle);
      if(list.length){ list.sort((a,b)=>a.name.localeCompare(b.name));
        sections.push({title:aisle.toUpperCase(), list, taste:false}); }
    });
    if(CUPBOARD.length){
      CUPBOARD.sort((a,b)=>a.name.localeCompare(b.name));
      sections.push({title:'SEASONING — TO TASTE', list:CUPBOARD, taste:true});
    }
    const heightOf = sec => 20 + sec.list.length*(sec.taste?15:21) + 10;
    const total = sections.reduce((n,sec)=>n+heightOf(sec), 0);
    let acc = 0, splitAt = sections.length;
    for(let i=0;i<sections.length;i++){
      if(acc >= total/2){ splitAt = i; break; }
      acc += heightOf(sections[i]);
    }

    let y = 110;
    const col2 = W/2 + 8;
    let x = 40, colw = W/2 - 56;

    /* How things are actually sold. Matched on the food name, first match wins,
       so put the specific ones above the general. These are typical UK
       supermarket sizes — they are assumptions, not data from the shop, and
       the list prints the raw weight alongside so nothing is hidden. */
    const PACKS = [
      [/chicken (breast|mince|thigh)|turkey (breast|mince)/i, 600, 'g', 'pack'],
      [/beef mince|lamb mince|pork mince|steak mince/i,       500, 'g', 'pack'],
      [/steak|beef (fillet|rump|sirloin)|lamb|pork (fillet|loin)/i, 400, 'g', 'pack'],
      [/bacon|chorizo|sausage|ham\b/i,                        300, 'g', 'pack'],
      [/salmon|cod|haddock|sea bass|tuna steak|white fish|mackerel/i, 240, 'g', 'pack of 2'],
      [/prawn|shrimp/i,                                       180, 'g', 'pack'],
      [/\begg/i,                                              60,  'g', 'egg',  6],
      [/milk/i,                                               1000,'ml','litre'],
      [/yoghurt|yogurt|skyr|quark/i,                          500, 'g', 'pot'],
      [/cheese|cheddar|mozzarella|feta|halloumi|parmesan/i,   200, 'g', 'block'],
      [/butter/i,                                             250, 'g', 'pack'],
      [/spinach|rocket|salad leaves|kale/i,                   200, 'g', 'bag'],
      [/broccoli|cauliflower|cabbage/i,                       350, 'g', 'head'],
      [/berries|berry/i,                                      150, 'g', 'punnet'],
      [/banana/i,                                             120, 'g', 'banana'],
      [/avocado/i,                                            170, 'g', 'avocado'],
      [/onion|shallot/i,                                      150, 'g', 'onion'],
      [/garlic/i,                                             50,  'g', 'bulb'],
      [/pepper(?!corn)|courgette|aubergine/i,                 160, 'g', 'each'],
      [/tomato/i,                                             400, 'g', 'pack'],
      [/potato|sweet potato|yam/i,                            1000,'g', 'bag'],
      [/rice|couscous|quinoa|bulgur/i,                        1000,'g', 'bag'],
      [/pasta|spaghetti|penne|noodle/i,                       500, 'g', 'pack'],
      [/oats|porridge|granola|muesli/i,                       1000,'g', 'bag'],
      [/tortilla|wrap\b|flatbread/i,                          40,  'g', 'wrap', 8],
      [/pitta|bagel|roll\b|bun\b|brioche/i,                    70,  'g', 'each', 6],
      [/loaf|sliced bread|wholemeal bread|white bread|sourdough/i, 800,'g','loaf'],
      // dry pulses are sold in bags; it is the tinned ones that come in tins
      [/dried (lentil|chickpea|bean)|lentils?, dry|red lentils?/i, 500,'g','bag'],
      [/tinned|tin of|chickpeas?$|kidney bean|black bean|baked bean|butter bean/i, 400,'g','tin'],
      [/lentil/i,                                             400, 'g', 'tin'],
      [/passata|chopped tomatoes|coconut milk/i,              400, 'g', 'tin'],
      [/\boil\b/i,                                           500, 'ml','bottle'],
      [/nut butter|peanut butter|tahini/i,                    340, 'g', 'jar'],
      [/honey|syrup|jam/i,                                    340, 'g', 'jar'],
      [/sauce|ketchup|mayo|mustard|pesto|vinegar/i,           250, 'ml','bottle'],
      [/almond|cashew|walnut|pecan|pistachio|seed|nuts/i,     200, 'g', 'bag'],
      [/protein powder|whey/i,                                1000,'g', 'tub']
    ];
    const packFor = name => {
      for(const [re, size, unit, label, per] of PACKS)
        if(re.test(name)) return {size, unit, label, per:per||1};
      return null;
    };
    const plural = (n, label) => {
      if(n === 1) return label;
      if(/^pack of/.test(label)) return label.replace('pack','packs');
      if(/(s|ch|sh|x)$/.test(label)) return label + 'es';
      return label + 's';
    };

    const amount = it => {
      const g = it.grams;
      if(it.unit === 'ml') return Math.round(g/(it.dens||1)) + ' ml';
      if(g >= 1000) return (Math.round(g/100)/10) + ' kg';
      if(g >= 100)  return Math.round(g/10)*10 + ' g';
      return Math.round(g) + ' g';
    };
    // what to actually put in the trolley
    const buy = it => {
      const pk = packFor(it.name);
      if(!pk) return null;
      const units = Math.ceil(it.grams / pk.size);
      if(pk.per > 1){                    // sold by the box: eggs
        const boxes = Math.ceil(units / pk.per);
        return units + ' ' + plural(units, pk.label) +
               ' (' + boxes + ' box' + (boxes>1?'es':'') + ' of ' + pk.per + ')';
      }
      if(pk.size >= 1000 && pk.unit === 'g')
        return units + ' × ' + (pk.size/1000) + 'kg ' + plural(units, pk.label);
      if(pk.unit === 'ml' && pk.size >= 1000)
        return units + ' × ' + (pk.size/1000) + 'L ' + plural(units, pk.label);
      if(/each|onion|avocado|banana|egg/.test(pk.label))
        return units + ' ' + plural(units, pk.label);
      return units + ' × ' + pk.size + pk.unit + ' ' + plural(units, pk.label);
    };

    sections.forEach((sec, si)=>{
      if(si === splitAt && x === 40){ x = col2; y = 110; }
      if(y + heightOf(sec) > H - 60){
        if(x === 40){ x = col2; y = 110; }
        else { newPage(); pageBg(); x = 40; y = 70; }
      }

      doc.setFillColor(...C.teal);
      doc.roundedRect(x, y-11, colw, 17, 4,4,'F');
      doc.setTextColor(...C.white); doc.setFont('helvetica','bold'); doc.setFontSize(8.5);
      doc.text(sec.title, x+8, y+1);
      y += 20;

      sec.list.forEach(it=>{
        if(y > H - 56){
          if(x === 40){ x = col2; y = 110; } else { newPage(); pageBg(); x = 40; y = 70; }
        }
        doc.setDrawColor(...C.line); doc.setLineWidth(.7);
        doc.rect(x+3, y-7, 8, 8);                 // tick box
        doc.setFont('helvetica','normal'); doc.setFontSize(9); doc.setTextColor(...C.ink);
        const nm = doc.splitTextToSize(it.name, colw - 120);
        doc.text(nm[0] + (nm.length>1?'…':''), x+18, y);
        const shop = sec.taste ? null : buy(it);
        if(shop){
          doc.setFont('helvetica','bold'); doc.setFontSize(8.5); doc.setTextColor(...C.ink);
          doc.text(shop, x+colw-6, y, {align:'right'});
          doc.setFont('helvetica','normal'); doc.setFontSize(7);
          doc.setTextColor(...C.faint);
          doc.text(amount(it) + ' needed', x+colw-6, y+8, {align:'right'});
          y += 21;
        }else{
          doc.setTextColor(...C.muted); doc.setFontSize(8.5);
          doc.text(sec.taste ? 'to taste' : amount(it), x+colw-6, y, {align:'right'});
          y += 15;
        }
      });
      y += 10;
    });

    footer('Shopping list');
  }
  shoppingList();

  /* ---------- NOTES TO CHEFS ----------
     Just what has been written for this week. The carb-coding explainer and
     the reference list came out — the colour key on the week page says the
     same thing in less space.                                              */
  (function chefNotes(){
    const txt = (S.chefNotes||'').trim();
    if(!txt) return;
    newPage(); pageBg();
    let y = 120;
    doc.setFont('helvetica','normal'); doc.setFontSize(26); doc.setTextColor(...C.ink);
    doc.text('Notes to Chefs', M, y);
    y += 20;
    doc.setFontSize(10); doc.setTextColor(...C.faint);
    doc.text('READ BEFORE COOKING', M, y);
    y += 26;

    const lines = doc.splitTextToSize(txt, W - 2*M - 40);
    const boxH = lines.length*17 + 34;
    doc.setFillColor(...C.bg2); doc.setDrawColor(...C.line); doc.setLineWidth(.9);
    doc.roundedRect(M, y, W-2*M, boxH, 10,10,'FD');
    doc.setFillColor(...C.teal); doc.roundedRect(M, y, 5, boxH, 2,2,'F');
    doc.setTextColor(...C.ink); doc.setFontSize(12);
    doc.text(lines, M+22, y+26, {lineHeightFactor:1.4});

    footer('Notes to Chefs');
  })();

  /* ---------- DAY PAGES ---------- */
  // Days with nothing planned share one page. Seven blank pages in a row made
  // the plan look unfinished rather than deliberate.
  const emptyDays = DAYS.filter(d=>S.days[d] && S.days[d].cleared);
  if(emptyDays.length){
    newPage(); pageBg();
    doc.setFont('helvetica','normal'); doc.setFontSize(24); doc.setTextColor(...C.ink);
    doc.text(emptyDays.length === 1 ? DAYFULL[emptyDays[0]] : 'Days with nothing planned',
             M, 120);
    doc.setFontSize(13); doc.setTextColor(...C.muted);
    doc.text(emptyDays.map(d=>DAYFULL[d]).join('  ·  '), M, 152);
    doc.setFontSize(10); doc.setTextColor(...C.faint);
    doc.text('No meals set — the player is off, or the food is coming from elsewhere.',
             M, 174);
    footer('Nothing planned');
  }

  DAYS.forEach(dk=>{
    const day=S.days[dk];
    if(day && day.cleared) return;
    newPage(); pageBg();
    let y=64;
    // header
    doc.setFont('helvetica','normal'); doc.setFontSize(24); doc.setTextColor(...C.ink);
    doc.text(DAYFULL[dk], M, y);
    doc.setFontSize(11); doc.setTextColor(...C.teal);
    doc.text(day.type.toUpperCase(), W-M, y-14, {align:'right'});
    // day macro target line
    const dkc=Math.round(4*day.pro+4*day.cho+9*day.fat);
    doc.setTextColor(...C.faint); doc.setFontSize(10);
    doc.text(`${dkc} kcal   ·   ${day.pro}g PRO   ·   ${day.cho}g CHO   ·   ${day.fat}g FAT`, M, y+18);
    y+=34; doc.setDrawColor(...C.line); doc.setLineWidth(.8); doc.line(M,y,W-M,y); y+=20;

    // content bottom limit (keeps clear of the footer logo band)
    const BOT=H-84;
    // continuation header — SAME size/style as the main day header
    const contHeader=()=>{
      footer(DAYFULL[dk]); newPage(); pageBg(); y=64;
      doc.setFont('helvetica','normal'); doc.setFontSize(24); doc.setTextColor(...C.ink);
      doc.text(DAYFULL[dk]+' (cont.)', M, y);
      y+=34; doc.setDrawColor(...C.line); doc.setLineWidth(.8); doc.line(M,y,W-M,y); y+=20;
    };

    /* Two dishes at the same sitting are one meal, not two. A rugby player
       having muesli and then eggs on toast reads as one breakfast with two
       things in it — printing "Breakfast" twice made it look like a mistake. */
    const sittings = [];
    day.meals.forEach(m=>{
      const key = String(m.name||'') + '|' + String(m.time||'');
      const last = sittings[sittings.length-1];
      if(last && last.key === key) last.meals.push(m);
      else sittings.push({key, name:m.name, time:m.time, meals:[m]});
    });

    sittings.forEach(sit=>{
    sit.meals.forEach((m, mi)=>{
      const alongside = mi > 0;         // second dish at the same sitting
      const r=RECIPES.find(x=>x.id===m.recipeId);
      const sc=r?scaledRecipe(applySwapsToRecipe(r, m),{cho:m.cho,pro:m.pro,fat:m.fat}, m.ovr):null;
      // estimate block height
      const ings=sc?sc.ings:[];
      doc.setFont('helvetica','normal'); doc.setFontSize(9);
      const ingLines=ings.map(i=>doc.splitTextToSize((i.scaled?'» ':'•  ')+i.text, (W-2*M)-260));
      const ingCount=ingLines.reduce((a,l)=>a+l.length,0);
      // Off unless asked for, meal by meal. A kitchen that makes the porridge
      // every week does not need telling how; a new dish might.
      const dirs=m.printMethod ? (r&&r.directions?r.directions.filter(Boolean):[]) : [];
      const dirLines=dirs.map((d,di)=>doc.splitTextToSize((di+1)+'.  '+d, W-2*M-24));
      const dirCount=dirLines.reduce((a,l)=>a+l.length,0);
      const methodH=dirs.length?(15+dirCount*12+dirs.length*3+8):0;
      // batch note: what to actually make, for anything served in portions
      const makes = Math.max(1, Math.round(+(r&&r.servings) || 1));
      const batchN = (m.batchN != null) ? Math.max(1, Math.round(m.batchN)) : makes;
      const isBatch = makes > 1 && sc && sc.ings;
      let batchLines = [], portionG = 0;
      if(isBatch){
        portionG = Math.round(sc.ings.reduce((t,i)=>t+(i.header?0:(i.grams||0)),0));
        const parts = sc.ings.filter(i=>!i.header && i.grams>0).map(i=>{
          const per = i.amount != null ? i.amount : i.grams;
          const tot = per * batchN;
          const countable = i.unit && i.unit!=='g' && i.unit!=='ml';
          const u = i.dunit || 'g';
          const amt = countable ? (Math.round(tot*100)/100)+' × '
                                : (tot>=1000 ? (Math.round(tot/10)/100)+' kg' : Math.round(tot)+u);
          return amt + ' ' + String(i.name || i.text || '').replace(/^[~\d.,/\s]*(g|ml|kg|tsp|tbsp)?\s*/i,'');
        });
        doc.setFontSize(8.5);
        batchLines = doc.splitTextToSize(parts.join(' · '), W-2*M-30);
      }
      const batchH = isBatch ? (28 + batchLines.length*11) : 0;
      const alts=r?bestMatch(m.cat,{cho:m.cho,pro:m.pro,fat:m.fat},S.excl,r.id).slice(0,3):[];
      const blockH=46 + Math.max(ingCount*12.5+14, 74) + methodH + batchH + 16;
      if(y+blockH > BOT){ contHeader(); }

      const cCho=sc?sc.cho:m.cho;
      const st=STATUS(cCho);
      /* The sitting is named once. A second dish at the same time belongs to
         the same breakfast, so it gets a quiet "and with it" rather than the
         word Breakfast printed twice, which read as a mistake. */
      const headTxt = alongside ? '+  and with it' : String(m.name||'');
      const sitCho = alongside ? cCho
        : sit.meals.reduce((a,mm)=>{
            const rr=RECIPES.find(x=>x.id===mm.recipeId);
            const ss=rr?scaledRecipe(applySwapsToRecipe(rr,mm),
                      {cho:mm.cho,pro:mm.pro,fat:mm.fat}, mm.ovr):null;
            return a + (ss?ss.cho:(mm.cho||0)); }, 0);
      const headSt = STATUS(sitCho);
      doc.setFillColor(...STATUS_TINT(alongside ? cCho : sitCho));
      doc.roundedRect(M,y,W-2*M,30,6,6,'F');
      doc.setFillColor(...(alongside ? st : headSt)); doc.roundedRect(M,y,5,30,2,2,'F');
      doc.setTextColor(...(alongside ? C.muted : C.ink));
      doc.setFont('helvetica','bold'); doc.setFontSize(alongside ? 10.5 : 13);
      doc.text(headTxt, M+18, y+20);
      const nameW=doc.getTextWidth(headTxt);
      // carb tag right — compute its left edge so the time never runs into it
      doc.setFont('helvetica','bold'); doc.setFontSize(9);
      const tagStr = alongside
        ? (cCho + 'g CHO')
        : (STATUSLBL(sitCho) + '  ·  ' + Math.round(sitCho) + 'g CHO' +
           (sit.meals.length>1 ? '  ·  ' + sit.meals.length + ' dishes' : ''));
      const tagLeft=(W-M-16)-doc.getTextWidth(tagStr);
      if(m.time && !alongside){ doc.setFont('helvetica','normal'); doc.setFontSize(10); doc.setTextColor(...C.muted);
        const tx=M+18+nameW+14;
        if(tx+doc.getTextWidth(m.time) < tagLeft-10) doc.text(m.time, tx, y+20); }
      doc.setFont('helvetica','bold'); doc.setFontSize(9);
      doc.setTextColor(...(alongside ? C.faint : headSt));
      doc.text(tagStr, W-M-16, y+19, {align:'right'});
      y+=42;

      if(!sc){ doc.setTextColor(...C.faint); doc.setFontSize(10); doc.text('No matching recipe.', M+18, y); y+=24; return; }

      const colX=M+18, macX=W-M-230;
      // recipe title
      doc.setFont('helvetica','bold'); doc.setFontSize(12); doc.setTextColor(...C.ink);
      const shownName = m.alias || sc.name;
      const tl=doc.splitTextToSize(shownName, macX-colX-12);
      doc.text(tl, colX, y+2);
      let yl=y+2+tl.length*14+2;
      // a renamed meal keeps the real recipe name here, so the kitchen can
      // still look it up
      if(m.alias && m.alias !== sc.name){
        doc.setFont('helvetica','normal'); doc.setFontSize(8.5); doc.setTextColor(...C.faint);
        doc.text(sc.name, colX, yl); yl+=12;
      }
      /* This read "breakfast · Library · Portioned to your macros" under a
         meal already headed Breakfast. It repeated the heading and described
         a scaling that no longer happens. */
      // how many balls or slices this works out as
      const nPort = Math.max(1, Math.round(+r.servings||1));
      if(nPort > 1 && sc.ings){
        const servG = sc.ings.reduce((t,i)=>t+(i.header?0:(i.grams||0)),0);
        const baseG = (r.ings||[]).reduce((t,i)=>t+(i.header?0:(i.grams||0)),0);
        if(servG && baseG){
          const nm0 = String(r.name||'').toLowerCase();
          const halves = /loaf|bread|cake|bar|brownie|blondie|flapjack/.test(nm0);
          const n = halves ? Math.round(servG/baseG*2)/2 : Math.round(servG/baseG);
          const word = /ball|bite|truffle/.test(nm0) ? 'ball'
                     : /loaf|bread|cake/.test(nm0) ? 'slice'
                     : /muffin|cupcake/.test(nm0) ? 'muffin'
                     : /bar|brownie|blondie|flapjack/.test(nm0) ? 'piece'
                     : /pancake|waffle/.test(nm0) ? 'pancake' : 'portion';
          if(n){
            doc.setFont('helvetica','bold'); doc.setFontSize(9); doc.setTextColor(122,95,16);
            doc.text(n + ' ' + word + (n===1?'':'s') + '  ·  ' + Math.round(servG) + 'g',
                     colX, yl);
            yl += 14;
          }
        }
      }
      /* "Made without garlic" meant nothing to a chef who has never seen the
         original recipe — the ingredient list below already IS the dish as it
         is to be cooked. Nothing to add. */
      // ingredients
      doc.setFontSize(9);
      ings.forEach((i,ix)=>{
        const lines=ingLines[ix];
        doc.setTextColor(...(i.scaled?C.teal:C.muted));
        doc.setFont('helvetica', i.scaled?'bold':'normal');
        doc.text(lines, colX, yl); yl+=lines.length*12.5;
      });

      // macro card (right)
      const cardY=y-2;
      doc.setFillColor(246,249,244); doc.setDrawColor(...C.line); doc.setLineWidth(.8);
      doc.roundedRect(macX,cardY,214,66,6,6,'FD');
      doc.setFont('helvetica','normal'); doc.setFontSize(8); doc.setTextColor(...C.faint);
      doc.text('DELIVERS', macX+14, cardY+16);
      const macs=[['PROTEIN',sc.pro,C.teal],['CARB',sc.cho,C.amber],['FAT',sc.fat,C.red]];
      macs.forEach((mm,i)=>{ const xx=macX+14+i*66;
        doc.setTextColor(...mm[2]); doc.setFont('helvetica','bold'); doc.setFontSize(15);
        doc.text(String(mm[1])+'g', xx, cardY+38);
        doc.setTextColor(...C.faint); doc.setFont('helvetica','normal'); doc.setFontSize(7);
        doc.text(mm[0], xx, cardY+50); });
      doc.setTextColor(...C.ink); doc.setFontSize(9); doc.setFont('helvetica','bold');
      doc.text(sc.kcal+' kcal', macX+14, cardY+62);

      y=Math.max(yl, cardY+66)+8;

      // METHOD (cooking instructions) — full width for readability
      if(dirs.length){
        if(y+26 > BOT) contHeader();
        doc.setFont('helvetica','bold'); doc.setFontSize(8); doc.setTextColor(...C.faint);
        doc.text('METHOD', colX, y); y+=13;
        doc.setFont('helvetica','normal'); doc.setFontSize(9); doc.setTextColor(...C.muted);
        dirs.forEach((d,di)=>{
          const dl=doc.splitTextToSize((di+1)+'.  '+d, W-2*M-24);
          if(y+dl.length*12 > BOT){ contHeader();
            doc.setFont('helvetica','normal'); doc.setFontSize(9); doc.setTextColor(...C.muted); }
          doc.text(dl, colX, y); y+=dl.length*12+3;
        });
        y+=6;
      }
      // alternatives
      if(isBatch){
        // the plan counts one portion; this is what the kitchen actually makes
        const bh = 20 + batchLines.length*11;
        doc.setFillColor(253,250,241); doc.setDrawColor(224,217,196); doc.setLineWidth(.7);
        doc.roundedRect(colX-6, y-4, W-M-colX+6, bh, 6,6,'FD');
        doc.setTextColor(122,95,16); doc.setFont('helvetica','bold'); doc.setFontSize(7.5);
        doc.text('BATCH COOK  ·  MAKES ' + batchN + '  ·  ABOUT ' + portionG + 'g A PORTION',
                 colX+4, y+8);
        doc.setFont('helvetica','normal'); doc.setFontSize(8.5); doc.setTextColor(...C.muted);
        doc.text(batchLines, colX+4, y+20, {lineHeightFactor:1.3});
        y += bh + 8;
      }
      /* The alternatives list came off: the plan says what is being cooked,
         and offering swaps on a printed page only invites confusion. */
      doc.setDrawColor(...C.line); doc.setLineWidth(.5); doc.line(M,y,W-M,y); y+=14;
    });
    });
    footer(DAYFULL[dk]);
  });

  const fname=(S.player||'Athlete').replace(/[^a-z0-9]+/gi,'_')+'_Close_Nutrition_Plan.pdf';
  doc.save(fname);
  toast('PDF exported');
}

/* ============ PHONE EXPORT ============
   Same plan, page shaped like a phone so it reads full-width with no pinching.
   One day per page, in the order the day happens. No method, no shopping list —
   this is for the person eating it, not the person cooking it.              */
function exportPhonePDF(mode){
  // 'player' leaves out the per-day recipe pages — the week page already lists
  // every meal, so they still see what they are eating, just not how it is made
  const playerOnly = mode === 'player';
  const { jsPDF } = window.jspdf;
  const W = 390, H = 844;                       // a phone screen, in points
  const doc = new jsPDF({unit:'pt', format:[W,H], orientation:'portrait'});
  const C={bg:[244,247,242], bg2:[255,255,255], line:[219,226,213], ink:[23,35,27],
    muted:[88,97,88], faint:[139,150,139], teal:[0,121,52], amber:[201,138,0],
    red:[239,109,0], white:[255,255,255], purple:[122,91,181], purpleBg:[246,244,251]};
  const STATUS = c => c<40?C.red : (c<=70?C.amber:C.teal);
  const SLOT_LABEL = {waking:'ON WAKING', breakfast:'WITH BREAKFAST',
    pre_training:'PRE-TRAINING', post_training:'POST-TRAINING', snack:'WITH A SNACK',
    lunchdinner:'WITH LUNCH OR DINNER', smoothie:'WITH A SMOOTHIE', bed:'BEFORE BED'};
  const SLOT_TIME = {waking:'07:00', breakfast:'08:00', pre_training:'11:00',
    post_training:'15:00', snack:'16:00', lunchdinner:'13:00', smoothie:'11:30', bed:'22:00'};
  const mins = t => { const m=/^(\d{1,2})[:.](\d{2})/.exec(String(t||'')); 
                      return m ? (+m[1])*60+(+m[2]) : 1230; };
  const pad = 18;
  let y = 0;

  const bg = () => { doc.setFillColor(...C.bg); doc.rect(0,0,W,H,'F'); };
  // the same footer as the A4: small logo bottom-left, wordmark bottom-right
  const foot = label => {
    try{ const lw=26, lh=lw*1.216; doc.addImage(LOGO_BLACK,'PNG',pad,H-lh-14,lw,lh); }catch(e){}
    doc.setTextColor(...C.faint); doc.setFont('helvetica','normal'); doc.setFontSize(6.5);
    doc.text('CLOSE NUTRITION · PERFORMANCE PLAN', W-pad, H-24, {align:'right'});
    if(label) doc.text(label, W-pad, H-15, {align:'right'});
  };
  // a green banner heading, used on every section page
  const banner = (title, sub) => {
    doc.setFillColor(...C.teal); doc.rect(0,0,W,84,'F');
    try{ const lw=22, lh=lw*1.216; doc.addImage(LOGO_WHITE,'PNG',W-pad-lw,24,lw,lh); }catch(e){}
    doc.setTextColor(...C.white); doc.setFont('helvetica','bold'); doc.setFontSize(20);
    doc.text(title, pad, 48);
    doc.setFont('helvetica','normal'); doc.setFontSize(9); doc.setTextColor(214,234,220);
    doc.text(sub, pad, 66);
  };
  const newPage = () => { doc.addPage([W,H],'portrait'); bg(); y = 0; };

  bg();

  // ---------- cover, laid out like the A4 one ----------
  try{ const lw=110, lh=lw*1.216; doc.addImage(LOGO_BLACK,'PNG',(W-lw)/2, 150, lw, lh); }catch(e){}
  doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(22);
  doc.text(String(S.player||'Athlete').toUpperCase(), W/2, 360,
           {align:'center', maxWidth:W-pad*2});
  doc.setDrawColor(...C.teal); doc.setLineWidth(1.2);
  doc.line(W/2-46, 378, W/2+46, 378);
  doc.setTextColor(...C.muted); doc.setFontSize(11);
  doc.text(playerOnly ? 'YOUR WEEK' : 'PERFORMANCE NUTRITION PLAN', W/2, 402, {align:'center'});
  const mth = new Date().toLocaleDateString('en-GB',{month:'long',year:'numeric'}).toUpperCase();
  doc.setTextColor(...C.faint); doc.setFontSize(9.5);
  doc.text(mth, W/2, 422, {align:'center'});
  if(S.bw){ doc.setTextColor(...C.muted); doc.setFontSize(10);
            doc.text(S.bw + 'kg', W/2, 452, {align:'center'}); }
  foot('');

  // ---------- the week at a glance ----------
  newPage();
  banner('Your week', 'EVERY DAY AT A GLANCE');
  y = 104;
  const days = DAYS.filter(d=>S.days[d]);
  days.forEach(d=>{
    const day = S.days[d];
    const kcal = Math.round(4*(day.pro||0) + 4*(day.cho||0) + 9*(day.fat||0));
    doc.setFillColor(...C.bg2); doc.setDrawColor(...C.line); doc.setLineWidth(.8);
    doc.roundedRect(pad, y, W-pad*2, 44, 9,9,'FD');
    doc.setTextColor(...C.ink); doc.setFont('helvetica','bold'); doc.setFontSize(12);
    doc.text(DAYFULL[d], pad+14, y+19);
    doc.setFont('helvetica','normal'); doc.setFontSize(8); doc.setTextColor(...C.faint);
    doc.text(String(day.type||'Normal').toUpperCase(), pad+14, y+32);
    doc.setTextColor(...C.muted); doc.setFontSize(9);
    doc.text(kcal + ' kcal', W-pad-14, y+19, {align:'right'});
    doc.setFontSize(7.5); doc.setTextColor(...C.faint);
    doc.text('P ' + Math.round(day.pro||0) + '  C ' + Math.round(day.cho||0) +
             '  F ' + Math.round(day.fat||0), W-pad-14, y+32, {align:'right'});
    y += 52;
  });

  // ---------- notes for the chef, straight after the cover ----------
  const notes = (S.chefNotes||'').trim();
  if(notes){
    newPage();
    banner('Notes', 'READ BEFORE COOKING');
    doc.setFillColor(...C.bg2); doc.setDrawColor(...C.line); doc.setLineWidth(.8);
    const nl = doc.splitTextToSize(notes, W-pad*2-28);
    doc.roundedRect(pad, 104, W-pad*2, nl.length*17+30, 10,10,'FD');
    doc.setTextColor(...C.ink); doc.setFontSize(11);
    doc.text(nl, pad+14, 128, {lineHeightFactor:1.5});
  }

  // ---------- the week, stacked rather than in columns ----------
  const SLOT_T = SLOT_TIME;
  newPage();
  banner('The week', 'EVERY MEAL, IN ORDER');
  y = 104;
  days.forEach(d=>{
    const day = S.days[d];
    const meals = day.cleared ? [] : (day.meals||[]).slice().sort((a,b)=>mins(a.time)-mins(b.time));
    const blockH = 30 + (meals.length ? meals.length*17 : 17) + 10;
    if(y + blockH > H-24){ newPage(); y = 24; }
    doc.setFillColor(...C.bg2); doc.setDrawColor(...C.line); doc.setLineWidth(.8);
    doc.roundedRect(pad, y, W-pad*2, blockH, 10,10,'FD');
    // no orange here either — it is the low carb colour, and a game day is a
    // high carb day. Match day is marked by weight, not by colour.
    const isMatch = /^game day$/i.test(String(day.type||''));
    doc.setFillColor(...C.teal);
    doc.roundedRect(pad, y, isMatch ? 7 : 4, blockH, 2,2,'F');
    doc.setTextColor(...C.ink); doc.setFont('helvetica','bold'); doc.setFontSize(12);
    doc.text(DAYFULL[d], pad+16, y+20);
    doc.setFont('helvetica', isMatch ? 'bold' : 'normal'); doc.setFontSize(7.5);
    doc.setTextColor(...(isMatch ? C.ink : C.faint));
    doc.text(String(day.type||'Normal').toUpperCase(), pad+16+doc.getTextWidth(DAYFULL[d])+38, y+20);
    doc.setFont('helvetica','normal');
    doc.setTextColor(...C.muted); doc.setFontSize(8.5);
    doc.text(Math.round(4*(day.pro||0)+4*(day.cho||0)+9*(day.fat||0)) + ' kcal',
             W-pad-14, y+20, {align:'right'});
    let my = y + 36;
    if(day.cleared){
      doc.setTextColor(...C.faint); doc.setFont('helvetica','normal'); doc.setFontSize(9);
      doc.text('Nothing planned on this day', pad+14, my);
    }
    meals.forEach(m=>{
      const rec = RECIPES.find(x=>x.id===m.recipeId);
      const nm = m.alias || (rec ? rec.name : (m.name||''));
      doc.setTextColor(...C.faint); doc.setFont('helvetica','bold'); doc.setFontSize(7.5);
      doc.text(String(m.time||''), pad+14, my);
      doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(9);
      const t = doc.splitTextToSize(nm, W-pad*2-76);
      doc.text(t[0] + (t.length>1?'…':''), pad+56, my);
      my += 17;
    });
    y += blockH + 10;
  });

  // ---------- supplements ----------
  const sBrief = {};
  days.forEach(d=>(S.days[d].supps||[]).forEach(sp=>{
    const k = sp.name+'|'+(sp.slot||'');
    if(!sBrief[k]) sBrief[k]={name:sp.name, slot:sp.slot||'', dose:sp.dose, unit:sp.unit,
                              days:[]};
    sBrief[k].days.push(d);
  }));
  const sList = Object.keys(sBrief).map(k=>sBrief[k]);
  if(sList.length){
    newPage();
    banner('Supplements', 'WHAT TO TAKE, AND WHEN');
    y = 104;
    sList.forEach(sp=>{
      if(y > H-70){ newPage(); y = 24; }
      doc.setFillColor(...C.purpleBg); doc.setDrawColor(221,214,238); doc.setLineWidth(.7);
      doc.roundedRect(pad, y, W-pad*2, 48, 9,9,'FD');
      doc.setFillColor(...C.purple); doc.roundedRect(pad, y, 4, 48, 2,2,'F');
      doc.setTextColor(...C.ink); doc.setFont('helvetica','bold'); doc.setFontSize(12);
      doc.text(sp.name, pad+14, y+19, {maxWidth:W-pad*2-96});
      doc.setFont('helvetica','normal'); doc.setFontSize(7.5); doc.setTextColor(107,87,160);
      doc.text(SLOT_LABEL[sp.slot] || 'ANY TIME', pad+14, y+32);
      doc.setTextColor(...C.faint); doc.setFontSize(7);
      doc.text(sp.days.length === days.length ? 'Every day' : sp.days.join(', '),
               pad+14, y+42);
      if(sp.dose != null){
        doc.setFont('helvetica','bold'); doc.setFontSize(13); doc.setTextColor(107,87,160);
        doc.text(sp.dose + ' ' + (sp.unit||''), W-pad-14, y+28, {align:'right'});
      }
      y += 56;
    });
  }

  // ---------- shopping list, same content as the A4 in one column ----------
  // left out of the player version — it is for whoever does the shopping
  if(!playerOnly) (function phoneShoppingList(){
    const AISLE = [
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
    const aisleOf = g => { for(const [n,gs] of AISLE) if(gs.indexOf(g)>=0) return n;
                           return 'Store cupboard'; };
    const PACKS = [
      [/chicken (breast|mince|thigh)|turkey (breast|mince)/i, 600,'g','pack'],
      [/beef mince|lamb mince|pork mince|steak mince/i, 500,'g','pack'],
      [/steak|beef (fillet|rump|sirloin)|lamb|pork (fillet|loin)/i, 400,'g','pack'],
      [/bacon|chorizo|sausage|ham\b/i, 300,'g','pack'],
      [/salmon|cod|haddock|sea bass|tuna steak|white fish|mackerel/i, 240,'g','pack of 2'],
      [/prawn|shrimp/i, 180,'g','pack'],
      [/\begg/i, 60,'g','egg',6],
      [/milk/i, 1000,'ml','litre'],
      [/yoghurt|yogurt|skyr|quark/i, 500,'g','pot'],
      [/cheese|cheddar|mozzarella|feta|halloumi|parmesan/i, 200,'g','block'],
      [/butter/i, 250,'g','pack'],
      [/spinach|rocket|salad leaves|kale/i, 200,'g','bag'],
      [/broccoli|cauliflower|cabbage/i, 350,'g','head'],
      [/berries|berry/i, 150,'g','punnet'],
      [/banana/i, 120,'g','banana'],
      [/avocado/i, 170,'g','avocado'],
      [/onion|shallot/i, 150,'g','onion'],
      [/garlic/i, 50,'g','bulb'],
      [/pepper(?!corn)|courgette|aubergine/i, 160,'g','each'],
      [/tomato/i, 400,'g','pack'],
      [/potato|sweet potato|yam/i, 1000,'g','bag'],
      [/rice|couscous|quinoa|bulgur/i, 1000,'g','bag'],
      [/pasta|spaghetti|penne|noodle/i, 500,'g','pack'],
      [/oats|porridge|granola|muesli/i, 1000,'g','bag'],
      [/bread|loaf|bagel|wrap|tortilla|pitta/i, 800,'g','loaf'],
      // dry pulses are sold in bags; it is the tinned ones that come in tins
      [/dried (lentil|chickpea|bean)|lentils?, dry|red lentils?/i, 500,'g','bag'],
      [/tinned|tin of|chickpeas?$|kidney bean|black bean|baked bean|butter bean/i, 400,'g','tin'],
      [/lentil/i,                                             400, 'g', 'tin'],
      [/passata|chopped tomatoes|coconut milk/i, 400,'g','tin'],
      [/\boil\b/i, 500,'ml','bottle'],
      [/nut butter|peanut butter|tahini/i, 340,'g','jar'],
      [/honey|syrup|jam/i, 340,'g','jar'],
      [/sauce|ketchup|mayo|mustard|pesto|vinegar/i, 250,'ml','bottle'],
      [/almond|cashew|walnut|pecan|pistachio|seed|nuts/i, 200,'g','bag'],
      [/protein powder|whey/i, 1000,'g','tub']
    ];
    const packFor = n => { for(const [re,size,unit,label,per] of PACKS)
      if(re.test(n)) return {size,unit,label,per:per||1}; return null; };
    const plural = (n,l) => n===1 ? l :
      (/^pack of/.test(l) ? l.replace('pack','packs') : (/(s|ch|sh|x)$/.test(l)? l+'es' : l+'s'));

    const tally = {};
    days.forEach(d=>{
      (S.days[d].meals||[]).forEach(m=>{
        const rec = RECIPES.find(x=>x.id===m.recipeId); if(!rec) return;
        const sc = scaledRecipe(applySwapsToRecipe(rec, m), {cho:m.cho,pro:m.pro,fat:m.fat}, m.ovr);
        if(!sc || !sc.ings) return;
        sc.ings.forEach(i=>{
          if(i.header || !i.grams) return;
          const key=(i.name||i.text||'').trim(); if(!key) return;
          if(!tally[key]) tally[key]={name:key,grams:0,aisle:aisleOf(i.swapGroup),
            negligible:i.negligible,unit:i.dunit||'g',dens:i.dens||1};
          tally[key].grams += i.grams;
        });
      });
    });
    const items = Object.keys(tally).map(k=>tally[k]).filter(x=>x.grams>0);
    if(!items.length) return;
    const MAIN = items.filter(x=>!x.negligible && x.grams>=15);
    const CUP  = items.filter(x=>x.negligible || x.grams<15);

    const amount = it => { const g=it.grams;
      if(it.unit==='ml') return Math.round(g/(it.dens||1))+' ml';
      if(g>=1000) return (Math.round(g/100)/10)+' kg';
      if(g>=100) return Math.round(g/10)*10+' g';
      return Math.round(g)+' g'; };
    const buy = it => { const pk=packFor(it.name); if(!pk) return null;
      const u=Math.ceil(it.grams/pk.size);
      if(pk.per>1){ const b=Math.ceil(u/pk.per);
        return u+' '+plural(u,pk.label)+' ('+b+' box'+(b>1?'es':'')+' of '+pk.per+')'; }
      if(pk.size>=1000 && pk.unit==='g') return u+' × '+(pk.size/1000)+'kg '+plural(u,pk.label);
      if(pk.unit==='ml' && pk.size>=1000) return u+' × '+(pk.size/1000)+'L '+plural(u,pk.label);
      if(/each|onion|avocado|banana|egg/.test(pk.label)) return u+' '+plural(u,pk.label);
      return u+' × '+pk.size+pk.unit+' '+plural(u,pk.label); };

    newPage();
    banner('Shopping list', '');
    y = 102;

    const sections = [];
    AISLE.map(a=>a[0]).forEach(a=>{
      const l = MAIN.filter(i=>i.aisle===a);
      if(l.length){ l.sort((x,z)=>x.name.localeCompare(z.name));
        sections.push({title:a.toUpperCase(), list:l, taste:false}); }
    });
    if(CUP.length){ CUP.sort((x,z)=>x.name.localeCompare(z.name));
      sections.push({title:'SEASONING — TO TASTE', list:CUP, taste:true}); }

    sections.forEach(sec=>{
      if(y + 34 > H-30){ newPage(); y = 24; }
      doc.setFillColor(...C.teal);
      doc.roundedRect(pad, y, W-pad*2, 18, 4,4,'F');
      doc.setTextColor(...C.white); doc.setFont('helvetica','bold'); doc.setFontSize(8);
      doc.text(sec.title, pad+10, y+12.5);
      y += 26;
      sec.list.forEach(it=>{
        const rowH = sec.taste ? 18 : 24;
        if(y + rowH > H-26){ newPage(); y = 24; }
        doc.setDrawColor(...C.line); doc.setLineWidth(.8);
        doc.setFillColor(...C.bg2);
        doc.rect(pad+4, y+2, 9, 9, 'FD');            // tick box
        doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(9.5);
        const nm = doc.splitTextToSize(it.name, W-pad*2-130);
        doc.text(nm[0]+(nm.length>1?'…':''), pad+22, y+10);
        const shop = sec.taste ? null : buy(it);
        if(shop){
          doc.setFont('helvetica','bold'); doc.setFontSize(9); doc.setTextColor(...C.ink);
          doc.text(shop, W-pad-4, y+10, {align:'right'});
          doc.setFont('helvetica','normal'); doc.setFontSize(7); doc.setTextColor(...C.faint);
          doc.text(amount(it)+' needed', W-pad-4, y+19, {align:'right'});
        }else{
          doc.setTextColor(...C.muted); doc.setFontSize(8.5);
          doc.text(sec.taste ? 'to taste' : amount(it), W-pad-4, y+10, {align:'right'});
        }
        y += rowH;
      });
      y += 10;
    });
  })();

  // ---------- one page per day ----------
  if(!playerOnly) days.forEach(d=>{
    const day = S.days[d];
    if(day && day.cleared) return;
    newPage();

    doc.setFillColor(...C.teal); doc.rect(0,0,W,96,'F');
    try{ const lw=18, lh=lw*1.216; doc.addImage(LOGO_WHITE,'PNG',W-pad-lw,8,lw,lh); }catch(e){}
    doc.setTextColor(...C.white); doc.setFont('helvetica','bold'); doc.setFontSize(22);
    doc.text(DAYFULL[d], pad, 50);
    doc.setFont('helvetica','normal'); doc.setFontSize(10); doc.setTextColor(214,234,220);
    doc.text(String(day.type||'Normal'), pad, 70);
    const dk = Math.round(4*(day.pro||0)+4*(day.cho||0)+9*(day.fat||0));
    doc.setFontSize(12); doc.setTextColor(...C.white);
    doc.text(dk + ' kcal', W-pad, 50, {align:'right'});
    doc.setFontSize(8.5); doc.setTextColor(214,234,220);
    doc.text('P ' + Math.round(day.pro||0) + '  C ' + Math.round(day.cho||0) +
             '  F ' + Math.round(day.fat||0), W-pad, 72, {align:'right'});
    y = 118;

    // meals and supplements on one timeline, the way the day happens
    // supplements at the top of the day, same as in the builder
    // a second dish at the same sitting follows the first, under one heading
    const grouped=[];
    (day.meals||[]).forEach(m=>{
      const key=String(m.name||'')+'|'+String(m.time||'');
      const last=grouped[grouped.length-1];
      if(last && last.key===key) last.list.push(m);
      else grouped.push({key, list:[m]});
    });
    const items = (day.supps||[]).map(sp=>({kind:'supp', sp, at:-1}))
      .concat(grouped.flatMap(g=>g.list.map((m,i)=>({
        kind:'meal', m, at:mins(m.time), alongside:i>0}))))
      .sort((a,b)=>a.at-b.at);

    items.forEach(it=>{
      if(it.kind === 'supp'){
        const sp = it.sp;
        if(y > H-70){ newPage(); y = 24; }
        doc.setFillColor(...C.purpleBg); doc.setDrawColor(221,214,238); doc.setLineWidth(.7);
        doc.roundedRect(pad, y, W-pad*2, 40, 9,9,'FD');
        doc.setFillColor(...C.purple); doc.roundedRect(pad, y, 4, 40, 2,2,'F');
        doc.setTextColor(107,87,160); doc.setFont('helvetica','bold'); doc.setFontSize(7);
        doc.text(SLOT_LABEL[sp.slot] || 'ANY TIME', pad+14, y+15);
        doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(11);
        doc.text(String(sp.name||''), pad+14, y+30, {maxWidth:W-pad*2-90});
        if(sp.dose != null){
          doc.setFont('helvetica','bold'); doc.setFontSize(11); doc.setTextColor(107,87,160);
          doc.text(sp.dose + ' ' + (sp.unit||''), W-pad-14, y+27, {align:'right'});
        }
        y += 48;
        return;
      }

      const m = it.m;
      const rec = RECIPES.find(x=>x.id===m.recipeId);
      const sc = rec ? scaledRecipe(applySwapsToRecipe(rec, m), {cho:m.cho, pro:m.pro, fat:m.fat}, m.ovr) : null;
      const pro = Math.round((sc&&sc.pro!=null?sc.pro:m.pro)||0);
      const cho = Math.round((sc&&sc.cho!=null?sc.cho:m.cho)||0);
      const fat = Math.round((sc&&sc.fat!=null?sc.fat:m.fat)||0);
      const kc  = Math.round(4*pro + 4*cho + 9*fat);
      const title = m.alias || (rec ? rec.name : (m.name||''));
      const ings = (sc && sc.ings ? sc.ings.filter(i=>!i.header && i.text) : []);

      doc.setFontSize(12.5);
      const titleLines = doc.splitTextToSize(title, W-pad*2-40).slice(0,3);
      const ingLines = [];
      ings.forEach(i=>{ doc.setFontSize(8.5);
        doc.splitTextToSize('•  ' + i.text, W-pad*2-28).forEach(l=>ingLines.push(l)); });
      const cardH = 54 + titleLines.length*15 + ingLines.length*11.5;

      if(y + cardH > H-30){ newPage(); y = 24; }

      doc.setFillColor(...C.bg2); doc.setDrawColor(...C.line); doc.setLineWidth(.8);
      doc.roundedRect(pad, y, W-pad*2, cardH, 10,10,'FD');
      doc.setFillColor(...STATUS(cho)); doc.roundedRect(pad, y, 4, cardH, 2,2,'F');

      doc.setTextColor(...C.faint); doc.setFont('helvetica','bold'); doc.setFontSize(8);
      doc.text(it.alongside ? '+  AND WITH IT'
             : ((function(t){ const v=mins(t);
                  return String(Math.floor(v/60)%24).padStart(2,'0')+':'+String(v%60).padStart(2,'0');
                })(m.time) + '   ·   ' + String(m.name||'').toUpperCase()),
               pad+14, y+17);
      doc.setTextColor(...C.ink); doc.setFont('helvetica','normal'); doc.setFontSize(12.5);
      doc.text(titleLines, pad+14, y+34, {lineHeightFactor:1.22});

      let ly = y + 34 + titleLines.length*15 + 4;
      doc.setTextColor(...C.muted); doc.setFontSize(8.5);
      doc.text(ingLines, pad+14, ly, {lineHeightFactor:1.35});
      ly += ingLines.length*11.5 + 8;

      doc.setDrawColor(...C.line); doc.setLineWidth(.5);
      doc.line(pad+14, ly-6, W-pad-14, ly-6);
      doc.setTextColor(...C.ink); doc.setFont('helvetica','bold'); doc.setFontSize(9.5);
      doc.text(kc + ' kcal', pad+14, ly+6);
      doc.setFont('helvetica','normal'); doc.setTextColor(...C.muted); doc.setFontSize(9);
      doc.text('P ' + pro + '    C ' + cho + '    F ' + fat, W-pad-14, ly+6, {align:'right'});

      y += cardH + 10;
    });
  });

  // footers last, so every page gets one including any that spilled
  const total = doc.internal.getNumberOfPages();
  for(let p=2; p<=total; p++){ doc.setPage(p); foot(''); }

  const safe = String(S.player||'plan').replace(/[^a-z0-9]+/gi,'-').toLowerCase();
  doc.save('close-nutrition-' + safe + (playerOnly ? '-player' : '-phone') + '.pdf');
}
