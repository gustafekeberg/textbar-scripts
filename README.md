# TextBar google inbox counter

This script takes account-config as an argument like this:

    "name,username:password"

Multiple accounts can be configured. They need to be separated with a semicolon:

    "name,username:password;name2,username2:password2"

Call script:

    ./inbox-checker.zsh "name,username:password"

A click on the account in the menubar will open the account in browser.

You can also specify regular gmail or google inbox by passing `gmail` or `inbox` as a second argument. Inbox will be default if there's no argument present.

    "name,username:password" gmail
