#!/bin/zsh

icon="⭐️"
menubartext=""

divider="--"
edittext="Edit"

file="${HOME}/.bookmarks.txt"
if [[ -n $1 ]]; then
	file=$1
fi

delimiter=";"
zmodload zsh/mapfile
bookmarks=( "${(f)mapfile[$file]}" )

case $TEXTBAR_TEXT in
	$edittext )
		if [[ -z $EDITOR ]]; then
			open -t $file
		else
			$EDITOR $file
		fi
		;;
	* )
		if [[ -n $TEXTBAR_INDEX && $TEXTBAR_TEXT != $divider  ]]; then
			url=`echo ${bookmarks[$TEXTBAR_INDEX]} | cut -d ${delimiter} -f 1`
			open "${url}"
			exit
		fi
		;;
esac


echo $icon$menubartext
for item in $bookmarks
do
	name=`echo ${item} | cut -d ${delimiter} -f 2`
	url=`echo ${item} | cut -d ${delimiter} -f 1`
	if [[ -z $name ]]; then
		name=$url
	fi
	echo $name
done

echo $divider
echo $edittext
