#!/bin/sh
#
# Render the pictures in doc/img: SVG for the HTML manual, PDF for the PDF
# manual. doc/img/<name>.* shows the graph that examples/<name>.g passes to
# Splash. Needs GAP and Graphviz; set GAP to use a GAP not on the PATH.
#
# Usage: etc/make-doc-images.sh
set -e

cd "$(dirname "$0")/.."
GAP=${GAP:-gap}

# the examples whose pictures the manual shows
examples="fsm"

# cairo stamps the PDF with this date instead of the current time, so an
# unchanged picture renders to an unchanged file
export SOURCE_DATE_EPOCH=0

dotfile=$(mktemp)
trap 'rm -f "$dotfile"' EXIT
mkdir -p doc/img

for name in $examples; do
  # Run the example with Splash replaced by writing the DOT source to $dotfile
  : > "$dotfile"
  $GAP -q -A -b --quitonbreak -c "
    SetPackagePath(\"GraphvizForGAP\", \".\");
    LoadPackage(\"GraphvizForGAP\");
    MakeReadWriteGlobal(\"Splash\");
    Splash := function(gv)
      FileString(\"$dotfile\", AsString(gv));
    end;
    Read(\"examples/$name.g\");" < /dev/null > /dev/null

  if [ ! -s "$dotfile" ]; then
    echo "examples/$name.g did not call Splash" >&2
    exit 1
  fi

  # -Gmargin=0 drops the 0.5in border Graphviz puts around PDF output only
  dot -Tsvg "$dotfile" -o "doc/img/$name.svg"
  dot -Tpdf -Gmargin=0 "$dotfile" -o "doc/img/$name.pdf"
done
