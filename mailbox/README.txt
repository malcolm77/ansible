

Ansbile script for createing mailboxes

Run script using the following method.
Replace bobsmailbox with the name of the mailbox you wish to create

$ ansible-playbook create-mailbox.yml --extra-vars "mailboxname=bob"

this will create the mailbox on all four mailservers.
 - SERVER01
 - SERVER02
 - SERVER01
 - SERVER02
