#!/bin/bash

echo "Debian Driver Installation and Update Script"

# Update the package list
echo "Updating package list..."
sudo apt update -y  # Changed from apt-get to apt

# Display system information
uname -a

# Get the current kernel version
kernel_version=$(uname -r | cut -d'-' -f1)

# Search for linux-headers that match the kernel version using apt-cache and grep
# linux_headers_list=$(apt-cache search linux-headers | grep -E "linux-headers-${kernel_version}"): This ensures that only the headers matching the current kernel version are displayed.
linux_headers_list=$(apt-cache search linux-headers | grep -E "linux-headers-${kernel_version}")

# Check if linux-headers include version numbers
if [[ -n "$linux_headers_list" ]]; then
    echo "Available Linux Headers matching your kernel version ($kernel_version):"
    
    # Present a numbered list of headers starting from 1
    options=()
    index=1
    while read -r line; do
        # Extract only the package name before the description
        header_name=$(echo "$line" | awk '{print $1}')
        options+=("$header_name")
        echo "$index) $header_name"
        ((index++))
    done <<< "$linux_headers_list"

    # Ask the user to choose a number from the list
    read -p "Choose a number for the linux-header you want to install: " num_choice

    # Convert num_choice to an integer and check if it's within the valid range
    if [[ "$num_choice" -ge 1 && "$num_choice" -lt "$index" ]]; then
        selected_header="${options[$((num_choice - 1))]}"
        echo "You chose: $selected_header"

        # Install the selected linux-header using apt
        sudo apt install -y "$selected_header"  # Changed from apt-get to apt
    else
        # Handle invalid input outside the range
        echo "Invalid choice. Exiting."
    fi
else
    echo "No linux-headers matching your kernel version ($kernel_version) found."
fi

# Prompt the user to choose a driver to update
read -p "What driver do you want to update: " user_choice

# Install the chosen driver
sudo apt install "$user_choice" -y

# Clean up old package files
echo "Cleaning up old package files..."
sudo apt clean  # Changed from apt-get to apt

# Automatically install recommended drivers (this part is specific to Ubuntu, so we'll omit it for Debian)
echo "Installing recommended drivers..."
if command -v debian-drivers &> /dev/null; then
    sudo debian-drivers autoinstall  # Debian's driver management may vary; use appropriate tools
else
    echo "No specific driver autoinstall command found for Debian."
fi

# Check for additional proprietary drivers (Debian uses different methods for proprietary drivers)
echo "Checking for additional proprietary drivers..."
if command -v ubuntu-drivers &> /dev/null; then
    echo "Available drivers:"
    ubuntu-drivers devices
else
    echo "The 'ubuntu-drivers' command is specific to Ubuntu and not available on Debian."
    echo "You may want to check the 'non-free' repository for proprietary drivers on Debian."
fi

# Clean up old package files
echo "Cleaning up old package files..."
sudo apt clean  # Changed from apt-get to apt

# Notify user of completion
echo "Driver installation and update process completed."

