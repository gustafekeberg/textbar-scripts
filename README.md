# TextBar scripts

Scripts to be used with [TextBar](http://www.richsomerfield.com/apps/).

## Google inbox counter - `inbox-counter.zsh`

This zsh-scripts counts unread mails in gmail. Multiple accounts are possible. The title will be the sum of unread mails from all accounts.

Google accounts configuration is passed as an argument to the script:

    "name,username:password"

Multiple accounts are separated with a semicolon:

    "name,username:password;name2,username2:password2"

A click on the account line in the menubar will open the account in browser.

You can also specify if you want to open *regular gmail* or *google inbox* by passing `gmail` or `inbox` as a second argument to the script. Google inbox is the default if no argument is present.

    "name,username:password" gmail
