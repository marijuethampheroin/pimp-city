# FAQ Synthesis — Pimp City Reference
> Compiled from all archived FAQs. Use this alongside PROJECT_PIMP.md.
> Sources span 2003–2026 across two separate games (IdlePimps → Pimpageddon).
> Where values conflict, **Pimpageddon values take precedence** — confirmed via
> the official game guide and the updated CrazyJap Pimpageddon port.

---

## Source Materials

| File | Author | Era | Game |
|---|---|---|---|
| `official_game_guide.html` | Pimpageddon admins | 2026 | Pimpageddon ✅ authoritative |
| `crazyjap_faq.html` | CrazyJap (ported) | ~2015? | Pimpageddon ✅ authoritative |
| `(CrazyJap)My FAQ.html` | CrazyJap (original) | ~2004 | IdlePimps ⚠️ old values |
| `THEGANKSTAS IDLEPIMPS FAQ's.html` | TheGanksta | 2003 | IdlePimps ⚠️ old values |
| `theganksta.html` | TheGanksta | ~2003 | IdlePimps ⚠️ old values |
| `VIOLATE'S F.A.Q..html` | Violate | ~2005? | IdlePimps ⚠️ old values |
| `Rut's IdleGuide*.html` (7 parts) | Rutgers | 2008–2009 | IdlePimps ⚠️ old values |

---

## Net Worth Values — CONFIRMED FOR PIMPAGEDDON

```
NW = cash + (hoes × 250) + (thugs × 1000) + (rides × 1000) + (crack × 2)
```

**Items that do NOT affect NW (wealth hiding):**
- AK-47s
- Weed
- Beer
- Condoms
- Kevlar Vests (note: Vests DID add to NW in original IdlePimps at $3,000 each — removed in Pimpageddon)

**Historical IdlePimps values (DO NOT USE — for reference only):**
- Thugs = $750, Hoes = $500, Vests = $3,000, Crack = $5, Rides = $500

---

## Key Formulas — CONFIRMED FOR PIMPAGEDDON

### Crack to Steal Hoes
```
crack_estimate = NW - [(hoes × 250) + (thugs × 1000) + (rides × 1000)]
crack_to_send  = crack_estimate / 6.6
```
- Gives you the amount of crack in the target's NW, then divides by 6.6 for optimal steal
- Sending too much or too little both reduce the hit (too much = diminishing returns)
- If target has cash on hand or vests, formula overestimates — send less
- If you get <100 hoes, you sent too much; try ~1/10th the amount

