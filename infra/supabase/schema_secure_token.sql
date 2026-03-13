create table if not exists public.app_state (
  state_key text primary key,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.goal_milestones (
  id bigserial primary key,
  state_key text not null,
  item_id text not null,
  item_label text not null,
  target_title text not null default '',
  target_date date,
  memo text not null default '',
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  unique (state_key, item_id)
);

create table if not exists public.goal_comments (
  id bigserial primary key,
  state_key text not null,
  item_id text not null,
  item_label text not null,
  comment_text text not null,
  commented_at timestamptz not null default now()
);

alter table public.app_state enable row level security;
alter table public.goal_milestones enable row level security;
alter table public.goal_comments enable row level security;

drop policy if exists "Allow anon select app_state" on public.app_state;
drop policy if exists "Allow anon upsert app_state" on public.app_state;
drop policy if exists "Allow anon update app_state" on public.app_state;
drop policy if exists "Allow anon upsert app_state by token" on public.app_state;
drop policy if exists "Allow anon update app_state by token" on public.app_state;
drop policy if exists "Allow anon select goal_milestones" on public.goal_milestones;
drop policy if exists "Allow anon upsert goal_milestones by token" on public.goal_milestones;
drop policy if exists "Allow anon update goal_milestones by token" on public.goal_milestones;
drop policy if exists "Allow anon select goal_comments" on public.goal_comments;
drop policy if exists "Allow anon insert goal_comments by token" on public.goal_comments;

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

create policy "Allow anon select goal_milestones"
on public.goal_milestones
for select
to anon
using (true);

create policy "Allow anon upsert goal_milestones by token"
on public.goal_milestones
for insert
to anon
with check (
  current_setting('request.headers', true)::jsonb ->> 'x-app-write-token' = 'CHANGE_ME_STRONG_TOKEN'
);

create policy "Allow anon update goal_milestones by token"
on public.goal_milestones
for update
to anon
using (
  current_setting('request.headers', true)::jsonb ->> 'x-app-write-token' = 'CHANGE_ME_STRONG_TOKEN'
)
with check (
  current_setting('request.headers', true)::jsonb ->> 'x-app-write-token' = 'CHANGE_ME_STRONG_TOKEN'
);

create policy "Allow anon select goal_comments"
on public.goal_comments
for select
to anon
using (true);

create policy "Allow anon insert goal_comments by token"
on public.goal_comments
for insert
to anon
with check (
  current_setting('request.headers', true)::jsonb ->> 'x-app-write-token' = 'CHANGE_ME_STRONG_TOKEN'
);
