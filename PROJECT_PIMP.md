# Project Pimp — Master Document
> README + Changelog + Handoff in one file.
> Last updated: April 10, 2026.

---

## Table of Contents
1. [What This Is](#what-this-is)
2. [File Structure](#file-structure)
3. [How to Run](#how-to-run)
4. [Game Design Reference](#game-design-reference)
5. [Firebase Architecture](#firebase-architecture)
6. [Changelog](#changelog)
7. [Known Issues & TODO](#known-issues--todo)
8. [Handoff — Resume Instructions for Next Claude](#handoff)

---

## What This Is

A faithful multiplayer browser remake of **Pimpageddon** (originally IdlePimps, est. 2003),
a text-based multiplayer idle/strategy game where you build a pimping empire, compete on a
leaderboard by net worth, and attack/steal from other players.

The game is a **single HTML file** (`idlepimps.html`) with no build step and no local server
required for gameplay. Firebase handles all persistence, auth, and shared state. The game must
be served via localhost (not file://) for Firebase Auth to work — use `serve.bat` to start a
local dev server, then open `http://localhost:8080/idlepimps.html`.

An `admin.html` file in the same folder provides a full admin toolkit (player editing, round
management, attack logs, hall of fame, round history browsing, and data export).

---

## File Structure

```
D:\GAMES - PC\multiplayer\idlepimps\       ← Reference material only, do not edit
├── html pages\                              Original saved HTML pages from Pimpageddon
├── FAQs\                                    FAQ HTML files from original game
│   ├── crazyjap_faq.html                    Pimpageddon port — authoritative for current values
│   ├── official_game_guide.html             Pimpageddon admin guide — most authoritative
│   ├── theganksta.html                      Pimpageddon port — confirms $0 vest NW
│   └── (10 other FAQ files)                 See FAQ_SYNTHESIS.md for full source inventory
└── OG (wayback machine)\                    Original IdlePimps archived pages + rankings

D:\GAMES - PC\multiplayer\pimp_city\       ← WORKING DIRECTORY
├── idlepimps.html                           Main game file (~3,957 lines as of April 9, 2026)
├── admin.html                               Admin toolkit (~730 lines)
├── dopewars.html                            Dope Wars side-game (~1,010 lines, added April 2026)
├── gangs_1.png                              Gang sprite sheet (2x2 grid, 128x128 per frame)
├── gangs_2.png                              Gang sprite sheet (2x2 grid, 128x128 per frame)
├── PROJECT_PIMP.md                          This file — technical reference
├── ROADMAP.md                               Product state, feature backlog, design decisions
├── FAQ_SYNTHESIS.md                         All confirmed game mechanics from source research
├── serve.bat                                Double-click to start local dev server on port 8080
└── FAQs\                                    Copy of FAQ files for local reference
```

---

## How to Run

1. Double-click `serve.bat` (starts a Python HTTP server on port 8080)
2. Open `http://localhost:8080/idlepimps.html` in a browser
3. Log in with your pimp name + password
4. For admin tools: `http://localhost:8080/admin.html`

Firebase Auth requires the page to be served via HTTP, not opened as a local file.

---

## Game Design Reference

All formulas and mechanics are confirmed from the original source HTML/FAQ files in
`D:\GAMES - PC\multiplayer\idlepimps\html pages\` and `FAQs\`.


### Net Worth Formula
```
NW = cash + (hoes × 250) + (thugs × 1000) + (rides × 1000) + (crack × 2)
```
Beer, weed, AK-47s, and Kevlar Vests do NOT add to net worth — used to hide wealth.

### Turn System
- 40 turns awarded every 10 minutes to all players simultaneously via shared Firebase tick
- Hard cap of 4,000 turns (tokens bypass the cap: 1 token = 500 turns)
- Each action costs turns (Turn Tricks: variable, attacks: 1 turn each)
- Tick is awarded via Firebase transaction — only one client fires it even if many are online
- Players offline accumulate turns based on shared tick timestamp, applied on login

### Hoe Happiness
- Each hoe needs 10 crack rocks for 100% happiness
- Payout % can supplement happiness (hoes take a cut of earnings instead of needing crack)
- Condoms consumed per turn (~0.67 per hoe per turn)
- Crack consumed per turn (~0.23 per hoe per turn)
- Unhappy hoes can be stolen with as little as 1 crack rock from an enemy

### Thug Happiness
- Requires weed AND beer (both contribute equally to happiness score)
- Needs AK-47s for full combat effectiveness (1 AK per thug ideal)
- Kevlar Vests give a defensive combat bonus — not mandatory but meaningful
- Unhappy thugs perform worse in combat
- **Weed and beer are never consumed** — confirmed from live Pimpageddon snapshot.
  Both are permanent NW-invisible wealth storage. No drain mechanic.

### Crackulator Formulas (confirmed against real data points)
```
crack_estimate = (NW - hoes×250 - thugs×1000 - rides×1000) / 2
crack_to_send  = crack_estimate / 6.6
```
- ✅ green check = target has enough crack, hoes are happy
- 🟠 orange dot = target has too many thugs, crack won't work
- ❌ red X = target's hoes are unhappy, vulnerable

### Attack Range
```
min_attackable_NW = player_NW × 0.5
max_attackable_NW = player_NW × 2.0
```
Target must also be in the same city. "Out of Range" shown otherwise.

### Attack Types
| Type | Requirement | Effect |
|---|---|---|
| Home Invasion | More thugs than target (ideally) | Kill thugs, steal cash |
| Drive-By | Need rides (1 per 4 thugs) | Better kill ratio, fewer losses |
| Steal Hoes | Crack rocks | Poach unhappy hoes |
| Jack Rides | 4 thugs per ride you want to steal | Steal lowriders |

All attacks cost 1 turn.

### Travel
Cities available from New York City: London ($30/unit), Atlanta ($300/unit), Las Vegas ($400/unit).
Cost = (hoes + traveling_thugs) × per-unit cost. Untraveled thugs are permanently lost.
Each city has different turn reward multipliers:
- New York City: balanced (1.0× all)
- London: high cash (1.5×), low hoe/thug recruitment (0.7×)
- Atlanta: highest cash (2.0×), near-normal recruitment (0.9×)
- Las Vegas: best hoe recruitment (1.8×), moderate cash (1.2×)

### Starting State
$4,500 cash, 1 hoe, 1 thug, New York City, 4,000 turns, 1 token.

### Idle Mart Prices
| Item | Buy | Sell |
|---|---|---|
| Beer | $2 | — |
| Condoms | $1 | — |
| Crack | $10 | — |
| Weed | $25 | — |
| AK-47 | $1,500 | — |
| Kevlar Vest | $5,500 | — |
| Thug | $2,500 | $1,000 |
| Lowrider | $2,500 | $1,000 (our game) |

Note: In the real Pimpageddon, only Thugs can be sold — Lowriders have no sell option.
Our implementation allows selling rides; this is a deliberate deviation, not a bug.
See ROADMAP.md Open Design Decisions for the pending decision on whether to remove it.

### Casino (Belagi-HOE Casino)
Three-step flow: (1) enter wager in turns → (2) dealer card revealed, guess Higher/Lower →
(3) result. Win = get back wager × 2 (net gain = wager). Lose = wager gone.
Tracks "turns lost this session" counter.

### Round System
- Rounds last 7 days from when they start
- Round end fires via Firebase transaction — one client handles it, others are notified
- On round end: full standings archived to `round_history/{roundId}`, winner recorded to
  `hall_of_fame`, `tick/roundId` incremented, new `roundEndTime` set for next 7 days
- Players between rounds stay logged in and can browse rankings and round history
- On next login (or immediately after round end), players who haven't activated see the
  activation screen — they choose a new pimp name, starting city, and optional new password
- Player IDs are sequential, assigned via `tick/nextId` transaction (starts at 1001)


---

## Firebase Architecture

**Project:** pimp-city | **Database:** https://pimp-city-default-rtdb.firebaseio.com

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyBO63O99sVTuIvWTLlwyAk-ej77TUA74WY",
  authDomain: "pimp-city.firebaseapp.com",
  databaseURL: "https://pimp-city-default-rtdb.firebaseio.com",
  projectId: "pimp-city",
  storageBucket: "pimp-city.firebasestorage.app",
  messagingSenderId: "41670433277",
  appId: "1:41670433277:web:945aa16d820c6ef30ce194"
};
```

### Database Structure

```
pimp-city-default-rtdb/
│
├── players/
│   └── {uid}/                        ← Firebase Auth UID
│       ├── name, id, city
│       ├── cash, hoes, thugs, rides
│       ├── crack, condoms, weed, beer, ak, vest
│       ├── payout, turns, tokens
│       ├── roundId                   ← compared to tick/roundId on login
│       ├── wins                      ← lifetime round wins
│       ├── createdAt                 ← account creation timestamp (preserved across rounds)
│       ├── stats                     ← lifetime stats object
│       ├── contacts                  ← { friends, enemies, ignored } (preserved across rounds)
│       ├── bio, icon                 ← profile fields (preserved across rounds)
│       └── disabled                  ← set by admin to block login
│
├── tick/
│   ├── lastTickTime                  ← shared timestamp of last 40-turn award
│   ├── roundEndTime                  ← when the current round ends
│   ├── roundId                       ← current round number (increments each round end)
│   └── nextId                        ← sequential player ID counter (starts at 1001)
│
├── attacks/
│   └── {attackId}/
│       ├── fromUid, fromName, toUid, toName
│       ├── type: "home"|"driveby"|"steal"|"jack"
│       ├── result: "won"|"lost"
│       ├── details, time
│
├── gangs/
│   └── {gangId}/
│       ├── name, dues, leaderId
│       └── members: { {uid}: true }
│
├── hall_of_fame/
│   └── {pushId}/
│       ├── name, id, nw, ts, roundId
│
└── round_history/
    └── {roundId}/
        ├── endedAt                   ← timestamp when round ended
        ├── roundId
        └── players/
            └── {uid}/               ← full player snapshot at round end
                ├── (all player fields)
                ├── finalRank         ← 1 = winner
                └── finalNW           ← net worth at round end

dopewars/
├── market/
│   └── {city_underscored}/
│       └── {drugName}: { price, trend }   ← shared city-wide prices, regenerated on tick
├── scores/
│   └── {roundId}/
│       └── {uid}: { name, cash, ts }      ← updated on every buy/sell
├── chat/
│   └── {pushId}: { uid, name, msg, ts, sys? }  ← global chat, trimmed to 200 msgs
├── awards/
│   └── {roundId}/
│       └── {YYYY-MM-DD}: { winner, uid, ts }   ← daily token award record
└── tokenCount/
    └── {roundId}/
        └── {uid}: number              ← how many tokens this player has won this round (cap: 3)
```

### Firebase Rules (production — applied March 28, 2026)
```json
{
  "rules": {
    "players": {
      ".read": true,
      "$uid": {
        ".write": "auth != null && auth.uid === $uid"
      }
    },
    "tick": { ".read": true, ".write": "auth != null" },
    "attacks": {
      ".read": "auth != null", ".write": "auth != null",
      ".indexOn": ["toUid", "fromUid"]
    },
    "gangs": { ".read": "auth != null", ".write": "auth != null" },
    "presence": {
      "$uid": { ".read": "auth != null", ".write": "auth.uid === $uid" }
    },
    "hall_of_fame": { ".read": true, ".write": "auth != null" },
    "round_history": { ".read": true, ".write": "auth != null" },
    "dopewars": {
      "market":     { ".read": true, ".write": "auth != null" },
      "scores":     { ".read": true, ".write": "auth != null" },
      "chat":       { ".read": "auth != null", ".write": "auth != null" },
      "awards":     { ".read": "auth != null", ".write": "auth != null" },
      "tokenCount": { ".read": "auth != null", ".write": "auth != null" }
    }
  }
}
```


---

## Changelog

### v0.1 — First Draft (single-player)
- Single HTML file, ~1,960 lines, localStorage save/load
- Core game state, main menu 3-column layout matching original design
- Original color scheme: black background, #336600 green borders, #FFCC33 gold, Tahoma/Verdana
- Turn Tricks, idle-Mart, Attack Menu (all 4 types), Attack Results narrative
- Travel page (city-aware), Rankings/City/Attack/Gang Rankings
- Gang Menu (create/join/leave), Console/Inbox, Pimp Profile with Crackulator
- Casino (initial single-step version), FAQ, History log, Preferences (rename)
- AI pimp opponents (20 named pimps, simulate activity on each tick)
- Turn ticker (client-side setInterval, 40 turns/10min, cap 4000)

### v0.2 — Casino Fix
- Replaced one-click casino with proper two-step flow:
  Step 1: Enter wager → Step 2: Dealer card revealed, Higher!/Lower! → Step 3: Result
- Added "turns lost this session" running counter on all casino pages
- Card deck uses Unicode playing card glyphs with correct values (2–A)
- Wager deducted on bet placement, doubled back on win

### v0.3 — Persistent Turn Timer
- Fixed turn countdown resetting on page refresh
- Added `lastTickTime` (absolute timestamp) to game save state
- Added `roundEndTime` (absolute timestamp) replacing `roundSeconds` countdown
- `applyOfflineTurns()` on load: calculates elapsed time, awards missed turns
- Round timer derived from `roundEndTime - Date.now()` instead of decremented setInterval
- Backward-compatible: migrates old saves that used `roundSeconds`

### v0.4 — Firebase Auth + Login/Signup (Phase 1 Multiplayer)
- Removed localStorage save/load entirely
- Added Firebase SDK (app-compat, auth-compat, database-compat v10.12.0)
- Firebase project: pimp-city
- Added `#page-login` and `#page-signup` — shown before main menu
- Login/signup use pimp name + password only; email constructed as `{name}@idlepimps.game`
- `saveGame()` writes to `db.ref('players/{uid}')` via Firebase
- `loadFromFirebase()` reads player record on login; falls back to `defaultGame()`
- `init()` replaced with `auth.onAuthStateChanged()`
- Log-Out calls `auth.signOut()` and returns to login screen
- Added `serve.bat` — double-click to start local dev server

### v0.5 — Real Multiplayer Rankings + Attacks (Phase 2)
- Removed AI pimp system entirely (generateAIPimps, simulateAI, G.aiPimps all gone)
- Added `cachedPlayers` array — refreshed from Firebase on rankings/attack page load
- Added `loadAllPlayers()` — queries `db.ref('players')`, attaches uid and isPlayer flag
- Added `loadAndRenderRankings()` — async Firebase fetch, populates all four ranking tables
- `doAttack()` — writes combat results to target's Firebase record via `.update()`
- Attack records logged to `db.ref('attacks')`
- `updateConsole()` — reads attacks IN/OUT from Firebase by toUid/fromUid query
- `viewProfile(uid)` — fetches live player data by Firebase uid

### v0.6 — Persistent Page Navigation
- URL hash routing: `showPage()` sets `window.location.hash` on every navigation
- `sessionStorage` saves last visited page across refreshes
- `hashchange` event listener: browser back/forward buttons navigate between pages
- Login/signup/activate excluded from hash/sessionStorage routing

### v0.7 — Round Activation System
- Added `roundId` to `tick` node and player records
- On login: if `player.roundId < tick.roundId`, player sees activation screen
- `doActivate()` resets round assets to `defaultGame()` while preserving cross-round fields:
  `createdAt`, `wins`, `stats`, `contacts`, `bio`, `icon`
- Added `page-activate` — pimp name input, city selector, "Let's Pimp" button
- To start a new round manually: set `tick.roundId` to next value in Firebase console

### v0.8 — Automatic Round End + 7-Day Rounds
- `ROUND_DURATION_MS` set to 7 days
- `ensureTickExists` corrects `tick.roundEndTime` on load if it exceeds 7-day duration
- Round-end detection inside `startTicker()` — checks every second
- Firebase transaction on `tick/roundEndTime` ensures only ONE client handles round end
- Round-end handler: records winner to `hall_of_fame`, increments `tick/roundId`,
  sets next `roundEndTime`
- Winner's `wins` counter incremented in Firebase
- All connected clients redirected to `page-round-end`
- On next login after round end, players see activation screen automatically

### v0.9 — Round Archiving + Inter-Round Experience + Sequential IDs (March 28, 2026)
- **Full round archiving:** round-end transaction now saves complete player snapshot to
  `round_history/{roundId}/players/` with `finalRank` and `finalNW` on each player,
  before resetting. `hall_of_fame` entries now include `roundId`.
- **Inter-round navigation:** players no longer forced to log out at round end.
  Round-end page shows "Activate New Pimp" (primary), "View Final Rankings", and
  "Round History" buttons. Log Out demoted to small link.
- **Navigation guard:** `window._needsActivation` flag blocks all game-action pages
  between rounds. Whitelisted pages (rankings, round-history, activate, login, signup)
  remain accessible.
- **Sequential player IDs:** `doActivate()` uses Firebase transaction on `tick/nextId`
  (initializes at 1001) — guaranteed unique sequential IDs, no more random numbers.
- **Activation screen improvements:** pimp name field pre-filled with current name;
  optional password change field added (blank = keep current, min 6 chars if filled);
  Back link returns to round-end screen.
- **In-game Round History page:** `page-round-history` with round selector, full standings
  table (rank, name, ID, city, NW, hoes, thugs), winner highlighted with 👑, round-end
  timestamp shown. Accessible from left nav and round-end screen.
- **Admin Round History panel:** browse and export any archived round from `admin.html`.
  Added between Hall of Fame and Export panels.
- **Admin Export panel:** "Export All Players (Combined)" downloads one JSON with all
  players sorted by NW. "Export Individual Files" downloads one JSON per player with
  300ms delay between files to avoid browser blocking.

### v0.10 — Login Page Overhaul + Rankings Fix + Token Manager + Hall of Fame (March 28, 2026)
- **Login page rewritten:** stripped all Pimpageddon-specific copy ("real money", "hundreds
  of dollars", hardcoded winner name). New description is original and accurate to the game.
- **Login page — previous round table:** added "Last Round — Round N" standings above the
  current round table. Reads from `round_history/{prevRoundId}/players`, sorted by finalRank.
  Both tables load without requiring login (public Firebase rules).
- **Login page — round labels:** current round table header now shows "Current Round — Round N".
  Round timer reads from `tick` directly so it's accurate without auth.
- **"Time Left: 0" fix:** removed early stale `_roundEndTime` fetch from `init()`.
  `applyOfflineTurns()` is now the single source of truth — it reads `tick` and sets
  both `G.roundEndTime` and `window._roundEndTime` together.
- **Rankings filter by roundId:** `loadAllPlayers()` now reads `tick/roundId` first and
  skips any player whose `roundId` is behind the current round. Old unactivated players
  no longer appear in live rankings alongside fresh activations.
- **Token Manager functional:** `redeemTokens()` implemented — deducts tokens, adds
  500 turns each (bypasses 4,000 cap), saves, updates display. Token link already existed
  in main menu center column; page HTML already existed.
- **Hall of Fame in-game page:** new `page-hall-of-fame` reads `hall_of_fame` node,
  sorted by timestamp descending. Shows round, winner name/ID, net worth, date. Most
  recent round highlighted. Nav link added to left column below Round History.
  Accessible between rounds (whitelisted in `_needsActivation` guard).
- **Firebase rules updated:** `players`, `tick`, `hall_of_fame`, `round_history` now
  have public read. Writes still require auth. Applied manually in Firebase console.
- **Round-end transaction hardened:** `tick/roundId` now incremented as the very first
  atomic step — before archiving — so a page-close mid-process can't leave the round
  in a stuck state. Aborted transactions now check fresh `tick` data before deciding
  whether to show round-end screen (prevents false positives from admin round extensions).
- **`doSignup` fixed:** `.then()` block no longer overwrites `G` — auth state change
  in `init()` handles everything. Eliminated the "main menu flash then bounce" bug.
- **New player roundId fix:** new accounts with no Firebase record get `roundId = 0`
  (not `1`) so they always hit the activation screen on first login regardless of
  current `tick/roundId`.


---

## Known Issues & TODO

### Confirmed Bugs / Missing Behavior
- [ ] **Turn Tricks city dropdown** — dropdown shows all cities but should only show
      current city. Original only showed current city.
- [ ] **Rankings page — previous round section** — no "Last Round" section on the
      in-game rankings page the way there is on the login page. Thin early-round
      leaderboard looks bare.
- [ ] **Gang dues go nowhere** — dues % is deducted from trick earnings correctly
      but the money doesn't land in any treasury. No shared gang balance exists yet.
- [ ] **Kevlar Vest combat bonus not wired** — Vests confirmed to give a defensive
      advantage in combat, but `doAttack()` doesn't factor vest count into outcomes.

### Confirmed Non-Bugs (previously listed as bugs)
- **Weed/beer never consumed** — this is correct behavior. Confirmed from live
  Pimpageddon: both are permanent wealth storage, never drained.

### Planned Features (not yet started)
- [ ] **Produce Crack** — page, function, and nav link. See ROADMAP.md for design notes.
- [ ] **Gang treasury** — shared balance, leader can withdraw/deploy.
- [ ] **Drive-by rides discount on travel** — full ride coverage reduces travel cost.
- [ ] **Player Titles** — populated with live stat leaders (most attacks, hoes stolen, etc.)
- [ ] **Attack messages in inbox** — richer narrative in console attack records.
- [ ] **Voting Booth** — simple poll UI, cosmetic.
- [ ] **Referral page** — cosmetic, low priority.

### Admin Panel
- [ ] **Round History export** downloads from cached data — if admin hasn't clicked
      Refresh since loading the page, the dropdown may be empty. Minor UX issue.
- [ ] **Individual file export** may prompt browser permission on first use for
      multiple downloads — expected browser behavior, not a bug.

---

## Handoff — Resume Instructions for Next Claude

**Read this section first if you're picking this project up fresh.**

### Context
The user (`mjah420`) has built a fully functional multiplayer browser remake of Pimpageddon.
The game is live with real players, real Firebase accounts, and completed rounds. It is one
HTML file. All multiplayer phases are complete. Current work is polish, bug fixes, and
new features.

### Where Things Are
- Working files: `D:\GAMES - PC\multiplayer\pimp_city\`
- Edit files directly using Desktop Commander — project is backed up
- Reference HTML pages (original game): `D:\GAMES - PC\multiplayer\idlepimps\html pages\`
- Reference FAQs: `D:\GAMES - PC\multiplayer\idlepimps\FAQs\` and `pimp_city\FAQs\`
- Always read the relevant section of `idlepimps.html` before editing it
- Use `Desktop Commander:start_search` with regex patterns to locate code sections quickly
- Use `Desktop Commander:edit_block` for surgical edits; write_file in chunks for large rewrites

### User's Preferences
- Faithful to original — match layout, terminology, colors, font choices exactly
- Original text-only aesthetic (no icons, no modern UI flourishes)
- Asks for confirmation before work starts on complex changes
- Comfortable with technical detail, prefers plain explanations
- Do not use Desktop Commander without confirming first (unless already in a working session)

### Current File Sizes (April 10, 2026)
- `idlepimps.html` — ~3,959 lines
- `admin.html` — ~730 lines
- `dopewars.html` — ~1,010 lines

### idlepimps.html Structure
- Lines 1–~100: `<head>`, Firebase SDK script tags, CSS start
- Lines ~100–~870: CSS
- Lines ~870–~500 (HTML section): All pages as hidden `<div id="page-X" class="page">` divs
  — only the one with class `.active` is shown at a time
- Lines ~500–~1000: Remaining HTML pages
- Lines ~1000–end: JavaScript

### Key JS Globals
- `G` — entire game state object (see Game Design Reference for structure)
- `currentUser` — Firebase Auth user object (null if logged out)
- `TICK_INTERVAL_MS` — 600000 (10 minutes)
- `ROUND_DURATION_MS` — 604800000 (7 days)
- `countdownSecs` — current countdown to next tick
- `window._roundEndTime` — shared round end timestamp (synced from Firebase)
- `window._needsActivation` — true when player is between rounds; blocks game-action pages
- `cachedPlayers` — array of all players loaded from Firebase for rankings/attacks

### Key JS Functions
- `showPage(name)` — navigate between pages; respects `_needsActivation` guard
- `updateAllDisplays()` — refresh all DOM elements from G
- `getNetWorth(p)` — NW formula for any player object
- `saveGame()` — writes G to Firebase (strips roundEndTime, which lives in tick node)
- `loadFromFirebase(uid, callback)` — reads player record on login
- `applyOfflineTurns(callback)` — reads shared tick, awards missed turns, sets `_roundEndTime`
- `startTicker()` — setInterval every 1s; handles tick and round-end transactions
- `doActivate()` — resets round assets, assigns sequential ID, optional password update
- `loadAllPlayers(callback)` — reads tick/roundId first, filters out stale-round players
- `loadAndRenderRankings()` — async Firebase fetch, populates all four ranking tables
- `doAttack()` — combat logic, writes results to Firebase
- `notify(msg)` — timed notification overlay
- `loadLoginTop5()` — populates login page tables (current + last round), no auth needed
- `loadInGameRoundHistory(callback)` — loads round_history from Firebase
- `renderInGameRoundHistory()` — renders standings table for selected round
- `loadHallOfFame()` — loads hall_of_fame, renders into page-hall-of-fame
- `redeemTokens()` — spends tokens for turns (500/token, bypasses 4k cap)
- `updateTokenPage()` — refreshes token count display and dropdown

### Page IDs (pass to showPage)
`login`, `signup`, `main`, `activate`, `round-end`, `round-history`, `hall-of-fame`,
`turn-tricks`, `turned`, `mart`, `attack-menu`, `attack-results`,
`travel`, `rankings`, `city-rankings`, `attack-rankings`, `gang-rankings`,
`gang-menu`, `console`, `profile`, `crackulator`, `faq`, `history`,
`casino`, `casino-bet`, `casino-result`, `prefs`, `tokens`, `player-titles`

### Between-Rounds Whitelisted Pages
These pages are accessible even when `window._needsActivation` is true:
`round-end`, `rankings`, `city-rankings`, `attack-rankings`, `gang-rankings`,
`round-history`, `hall-of-fame`, `activate`, `login`, `signup`

### How to Start a New Session
1. Read **ROADMAP.md** first — it has current product state, backlog, and open decisions
2. Read this document for architecture and code map
3. Consult **FAQ_SYNTHESIS.md** for any mechanic or formula questions
4. Use `Desktop Commander:start_search` to locate relevant code before editing
5. Confirm plan with user before touching code
6. Edit directly in `D:\GAMES - PC\multiplayer\pimp_city\`

The three documents together cover everything needed to resume without re-explaining:
- `PROJECT_PIMP.md` — architecture, Firebase, code map (this file)
- `ROADMAP.md` — what's built, what's broken, what's next, design decisions
- `FAQ_SYNTHESIS.md` — all confirmed game mechanics verified against live source material

### v0.12 — Dope Wars Side-Game (April 10, 2026)
- **New file: `dopewars.html`** — standalone Dope Wars side-game served alongside the main game.
  Classic buy-low/sell-high loop. 11 drugs, 5 districts per city, 100-unit coat limit.
- **City-aware districts:** reads `players/{uid}/city` on load and sets the player in the
  matching city's 5 real-world districts. City values are normalized via `CITY_MAP` (handles
  abbreviated values like `"nyc"` stored in Firebase).
- **Shared market prices:** stored in `dopewars/market/{city}/`, shared across all players in
  a city. Prices regenerate on the same tick as the main game (`tick/lastTickTime`), with
  deterministic per-district modifiers (±10%, sin-seeded) so prices vary slightly between
  districts each session.
- **Random travel events:** cops (lose stash), robbery (lose cash), found drugs, price shock.
  8% chance per travel move.
- **Collapsible event log:** local-only log in the chat panel showing buys, sells, travel
  moves, and random events with timestamps. Toggle via "Show/Hide Event Log" link.
- **Live global chat:** `dopewars/chat` node, last 50 messages, auto-trimmed to 200 total.
  Join message posted on login.
- **Daily leaderboard + token awards:** scores saved to `dopewars/scores/{roundId}/{uid}`.
  UTC-midnight daily check awards 1 token to the current top player via Firebase transaction,
  written directly to `players/{uid}/tokens`. Max 3 tokens per player per round tracked in
  `dopewars/tokenCount/{roundId}/{uid}`.
- **Auth:** uses the same Firebase Auth session as the main game. No separate login. If not
  logged in, shows a redirect to `idlepimps.html`.
- **Nav link:** "Dope Wars" link added to the bottom of the left column in `idlepimps.html`
  main menu, below the stats block. Opens in a new tab.
- **Firebase rules updated:** added `dopewars` subtree to rules (market public read,
  scores public read, chat/awards/tokenCount auth-required read/write).

### v0.11 — FAQ Overhaul + Documentation Sprint (April 9, 2026)
- **FAQ completely rewritten:** replaced thin 7-section cheat sheet with comprehensive
  guide covering Beginner's Guide, Hoe Happiness, Thug Happiness, Net Worth, Payout,
  Stealing Hoes & Crackulator, Attacks, Ganking, Cities, Turns & Tokens, Gangs, Casino,
  Produce Crack, The Drop sequence, Advanced NW Management, Rounds, and Glossary (13 terms).
- **Mechanics research completed:** all FAQ files read and synthesized. Crackulator formula
  verified to the decimal against live Pimpageddon data. NW values, IdleMart prices, city
  travel costs, and supply mechanics all confirmed from live HTML snapshots.
- **Weed/beer confirmed never consumed:** both are permanent NW-invisible wealth storage
  in Pimpageddon. Removed from bug list.
- **Kevlar Vest NW confirmed $0:** was $3,000 in original IdlePimps, explicitly $0 in
  Pimpageddon. Vest combat bonus confirmed but not yet wired into doAttack().
- **AK-47 and Vest combat roles documented:** AKs mandatory, Vests give defensive bonus.
- **Three new documentation files created:**
  - `ROADMAP.md` — product state, backlog (3 priority tiers), open design decisions,
    decided decisions log, "done" definition, session workflow
  - `FAQ_SYNTHESIS.md` — all confirmed mechanics from source research with source citations
  - Working directory corrected throughout all docs: `pimp_city\` not `idlepimps\project pimp\`

### v0.12 — Alt Color Scheme (April 17, 2026)
- **Alt color scheme added:** checkbox in Pimp Preferences replaces the old Pimp Name
  field. Toggling "Alt Scheme (Purple & Green)" switches green UI elements to purple
  (`#336600` → `#660066`) and yellow elements to green (`#ffcc00`/`#ffcc33` → `#00cc33`/`#33cc00`).
- **CSS variables:** both `idlepimps.html` and `dopewars.html` now use `:root` CSS custom
  properties (`--clr-green`, `--clr-yellow`, `--clr-yellow2`) throughout their stylesheets.
  `body.alt-theme` overrides those variables. Inline-styled elements covered by targeted
  `body.alt-theme [style*="..."]` attribute selectors.
- **Persisted to Firebase:** `G.altTheme` (boolean) saved via `saveGame()`. Applied on
  login in both files via `document.body.classList.toggle('alt-theme', !!G.altTheme)`.
- **dopewars.html:** reads `p.altTheme` from the player Firebase record on auth load
  alongside `p.name` and `p.city`.

---
*End of document.*
