-- Carteira João Matheus — configuração do banco no Supabase
-- Cole tudo no SQL Editor do Supabase e clique em "Run". Pode rodar mais de uma vez sem problema.

-- 1) Tabela única: cada linha é um lead, um imóvel, um gasto ou a configuração.
create table if not exists public.registros (
  user_id       uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  id            text        not null,
  colecao       text        not null check (colecao in ('leads', 'imoveis', 'gastos', 'config')),
  dados         jsonb       not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now(),
  primary key (user_id, id)
);

create index if not exists registros_colecao_idx on public.registros (user_id, colecao);

-- 2) Segurança: cada usuário só enxerga e altera as próprias linhas.
alter table public.registros enable row level security;

drop policy if exists "dono le"      on public.registros;
drop policy if exists "dono cria"    on public.registros;
drop policy if exists "dono altera"  on public.registros;
drop policy if exists "dono apaga"   on public.registros;

create policy "dono le"     on public.registros for select to authenticated using ((select auth.uid()) = user_id);
create policy "dono cria"   on public.registros for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "dono altera" on public.registros for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "dono apaga"  on public.registros for delete to authenticated using ((select auth.uid()) = user_id);

-- Quem não fez login não acessa nada.
revoke all on public.registros from anon;
grant select, insert, update, delete on public.registros to authenticated;

-- 3) Tempo real: o que você lança no celular aparece no computador na hora.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'registros'
  ) then
    alter publication supabase_realtime add table public.registros;
  end if;
end $$;
