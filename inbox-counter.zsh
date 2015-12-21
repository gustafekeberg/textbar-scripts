#!/bin/zsh

######################################################################
#                                                                    #
# This script takes account-config as an argument:                   #
#                                                                    #
#     "name,username:password"                                       #
#                                                                    #
# Multiple accounts needs to be separated with a semicolon like this #
#                                                                    #
#     "name,username:password;name2,username2:password2"             #
#                                                                    #
# You can also pass a second argument for "gmail" or "inbox"         #
#                                                                    #
# Call script like this:                                             #
#                                                                    #
# ./inbox-checker.zsh "name,username:password" gmail                 #
#                                                                    #
######################################################################


# Config
# -----------
title="️";
unreadicon="✉️";
unreadicon=" ";
emptyicon=$unreadicon;
notifyicon="❗️";

gmail="https://mail.google.com/mail/u/?authuser=";
inbox="https://inbox.google.com/u/?authuser=";
feed="https://mail.google.com/mail/feed/atom";

case $2 in
    gmail )
        url=$gmail;
        ;;
    *|inbox )
        url=$inbox;
        ;;
esac

input=$1;
accounts=("${(@s/;/)input}");

for (( i = 1; i <=  $#accounts; i++ )) do
	auth=`echo ${accounts[i]} | cut -d , -f 2`;
	name=`echo ${accounts[i]} | cut -d , -f 1`;
	authuser=`echo ${auth} | cut -d : -f 1`;

	curl=`curl -su ${auth} ${feed}`;
	mailcount=`echo ${curl} | awk 'gsub(/.*<fullcount>|<\/fullcount>.*/,g)'`;
	
	(( unreadsum = mailcount + unreadsum ));

	row="${mailcount}\t${name}";
	output="${output}\n${row}";	

	if [[ $i == $TEXTBAR_INDEX ]]; then
		open "${url}${authuser}";
		exit;
	fi
done

# Output
# -------------------------------------------------------------------------
if [[ $unreadsum == "0" ]]; then
	messagestatus=$emptyicon;
else
	messagestatus=$unreadicon$unreadsum;
fi

echo $title$messagestatus;
echo $output;
