-- Inspect all saved states
select
  state_key,
  updated_at,
  payload->>'lastUpdated' as payload_last_updated,
  jsonb_array_length(coalesce(payload->'items', '[]'::jsonb)) as item_count
from public.app_state
order by updated_at desc;

-- Inspect one specific state row (change key if needed)
select
  state_key,
  updated_at,
  payload
from public.app_state
where state_key = 'self_goal_main';

-- Expand scores in payload.items for one state key
select
  a.state_key,
  i.value->>'id' as id,
  (i.value->>'now')::int as now_score,
  (i.value->>'goal')::int as goal_score
from public.app_state a
cross join lateral jsonb_array_elements(coalesce(a.payload->'items', '[]'::jsonb)) as i(value)
where a.state_key = 'self_goal_main'
order by id;
