#!/bin/bash

# Get the absolute path of the script's directory
script_dir=$(dirname "$(readlink -f "$0")")

# Set the custom_commands directory path
custom_commands_dir="$script_dir"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "Running Custom Commands Setup..!"


# Check if the script is run from the custom_commands directory
if [ "$(basename "$custom_commands_dir")" != "custom-commands" ]; then
  echo -e "${RED}Error:${NC} Please run the setup-env.sh script from the custom-commands directory."
  exit 1
fi

# Check if the bin directory already exists
if [ -d "$custom_commands_dir/bin" ]; then
  echo "The bin directory is already present."
  echo
else
  # Create the bin directory
  if mkdir -p "$custom_commands_dir/bin"; then
    echo "Successfully created the bin directory."
    echo
  else
    echo "Failed to create the bin directory."
    exit 1
  fi
fi


# Store the list of new files found
new_files=()

# Store the list of edited files found
edited_files=()

# Move .sh scripts to the bin directory if they don't exist in the bin directory or have been modified
for file in "$custom_commands_dir/scripts"/*.sh; do
  filename=$(basename "$file")
  filename_without_ext="${filename%.*}"
  dest_file="$custom_commands_dir/bin/$filename_without_ext"

  if [ ! -f "$dest_file" ]; then
    if cp "$file" "$dest_file"; then
      chmod +x "$dest_file" # Add executable permission
      new_files+=("$filename_without_ext")
    else
      echo -e "${RED}Error:${NC} Failed to copy or update $filename to the bin directory."
      exit 1
    fi
  elif [ "$file" -nt "$dest_file" ]; then
    source_modified_time=$(stat -c "%Y" "$file")
    dest_modified_time=$(stat -c "%Y" "$dest_file")
    if [ "$source_modified_time" -gt "$dest_modified_time" ]; then
      if cp "$file" "$dest_file"; then
        chmod +x "$dest_file" # Add executable permission
        edited_files+=("$filename_without_ext")
      else
        echo -e "${RED}Error:${NC} Failed to copy or update $filename to the bin directory."
        exit 1
      fi
    fi
  fi
done

# Print the new files found
if [ ${#new_files[@]} -gt 0 ]; then
  echo -e "${GREEN}New files copied or updated in the bin directory:${NC}"
  for file in "${new_files[@]}"; do
    echo -e "${GREEN}$file${NC}"
  done
else
  echo "No new files found."
fi
echo

# Print the edited files found
if [ ${#edited_files[@]} -gt 0 ]; then
  echo -e "${YELLOW}Edited files:${NC}"
  for file in "${edited_files[@]}"; do
    echo -e "${YELLOW}$file${NC}"
  done
else
  echo "No edited files found."
fi
echo

# Delete files in the bin directory if the corresponding file is deleted in the scripts directory
deleted_files=()
for file in "$custom_commands_dir/bin"/*; do
  filename=$(basename "$file")
  filename_without_ext="${filename%.*}"
  source_file="$custom_commands_dir/scripts/$filename.sh"

  if [ ! -f "$source_file" ]; then
    rm "$file"
    deleted_files+=("$filename_without_ext")
  fi
done

# Print the deleted files found
if [ ${#deleted_files[@]} -gt 0 ]; then
  echo -e "${RED}Deleted files:${NC}"
  for file in "${deleted_files[@]}"; do
    echo -e "${RED}$file${NC}"
  done
else
  echo "No deleted files found."
fi
echo

# Add the custom_commands/bin directory to the PATH if it's not already present
#if ! echo "$PATH" | grep -q "$custom_commands_dir/bin"; then
#  export PATH="$custom_commands_dir/bin:$PATH"
#  echo "Added the custom_commands/bin directory to the PATH."
#else
#  echo "The custom_commands/bin directory is already in the PATH."
#fi

# Source the .bashrc file
if source ~/.bashrc; then
  echo "Successfully sourced the .bashrc file."
else
  echo -e "${RED}Error:${NC} Failed to source the .bashrc file."
  exit 1
fi