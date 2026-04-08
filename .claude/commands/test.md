Run the DCC test suite against the Dark Echoes test files. Unzip DCC_test_files.zip if not already extracted, then verify:

1. Parse test_PLDL.xlsx — should find 35 entries, 30 after non-dialog filter
2. Parse test_ProTools_SessionInfo.txt — should find clips, filter stems > 2min
3. Match clips — expected: 27 grabados, 2 faltantes (Elena 02:40 + Marco 02:44), 2 NARRATOR (excluible)
4. Verify edge cases:
   - ZACK'S MOTHER matches ZACKS_MOTHER (apostrophe normalization)
   - MÜLLER matches MULLER (diacritic normalization)
   - INSPECTOR GRAF found in NICK_BRADLEY track (cross-track matching)
   - ELENA VOSS phone clip found in FUTZ track
   - Tag "MAIN TITLE IN DIALOGUE,CONTEXT" NOT excluded
   - Drop frame TCs (00:03:10;05) parsed correctly
5. Verify KNP: term "Vo" should NOT match inside "Voss"

Report results with pass/fail for each check.
