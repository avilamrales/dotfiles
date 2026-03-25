#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input-file>"
  exit 1
fi

input=$1

if [ ! -f "$input" ]; then
  echo "Error: file not found: $input"
  exit 1
fi

base=${input%.*}

if [ "$base" = "$input" ]; then
  output="${input}-clean.txt"
else
  output="${base}-clean.txt"
fi

awk '
{
    line = $0
    gsub(/^[ \t]+|[ \t]+$/, "", line)
    if (line != "" && !seen[line]++) print $0
}
' "$input" >"$output"

echo "Done. Cleaned file saved as: $output"
