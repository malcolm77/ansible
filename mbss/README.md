Role Name
=========

A series of roles designed to do some configuration on MBSS servers

Requirements
------------

This roles require the community.general collections

Role Tags
--------------

    lvolume
    Creates all the required logical volumes

    filesystem
    'Formats' all the new logical volumes with the ext4 filesystem

    fstab
    Adds the new logical volumes to fstab file

    folders
    Create all the required folders

Dependencies
------------

This roles require the community.general collections

Example Playbook
----------------

ap -l SERVER01, site.yml --tags=fstab

License
-------

BSD

Author Information
------------------

malcolm.chalmers@idemia.com
