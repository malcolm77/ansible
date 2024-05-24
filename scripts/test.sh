#!/bin/bash
echo "test"


function _displayhelp(){
cat << _EOF
Shell Script to create trigger files based on jar and xml files
A tirger files will be create with the same name as jar and xml pairs

Syntax
script.sh [options]

Options
-path: The directory to search for jar and trigger file
*You must enter a valid directory.
Will not search sub directories.
-h display help

Example
./CreateTriggerFiles.sh -path:"/tmp/nicholas walsh"

_EOF
}

_displayhelp