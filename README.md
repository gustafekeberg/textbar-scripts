# TextBar scripts

Scripts to be used with [TextBar](http://www.richsomerfield.com/apps/).

## Inbox counter - `inbox-counter.rb`

- This ruby counts unread mails in a mailbox via IMAP.
- Multiple accounts are possible.
- The configuration file uses YAML-format.
- When used with TextBar the script can perform a custom command for each mailbox

Sample YAML-config file:

```yaml
unreadicon: " "
emptyicon: ""
unreachable: "❓"
unreachable: "⚠️"

accounts:
  - display: "account 1 name"
    username: "my@username"
    password: "***"
    command: "/usr/bin/open https://inbox.google.com/u/?authuser=my@username"
    port: 993
    ssl: true
    imap: "imap.googlemail.com"
    mailbox: "INBOX"

  - display: "account 2 name"
    username: "my2nd@username"
    password: "mxmxukubkiaehync"
    command: "/usr/bin/open https://mail.google.com/mail/u/?authuser=my2nd@username"
    port: 993
    ssl: true
    imap: "imap.googlemail.com"
    mailbox: "INBOX"
```
