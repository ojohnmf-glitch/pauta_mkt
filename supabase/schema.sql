-- Painel Semanal de Pautas: estrutura no Supabase
-- Rode este arquivo inteiro no SQL Editor do projeto (Run).

create table if not exists public.projetos (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

-- Segurança por linha: o site usa a chave anon, então as políticas definem quem pode o quê.
-- Esta versão libera leitura e escrita para quem tiver o link do painel.
alter table public.projetos enable row level security;

drop policy if exists "pautas: ler" on public.projetos;
drop policy if exists "pautas: inserir" on public.projetos;
drop policy if exists "pautas: atualizar" on public.projetos;
drop policy if exists "pautas: excluir" on public.projetos;

create policy "pautas: ler"      on public.projetos for select using (true);
create policy "pautas: inserir"  on public.projetos for insert with check (true);
create policy "pautas: atualizar" on public.projetos for update using (true) with check (true);
create policy "pautas: excluir"  on public.projetos for delete using (true);

-- Atualizações em tempo real entre quem está com o painel aberto
do $$
begin
  alter publication supabase_realtime add table public.projetos;
exception when duplicate_object then null;
end $$;
