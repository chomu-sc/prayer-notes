-- 기도제목 노트: Supabase 설정 (SQL Editor에 붙여넣고 Run)
create table if not exists public.prayer_items (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  kind text not null check (kind in ('prayer','person','meta')),
  id text not null,
  body jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, kind, id)
);
alter table public.prayer_items enable row level security;
drop policy if exists "own rows only" on public.prayer_items;
create policy "own rows only" on public.prayer_items
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
alter table public.prayer_items replica identity full;
alter publication supabase_realtime add table public.prayer_items;
