[sssd]
services = nss, pam, ssh, autofs
config_file_version = 2
domains = nafis.cicz.gov.au

[domain/domain.domain.au]
id_provider = ad
ad_server = SERVER01.domain.domain.au
override_homedir = /home/%u
default_shell = /bin/bash

[nss]

[pam]