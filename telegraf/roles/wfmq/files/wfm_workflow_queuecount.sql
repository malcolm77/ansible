set echo off
set feedback off
set headsep off
 
set trimspool on
set linesize 100
set heading on
set pagesize 0
 
alter sessions set container=PREPRODPDB
 
-- spool wfm_workflow_queuestatecount.txt
-- 'workflowqueuecount,queuestate=' || state.queue || ' count=' || count(*) as count
 
SELECT
  'workflowqueuecount,' || state.queue || ',' || count(*) as count
FROM
  wfm.site_workflow,wfm.workflow,wfm.wf_object_state,wfm.state
WHERE
  site_workflow.name = 'acic'
  AND site_workflow.site_id = workflow.site_id
  AND workflow.wf_id = state.wf_id
  AND state.state_id = wf_object_state.state_id
  AND state.queue IS NOT NULL
  AND wf_object_state.locked = 0
  GROUP BY state.queue
ORDER by
  count;

-- SELECT 'workflowqueuecount,queuestate=empty count=0' from DUAL;
quit
