# Loop through files starting with a dot in the current directory
for file in $(find -L ~/shell -type f -name ".*"); do

  # Source the file using the dot (.) operator
  . "$file"
  echo "Sourced file: $file"

done
