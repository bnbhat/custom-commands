#!/bin/bash

# Get the absolute path of the script's directory
script_dir=$(dirname "$(readlink -f "$0")")

# Set the custom_commands directory path
custom_commands_dir="$script_dir"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if the script is run from the custom_commands directory
if [ "$(basename "$custom_commands_dir")" != "custom-commands" ]; then
  echo -e "${RED}Error:${NC} Please run the setup-env.sh script from the custom-commands directory."
  exit 1
fi

# Create the bin directory if it doesn't exist
if mkdir -p "$custom_commands_dir/bin"; then
  echo "Successfully created the bin directory."
else
  echo -e "${RED}Error:${NC} Failed to create the bin directory."
  exit 1
fi

# Store the list of new files found
new_files=()

# Move .sh scripts to the bin directory if they don't exist in the bin directory or have been modified
for file in "$custom_commands_dir/scripts"/*.sh; do
  filename=$(basename "$file")
  filename_without_ext="${filename%.*}"
  dest_file="$custom_commands_dir/bin/$filename_without_ext"

  if [ ! -f "$dest_file" ] || [ "$file" -nt "$dest_file" ]; then
    if cp "$file" "$dest_file"; then
      chmod +x "$dest_file" # Add executable permission
      new_files+=("$filename_without_ext")
    else
      echo -e "${RED}Error:${NC} Failed to copy or update $filename to the bin directory."
      exit 1
    fi
  fi
done

# Print the new files found
if [ ${#new_files[@]} -gt 0 ]; then
  echo -e "${GREEN}New files copied or updated in the bin directory:${NC}"
  for file in "${new_files[@]}"; do
    echo "${GREEN}$file"
  done
else
  echo "No new files found."
fi

# Add the custom_commands/bin directory to the PATH if it's not already present
if ! echo "$PATH" | grep -q "$custom_commands_dir/bin"; then
  export PATH="$custom_commands_dir/bin:$PATH"
  echo "Added the custom_commands/bin directory to the PATH."
else
  echo "The custom_commands/bin directory is already in the PATH."
fi

# Source the .bashrc file
if source ~/.bashrc; then
  echo "Successfully sourced the .bashrc file."
else
  echo -e "${RED}Error:${NC} Failed to source the .bashrc file."
  exit 1
fi

echo "Setup completed successfully!"
