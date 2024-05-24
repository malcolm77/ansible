set echo off
set feedback off
set headsep off
 
set trimspool on
set linesize 100
set heading on
set pagesize 0
 
 
alter session set container=PREPRODPDB

-- spool wfm_workflow_statecount.txt  
-- 'workflowstatecount,statename=' || s.name || ' count=' || count(*)
 
SELECT
  'workflowstatecount,' || s.name || ',' || count(*)
FROM
  wfm.site_workflow sw,
  wfm.workflow w,
  wfm.wf_object_state wos,
  wfm.state s,
  dual
WHERE
  sw.name = 'acic'
  AND sw.site_id = w.site_id
  AND w.wf_id = s.wf_id
  AND s.state_id = wos.state_id
  AND wos.locked = 0
  and wos.incarnation = (select max(incarnation) from wfm.wf_object_state wos2 where wos2.wfo_id = wos.wfo_id)
GROUP BY s.name
  ORDER by count(*);  
 
-- spool off
 
quit;
