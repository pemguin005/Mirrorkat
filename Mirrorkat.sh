#!/bin/bash

# v0.6 YAD version
#		+ Expanded forms for more detailed selection.
#		+ Less "noise" of constant windows. More concise UI.
#		+ Data parsed to variables, less .tempfile trail.
#		+ Checksum Feature rebuilt
#		+ Copy tool rebuilt
#		+ Rename Sequencer rebuilt

# v0.5 YAD version
#		+ Expanded modern windows with YAD	
#		- An hour in, it was clear all tools should be rebuilt for easier data parcing.

# v0.4 Final working Kdialog version: 
#		+ Searches the SD Card for any .jpgs
#		+ Asks for a destination folder
#		+ Asks for a prefix
#		+ Rsync runs.
#		- No temp cleanup... needs to be built.
# v0.3 Temp Folder Version
# v0.2 The more Automated, rync version
# v0.1 This was built using JPG extetions. Find and replace any instance of JPG
# With whatever file extention you are using.

#----------------------------------------------------------------------------------

# Starting choice buttons

yad --title="MirrorKat" --text-align=left \
	--width=500 --height=200 --window-icon=gtk-yes --borders=20 --center \
	--text="<big>Choose a tool:</big>\n\n<b>Checksum Checker:</b> Compare MD5s of source files to a target.\n<b>New File Syncer:</b> Sync only unsyned files to a location.\n<b>Sequence Renamer:</b> Batch rename all files in a locatoin to a \"NewName0001.ext\" pattern.\n" \
	--button="Checksum Checker":2 \
	--button="New File Syncer":3 \
	--button="Sequence Renamer":4 \
	--button=gtk-cancel:1 \
	
BUTTON=$?
[[ $BUTTON -eq 1 ]] && exit 0
if [[ $BUTTON -eq 2 ]]; then
	# ########################################################################
	# #                          Checksum Checker                            #
	# ########################################################################


# Get Comparison sources
	CHK_FORM=$(yad --title="MirrorKat - Chucksum Checker" --text-align=center \
		--width=500 --height=200 --window-icon=gtk-yes --borders=20 --center \
		--text="<b>What locations would you like to compare:</b>" \
		--form \
		--field="Are the files here":MDIR "$HOME/Videos" \
		--field="Already in here":MDIR "$HOME/Videos" \
		
)

LOG_FILE=$HOME/Desktop/Unsynced.log
touch $LOG_FILE
# 	The Following "(" begins the feed into a progress bar.	
	(

	sleep 1
	echo "# Generating Checksums... this could take a while.."; sleep 1
	echo "53" ;
		[[ $? -eq 1 ]] && exit 0
	# Parsing the CHK_FORM location info
	SRC_LOC=$(echo $CHK_FORM|cut -d'|' -f1)
	DST_LOC=$(echo $CHK_FORM|cut -d'|' -f2)
echo -e "The following files from:\n\t$SRC_LOC\n\nAre not found nested under:\n\n\t$DST_LOC\n\n(If blank then all files found a match.)\n========================================\n" > $LOG_FILE
	
	
	# Generating Checksums
	SRC_TMP=$(mktemp)
	DST_TMP=$(mktemp)
		SRC_EVAL=$(mktemp)
	SRC_MD5=$(find "$SRC_LOC" -type f -iname "*.*" -exec md5sum "{}" + > $SRC_TMP)
	DST_MD5=$(find "$DST_LOC" -type f -iname "*.*" -exec md5sum "{}" + > $DST_TMP)
	find "$SRC_LOC" -type f -iname "*.*" -exec md5sum "{}" + > $SRC_EVAL


# Parsing checksums to make easy comparisons
	echo "# Comparing Checksum results..."; sleep 1
	echo "75" ;
	
	SRC_MD5=$(mktemp)
	DST_MD5=$(mktemp)
	awk '{print $1}' $SRC_TMP > $SRC_MD5
	awk '{print $1}' $DST_TMP > $DST_MD5

	

	echo "# Generating report info..."; sleep 1
	echo "90" ;
	# Comparing checksums
	MD5_EVAL=$(mktemp)
	comm -23 <(sort -u $SRC_MD5) <(sort -u $DST_MD5) > $MD5_EVAL
	UNSYNCED=$(grep -F -f $MD5_EVAL $SRC_EVAL|cut -d' ' -f2-)
	echo -e "$UNSYNCED" >> $LOG_FILE
	echo "# Done."; 
	echo "100" ; sleep 1
	
	) | \
	
	# Progress Bar Intake
		yad --progress --title="MirrorKat - Checksum Checker" --text-align=center \
		--width=500 --height=200 --window-icon=gtk-yes --borders=20 --center \
		--auto-close --auto-kill --pulsate
		[[ $? -eq 1 ]] && exit 0

			# The Reporting Window and log production
			cat "$LOG_FILE" |
			yad --center --title="MirrorKat - Checksum Checker" \
			--text="<b>\Checksum report.</b>\n\tThis log file has also been placed on the desktop." \
			--text-info --text-align=center --width=700 --height=400 \ 	
	
	exit 0
	
