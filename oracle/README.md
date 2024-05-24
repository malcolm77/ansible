Role Use
=========
Configure the database servers ready for Oracle

Requirements
------------
Server able to be contacted by Ansible server

Role Variables
--------------
NOTE: if you don't specify a tag, all roles will be executed in order
NOTE: some manual setup is still required

  roles:
    - role: cleanup             # remove any existing oracle groups and users
      tags: cleanup
    - role: packages            # install required packages
      tags: packages
    - role: users               # create users and groups
      tags: users
    - role: folders             # create folders        
      tags: folders
    - role: other               # other stuff requested by the French team
      tags: other
    - role: ownership           # set/fix ownership
      tags: ownership

Dependencies
------------
Ansible 2.9

Example Playbook
----------------
# ansible-playbook -l DB site.yml --tags=cleanup

License
-------
BSD

Author Information
------------------
malcolm.chalmers@idemia.com
