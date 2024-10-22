#!/bin/bash
# CMS Detector Tool
# Function to show usage
show_usage() {
    echo "Usage: $0 [-s] <target_url>"
    echo "  -s    Silent mode (hide CMS Detection Results)"
    exit 1
}

# Check for flags and arguments
SILENT=0

# Process the options
while getopts ":s" opt; do
    case $opt in
        s)
            SILENT=1
            ;;
        \?)
            show_usage
            ;;
    esac
done

# Shift positional arguments
shift $((OPTIND-1))

# Check if target URL is provided
if [ -z "$1" ]; then
    show_usage
fi

TARGET=$1

# Scan the target using WhatWeb to detect CMS
if [ $SILENT -eq 0 ]; then
    echo "Scanning $TARGET for CMS detection..."
fi

CMS_INFO=$(whatweb $TARGET)

# Check if WhatWeb was successful
if [ $? -ne 0 ]; then
    echo "Failed to scan the target. Make sure WhatWeb is installed and the URL is valid."
    exit 1
fi

# If not in silent mode, show the CMS detection results
if [ $SILENT -eq 0 ]; then
    echo -e "\n--- CMS Detection Results ---"
    echo "$CMS_INFO"
fi

# Look for known CMS patterns in WhatWeb output
CMS_DETECTED=$(echo "$CMS_INFO" | grep -oP '(WordPress|Joomla|Drupal|Magento|PrestaShop)')

if [ -z "$CMS_DETECTED" ]; then
    echo -e "\nNo known CMS detected."
else
    echo -e "\nDetected CMS: $CMS_DETECTED"
fi

echo -e "\nCMS Detection Completed."
