@echo off
setlocal enabledelayedexpansion

REM Step 1: This is for Source tree user to download all branches from repository. open sourcetree repository.
REM Step 2:Click "Add"

    REM Step 2.1:Menu caption: give this a name like "checkout all remote branches"
    REM Step 2.2:Make sure "Show Full Output" and "Run command silently" are unchecked so that you can debug your script
    REM Step 2.3:Script to run: make a new file called "checkout_all_branches.bat" or something like that. Edit the file to contain a script that does what you'd like to do (I'm not sure how to pull all remote branches so you'll need to figure out this part yourself)
    REM Step 2.4:Parameters: this should be $REPO
	REM Step 2.5:Click "OK"
	REM Step 2.5:You can now find your custom action under "Actions > Custom Actions"
	

 
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

endlocal