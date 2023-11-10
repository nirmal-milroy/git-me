#!/bin/bash

# Set the path to the file containing the list of repository URLs
repo_list_file="repo_list.txt"

# Specify the target directory where repositories will be cloned
target_directory="/path/to/cloning/directory"

# Set your Git server's URL, username, and password here
git_username="nirmal"
git_password="ib1234"

# Check if the target directory exists, create it if it doesn't
mkdir -p "$target_directory"

# Loop through the repository list and clone each repository
while IFS= read -r repo_path; do
    repo_name=$(basename "$repo_path")
    clone_path="$target_directory/$repo_name"
    
    # Check if the repository has already been cloned
    if [ -d "$clone_path" ]; then
        echo "Repository '$repo_name' already exists in '$target_directory'. Skipping..."
    else
        echo "Cloning '$repo_name' into '$clone_path'"
        # Clone the repository using the provided username and password
        git clone "$$repo_path" "$clone_path" \
            --config http.sslVerify=false \
            --config credential.helper="store --file=.git-credentials"
        echo "Cloning of '$repo_name' completed."
    fi
done < "$repo_list_file"

echo "All repositories cloned."
