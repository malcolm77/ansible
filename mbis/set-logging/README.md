
How to Use these scripts

-- STOP --
ap -l FES,DES,JBOSS,TERA stop.yml --tags=stopFES
ap -l SERVER07 stop.yml --tags=stopFESMIG,stopDES,stopTERAMIG

-- DEBUG --
ap -l FES,DES,JBOSS,TERA,SERVER07 debug.yml

-- INFO  --
ap -l FES,DES,JBOSS,TERA,SERVER07 info.yml

-- START --
ap -l FES,DES,JBOSS,TERA start.yml --tags=startFES
ap -l SERVER07 start.yml --tags=startFESMIG,startDES,startTERAMIG

