#!/bin/bash

# Check if an input string is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <string>"
  exit 1
fi

input="$1"

# 1. Insert a hyphen between lowercase and uppercase letters (HabitTracker -> Habit-Tracker)
# 2. Replace underscores, plus signs, and spaces with hyphens
# 3. Squeeze multiple hyphens into one
# 4. Convert to lowercase
echo "$input" |
  sed -E 's/([a-z0-9])([A-Z])/\1-\2/g' |
  sed -E 's/[ _+]+/-/g' |
  sed -E 's/-+/-/g' |
  tr '[:upper:]' '[:lower:]'
