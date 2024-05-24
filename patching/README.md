Role Name
=========

Patch and restart servers #### ONE AT A TIME ####

Requirements
------------

nil

Role Variables
--------------

# ansible-playbook -l SERVER site.yml --tags "pre,path,restart"

  roles:
    - role: prereqs     # install/do any pre-req steps
      tags: pre
    - role: patch       # install latest security patches
      tags: patch
    - role: restart     # check if a restart is required, if so, do it.
      tags: restart

NOTE : Serial is set to 1, so only 1 server is patched at a time

Dependencies
------------

nil

Example Playbook
----------------

    - hosts: all
      roles:
         - prereqs
         - patch
         - restart

Example,
# ansible-playbook -l <SERVER> site.yml

License
-------

BSD

Author Information
------------------

malcolm.chalmers@idemia.com

