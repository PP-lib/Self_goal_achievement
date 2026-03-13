create table if not exists public.app_state (
  state_key text primary key,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.app_state enable row level security;

drop policy if exists "Allow anon select app_state" on public.app_state;
drop policy if exists "Allow anon upsert app_state" on public.app_state;
drop policy if exists "Allow anon update app_state" on public.app_state;
drop policy if exists "Allow anon upsert app_state by token" on public.app_state;
drop policy if exists "Allow anon update app_state by token" on public.app_state;

create policy "Allow anon select app_state"
on public.app_state
for select
to anon
using (true);

create policy "Allow anon upsert app_state by token"
on public.app_state
for insert
to anon
with check (
  current_setting('request.headers', true)::jsonb ->> 'x-app-write-token' = 'CHANGE_ME_STRONG_TOKEN'
);

create policy "Allow anon update app_state by token"
on public.app_state
for update
to anon
using (
  current_setting('request.headers', true)::jsonb ->> 'x-app-write-token' = 'CHANGE_ME_STRONG_TOKEN'
)
with check (
  current_setting('request.headers', true)::jsonb ->> 'x-app-write-token' = 'CHANGE_ME_STRONG_TOKEN'
);
