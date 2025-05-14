#!/bin/bash

# Define two path options
path1="/home/huai/data/media/downloads/mv"
path2="/home/huai/data/media/downloads/h"

# Prompt user to select a path
echo "Please select the directory to delete .jpg files from:"
echo "1. $path1"
echo "2. $path2"
read -p "Enter option (1 or 2): " choice

# Set deletion path based on user choice
case $choice in
  1)
    delete_dir="$path1"
    ;;
  2)
    delete_dir="$path2"
    ;;
  *)
    echo "Invalid input, please try again."
    exit 1
    ;;
esac

# Find and delete all .jpg files in the specified directory and its subdirectories
find "$delete_dir" -type f -name "*.jpg" -delete

echo "Deletion complete."
