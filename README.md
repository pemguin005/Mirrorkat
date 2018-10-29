# Mirrorkat

# SYNOPSIS
 Simple GUI running rsync, md5sum, YAD and bash commands for quick MD5 verification, rsyncing, and renaming files.
 
# Getting Started
 Run from terminal or add to your $PATH to execute it as a program.
 
 You'll need to install yad beforehand, and any libraries it will want.
 I just ran on debian
 
 sudo apt install yad
 

# Description 
 Simple GUI running rsync, md5sum, YAD and bash commands on the backend for the purpose of streamlining the syncing  and making  archival copies of digital camera media files from SD cards, flash drives, external drives, etc.

 This program was built to streamline the process that photographers and videographers run into when they fill up SD cards on a photoshoot or video set, and they need a quick way to copy all their content to a drive quickly, drop all nested folders, and put all files in single spot, confirm that the data hasn't changed at all since leaving the card, and then rename all the files per the project name, date, and number sequence. 
 
 I'm hardly a programmer and so it's mostly simple bash commands piped into YAD for some easier usability. There are definitely better ways to do this, but I'm  working only with what abilities the Linux+ gave me. ;P

# Testing
 I'm still dealing with testing and debugging, particulalry when related to YAD. There isn't a lot of documentation out there for it, and I feel like i get some mixed results when making cancel buttons actually cancel, and not continue with the rest of the program.
 
 That said, I wrote it on in a rush, with little bash scripting experience (maybe my 3rd script) and so it's likely chock full of little issues.

# See Also:
 rsync, https://git://git.samba.org/rsync.git
 yad, https://github.com/v1cont/yad.git
 md5sum, https://linux.die.net/man/1/md5sum

# Thanks 
 To the millions of forums I've been cross referencing for information. Espeically: 
 
 https://www.thelinuxrain.com/articles/the-buttons-of-yad
 http://smokey01.com/yad/