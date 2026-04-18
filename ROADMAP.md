# Pimp City — Development Roadmap
> What's built, what's broken, what's next, and what "done" looks like.
> This is the working document. PROJECT_PIMP.md is the technical reference.
> Last updated: April 10, 2026.

---

## What This Document Is For

PROJECT_PIMP.md covers architecture, Firebase structure, and code map.
This document answers different questions:

- What is the current state of the game as a *product*?
- What features are stubs vs. actually working?
- What are the priorities for the next sessions?
- What decisions have been made and why?
- What does a "finished" game look like?

---

## Current State: What's Actually Working

These features are fully implemented and tested with real players:

- Firebase auth (pimp name + password login/signup)
- Turn Tricks (income, hoe/thug recruitment, supply consumption)
- idle-Mart (buy/sell, all 8 items, correct prices)
- All 4 attack types (Home Invasion, Drive-By, Steal Hoes, Jack Rides)
- Travel (4 cities, costs confirmed against live Pimpageddon snapshot)
- Crackulator (formula verified to the decimal against real game data)
- Hoe happiness (crack×10 formula + payout supplement)
- Thug happiness (weed×5 + beer×3 per thug, averaged)
- Net worth formula (confirmed: cash + hoes×250 + thugs×1000 + rides×1000 + crack×2)
- Attack rankings (NW range ½× to 2×, same city only)
- All 4 ranking views (World, City, Attack, Gang)
- Gang system (create, join, leave, invite, dues deduction from turns)
- Casino (Higher/Lower card game, turn wagering)
- Tokens (1 token = 500 turns, bypasses 4k cap, Token Manager page)
- Round system (7-day rounds, Firebase transaction, one-client-fires safety)
- Round archiving (full player snapshots in round_history)
- Hall of Fame (winner recorded per round, in-game page)
- Round History page (browse any past round's final standings)
- Inter-round experience (browse rankings/history between rounds, activation screen)
- Sequential player IDs (Firebase transaction on tick/nextId, starts at 1001)
- Admin panel (player editing, round management, attack logs, export)
- Persistent navigation (URL hash routing, browser back/forward)
- FAQ page (fully rewritten April 2026, comprehensive)
- **Dope Wars side-game** (`dopewars.html`) — standalone buy/sell game, shared Firebase market,
  live chat, token rewards (top player each UTC day gets 1 token, max 3/round)
- **Dope Wars leaderboard** — 3 panels: Live Standings (real-time `.on()` listener, Rank/Pimp/Gang/Cash/Tokens),
  Round History (combined past round winners + daily token awards in one table), Gang Cash Rankings
  (aggregated Dope Wars cash by gang, cross-referenced from `players/`)


---

## Stubs: In the Code But Not Functional

These exist in the data model or UI but don't actually do anything yet:

| Feature | Status | Notes |
|---|---|---|
| `G.gangThugs` | Data field only | Field exists and migrates, never used in combat |
| `G.gangBalance` | Data field only | Dues are deducted from player but go nowhere |
| Gang treasury | No UI, no logic | Dues collected but no shared pool, no spending mechanism |
| Produce Crack | Not built | No page, no function, no link in main menu |
| Drive-by travel discount | Not built | Rides vs thugs ratio discount on travel cost, documented but missing |
| Attack messages in inbox | Not built | Console shows attack in/out but no attacker message text |
| Weed/beer consumption | Partial | Both tracked in G, happiness formula uses them, neither is ever consumed |
| Player Titles page | Partial | Page exists (`page-player-titles`), content may be populated or stub |
| Voting Booth | Not built | Original game had this, no page or logic |
| Referral system | Not built | Mentioned in original rules, no implementation |


---

## Known Bugs

Confirmed broken behavior, ranked by impact on active players:

**High — affects active gameplay:**
- [ ] **Weed/beer never consumed** — Players can buy weed and beer once and never need
      more. Both are functionally just NW-invisible cash storage, not ongoing supplies.
      This makes thug happiness trivially easy to maintain, which removes tension.
      Decision needed: consumed on turn tricks? on attacks? passively per tick?

- [ ] **Rides can be sold** — The real Pimpageddon only allows selling Thugs.
      Our sell section includes rides. Minor deviation; may keep as deliberate improvement
      or remove to match original. Flag for a decision.

**Medium — noticeable but not game-breaking:**
- [ ] **Turn Tricks city dropdown** — Dropdown shows all 4 cities but should only show
      the current city. Original game only showed current city options.

- [ ] **In-game rankings missing "last round" section** — The login page shows last
      round standings but the in-game rankings page doesn't. Thin leaderboard early
      in a round looks bad.

- [ ] **Gang dues collected but go nowhere** — Dues % is deducted from trick earnings
      correctly, but the money doesn't land anywhere. No treasury, no shared balance.
      Gang members are donating to the void.

**Low — cosmetic or edge case:**
- [ ] **Admin round history export** loads from cached data — if admin hasn't clicked
      Refresh after page load, dropdown may be empty.

- [ ] **Individual file export** may prompt browser permission on first use.


---

## Feature Backlog

Ordered roughly by priority. Top items are the ones that matter most to
players who are already in the game and playing seriously.

### Priority 1 — Core Gameplay Gaps

**Weed & Beer Consumption**
Both supplies should drain over time. The question is when:
- Option A: Consumed on Turn Tricks (mirrors how crack/condoms work)
- Option B: Consumed passively on the turn tick (background drain)
- Option C: Consumed only when attacked (weed/beer affect combat performance)
The real game likely used Turn Tricks consumption. Option A is simplest and consistent
with the existing supply model. Needs a rate that isn't punishing but requires restocking.

**Produce Crack**
A full page with a form: enter number of turns, thugs use them to produce crack.
Rate should depend on thug happiness and AK count. Unhappy/unarmed thugs produce less.
The real game had this as a right-column menu item. Need to add the page, the function,
and the nav link. Should cost turns (making it a meaningful tradeoff vs. turning tricks).

**Gang Treasury**
Dues are being collected from players. That money needs to go somewhere.
Options:
- Simple: gang dues go into a per-gang `balance` stored in Firebase under `gangs/{id}/balance`
- Leader (and co-leader) can see the balance and withdraw cash to their own account
- Could also allow buying shared supplies (crack for a gang drop, etc.)
- At minimum: display the running balance to gang members so dues feel meaningful

### Priority 2 — Polish & Completeness

**Weed/Beer in supply status display**
If we implement consumption, both need to show in the main menu stats panel
alongside crack and condoms, with happiness indicators.

**Drive-By Travel Discount**
If player has 1 lowrider per 4 thugs (full coverage), travel should cost less.
Original game gave a discount for full ride coverage. Exact discount rate unknown —
design it to feel meaningful (maybe 25–50% reduction).

**Attack Messages in Inbox**
When you get attacked, the console shows the raw event. The original game
supported attacker messages. At minimum: flesh out the narrative in the
attack record so the inbox entry reads like a story, not a log line.

**In-Game "Last Round" Rankings Section**
The login page already has this. Replicate it on the in-game rankings page:
a collapsed/secondary section showing final standings from the previous round.
Useful early in a round when current rankings are thin.

**Player Titles Page**
The original game tracked stat leaders (most attacks, most hoes stolen, etc.)
and gave them titles. This page exists as a stub. Needs:
- Defined title categories (most attacks won, most hoes stolen, highest NW reached, etc.)
- Firebase queries to find leaders in each category
- Rendered table with title, holder, and stat value

### Priority 3 — Nice to Have

**Voting Booth**
Simple poll UI. Leader posts a question, members vote. Results visible to gang.
Or game-wide polls from admin. Cosmetic but adds community feel.

**Referral System**
Original rules mentioned a referral program. Could be: if you refer someone
(they sign up with your pimp ID), you get a bonus token or extra turns.
Low priority but good for growth.

**Bot Population System**
When player count is low (early round, off-hours), the rankings feel empty.
A lightweight bot layer — named after real historical IdlePimps players from
the OG archives — could populate rankings and provide gank targets.
This was in v0.1 and was removed. Worth reconsidering for a better new-player
experience, but bots must be clearly distinguishable or clearly invisible.

**Pimp Profile Bios & Icons**
Fields exist (`G.bio`, `G.icon`). The profile page shows them. But there's
no strong incentive to fill them in. Could add character with flavor copy
encouraging players to personalize.


---

## Open Design Decisions

Questions that need an answer before the related feature can be built.
These are recorded here so we don't re-debate them from scratch each session.

| # | Question | Options | Status |
|---|---|---|---|
| 1 | Should lowrider selling be removed? | Keep (more flexible) / Remove (faithful) | ❓ Undecided |
| 2 | Should gang thugs exist? | Yes (original feature) / No (cut) | ❓ Undecided |
| 3 | Gang treasury: what can it buy? | Cash only / Supplies / Gang-wide buffs | ❓ Undecided |
| 4 | Drive-by travel discount rate? | 25% / 50% / tiered by coverage | ❓ Undecided |
| 5 | Bots: bring back or keep player-only? | Yes / No / Optional via admin toggle | ❓ Undecided |
| 6 | Add Produce Crack as original design feature? | Yes (thugs produce crack over time) / No (buy only) | ❓ Undecided |

---

## Decided: Design Decisions Already Made

Record of things that were consciously decided so we don't relitigate them.

| Decision | Choice | Reason |
|---|---|---|
| 5 cities (official guide) vs 4 (live game) | **4 cities** | Live travel page only shows 3 destinations; NYC + London + Atlanta + Las Vegas confirmed |
| Vest NW value | **$0** | Confirmed $0 in Pimpageddon (was $3,000 in original IdlePimps) |
| Crack NW multiplier | **$2** | Confirmed from live HTML and crackulator formula verification |
| Supply consumption rates | **Higher than original** | ~49× original rates, tuned for faster economy. Intentional. Don't change mid-round. |
| Gang thugs in combat | **Not implemented** | Original feature, cut. Original gang thugs were unkillable defenders. Needs design decision to bring back. |
| Crack formula | **NW - (hoes×250 + thugs×1000 + rides×1000) / 2 for estimate, /6.6 for send** | Verified to the decimal against live Pimpageddon crackulator output |
| Hoe happiness formula | **crack/(hoes×10) + payout supplement** | Consistent across all source FAQs |
| Thug happiness formula | **Average of (weed/weedNeeded) and (beer/beerNeeded)** | Our interpretation; original game less explicit |
| Turn tick rate | **40 turns / 10 min** | Confirmed from PROJECT_PIMP.md; matches original Pimpageddon premium-ish rate |
| Turn hard cap | **4,000** | Confirmed from official game guide |
| Token value | **500 turns, bypasses cap** | Confirmed from official game guide |
| Round length | **7 days** | Our design; original was ~1 month. Shorter rounds = more resets, more competition |
| Starting state | **$4,500, 1 hoe, 1 thug, 4,000 turns, 1 token, NYC** | Confirmed $4,500 and 1 hoe/thug from all FAQs; turns/token our additions |
| AK-47s in combat | **Mandatory, affects outcome** | Confirmed: thugs without AKs fight at severely reduced effectiveness. Already in game. |
| Kevlar Vests in combat | **Advantage, not mandatory** | Confirmed: Vests give a defensive bonus when attacking or being attacked. $0 NW. Combat bonus not yet wired into attack formula — needs implementation. |
| Weed/beer consumption | **Never consumed** | Confirmed: In Pimpageddon, weed/beer are needed for happiness but are never drained. They are permanent NW-invisible wealth storage. No consumption mechanic needed. |
| Produce Crack | **Not in Pimpageddon; open design question for our game** | Original IdlePimps may have had it; Pimpageddon does not. Whether to add as original feature is undecided (see Open Design Decisions #6). |


---

## What "Done" Looks Like

There's no single finish line for a multiplayer game, but here's a honest definition
of what "feature complete" means for Pimp City — the point where it's a full,
self-sustaining game that doesn't need apology.

### Minimum Viable "Done"

The game is done when a new player can sign up, read the FAQ, play a full 7-day round,
understand what happened, and want to come back for the next one. Concretely:

- [ ] Weed and beer are consumed and need restocking (supply loop is complete)
- [ ] Produce Crack is functional (second resource path beyond turning tricks)
- [ ] Gang treasury works (dues go somewhere real, leader can deploy them)
- [ ] Player Titles page is populated with real live stats
- [ ] No stub pages or dead links anywhere in the main menu
- [ ] Full round runs start-to-finish with zero admin intervention needed

### What Would Make It Great

Beyond functional, these are the things that separate a game people play once
from one they come back to:

- A bot layer using names from the OG IdlePimps player archives — keeps rankings
  feeling alive during off-hours, gives new players something to gank before
  real players build up, and pays tribute to the original community
- Gang coordination actually mattering in combat — shared treasury that can fund
  a coordinated drop, gang thugs as a real defensive mechanic
- A round recap shown to all players at round end: top ganks, most hoes stolen,
  biggest drops, who zeroed whom — the drama of the round condensed into one page
- Drive-by travel discount so rides have strategic value beyond just drive-bys
- A light mobile CSS pass — the design works on mobile but wasn't built for it

### What It Will Never Need

Explicitly out of scope — recorded so we don't get distracted:

- Graphics, animations, or visual redesign. The text-based aesthetic is the point.
- External chat (Discord bot, etc.). The console and inbox are sufficient.
- Monetization. This is a passion project.
- A rewrite. The single-file architecture is a feature, not a liability.


---

## Session Workflow

How to pick this project back up efficiently, whether it's been a day or a month.

### Starting a Session

1. Read this file (ROADMAP.md) top to bottom — 5 minutes, not optional
2. Check **Open Design Decisions** — if anything there blocks what you want to build,
   decide it now before writing code
3. Check **Known Bugs** — if a high-impact bug exists, fix it before adding features
4. Pick one concrete thing to work on. One feature or one bug. Not three.
5. Before touching `idlepimps.html`, search for the relevant section and read it.
   Never edit code you haven't just read.

### During a Session

- Make one change at a time. Verify it works before moving to the next.
- If a new design question surfaces, record it in Open Design Decisions rather
  than making an arbitrary call silently and burying it in code.
- Keep `idlepimps.html` as a single file. Resist any urge to split it.
- All game logic lives in JS at the bottom of the file. All pages are hidden divs
  in the HTML section. CSS is at the top. Don't blur these sections.

### Ending a Session

- Update this file: move completed items out of the backlog, record any new
  decisions made, add any new bugs discovered
- If something was decided mid-session (e.g. "weed is consumed on Turn Tricks"),
  move it from Open Design Decisions to Decided
- Note the approximate line count of idlepimps.html so the next session has
  a baseline

### Handing Off to a New Claude Session

The most important thing: **start fresh Claude sessions with this file and
PROJECT_PIMP.md both in context**. PROJECT_PIMP.md has the architecture and
code map. This file has the product state and priorities. Together they're
enough to resume without re-explaining everything from scratch.

The files that matter:
```
D:\GAMES - PC\multiplayer\pimp_city\
├── idlepimps.html        The entire game
├── admin.html            Admin toolkit
├── dopewars.html         Dope Wars side-game
├── PROJECT_PIMP.md       Technical reference (architecture, Firebase, code map)
├── ROADMAP.md            This file (product state, priorities, decisions)
└── FAQ_SYNTHESIS.md      All confirmed game mechanics from source research
```

`FAQ_SYNTHESIS.md` is the research archive — consult it any time a mechanic
is in question (formulas, city names, NW values, supply rates, etc.). It
includes verified-against-live-game data points and notes which values are
Pimpageddon-confirmed vs. original IdlePimps only.


---

## Source Material & Research

All game mechanics research is compiled in `FAQ_SYNTHESIS.md`. Key points:

**Confirmed against live Pimpageddon (authoritative):**
- NW formula: cash + hoes×250 + thugs×1000 + rides×1000 + crack×2
- Crackulator: verified to the decimal against a real live target
- All IdleMart prices confirmed from live HTML source
- 4 cities confirmed: New York City ($0), London ($30/head), Atlanta ($300/head), Las Vegas ($400/head)
- Vests = $0 NW (was $3,000 in original IdlePimps — explicitly zero in Pimpageddon)
- Only Thugs are sellable in the real game's IdleMart (Rides are not)

**Estimated / tuned for our version:**
- Supply consumption rates (~49× faster than original — intentional for pacing)
- Thug happiness formula (our interpretation; original game less explicit)
- Weed/beer consumption timing (not documented anywhere — design decision needed)

**Source files read:**
- `official_game_guide.html` — Pimpageddon admin-authored, 2026, most authoritative
- `crazyjap_faq.html` — CrazyJap's Pimpageddon port, confirms NW values and cities
- `(CrazyJap)My FAQ.html` — Original IdlePimps version (old values, use with caution)
- `THEGANKSTAS...www.pimpageddon.com.html` — Pimpageddon port, confirms $0 vest NW
- `THEGANKSTAS...www.idlepimps.com.html` — Original IdlePimps version (old values)
- `VIOLATE'S F.A.Q..html` — Original IdlePimps, good beginner advice
- `Rut's IdleGuide*.html` (7 parts) — Deep strategy, 2008-2009, original IdlePimps
- Live HTML snapshots from `html pages\` — idle mart, travel, crackulator, attack results

**Bot names source:**
When the bot layer gets built, player names should come from the OG IdlePimps
rankings archived in `D:\GAMES - PC\multiplayer\idlepimps\OG (wayback machine)\`.
Multiple ranked snapshots exist from 2001-2005. These are real players who made
the original game what it was — using their names is a tribute, not a theft.

