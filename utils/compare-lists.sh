#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <file1.txt> <file2.txt> <output.txt>"
  exit 1
fi

file1="$1"
file2="$2"
output="$3"

if [ ! -f "$file1" ]; then
  echo "Error: '$file1' does not exist."
  exit 1
fi

if [ ! -f "$file2" ]; then
  echo "Error: '$file2' does not exist."
  exit 1
fi

# Keep only lines that appear in file1 or file2, but not both.
# Also remove duplicates within each file first.
comm -3 <(sort -u "$file1") <(sort -u "$file2") | sed 's/^\t//' >"$output"

echo "Done. Unique lines written to: $output"
