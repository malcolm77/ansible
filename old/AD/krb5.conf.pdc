[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = domain.domain.au
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 domain.domain.au = {
  kdc = SERVER01.domain.domain.au
  admin_server = SERVER01.domain.domain.au
 }

[domain_realm]
 .nafis.cicz.gov.au = domain.domain.au
 nafis.cicz.gov.au = domain.domain.au
