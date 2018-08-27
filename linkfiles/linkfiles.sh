#!/bin/bash

# linkfiles.sh
# copy this file in a folder and execute to replicate all files
# in another folder with physical link between files

# get curr directory name
srcdir=$PWD
currdirname=${PWD##*/}
echo $currdirname

# create same directory name in apache web root
targetdir="/opt/lampp/htdocs/tests/"
targetdir+=$currdirname
echo $targetdir

# it directory exists, we remove it and create it again
if [[ -d $targetdir ]]; then
    rm -r $targetdir
    sleep 1
fi
mkdir $targetdir
sleep 1

linkDirFiles()
{
    for srcfile in `ls`
    do
        # if file is a directory
        if [[ -d $srcfile ]]; then
            # we create the same directory in the target
            targetdir=$targetdir/"$(echo $srcfile)"
            # but before, we remove it if exists
            if [[ -d $targetdir ]]; then
                rm -r $targetdir
                sleep 1
            fi

            mkdir $targetdir
            sleep 1
            
            # we go to the folder, in source, and call again this function to process its files
            srcdir=$srcdir/"$(echo $srcfile)"
            cd $srcdir
            linkDirFiles

            # once we process child files, we need to go back to parent folder to process brother files
            # and as we will have to copy into parent level in targetdir, we will go into it with cd command and go up with cd ".."
            srcdir=$PWD #store curr folder (child source folder)
            cd $targetdir #go to child dest folder
            cd ".." #go to parent dest folder
            targetdir=$PWD #store parent dest folder
            cd $srcdir #go back to source folder (child source folder)
            cd ".." #go to parent source folder
            srcdir=$PWD
        else
            # if file is a file, we copy it in target directory using ln to create a link
            destfile=$targetdir/"$(echo $srcfile)"
            ln $srcfile $destfile
            echo $destfile
        fi
    done
}

linkDirFiles

echo "process done"