### Detecting Unhappy Hoes
```
crack_on_hand = NW - [(hoes × 250) + (thugs × 1000) + (rides × 1000)] / 2
```
*(divide by crack's NW value of 2 — same numerator as steal formula)*

Then: if (crack_on_hand / 10) < hoes → hoes are UNHAPPY → send 1 crack rock to steal

- Payout being set high will interfere (high payout = fewer crack needed = hoes appear happier)
- If target is sitting on raw cash, formula will overestimate their crack
- "Send 1 crack rock" exploit: if hoes are unhappy, even 1 rock can steal some

### Attack Range
```
min_NW = attacker_NW × 0.5
max_NW = attacker_NW × 2.0
```
Target must also be in the **same city**.

---

## Payout Mechanic

- Default starting payout: **10%** — players immediately change to **1%**
- Minimum possible: **1%** (cannot set to 0%)
- Payout = percentage of trick earnings given to hoes as their cut
- **At 1% payout:** hoes need **crack × 10 per hoe** to stay happy (crack is primary supply)
- **At 100% payout:** hoes need almost no crack (~hoes / 100) — their earnings keep them happy
- **Strategic use of 100% payout:** suppresses visible NW (less crack stored = lower NW),
  making the player a less attractive gank/steal target. A defensive trick.

---

## Hoe & Thug Happiness

### Hoe Happiness
- Requires: **condoms** + **crack**
- At 1% payout: need **hoes × 10** crack to stay at 100% happiness
- At 100% payout: need roughly **hoes / 100** crack (payout supplements happiness)
- Consuming turns also consumes crack and condoms — always keep more than the minimum
- Unhappy hoes can be stolen with 1 crack rock from an enemy
- Any hoe below 100% happy is vulnerable — the official guide is explicit on this

### Thug Happiness
- Requires: **weed** + **beer** (both)
- Needs **1 AK-47 per thug** for full combat effectiveness
- Unhappy thugs lose more fights: "50k unhappy thugs vs 25k happy thugs — happy wins"
- Beer is effectively NW-neutral wealth storage (doesn't show in NW)
- Weed consumption on attacks is unconfirmed in sources — design decision needed

---

## Combat & Attacks

All attacks cost **1 turn** (confirmed across all sources including current official guide).

| Attack | Requirement | Effect |
|---|---|---|
| Home Invasion | More thugs than target (ideally) | Kill thugs, steal cash |
| Drive-By | 1 ride per 4 attacking thugs | Better kill ratio, attacker loses fewer thugs (~5:1 kill ratio per Ganksta) |
| Steal Hoes | Crack rocks sent | Poach hoes (works best when target is unhappy or low-thugged) |
| Jack Rides | Target has < 4 thugs per ride | Steal their lowriders |

**Thug:Hoe ratio for protection:** need **4 thugs per hoe** to protect hoes from being stolen.
If a target has < 4:1 ratio AND their hoes are unhappy, they're doubly vulnerable.

**Gang thugs (original IdlePimps only):** permanent defensive thugs that could not die,
did not attack on offense. These do NOT exist in Pimpageddon — not referenced in official guide.

---

## Travel & Cities

### Travel Cost (confirmed current)
```
cost = (hoes + traveling_thugs) × per_city_rate
```
Thugs left behind when traveling are **permanently lost**.
Having enough rides for all thugs gives a **travel discount** (4 thugs per ride = full coverage).

### City Characteristics — PIMPAGEDDON NAMES

The updated CrazyJap port (crazyjap_faq.html) lists 3 cities with Pimpageddon names.
The original IdlePimps names map approximately as:

| Original IdlePimps | Pimpageddon | Character |
|---|---|---|
| Birmingham | Detroit | Noob city — wide attack range, easy hoe targets, bad payouts |
| Atlanta | Amsterdam | Best cash payouts when turning tricks |
| Stockholm | Las Vegas | Best for turning 8s to recruit hoes (~48 hoes per 8 turns) |
| Brooklyn | *(unknown)* | Mediocre all-around |
| Toronto | *(unknown)* | Remote/expensive to reach, fewer players = safer |
| Vancouver | *(unknown)* | Best for 4k+ hoes; also good thug recruitment when turning 8s |

**Note:** Official guide says 5 cities total. The updated CrazyJap file only lists 3.
The remaining 2 Pimpageddon city names need confirmation from the HTML archive snapshots.
Our current implementation uses: New York City, London, Atlanta, Las Vegas — verify against OG snapshots.

---

## Ganking Strategy (compiled from Rut + Ganksta + CrazyJap)

**What is a gank:** Attacking a pimp the moment they turn tricks, before they can spend their cash.
Cash appears in NW the instant tricks are turned — watchful players exploit this window.

**Standard 3-window setup:**
1. **Rankings/profile window** — refresh target's profile or Attack Rankings; hover over attack button
2. **Attack window** — target's pimp ID pre-entered, Home Invasion selected, ready to click
3. **IdleMart window** — preset purchase amounts ready to spend the ganked cash immediately

**How to spot a target about to turn:**
- Their NW jumps suddenly (cash now visible in NW)
- They appear in Attack Rankings with noticeably fewer thugs than NW suggests
- They've been accumulating hoes and are about to spend turns building

**Variants:**
- **Travel Gank:** open a 4th travel window; intercept a target you predict will turn in another city
- **Late Gank:** target already spent most cash; still worth attacking for leftover money
- **Hoe Gank:** after a gank kills most of target's thugs (< 4:1 ratio), immediately send crack
  to steal their hoes before they can rebuy protection

**Spend fast:** after getting ganked cash, spend it immediately in IdleMart — you now have
visible cash that makes YOU a gank target.

---

## First Build Strategy (Rut's Guide — adapted)

Rut wrote from a high-level competitive standpoint. Context matters.

**Pre-build phase:**
- Start by selling your starting thug, buying condoms + crack
- Turn 8s in the early going to accumulate hoes and thugs gradually
- Do NOT attempt a real build on your first 250 turns — too vulnerable
- Wait until you have **800–850 turns minimum** before your first serious build
  (Violate says 1,000 — more conservative but safer)

**Why steal hoes instead of scouting:**
- Turning 8s to scout 5k hoes ≈ 350 turns
- Stealing 5k hoes ≈ 50 turns of 8s for crack + ~5 steal attacks
- Same hoes, but you have 270+ extra turns left for thugs/supplies
- Sitting there turning 8s also makes you a sitting duck — players watch for slow builders

**First build execution:**
- Build in a **different city** than where you stole/scouted — players above you are watching
- Use multiple browser windows (multiple accounts = ban; multiple windows = legal and necessary)
- Speed is everything: refresh F5 on target profile, hover attack button, spend cash immediately
- Watch the thug:hoe ratio of neighbors — if everyone has 100k thugs for 6k hoes and you
  have 9k hoes with the same thugs, you stand out as a target

---

## Beginner Advice (cross-source consensus)

These points were consistent across all FAQs regardless of era:

1. Sell your starting thug immediately — buy condoms and crack with the $4,500
2. Start in a hoe-friendly city (Stockholm/Las Vegas equivalent)
3. Turn 8s at a time early on — more efficient hoe/thug recruitment per turn than turning 100
4. Always keep payout at 1% (not 10% default, not 100% unless deliberately hiding NW)
5. Keep hoes at 100% happiness at all times — even 1 enemy crack rock can steal unhappy hoes
6. 1 AK-47 per thug — unarmed thugs fight at reduced effectiveness
7. 1 lowrider per 4 thugs — required for drive-bys; full coverage = travel discount
8. Never tell anyone what you're holding (original Ganksta advice — still applies)
9. Spend ganked cash immediately before getting ganked yourself

---

## Things in Original IdlePimps NOT Confirmed in Pimpageddon

These features existed in the original game and may or may not be in our version:

- **Gang thugs:** permanent defensive thugs (not killed in attacks, don't attack out)
  → Not mentioned in Pimpageddon official guide. Likely removed.
- **Produce Crack:** thugs manufacture crack over time
  → Referenced in TheGanksta (2003). Pimpageddon guide mentions it exists. Keep.
- **Kevlar Vests in NW:** Vests added $3,000 each to NW in original
  → Removed in Pimpageddon (not listed in official NW breakdown).
- **No Boundaries (NB) mode:** premium game with 70k+ turns, 100–500 turns/10min
  → Pimpageddon has Premium membership but different perks. Not our concern.
- **mIRC integration:** #idlepimps IRC channel was the community hub
  → Not applicable to our version.
- **Vancouver:** 6th city added late in IdlePimps run
  → No Pimpageddon equivalent confirmed yet.

---

## City Names — CONFIRMED FOR PIMPAGEDDON

From `theganksta.html` (Pimpageddon port, lists in Travel menu):
> "Detroit, Las Vegas, Amsterdam where we pimp."

That's only 3 listed — official guide says 5 total. The other 2 remain unconfirmed until
we check the HTML archive snapshots. Our current implementation uses NYC + London as the
other two — verify against OG snapshots when ready.

---

## Kevlar Vests — NW VALUE CONFIRMED $0

From `theganksta.html` (Pimpageddon NW breakdown):
```
Thugs = $1000
Hoes  = $250
Vests = $0       ← explicitly zero in Pimpageddon
Crack = $2
Cash  = face value
```
Vests were $3,000 NW in original IdlePimps. Now $0. This means vests are pure
wealth storage (like AKs, weed, beer) — invisible to NW, safe to hold in large amounts.

---

## Crackulator — BUILT INTO THE GAME

From `theganksta.html` (Pimpageddon port):
> "Go to the pimps profile that you want to kill by clicking on their ID in the ranks.
> Click on the link that says Crack-u-lator and read it. It tells you what you need to
> do to steal that pimps hoes and even how much crack to send!"

The Crackulator is accessible from any pimp's profile — a built-in tool, not just a
player spreadsheet trick. Our implementation should reflect this (it does — it's in the
left nav and also accessible from the profile page).

---

## Player Glossary (from Rut's NewPage1)

Useful terminology for in-game text, FAQ page, and flavor copy:

| Term | Meaning |
|---|---|
| **Deadnet** | A pimp's NW without thugs: (hoes × worth) + (crack × worth) + (rides × worth). Used to assess how vulnerable someone is after being zeroed. |
| **Zero / to zero** | Kill all of a pimp's thugs. |
| **Diving** | Selling NW items (thugs, crack, rides) to lower your NW and get into attack range of a target who would otherwise be out of range. Also used to protect gangmates. |
| **Dropping** | Killing all of a target's thugs so their hoes become vulnerable to stealing. Faster path to hoes than producing your own. |
| **Spinning** | Turning tricks (using turns to generate income). |
| **Gank** | Attacking a pimp the moment they turn tricks to steal their cash. |
| **Hoe gank** | Stealing hoes from a pimp who just turned up with a low thug:hoe ratio. |
| **Multi(-ing)** | a) Turning tricks many times consecutively; b) Running multiple accounts — BANNABLE. |
| **Thugwhore** | Player who only turns tricks and buys thugs, rarely attacks, avoids risk. Tends to make a move near round end. |
| **Crackie / Crackpimp** | Player who stockpiles crack instead of spending on defense. Not playing aggressively; usually aims for rank via NW without pvp. |
| **Padder** | Player who games stats without genuine competition — "stat padding." |
| **Suicide** | Attacking someone to zero them while knowing you won't recover yourself. |
| **Spread / Spreadsheet** | External tool (Excel etc.) used to pre-calculate crack amounts, deadnet, etc. Our Crackulator serves this purpose in-game. |
| **Producing (hoes)** | Gaining hoes through trick-turning (as opposed to stealing them). |
| **NB (No Boundaries)** | Premium/paid variant with massively more turns. Not relevant to our version. |

---

## Rut's IdleGuide(2) — Status

This file has not yet been read. It may contain additional content or an updated version
of the main guide. Lower priority given how much has already been covered.

---

## Summary of Remaining Unknowns

1. **5th city name(s)** — 3 confirmed (Detroit, Las Vegas, Amsterdam). Need 2 more from HTML archive.
2. **Weed consumption** — all sources confirm weed keeps thugs happy but none specify
   *when* weed is consumed (on tricks? on attacks? passively?). Design decision needed.
3. **Condom consumption rate** — our current rate (~0.67/hoe/turn) is estimated. Not
   confirmed by any FAQ. Needs playtesting.
4. **Beer consumption** — similar to weed. Likely consumed same way.
5. **Produce Crack mechanic** — mentioned in original game and Pimpageddon official guide.
   Thugs manufacture crack. Rate and formula not documented in any FAQ.
6. **Drive-by kill ratio** — Ganksta says "about 5:1 kill/loss ratio with big ones at
   the end." This is a rough player estimate, not a formula.
7. **Exact hoe/thug recruitment per 8 turns** — CrazyJap says "10-20 each" from 8 turns
   at start; Stockholm/Las Vegas gives "up to 48 hoes per 8." City multipliers are real
   but exact values are player estimates.

---

## Confirmed From Live HTML Snapshots (March 2026)

### Idle Mart Prices — CONFIRMED

Buy prices confirmed from JS `countTotal()` function in `idle mart.html`:

| Item | Buy Price | Sell Price |
|---|---|---|
| Beer | $2 | — |
| Condoms | $1 | — |
| Crack | $10 | — |
| Weed | $25 | — |
| AK-47 | $1,500 | — |
| Kevlar Vest | $5,500 | — |
| Thug | $2,500 | $1,000 |
| Lowrider | $2,500 | **not sellable** |

**Important:** The sell section of IdleMart only lists Thugs. Lowriders have NO sell option
in the live game. Our implementation allows selling rides — this is a discrepancy to resolve.

### Crackulator Formula — VERIFIED AGAINST REAL DATA

Target from live snapshot: YoungOne (#620), NW=511,402, Thugs=0, Hoes=1,115, Rides=0

```
crack_estimate = (511,402 - (1115×250) - (0×1000) - (0×1000)) / 2
               = (511,402 - 278,750) / 2
               = 116,326  ← matches displayed "Crack Estimate: 116,326" exactly ✅

crack_to_send  = 116,326 / 6.6
               = 17,625.15 ≈ 17,626  ← matches displayed "Crack To Send: 17626" exactly ✅
```

Formula is confirmed correct to the decimal.

The crackulator also shows a ✅ green check icon when the target has no thugs and crack
is detectable — this is the UI cue we already implement.

### Supply Consumption Rates — REAL DATA POINT

From `turned tricks.html` (100 turns, 482 hoes, 83% hoe happiness, 100% thug happiness):
- Condoms used: **654** over 100 turns
- Crack used: **219** over 100 turns
- Display text: "Your consumption ratio is 1.33/1"
  → 654 / 482 hoes ≈ **1.357 condoms per hoe per 100 turns**
  → 219 / 482 hoes ≈ **0.454 crack per hoe per 100 turns**

Per single turn per hoe:
- Condoms: ~0.01357 per hoe per turn
- Crack: ~0.00454 per hoe per turn

**Our current implementation (0.67 condoms/hoe/turn, 0.23 crack/hoe/turn) is ~49× higher
than the real game.** This was deliberately tuned for our faster economy, but worth knowing
the true baseline for comparison. Adjust if supply management feels too punishing.

Note: hoe happiness was only 83% during this turn (crack ran out mid-session), which may
slightly affect consumption compared to full-happy rates.

### Attack Combat — NARRATIVE FORMAT CONFIRMED

From `attack results.html` — Home Invasion result text:
```
"Your 1,228 thugs busted down Delo's door and began unloading!
Your thugs fired 12,450 shots
1,868 of your thugs' shots hit!
You killed 162 thugs!

Delo's 7,041 thugs took cover and began firing back.
Delo's thugs fired 98,574 shots
14,786 of Delo's shots hit!
Delo killed 1,006 of your thugs!

You Lost!"
```

Combat math visible: attacker fired (thugs × ~10 shots), ~15% hit rate, each hit kills 1 thug.
Defender had 7,041 thugs vs attacker's 1,228 — attacker was badly outnumbered, lost ~82%
of their thugs (1,006 of 1,228). Confirms that attacking into a much larger force is suicidal.

The "shots fired" and "shots hit" narrative is pure flavor — the actual outcome is determined
by thug counts, happiness, and AK ratio. Our narrative implementation matches this style.

### Travel — Cities and Costs CONFIRMED

From `travel.html` (player in New York City):
- **London**: $30 per thug/hoe traveling
- **Atlanta**: $300 per thug/hoe traveling
- **Las Vegas**: $400 per thug/hoe traveling

Home city shown in main menu as **New York City** (displayed in red `#CC0033`).
Travel page header: **"Pimpin' Hoes International Airport"**

4 cities total in live game: New York City, London, Atlanta, Las Vegas.
Official guide says 5 — may be outdated or referring to an older version. Our 4-city
implementation matches the actual live travel page exactly.
