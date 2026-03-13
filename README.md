# Self_goal_achievement
management my goals

## Supabase Sync (Recommended)

1. Create a Supabase project.
2. Open SQL Editor and run this schema:

```sql
create table if not exists public.app_state (
	state_key text primary key,
	payload jsonb not null,
	updated_at timestamptz not null default now()
);

alter table public.app_state enable row level security;

create policy if not exists "Allow anon select app_state"
on public.app_state
for select
to anon
using (true);

create policy if not exists "Allow anon upsert app_state"
on public.app_state
for insert
to anon
with check (true);

create policy if not exists "Allow anon update app_state"
on public.app_state
for update
to anon
using (true)
with check (true);
```

3. In the app toolbar, click "Supabase sync settings".
4. Set these values:
	 - Project URL: `https://<project-ref>.supabase.co`
	 - Anon key: Project Settings > API > anon public
	 - Table: `app_state`
	 - State key: `self_goal_main` (or any ID you want)

When configured, the app auto-saves to browser storage and also syncs to Supabase for cross-device access.

## Open in GitHub Codespaces

1. Open this repository in GitHub and create a new Codespace.
2. The container auto-starts a Node web server on port 8080.
3. Open the forwarded port URL (or browser preview).
4. Access the app with `index.html` (redirects to `radar_chart.html`).

## JSON Management in GitHub

- The app reads initial state from `scores.json` via `/api/state`.
- Every browser edit is saved back to `scores.json` via `/api/state`.
- This keeps JSON managed inside the repository in Codespaces.

## Sync Priority

At startup, the app picks the latest timestamp among available sources.

1. Supabase (if configured)
2. GitHub file sync (if configured)
3. `scores.json` (static file)
4. IndexedDB
5. localStorage

## Files

- `radar_chart.html`: Main application
- `scores.json`: Saved data template
- `index.html`: Entry point for web hosting/preview
- `server.js`: Static hosting + JSON API (`GET/POST /api/state`)
