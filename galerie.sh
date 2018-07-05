#!/bin/bash

# galerie.sh
# TP OpenClassRoom: générateur de galerie d'images

gotoPictureFolder()
{
	cd "$1"
}

miniFile()
{
	# this function will resize and convert all picture files

	# we check if folder named mini exists then we rm, whatever we create it then
	minidirectory="mini"
	if [[ -d $minidirectory ]]; then
		`rm -r mini 2>> galerie.log`
		sleep 1

	fi
	`mkdir mini/ 2>> galerie.log`
	sleep 1

	# first we need to list file and process one by one
	# the cut is necessary to remove first two char of the find result
	# because find result format is ./picture.jpg
	for pic in `find -name '*.png' | cut -c 3- 2>> galerie.log`
	do
		picname="mini_$(echo $pic | cut -d '.' -f 1).png" 
		if [[ ! -e mini/"$picname" ]]; then
			`convert $pic -resize 30% mini/$picname 2>> galerie.log`
		fi
	done

	for pic in `find -name '*.jpg' | cut -c 3- 2>> galerie.log`
	do
		picname="mini_$(echo $pic | cut -d '.' -f 1).png" 
		if [[ ! -e mini/"$picname" ]]; then
			`convert $pic -resize 30% mini/$picname 2>> galerie.log`
		fi
	done	
}
createHTMLPage()
{
	# function to create html page structure
	# first we define html file name and also css file name
	htmlfile="galerie.html"
	cssfile="galeriestyle.css"

	# then we remove html and css file if already exist
	if [[ -e $htmlfile ]]; then
		`rm $htmlfile`
	fi
	if [[ -e $cssfile ]]; then
		`rm $cssfile`
	fi
	
	sleep 1
	
	# then we define basic content for css file
	echo "/* stylesheet for galerie.html file */" >> $cssfile
	echo "a img" >> $cssfile
	echo "{" >> $cssfile
	echo "    border: 2px solid black;" >> $cssfile
	echo "}" >> $cssfile
	echo "a img:hover" >> $cssfile
	echo "{" >> $cssfile
	echo "    transition: all 1s ease-in;" >> $cssfile
	echo "}" >> $cssfile

	# then we define html file structure
	echo "<!DOCTYPE html>" >> $htmlfile
	echo " <html>" >> $htmlfile
	echo "  <head>" >> $htmlfile
	echo "   <meta charset=\"utf-8\" />" >> $htmlfile
	echo "   <link rel=\"stylesheet\" href=\"galeriestyle.css\" />" >> $htmlfile
	echo "   <title>Galerie</title>" >> $htmlfile
	echo "  </head>" >> $htmlfile
	echo "  <body>" >> $htmlfile
	echo "   <p>" >> $htmlfile

	# here we need to call function to insert picture in html content for each picture file
	insertMiniFile

	# finally we close html file structure
	echo "   </p>" >> $htmlfile
	echo "  </body>" >> $htmlfile
	echo " </html>" >> $htmlfile

}
insertMiniFile()
{
	# this function will process mini pic file one by one to insert in html
		
	# first we need to process file one by one
	# we process big files because extensions can be different than mini files
	# then, for each big picture, we will check if mini picture exists
	# and so we will add the html line
	for pic in `find -name '*.png' | cut -c 3-`
	do
		minifilename="$(echo $pic | cut -d '.' -f 1)"
		minifilename="mini/mini_$minifilename.png"

		if [[ -e "$minifilename" ]]; then
			echo "    <a href=\"$pic\" title=\"\"><img src=\"$minifilename\" alt=\"pic\"/></a>" >> $htmlfile
		fi
	done

	for pic in `find -name '*.jpg' | cut -c 3-`
	do
		minifilename="$(echo $pic | cut -d '.' -f 1)"
		minifilename="mini/mini_$minifilename.png"

		if [[ -e "$minifilename" ]]; then
			echo "    <a href=\"$pic\" title=\"\"><img src=\"$minifilename\" alt=\"pic\"/></a>" >> $htmlfile
		fi

	done

}
linkToOriginalPicture()
{
	a=""
}
getIndexofCar()
{
	# not necessary anymore..
	# we could also have done this way: i=`expr index "$pic" "."`
	x="${1%%$2*}"
	[[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

if [ "$1" != "" ]; then
	pictureFolder=$1
else
	pictureFolder="Images/"
fi

gotoPictureFolder $pictureFolder

miniFile

createHTMLPage

