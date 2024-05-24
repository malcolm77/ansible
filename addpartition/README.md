Role Name
=========

A set of roles for adding a partition

Requirements
------------

The community.generl collection


Role Variables ( defined in group_vars/all.yml )
--------------

# Define device to add partition to
device: /dev/sda

# Define partition number
partition_number: 3

# Define filesystem type to use 
filesystem_type: ext4

#Define logical volume size
volume_size: -45GiB

# Define existing volume group name to use
volume_group: rootvg

# Define any devices already in volume_group defined below
existing_pvs: /dev/sda2

# Define logical volume name to use
logical_volume: ansiblelv

# Define filesystem path to use
local_path: /ansible


Dependencies
------------

The community.generl collection

Example Playbook
----------------

 - role: parted
   tags: parted
   use:  Creates a partition using the last 45G of space on the disk

 - role: vgroup
   tags: vgroup
   use:  Adds the above partition to the rootvg volume group

 - role: lvol
   tags: lvol
   use:  creates lvol in above vg and formats it to ext4

 - role: filesystem
   tags: fstab
   use:  creates folder, adds entry to fstab and mounts volume

License
-------

BSD

Author Information
------------------

malcolm.chalmers@outlook.com