elif [[ $BUTTON -eq 3 ]]; then

	# ########################################################################
	# #                            Sync Program                              #
	# ########################################################################

	# Form Creation, with 2 fields. Source Path, Destination Path.
	# rsync will Archive sync the unseen files.

INPUTFORM=$(yad --title="MirrorKat - Syncer" --text-align=center \
	--width=600 --height=200 --window-icon=gtk-yes --borders=20 --center \
	--form --text="<big>Select folders to sync:</big>\n" \
	--field="Select source folder":MDIR "$HOME/Videos" \
	--field="Select or create a destination folder":MDIR "$HOME/Videos" \
)
[[ $? -eq 1 ]] && exit 0


# Parsing Data

SRC_LOC=$(echo $INPUTFORM|cut -d'|' -f1)
DST_LOC=$(echo $INPUTFORM|cut -d'|' -f2)

#Confirming selection
echo -e "Source:\n$SRC_LOC\n\nDestination:\n$DST_LOC" | yad --title="MirrorKat - Syncer" \
	--text="<big>Confirm your entry:</big>" --text-align=center --text-info \
	--center --width=500 --height=200 --window-icon=gtk-yes --borders=20 
[[ $? -eq 1 ]] && exit 1

# Finding files and setting progress variables.
(
SRC_TEMP=$(mktemp)
find "$SRC_LOC" -type f -iname "*.*" > $SRC_TEMP
SRC_FILES=$( wc -l  $SRC_TEMP | cut -c1)
SYNCED=0
find "$SRC_LOC" -type f -iname "*.*" -exec rsync -ac {} "$DST_LOC" \; &

until [ "$TOTAL" = "100" ]; do
	DST_FILES=$(ls -l $DST_LOC | wc -l | cut -c1)
	TOTAL=$(echo "($DST_FILES / $SRC_FILES)*100" | bc -l | cut -d"." -f1)
#	echo "$TOTAL"
	echo "# Syncing New Files..."
done
) | \
# Progress Bar Intake
		yad --progress --title="MirrorKat - Syncer" --text-align=center \
		--width=500 --height=100 --window-icon=gtk-yes --borders=20 --center \
		--auto-close --auto-kill --pulsate
[[ $? -eq 1 ]] && exit 1

yad --title="MirrorKat - Syncer" --text-align=center \
		--width=500 --height=150 --window-icon=gtk-yes --borders=20 --center \
		--text="<big>All files synced to:</big>\n\n$DST_LOC." \

elif [[ $BUTTON -eq 4 ]]; then
# ####################################
# #         Sequence Renamer         #
# ####################################

	# Get Comparison sources
	RNM_FORM=$(yad --title="MirrorKat - Sequence Renamer" --text-align=center \
		--width=500 --height=200 --window-icon=gtk-yes --borders=20 --center \
		--text="<b>Renaming will follow the pattern:</b>\n\nNewName_YYYYMMDD_000#.Extension" \
		--form \
		--field="Path to files":MDIR "$HOME/Videos" \
		--field="New Name" "PhotoShoot" \
		)
	[ $? -eq 1 ] && exit 1

	# Parsing information
	SRC_PATH=$(echo $RNM_FORM|cut -d'|' -f1)
	NEWNAME=$(echo $RNM_FORM|cut -d'|' -f2)
	DATE=`date +%Y%m%d`

	i=0
	# Batch Rename
	for file in $SRC_PATH/*; do
    	mv "$file" $SRC_PATH/"$(printf "$NEWNAME"_"$DATE"_%04d.${file##*.} $i )"
	i=$(($i+1))
	done

yad --title="MirrorKat - Syncer" --text-align=center \
		--width=500 --height=150 --window-icon=gtk-yes --borders=20 --center \
		--text="<big>All files have been renamed:</big>\n\n"$NEWNAME"_"`date +%Y%m%d`"_000#.Ext" \

fi

exit 