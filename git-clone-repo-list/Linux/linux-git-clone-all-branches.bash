#!/bin/bash

# Set the path to the file containing the list of repository URLs
repo_list_file="repo_list.txt"

# Specify the target directory where repositories will be cloned
target_directory="/path/to/cloning/directory"

# Set your Git server's URL, username, and password here
git_username="nirmal"
git_password="xxxxxxxx"

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
	
	# Step 2: Read and list remote branches and create a list
		git ls-remote --heads origin | awk '{print $2}' | cut -d/ -f3 > branch_list.txt

	# Step 3: Read the list and create local branches
		while read -r branch; do
			git checkout -b "$branch" "origin/$branch"
		done < branch_list.txt

	# Step 4: Checkout all branches
		git checkout $(cat branch_list.txt)

	# Clean up the branch list file
		rm branch_list.txt
	
done < "$repo_list_file"

echo "All repositories cloned."
