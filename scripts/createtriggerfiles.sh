#!/bin/bash
# Name: createTirggerFiles
# Author: Nicholas Walsh
# Use: Create trigger files for procesing


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

#Main Application
function _searchforjarxml {
echo "Path:"$path

declare -a jar
declare -a xml

jar=($(find $path -type f -iname "*.jar" -printf "%f\n" | grep .jar$ | sed -e 's/\.jar$//'))
xml=($(find $path -type f -iname "*.xml" -printf "%f\n" | grep .xml$ | sed -e 's/\.xml$//'))
trigger=($(find $path -type f -iname "*.trigger" -printf "%f\n" | grep .trigger$ | sed -e 's/\.trigger$//'))


echo "          jar files detected: " ${jar[@]}
echo "          xml files detected: " ${xml[@]}
echo "Trigger files files detected: " ${trigger[@]}


for filename in "${jar[@]}"
do

if [[ ${xml[@]} =~ $filename ]] ; then
if [[ ! ${trigger[@]} =~ $filename ]] ; then
echo ""
touch "$path/$filename.trigger"
echo "Trigger file created: " $filename.trigger
fi
fi
done

}


if [ $# == 0 ] ; then
echo "empty paramters"
_displayhelp
fi


while [[ "$1" != "" && "$1" =~ ^-path.*|^-h ]]; do #check for valid parmaters
case $1 in
-path:* )
echo "Create Trigger case"
DoCreateTrigger="true"
# Include Path validation here
path=`echo $1 | cut -d: -f2` #extract arg option
;;
-h )
echo "display help"
_displayhelp
exit
;;
* )
echo "invalid paramater"
_displayhelp
;;
esac
shift
done


if [ "$DoCreateTrigger" = true ] ; then
_searchforjarxml
fi
