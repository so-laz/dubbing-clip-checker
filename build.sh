#!/bin/bash
# build.sh — Generates minified/obfuscated version for distribution
# Requires: npm install -g terser html-minifier-terser
#           npm install --save-dev @babel/core @babel/preset-react
# Usage: ./build.sh

set -e

SRC="dubbing-clip-checker.html"
DIST_DIR="dist"
DIST="$DIST_DIR/dubbing-clip-checker.html"

mkdir -p "$DIST_DIR"

echo "🔨 Building distribution version..."

# Extract JSX and HTML shell from source
python3 -c "
import re
with open('$SRC', 'r') as f:
    html = f.read()

match = re.search(r'<script type=\"text/babel\">(.*?)</script>', html, re.DOTALL)
if not match:
    print('ERROR: No babel script found')
    exit(1)

js = match.group(1)
with open('/tmp/dcc_src.jsx', 'w') as f:
    f.write(js)

# Shell: everything before/after the babel script block
# Also strip the Babel CDN <script> tag (not needed after pre-transpile)
before = html[:match.start()]
after = html[match.end():]
before = re.sub(r'\s*<script[^>]+babel[^>]+></script>\n?', '', before)
with open('/tmp/dcc_shell_before.html', 'w') as f:
    f.write(before + '<script>')
with open('/tmp/dcc_shell_after.html', 'w') as f:
    f.write('</script>' + after)

print('✓ Extracted JS (' + str(len(js)) + ' chars)')
"

# Pre-transpile JSX → standard JS using @babel/core
node -e "
const babel = require('@babel/core');
const fs = require('fs');
const jsx = fs.readFileSync('/tmp/dcc_src.jsx', 'utf8');
const result = babel.transformSync(jsx, {
  presets: [['@babel/preset-react', {runtime: 'classic'}]],
  filename: 'dcc.jsx'
});
fs.writeFileSync('/tmp/dcc_transpiled.js', result.code);
console.log('✓ Transpiled JSX → JS (' + result.code.length + ' chars)');
"

# Minify + obfuscate with terser
terser /tmp/dcc_transpiled.js \
    --compress passes=2,dead_code=true,drop_console=true \
    --mangle toplevel=true \
    --output /tmp/dcc_min.js \
    2>&1 || {
    echo "⚠ terser failed, using transpiled (unminified) JS"
    cp /tmp/dcc_transpiled.js /tmp/dcc_min.js
}
echo "✓ Minified JS ($(wc -c < /tmp/dcc_min.js) chars)"

# Add copyright header
echo "/* Dubbing Clip Checker — © 2026 Said Robles Nájera. All rights reserved. */" > /tmp/dcc_final.js
cat /tmp/dcc_min.js >> /tmp/dcc_final.js

# Reassemble HTML
cat /tmp/dcc_shell_before.html /tmp/dcc_final.js /tmp/dcc_shell_after.html > "$DIST"

# Minify HTML + CSS
html-minifier-terser "$DIST" \
    --collapse-whitespace \
    --remove-comments \
    --minify-css true \
    --output "$DIST" \
    2>/dev/null || echo "⚠ html-minifier-terser failed, HTML not minified"

# Report sizes
SRC_SIZE=$(wc -c < "$SRC")
DIST_SIZE=$(wc -c < "$DIST")
RATIO=$((DIST_SIZE * 100 / SRC_SIZE))

echo "✓ Built: $DIST"
echo "  Source: $(numfmt --to=iec $SRC_SIZE 2>/dev/null || echo ${SRC_SIZE}b)"
echo "  Dist:   $(numfmt --to=iec $DIST_SIZE 2>/dev/null || echo ${DIST_SIZE}b) (${RATIO}% of source)"
echo ""
echo "📦 Distribute: $DIST"
echo "🔒 Source stays in: $SRC"

# Cleanup
rm -f /tmp/dcc_src.jsx /tmp/dcc_transpiled.js /tmp/dcc_min.js /tmp/dcc_final.js /tmp/dcc_shell_before.html /tmp/dcc_shell_after.html
