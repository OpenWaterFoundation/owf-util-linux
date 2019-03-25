#!/bin/sh
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is required
# The above line ensures that the script can be run on Cygwin/Linux even with Windows CRNL

#-----------------------------------------------------------------NoticeStart-
# Linux Utilities
# Copyright 2019 Open Water Foundation.
# 
# License GPLv3+:  GNU GPL version 3 or later
# 
# There is ABSOLUTELY NO WARRANTY; for details see the
# "Disclaimer of Warranty" section of the GPLv3 license in the LICENSE file.
# This is free software: you are free to change and redistribute it
# under the conditions of the GPLv3 license in the LICENSE file.
#-----------------------------------------------------------------NoticeEnd---
#
# du-for-dvd.sh
#
# Given a starting folder, determine which files and subfolders should be written to DVDs
# within 4.7 GB DVD advertised storage limit (assumed to be 4.3 GB for file system).

# List functions in alphabetical order

# Determine the operating system that is running the script
checkOperatingSystem()
{
	if [ ! -z "${operatingSystem}" ]; then
		# Have already checked operating system so return
		return
	fi
	operatingSystem="unknown"
	os=`uname | tr [a-z] [A-Z]`
	case "${os}" in
		CYGWIN*)
			operatingSystem="cygwin"
			;;
		LINUX*)
			operatingSystem="linux"
			;;
		MINGW*)
			operatingSystem="mingw"
			;;
	esac
	#echo "operatingSystem=$operatingSystem (used to check for Cygwin and filemode compatibility)"
}

# Parse the command parameters
parseCommandLine() {
	local OPTIND opt h v
	optstring=":hv"
	while getopts $optstring opt; do
		#echo "Command line option is ${opt}"
		case ${opt} in
			h) # -h  Print the program usage
				printUsage
				exit 0
				;;
			v) # -v  Print the program version
				printVersion
				exit 0
				;;
			\?)
				echo "" 
				echo "Invalid option:  -$OPTARG" >&2
				printUsage
				exit 1
				;;
			:)
				echo "" 
				echo "Option -$OPTARG requires an argument" >&2
				printUsage
				exit 1
				;;
		esac
	done
	# Non-option arguments (folder to list)
	shift $((OPTIND-1))
	duFolders="$*"
}

# Print the script usage
# - calling code must exist with appropriate code
printUsage() {
	scriptName=$(basename $0)
	echo ""
	echo "Usage: $scriptName"
	echo ""
	echo "List files and folder size, grouped by assumed DVD capacity (4.3 GB is assumed)."
	echo ""
	echo "Example:"
	echo "  $scriptName *"
	echo ""
	echo "-h print the usage"
	echo "-v print the version"
	echo ""
}

# Print the script version and copyright/license notices
# - calling code must exist with appropriate code
printVersion() {
	scriptName=$(basename $0)
	echo ""
	echo "$scriptName version ${version}"
	echo ""
	echo "Linux Utilities"
	echo "Copyright 2019 Open Water Foundation."
	echo ""
	echo "License GPLv3+:  GNU GPL version 3 or later"
	echo ""
	echo "There is ABSOLUTELY NO WARRANTY; for details see the"
	echo "'Disclaimer of Warranty' section of the GPLv3 license in the LICENSE file."
	echo "This is free software: you are free to change and redistribute it"
	echo "under the conditions of the GPLv3 license in the LICENSE file."
	echo ""
}

# Entry point into main script
# - call functions from above as needed

version="1.0.0 2019-03-24"

# Determine which echo to use, needs to support -e to output colored text
# - normally built-in shell echo is OK, but on Debian Linux dash is used, and it does not support -e
echo2='echo -e'
testEcho=`echo -e test`
if [ "${testEcho}" = '-e test' ]; then
	# The -e option did not work as intended.
	# -using the normal /bin/echo should work
	# -printf is also an option
	echo2='/bin/echo -e'
	# The following does not seem to work
	#echo2='printf'
fi

# Default folder to process
duFolders="."

# Parse the command line
parseCommandLine "$@"

# Output some blank lines to make it easier to scroll back in window to see the start of output

echo ""
echo ""

# Strings to change colors on output, to make it easier to indicate when actions are needed
# - Colors in Git Bash:  https://stackoverflow.com/questions/21243172/how-to-change-rgb-colors-in-git-bash-for-windows
# - Useful info:  http://webhome.csc.uvic.ca/~sae/seng265/fall04/tips/s265s047-tips/bash-using-colors.html
# - See colors:  https://en.wikipedia.org/wiki/ANSI_escape_code#Unix-like_systems
# - Set the background to black to eensure that white background window will clearly show colors contrasting on black.
# - Yellow "33" in Linux can show as brown, see:  https://unix.stackexchange.com/questions/192660/yellow-appears-as-brown-in-konsole
# - Tried to use RGB but could not get it to work - for now live with "yellow" as it is
errorColor='\e[0;40;33m' # user needs to do something, 40=background black, 33=yellow
warnColor='\e[0;40;31m' # serious issue, 40=background black, 31=red
okColor='\e[0;40;32m' # status is good, 40=background black, 32=green
endColor='\e[0m' # To switch back to default color

# Check the operating system
checkOperatingSystem

# TODO enable this later
# Make sure that everything exists
#if [ ! -d "$duFolders" ]; then
#	${echo2} "${warnColor}Folder to list (${duFolders}) does not exist."
#	echo ""
#	exit 1
#fi

# List folder contents by KB
# - du uses a tab for the delimiter
# - change du output to use spaces and squeeze to only one space so easier to visually debug
# - don't use quotes around $duFolder because it may have been expanded to
#   multiple files/folders on the command line
# - send through tee so can monitor progress because sometimes takes a long time
tmpFile=$(mktemp)
echo "Listing the sizes into $tmpFile with du -sk $duFolders..."
# Have to use -a on tee because mktemp creates the file
du -sk $duFolders | tee -a $tmpFile
echo "...now analyzing for DVD size..."
echo ""

# Now process the output to standard output.
cat $tmpFile | sed -e 's/\t/ /g' | tr -s " " | awk '
BEGIN {
  #FS="\t"
  dvdMaxKb=4.3*1024*1024
  fileSumKb=0
  groupEndPrinted=0
}
{
  fileKb = $1
  fileName = $2
  printf "%60.60s:  %10d KB\n", fileName, fileKb
  if ( (fileSumKb+fileKb) > dvdMaxKb) {
    # Cannot fit the file on the DVD so end
    printf "........................................................................................\n"
    printf "%60.60s:  %10d KB %5.2f GB\n", "DVD Total", fileSumKb, fileSumKb/1024.0/1024.0
    printf "========================================================================================\n\n"
    # Reset the sum
    fileSumKb = 0
    groupEndPrinted = 1
  } 
  else {
    # Add to the total for the DVD and indicate that group end has not been processed
    fileSumKb = fileSumKb + fileKb
    groupEndPrinted = 0
  }
}
END {
  if ( groupEndPrinted == 0 ) {
    # Last item did not cause group to finish so print here
    printf "........................................................................................\n"
    printf "%60.60s:  %10d KB %5.2f GB\n", "DVD Total", fileSumKb, fileSumKb/1024.0/1024.0
    printf "========================================================================================\n\n"
  }
}
'

# Remove the temporary file
rm $tmpFile

# Done
exit 0
