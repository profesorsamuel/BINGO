-- ==========================================================
-- BINGO EL JIRAL - Esquema de base de datos para Supabase
-- ==========================================================
-- Instrucciones:
-- 1. Entra a tu proyecto de Supabase (el mismo "control-notas-jiral"
--    o crea uno nuevo llamado "BINGO").
-- 2. Ve a "SQL Editor" (menu izquierdo) > "New query".
-- 3. Pega TODO este archivo y dale click en "Run".
-- ==========================================================

create extension if not exists "pgcrypto";

create table if not exists public.pagos (
  id uuid primary key default gen_random_uuid(),
  cobrador text not null check (cobrador in ('samuel','betzaida')),
  nombre_comprador text not null,
  telefono text,
  boletos integer not null default 1 check (boletos > 0),
  monto numeric(10,2) not null check (monto >= 0),
  numero_recibo integer generated always as identity,
  fecha timestamptz not null default now()
);

-- Activamos seguridad a nivel de fila (RLS)
alter table public.pagos enable row level security;

-- Como el login de cobradores lo maneja la propia pagina (no Supabase Auth),
-- dejamos que la llave publica ("anon key") pueda leer, insertar y borrar.
-- Esto es aceptable para una herramienta interna pequena, pero ten en cuenta
-- que cualquiera que tenga tu URL + anon key podria ver/editar los datos.
drop policy if exists "pagos_select" on public.pagos;
create policy "pagos_select" on public.pagos for select using (true);

drop policy if exists "pagos_insert" on public.pagos;
create policy "pagos_insert" on public.pagos for insert with check (true);

drop policy if exists "pagos_delete" on public.pagos;
create policy "pagos_delete" on public.pagos for delete using (true);

-- Indice util para filtrar rapido por cobrador
create index if not exists pagos_cobrador_idx on public.pagos (cobrador);
