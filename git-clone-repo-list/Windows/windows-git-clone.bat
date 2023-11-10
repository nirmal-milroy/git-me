@echo off
setlocal enabledelayedexpansion

REM Set the path to the file containing the list of repository URLs
set "repo_list_file=repo_list.txt"

REM Specify the target directory where repositories will be cloned
set "target_directory=C:\SSF\git\cloning\directory"

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
        git clone -b master --single-branch "!repo_path!" "!clone_path!" --config http.sslVerify=false --config credential.username="%git_username%" --config credential.password="%git_password%"
        echo Cloning of '!repo_name!' completed.
    )
)

echo All repositories cloned.
