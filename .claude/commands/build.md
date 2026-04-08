Build the distribution version of DCC:

1. Validate JSX syntax using @babel/parser (npm install if needed)
2. Check brace/paren/bracket balance in the script
3. Run ./build.sh to generate dist/dubbing-clip-checker.html (minified + obfuscated)
4. Verify the dist file opens correctly (check it has all CDN scripts, root div, etc.)
5. Report source vs dist file sizes
