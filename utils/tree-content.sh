#!/bin/bash

IGNORE=true
SAVE_TO_FILE=false
DIR="."
FILES_TO_PRINT=()

for arg in "$@"; do
  if [[ "$arg" == "--no-ignore" ]]; then
    IGNORE=false
  elif [[ "$arg" == "--save" ]]; then
    SAVE_TO_FILE=true
  elif [[ -d "$arg" ]]; then
    DIR="$arg"
  fi
done

shopt -s nullglob dotglob

walk() {
  local dir="$1"
  local prefix="$2"
  local current_ignores=("${@:3}")

  if $IGNORE && [[ -f "$dir/.gitignore" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -z "$line" || "$line" == \#* ]] && continue
      current_ignores+=("${line%/}")
    done <"$dir/.gitignore"
  fi

  local items=("$dir"/*)
  local valid_items=()

  for item in "${items[@]}"; do
    local basename="${item##*/}"

    [[ "$basename" == "." || "$basename" == ".." || "$basename" == ".git" || "$basename" == "node_modules" || "$basename" == ".next" ]] && continue

    local skip=false
    if $IGNORE; then
      for pat in "${current_ignores[@]}"; do
        if [[ "$basename" == $pat ]]; then
          skip=true
          break
        fi
      done
    fi
    $skip || valid_items+=("$item")
  done

  local count=${#valid_items[@]}
  local i=0

  for item in "${valid_items[@]}"; do
    ((i++))
    local basename="${item##*/}"

    if [[ $i -eq $count ]]; then
      echo "${prefix}└── ${basename}"
      if [[ -d "$item" ]]; then
        walk "$item" "${prefix}    " "${current_ignores[@]}"
      elif [[ -f "$item" ]]; then
        FILES_TO_PRINT+=("$item")
      fi
    else
      echo "${prefix}├── ${basename}"
      if [[ -d "$item" ]]; then
        walk "$item" "${prefix}│   " "${current_ignores[@]}"
      elif [[ -f "$item" ]]; then
        FILES_TO_PRINT+=("$item")
      fi
    fi
  done
}

print_file_contents() {
  echo -e "\n"
  for file in "${FILES_TO_PRINT[@]}"; do
    echo "---------------------"
    echo "$file"
    echo "--------------------->"

    if [[ ! -r "$file" ]]; then
      echo "[Cannot read file]"
    elif [[ $(file -b --mime-encoding "$file") == "binary" ]]; then
      echo "[Binary file skipped]"
    else
      cat "$file"
      # Ensure there's a newline at the end of the file output
      echo ""
    fi

    echo "---------------------"
    echo ""
  done
}

# Determine the absolute path and extract the base folder name
ABS_PATH=$(realpath "$DIR")
FOLDER_NAME=$(basename "$ABS_PATH")
OUTPUT_FILE="${FOLDER_NAME}-tree-and-contents.txt"

if $SAVE_TO_FILE; then
  {
    echo "Folder tree:"
    echo "$FOLDER_NAME"
    walk "$DIR" ""
    print_file_contents
  } >"$OUTPUT_FILE"
  echo "Tree and contents saved to $OUTPUT_FILE"
else
  echo "Folder tree:"
  echo "$FOLDER_NAME"
  walk "$DIR" ""
  print_file_contents
fi
