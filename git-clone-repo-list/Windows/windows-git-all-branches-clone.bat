@echo off
setlocal enabledelayedexpansion

REM Set the path to the file containing the list of repository URLs
set "repo_list_file=repo_list.txt"

REM Specify the target directory where repositories will be cloned
set "target_directory=C:\SSF\git"

REM Set your Git server's URL, username, and password here
set "git_server_url=https://domain-name"
set "git_username=nirmal"
set "git_password=xxxxxxxx"

REM Check if the target directory exists, create it if it doesn't
if not exist "%target_directory%" mkdir "%target_directory%"

REM Loop through the repository list and clone each repository
for /f "usebackq delims=" %%a in ("%repo_list_file%") do (
    set "repo_path=%%a"
    REM Extract repo name from URL
    for %%b in (!repo_path!) do set "repo_name=%%~nxb"
    set "clone_path=%target_directory%\!repo_name!"
    
    REM Check if the repository has already been cloned
    if exist "!clone_path!\" (
        echo Repository '!repo_name!' already exists in '!target_directory!'. Skipping...
    ) else (
        echo Cloning '!repo_name!' into '!clone_path!'
        REM Clone the repository using the provided username and password
        git clone "!repo_path!" "!clone_path!" --config http.sslVerify=false --config credential.username="%git_username%" --config credential.password="%git_password%"
        echo Cloning of '!repo_name!' completed.
		
		echo %cd%
		cd "!target_directory!"\"!repo_name!"
		echo %cd%
		
		REM Step 2: Read and list remote branches and create a list
		for /f "tokens=1,2" %%a in ('git ls-remote --heads origin') do (
		set "branch=%%b"
		set "branch=!branch:~11!"  REM Remove "refs/heads/" prefix
		echo !branch! >> branch_list.txt
		)

		REM Step 3: Read the list and create local branches
		for /f %%b in (branch_list.txt) do (
		git checkout -b %%b origin/%%b
		)

		REM Step 4: Checkout all branches
		for /f %%b in (branch_list.txt) do (
		git checkout %%b
		)

		REM Clean up the branch list file
		del branch_list.txt

		
    )
)

echo All repositories cloned.
