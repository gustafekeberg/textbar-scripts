#!/bin/zsh

######################################################################
#                                                                    #
# This script takes account-config as an argument:                   #
#                                                                    #
#     "user:password,optional account name,optional inbox/gmail"     #
#                                                                    #
# Multiple accounts needs to be separated with a semicolon like this #
#                                                                    #
#     "user:pass,account name,inbox/gmail;user2:pass2"               #
#                                                                    #
# Call script like this:                                             #
#                                                                    #
#     zsh inbox-counter.zsh "user:pass,name,inbox"                   #
#                                                                    #
######################################################################


# Config
# -----------
title="️"
unreadicon="✉️"
unreadicon=""
emptyicon=$unreadicon
notifyicon="❗️"
spacing=" "

gmail="https://mail.google.com/mail/u/?authuser="
inbox="https://inbox.google.com/u/?authuser="
feed="https://mail.google.com/mail/feed/atom"


input=$1
accounts=("${(@s/;/)input}")

for (( i = 1; i <=  $#accounts; i++ )) do
	auth=`echo ${accounts[i]} | cut -d , -f 1`
	user=`echo ${auth} | cut -d : -f 1`
	name=`echo ${accounts[i]} | cut -d , -f 2`
	open=`echo ${accounts[i]} | cut -d , -f 3`
	
	if [[ -z $name || $name == $auth ]]; then
		name=$user
	fi
	
	case $open in
	    gmail )
	        url=$gmail
	        ;;
	    *|inbox )
	        url=$inbox
	        ;;
	esac

	curl=`curl -su ${auth} ${feed}`
	mailcount=`echo ${curl} | awk 'gsub(/.*<fullcount>|<\/fullcount>.*/,g)'`
	
	(( unreadsum = mailcount + unreadsum ))

	row="${mailcount}\t${name}"
	output="${output}\n${row}";	

	if [[ $i == $TEXTBAR_INDEX ]]; then
		open "${url}${user}"
		exit
	fi
done

# Output
# -------------------------------------------------------------------------
if [[ $unreadsum == "0" ]]; then
	messagestatus=$emptyicon
else
	messagestatus=$unreadicon$spacing$unreadsum
fi

echo $title$messagestatus
echo $output
