set echo off
set feedback off
set headsep off
 
set trimspool on
set linesize 100
set heading on
set pagesize 0
 
alter session set container=PREPRODPDB;
 
-- spool jms_wms_store_queuestatuscount.txt
 
--'workflowstatuscount,queue=' || send_to || ',status=' || decode(status, 0, 'Available', 1,'Inprogress', 'Unknown') || ' count=' || count(*) as count

SELECT
  'workflowstatuscount,' || send_to || ',' || decode(status, 0, 'Available', 1,'Inprogress', 'Unknown') || ',' || count(*) as count
from 
   JMS.WMS_STORE
group by
   send_to, status;

-- SELECT 'workflowstatuscount,queue=empty count=0' from DUAL;
quit;
