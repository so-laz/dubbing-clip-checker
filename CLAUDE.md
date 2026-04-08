# Dubbing Clip Checker (DCC) — Project Context

## What this is
A standalone HTML web app for automated QC (Quality Control) in dubbing studios. It cross-references a client's Dialog List (PLDL) against a Pro Tools session export to detect missing dubbed clips. Built for Newart (dubbing studio, Mexico City) by Said Robles.

## Architecture — CRITICAL
**Single HTML file**. Everything in one file: React 18 + Babel + SheetJS + mammoth.js via CDN. No build step, no server. Users open it by double-clicking in a browser. **Every change must preserve this single-file standalone nature.**

The file uses `<script type="text/babel">` for JSX transpilation in the browser.

## Tech stack
- React 18 (CDN: cdnjs.cloudflare.com)
- Babel standalone (CDN) for JSX
- SheetJS/XLSX (CDN) for Excel parsing
- mammoth.js (CDN) for DOCX parsing
- No npm, no node_modules, no build tools

## Supported file formats

### PLDL (Dialog List) — REQUIRED
Two formats auto-detected:
- **Netflix**: Sheet "Dialogue List" (or first sheet), headers in row 1. Columns: `IN-TIMECODE`, `OUT-TIMECODE`, `SOURCE`, `TRANSCRIPTION`, `DIALOGUE`, `ANNOTATIONS`, `TAGS`
- **Disney**: Sheet "Dialogue List", headers in row 5. Columns: `TIMECODE IN`, `TIMECODE OUT`, `CHARACTER :: SOURCE`, `CONTENT :: DIALOGUE TRANSCRIPTION`, `TYPE`

### Dub Script — OPTIONAL
- **Netflix .xlsx**: Same parseExcel function, matched via TC+Source (Pass 0) or English text (Pass 1)
- **Disney .docx**: Table with columns TC (MM:SS format), PERSONAJE(S), DIÁLOGO. Parsed via mammoth.js → HTML → DOM table extraction. TCs converted from MM:SS to 00:MM:SS:00

### KNP / LL — OPTIONAL
- **Netflix KNP .xlsx**: Columns `Term`, `Term Type`, `Term Definition`, `es(Spanish (Latam))`, `es(Spanish (Latam)) notes`
- **Disney LL .xlsx**: Sheet "LL", headers at row 5. Columns: `TYPE`, `CHARACTER :: SOURCE`, `CONTENT :: DIALOGUE :: SONG TITLE`, `DUBBING INSTRUCTIONS`. Auto-detected when KNP parsing finds no terms.

### Pro Tools Session Info — REQUIRED
- Export via `File → Export → Session Info as Text`
- Encoding: **latin-1** (Mac Roman). JavaScript reads with `readAsText(f, "latin1")`
- Parses `T R A C K  L I S T I N G` section
- Filters clips > 2 minutes (removes stems: DIA_STEM, PM, MIX, etc.)

## Critical technical knowledge

### TC Offset (Disney vs Netflix)
- Netflix sessions start at `00:00:00:00` → offset = 0
- Disney sessions start at `00:59:59:00` → content begins at `01:00:00:00`
- Offset auto-detected from earliest clip in PT (including stems). If > 30 minutes, used as offset.
- Applied to PLDL TCs before matching: `pldlFrames + offset`

### Character name normalization (`norm()` function)
All comparisons go through `norm()` which:
1. Unicode NFD → strips combining marks (accents, diacritics): `MÜLLER` → `MULLER`
2. Uppercase
3. Strips apostrophes: `ZACK'S` → `ZACKS`
4. Replaces spaces AND hyphens with underscores: `LARS-ERIK` → `LARS_ERIK`

### Fuzzy matching (edit distance ≤ 2)
Handles typos in PT track/clip names. Examples found in real projects:
- `CAMlLLA` (lowercase L instead of uppercase I) → matches `CAMILLA`
- `TIFANNY` (double N) → matches `TIFFANY`
- `MIKEY` vs `MICKEY` → distance 1

### Clip matching (3 tiers)
1. **Track match**: Source → track via `buildSTMap()` with exact + fuzzy matching
2. **Global clip search**: All tracks, but clip name must `belongs()` to source character
3. **Not found** → FALTANTE

### PLDL ↔ Dub Script matching (3 passes)
- **Pass 0**: Exact TC IN + Source (Netflix Salish-style identical TCs)
- **Pass 1**: Exact English text match (Netflix Crooks-style different TCs)
- **Pass 2**: Reverse closest-TC matching — each DOCX entry finds its closest PLDL by same source, multiple DOCX entries can group into one PLDL entry with " / " separator

### Tag filtering (exact match)
Tags are comma-separated. Each tag must match exactly: `MAIN TITLE IN DIALOGUE` ≠ `MAIN TITLE`. Only exclude on exact matches of: `MAIN TITLE`, `GRAPHICS INSERTS`, `INAUDIBLE`, `SONG`.

### KNP word boundaries
Uses `isLetter()` function checking Unicode ranges. Terms only match if surrounded by non-letter characters. Prevents "Ce" matching inside "hacer".

### Clipboard on file:// protocol
`navigator.clipboard` API fails silently on `file://`. All copy operations use hidden textarea + `execCommand('copy')` fallback.

## Keyboard shortcuts
- Arrows: navigate cells
- Shift+Arrows: extend selection
- Enter: textarea mode inside cell (real cursor, partial selection)
- Escape: exit text mode or deselect
- Cmd+C: copy selected cells or text
- Cmd+L: cycle language (Original → ENG → ESP)
- Cmd+D: dictionary popup (DLE/RAE, DEM/Colmex, DA/ASALE)

## File structure
```
dubbing-clip-checker/
├── CLAUDE.md              ← This file
├── dubbing-clip-checker.html  ← The app (single file, ~850 lines)
├── dist/                  ← Built/minified version for distribution
├── tests/                 ← Test suite
├── DCC_test_files.zip     ← Synthetic test data (Dark Echoes)
├── README.md
├── CHANGELOG.md
├── LICENSE                ← Proprietary license
├── .gitignore
└── build.sh               ← Minification script
```

## Real projects tested
- Love Is Blind S10 (Netflix, 23.976fps)
- Crooks S2E6 (Netflix, 24fps) — different TCs between PLDL and Dub Script
- Salish & Jordan Matter S1 (Netflix, 29.97fps drop frame) — identical TCs, empty TRANSCRIPTION
- The Boroughs S1E8 (Netflix, 24fps) — numeric tracks, MAIN TITLE IN DIALOGUE tag
- Love Is Blind Sweden S3E10 (Netflix, 25fps) — LARS-ERIK hyphen, CAMlLLA typo
- The Bear E1 (Disney, 24fps) — session offset 00:59:59:00, DOCX dub script, LL format, MIKEY/MICKEY typo

## Edge cases to always test
1. Stems/mixes > 2 min filtered out
2. Character in another character's track (INSPECTOR_GRAF in NICK_BRADLEY track)
3. FUTZ/phone dialog tracks
4. Drop frame TCs (`;` separator)
5. Apostrophes, diacritics, hyphens in names
6. Tag exact match (MAIN TITLE IN DIALOGUE not excluded)
7. Reactions isolated vs reactions with dialog
8. KNP short terms not matching inside longer words
9. Disney TC offset auto-detection
10. DOCX MM:SS timecode conversion and multi-line grouping

## Author
Said Robles — Newart, Mexico City. QC Specialist.
