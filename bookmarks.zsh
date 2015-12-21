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

if [[ -z $EDITOR ]]; then
	EDITOR="open -t"
fi
case $TEXTBAR_TEXT in
	$edittext )
		$EDITOR "$file"
		;;
	* )
		if [[ -n $TEXTBAR_INDEX && $TEXTBAR_TEXT != $divider  ]]; then
			url=`echo ${bookmarks[$TEXTBAR_INDEX]} | cut -d ${delimiter} -f 2`
			open "${url}"
			exit
		fi
		;;
esac


echo $icon$menubartext
for item in $bookmarks
do
	name=`echo ${item} | cut -d ${delimiter} -f 1`
	echo $name
done

echo $divider
echo $edittext
