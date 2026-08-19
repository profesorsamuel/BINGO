-- ==========================================================
-- BINGO EL JIRAL - Esquema de base de datos para Supabase
-- ==========================================================
-- Instrucciones:
-- 1. Entra a tu proyecto de Supabase ("control-notas-jiral").
-- 2. Ve a "SQL Editor" (menu izquierdo) > "New query".
-- 3. Pega TODO este archivo y dale click en "Run".
--    (Si ya habias creado la tabla "pagos" antes, no pasa nada,
--    los "create table if not exists" no la vuelven a crear.)
-- ==========================================================

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------
-- Tabla de pagos de boletos del BINGO (ya existente)
-- ---------------------------------------------------------
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

alter table public.pagos enable row level security;

drop policy if exists "pagos_select" on public.pagos;
create policy "pagos_select" on public.pagos for select using (true);

drop policy if exists "pagos_insert" on public.pagos;
create policy "pagos_insert" on public.pagos for insert with check (true);

drop policy if exists "pagos_update" on public.pagos;
create policy "pagos_update" on public.pagos for update using (true) with check (true);

drop policy if exists "pagos_delete" on public.pagos;
create policy "pagos_delete" on public.pagos for delete using (true);

create index if not exists pagos_cobrador_idx on public.pagos (cobrador);

-- El login de cobradores lo maneja la propia pagina (no Supabase Auth),
-- asi que dejamos que la llave publica ("anon key") pueda leer, insertar,
-- actualizar y borrar. Aceptable para una herramienta interna pequena.
grant select, insert, update, delete on public.pagos to anon;

-- ---------------------------------------------------------
-- Tabla NUEVA: donaciones para la Banda C.E.B.G El Jiral
-- ---------------------------------------------------------
create table if not exists public.donaciones (
  id uuid primary key default gen_random_uuid(),
  nombre_donante text not null,
  monto numeric(10,2) not null check (monto > 0),
  fecha_donacion date not null,
  cobra text not null check (cobra in ('samuel','betzaida','jiral')),
  agradecimiento text,
  frase text,
  numero_recibo integer generated always as identity,
  creado_en timestamptz not null default now()
);

alter table public.donaciones enable row level security;

drop policy if exists "donaciones_select" on public.donaciones;
create policy "donaciones_select" on public.donaciones for select using (true);

drop policy if exists "donaciones_insert" on public.donaciones;
create policy "donaciones_insert" on public.donaciones for insert with check (true);

drop policy if exists "donaciones_update" on public.donaciones;
create policy "donaciones_update" on public.donaciones for update using (true) with check (true);

drop policy if exists "donaciones_delete" on public.donaciones;
create policy "donaciones_delete" on public.donaciones for delete using (true);

create index if not exists donaciones_fecha_idx on public.donaciones (fecha_donacion);

grant select, insert, update, delete on public.donaciones to anon;

-- ---------------------------------------------------------
-- Tabla NUEVA: promesas de donación (aun no han donado)
-- ---------------------------------------------------------
create table if not exists public.promesas_donacion (
  id uuid primary key default gen_random_uuid(),
  nombre_donante text not null,
  monto_prometido numeric(10,2) not null check (monto_prometido > 0),
  fecha_promesa date not null,
  cobra text not null check (cobra in ('samuel','betzaida','jiral')),
  notas text,
  numero_recibo integer generated always as identity,
  creado_en timestamptz not null default now()
);

alter table public.promesas_donacion enable row level security;

drop policy if exists "promesas_select" on public.promesas_donacion;
create policy "promesas_select" on public.promesas_donacion for select using (true);

drop policy if exists "promesas_insert" on public.promesas_donacion;
create policy "promesas_insert" on public.promesas_donacion for insert with check (true);

drop policy if exists "promesas_update" on public.promesas_donacion;
create policy "promesas_update" on public.promesas_donacion for update using (true) with check (true);

drop policy if exists "promesas_delete" on public.promesas_donacion;
create policy "promesas_delete" on public.promesas_donacion for delete using (true);

grant select, insert, update, delete on public.promesas_donacion to anon;

-- ---------------------------------------------------------
-- Tabla NUEVA: abonos (pagos parciales) de una promesa
-- ---------------------------------------------------------
create table if not exists public.abonos_promesa (
  id uuid primary key default gen_random_uuid(),
  promesa_id uuid not null references public.promesas_donacion(id) on delete cascade,
  monto numeric(10,2) not null check (monto > 0),
  fecha date not null,
  cobra text not null check (cobra in ('samuel','betzaida','jiral')),
  numero_abono integer generated always as identity,
  creado_en timestamptz not null default now()
);

alter table public.abonos_promesa enable row level security;

drop policy if exists "abonos_select" on public.abonos_promesa;
create policy "abonos_select" on public.abonos_promesa for select using (true);

drop policy if exists "abonos_insert" on public.abonos_promesa;
create policy "abonos_insert" on public.abonos_promesa for insert with check (true);

drop policy if exists "abonos_update" on public.abonos_promesa;
create policy "abonos_update" on public.abonos_promesa for update using (true) with check (true);

drop policy if exists "abonos_delete" on public.abonos_promesa;
create policy "abonos_delete" on public.abonos_promesa for delete using (true);

create index if not exists abonos_promesa_idx on public.abonos_promesa (promesa_id);

grant select, insert, update, delete on public.abonos_promesa to anon;
