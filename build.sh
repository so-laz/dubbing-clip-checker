#!/bin/bash
# build.sh — Generates minified/obfuscated version for distribution
# Requires: npm install -g terser html-minifier-terser
# Usage: ./build.sh

set -e

SRC="dubbing-clip-checker.html"
DIST_DIR="dist"
DIST="$DIST_DIR/dubbing-clip-checker.html"

mkdir -p "$DIST_DIR"

echo "🔨 Building distribution version..."

# Extract JS from the HTML
python3 -c "
import re
with open('$SRC', 'r') as f:
    html = f.read()

# Extract the babel script content
match = re.search(r'<script type=\"text/babel\">(.*?)</script>', html, re.DOTALL)
if not match:
    print('ERROR: No babel script found')
    exit(1)

js = match.group(1)

# Write JS separately for processing
with open('/tmp/dcc_src.jsx', 'w') as f:
    f.write(js)

# Write HTML shell (everything except the script content)
before = html[:match.start(1)]
after = html[match.end(1):]
with open('/tmp/dcc_shell_before.html', 'w') as f:
    f.write(before)
with open('/tmp/dcc_shell_after.html', 'w') as f:
    f.write(after)

print('✓ Extracted JS (' + str(len(js)) + ' chars)')
"

# Minify JS with terser (preserves React/JSX since Babel handles it at runtime)
# We use mangle to obfuscate variable names
terser /tmp/dcc_src.jsx \
    --compress passes=2,dead_code=true,drop_console=true \
    --mangle toplevel=true,reserved=['React','ReactDOM','XLSX','mammoth'] \
    --output /tmp/dcc_min.js \
    2>/dev/null || {
    echo "⚠ terser not found. Install with: npm install -g terser"
    echo "  Falling back to simple copy..."
    cp /tmp/dcc_src.jsx /tmp/dcc_min.js
}

# Add copyright header
echo "/* Dubbing Clip Checker — © 2026 Said Robles Nájera. All rights reserved. */" > /tmp/dcc_final.js
cat /tmp/dcc_min.js >> /tmp/dcc_final.js

# Reassemble HTML
cat /tmp/dcc_shell_before.html /tmp/dcc_final.js /tmp/dcc_shell_after.html > "$DIST"

# Minify HTML
html-minifier-terser "$DIST" \
    --collapse-whitespace \
    --remove-comments \
    --minify-css true \
    --output "$DIST" \
    2>/dev/null || {
    echo "⚠ html-minifier-terser not found. Install with: npm install -g html-minifier-terser"
    echo "  HTML not minified, but JS is obfuscated."
}

# Report sizes
SRC_SIZE=$(wc -c < "$SRC")
DIST_SIZE=$(wc -c < "$DIST")
RATIO=$((DIST_SIZE * 100 / SRC_SIZE))

echo "✓ Built: $DIST"
echo "  Source: $(numfmt --to=iec $SRC_SIZE 2>/dev/null || echo ${SRC_SIZE}b)"
echo "  Dist:   $(numfmt --to=iec $DIST_SIZE 2>/dev/null || echo ${DIST_SIZE}b) (${RATIO}%)"
echo ""
echo "📦 Distribute: $DIST"
echo "🔒 Source stays in: $SRC"

# Cleanup
rm -f /tmp/dcc_src.jsx /tmp/dcc_min.js /tmp/dcc_final.js /tmp/dcc_shell_before.html /tmp/dcc_shell_after.html
