###############################################################
##
## How to use these playbooks
##
###############################################################


# Command Syntax
$ ansible-playbook start.yml --tags=<app>
$ ansible-playbook stop.yml --tags=<app>

###############################################################
######################## start services ########################
###############################################################

# i.e. To start the FES services on all servers in the FES group
$ ansible-playbook start.yml --tags=FES

# To start the services assigned to all servers 
$ ansible-playbook start.yml --tags=ALL

# Options for tags are:
      ALL
      KEY
      APP
      ART
      FES
      DES
      TERA
      FESMIG
      TERAMIG

###############################################################
######################## STOP services ########################
###############################################################

# To stop all services on all services
$ ansible-playbook stop.yml --tags=ALL

# To stop FES on the FES servers
$ ansible-playbook stop.yml --tags=FES
