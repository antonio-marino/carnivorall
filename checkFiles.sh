#!/bin/bash
#=========================================================================
#Title           :checkFiles.sh
#Description     :Script to scan files looking for sensitive information.
#Authors         :L0stControl and BFlag
#Date            :2018/02/12
#Version         :0.1.2    
#Dependecies     :smbclient / xpdf-utils / zip / 
#=========================================================================

FILENAME=$1
PATTERNMATCH=$2
TMPDIR=$3
UNZIP=$(whereis unzip |awk '{print $2}')
PDFTOTEXT=$(whereis pdftotext |awk '{print $2}')
DSTFOLDER=$4
LOG=$5
MOUNTPOINT=$6
HOSTSMB=$7
PATHSMB=$8
FILENAMEMSG=$(echo $FILENAME |sed "s/^.\{,${#MOUNTPOINT}\}/$HOSTSMB\/$PATHSMB/")
DEFAULTCOLOR="\033[0m"
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
WHITE="\033[1;37m"
MAGENTA="\033[1;35m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"

shopt -s nocasematch

for WORDPATTERN in $PATTERNMATCH
    do
        if [[ ${FILENAME: -5} =~ ".XLSX" ]];then

            $UNZIP -q -o "$FILENAME" -d $TMPDIR > /dev/null 2>&1
            if grep --color -i -R "$WORDPATTERN" $TMPDIR/* > /dev/null 2>&1 ; then
                
                echo -e "$GREEN [+] $WHITE Looking for word [$RED$WORDPATTERN$WHITE] on file smb://$FILENAMEMSG...... $GREEN[FOUND!]$DEFAULTCOLOR"
                cp --backup=numbered "$FILENAME" "$DSTFOLDER"
                echo "Pattern $WORDPATTERN found on => $DSTFOLDER$(echo $FILENAME | awk -F"/" '{print $NF}')" >> $LOG
            fi

        elif [[ ${FILENAME: -5} =~ ".DOCX" ]];then
    
            $UNZIP -q -o "$FILENAME" -d $TMPDIR > /dev/null 2>&1
            if grep --color -i -R "$WORDPATTERN" $TMPDIR/* > /dev/null 2>&1 ; then
                echo -e "$GREEN [+] $WHITE Looking for word [$RED$WORDPATTERN$WHITE] on file smb://$FILENAMEMSG...... $GREEN[FOUND!]$DEFAULTCOLOR"
                cp --backup=numbered "$FILENAME" $DSTFOLDER
                echo "Pattern $WORDPATTERN found on => $DSTFOLDER$(echo $FILENAME | awk -F"/" '{print $NF}')" >> $LOG
            fi

        elif [[ ${FILENAME: -5} =~ ".PPTX" ]];then

            $UNZIP -q -o "$FILENAME" -d $TMPDIR > /dev/null 2>&1
            if grep --color -i -R "$WORDPATTERN" $TMPDIR/* > /dev/null 2>&1 ; then
                echo -e "$GREEN [+] $WHITE Looking for word [$RED$WORDPATTERN$WHITE] on file smb://$FILENAMEMSG...... $GREEN[FOUND!]$DEFAULTCOLOR"
                cp --backup=numbered "$FILENAME" "$DSTFOLDER"
                echo "Pattern $WORDPATTERN found on => $DSTFOLDER$(echo $FILENAME | awk -F"/" '{print $NF}')" >> $LOG
            fi

        elif [[ ${FILENAME: -4} =~ ".TXT" ]];then

            if grep --color -i -a "$WORDPATTERN" "$FILENAME" > /dev/null 2>&1 ; then
                echo -e "$GREEN [+] $WHITE Looking for word [$RED$WORDPATTERN$WHITE] on file smb://$FILENAMEMSG...... $GREEN[FOUND!]$DEFAULTCOLOR"
                cp --backup=numbered "$FILENAME" "$DSTFOLDER"
                echo "Pattern $WORDPATTERN found on => $DSTFOLDER$(echo $FILENAME | awk -F"/" '{print $NF}')" >> $LOG
            fi

        elif [[ ${FILENAME: -5} =~ ".CONF" ]];then

            if grep --color -i -a "$WORDPATTERN" "$FILENAME" > /dev/null 2>&1 ; then
                echo -e "$GREEN [+] $WHITE Looking for word [$RED$WORDPATTERN$WHITE] on file smb://$FILENAMEMSG...... $GREEN[FOUND!]$DEFAULTCOLOR"
                cp --backup=numbered "$FILENAME" "$DSTFOLDER"
                echo "Pattern $WORDPATTERN found on => $DSTFOLDER$(echo $FILENAME | awk -F"/" '{print $NF}')" >> $LOG
            fi

        elif [[ ${FILENAME: -4} =~ ".DOC" ]];then

            if grep --color -i -a "$WORDPATTERN" "$FILENAME" > /dev/null 2>&1 ; then
                echo -e "$GREEN [+] $WHITE Looking for word [$RED$WORDPATTERN$WHITE] on file smb://$FILENAMEMSG...... $GREEN[FOUND!]$DEFAULTCOLOR"
                cp --backup=numbered "$FILENAME" $DSTFOLDER
                echo "Pattern $WORDPATTERN found on => $DSTFOLDER$(echo $FILENAME | awk -F"/" '{print $NF}')" >> $LOG
            fi
    
        elif [[ ${FILENAME: -4} =~ ".CSV" ]];then

            if grep --color -i -a "$WORDPATTERN" "$FILENAME" > /dev/null 2>&1 ; then
                echo -e "$GREEN [+] $WHITE Looking for word [$RED$WORDPATTERN$WHITE] on file smb://$FILENAMEMSG...... $GREEN[FOUND!]$DEFAULTCOLOR"
                cp --backup=numbered "$FILENAME" $DSTFOLDER
                echo "Pattern $WORDPATTERN found on => $DSTFOLDER$(echo $FILENAME | awk -F"/" '{print $NF}')" >> $LOG
            fi

        elif [[ ${FILENAME: -4} =~ ".ZIP" ]];then
                 
                echo -e "$YELLOW [+] $WHITE ZIP file smb://$FILENAMEMSG...... $GREEN[FOUND!] and was not copied $DEFAULTCOLOR"

        elif [[ ${FILENAME: -4} =~ ".PDF" ]];then

            if $PDFTOTEXT "$FILENAME" - | grep --color -i -a "$WORDPATTERN" > /dev/null 2>&1 ; then
                echo -e "$GREEN [+] $WHITE Looking for word [$RED$WORDPATTERN$WHITE] on file smb://$FILENAMEMSG...... $GREEN[FOUND!]$DEFAULTCOLOR"
                cp --backup=numbered "$FILENAME" $DSTFOLDER
                echo "Pattern $WORDPATTERN found on => $DSTFOLDER$(echo $FILENAME | awk -F"/" '{print $NF}')" >> $LOG
            fi
            
        fi
done
rm -rf $TMPDIR
