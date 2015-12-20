#!/bin/zsh

######################################################################
#                                                                    #
# This script takes account-config as input "name,username:password" #
# Multiple accounts needs to be separated with a semicolon like this #
# "name,username:password;name2,username2:password2"                 #
#                                                                    #
# Call script like this:                                             #
# ./inbox-checker.zsh "name,username:password"                       #
#                                                                    #
######################################################################


# Config
# -----------
title="️";
unreadicon="✉️";
unreadicon=" ";
emptyicon=$unreadicon;
notifyicon="❗️";

feed="https://mail.google.com/mail/feed/atom";
url="https://inbox.google.com/u/?authuser=";
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
