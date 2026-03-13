# Supabase setup

## Files

- schema_quickstart.sql: Simple setup, open anon write policy. Creates app_state + goal_milestones + goal_comments.
- schema_secure_token.sql: Write-protected setup using x-app-write-token header. Creates app_state + goal_milestones + goal_comments.

## Recommended flow

1. Run schema_secure_token.sql in Supabase SQL Editor.
2. Replace CHANGE_ME_STRONG_TOKEN with your own random string before running.
3. In the app, open Supabase sync settings and set the same write token.
4. Save once and verify badge shows Supabase save success.

## New tables

- app_state: existing aggregate state payload.
- goal_milestones: per item target title/date/memo.
- goal_comments: per item comments (time-stamped).

## Notes

- Never expose service role keys in frontend code.
- Anon key is expected in browser apps.
- If secure token is empty in the app while secure schema is active, writes will fail by design.
