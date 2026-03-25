#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

sed -i -e 's/^[[:space:]]*//; s/[[:space:]]*$//' \
  -e '/^http\|^www/ s/\/\+$//' "$1"

echo "Done! URLs in '$1' have been normalized."
