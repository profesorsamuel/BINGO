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
  creado_en timestamptz not null default now(),
  telefono text,
  integrante_banda text
);

-- Si la tabla "donaciones" ya existia de antes (sin estas columnas),
-- esto las agrega sin borrar nada de lo que ya tenias guardado.
alter table public.donaciones add column if not exists telefono text;
alter table public.donaciones add column if not exists integrante_banda text;

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
  creado_en timestamptz not null default now(),
  telefono text,
  integrante_banda text
);

-- Si la tabla "promesas_donacion" ya existia de antes (sin estas columnas),
-- esto las agrega sin borrar nada de lo que ya tenias guardado.
alter table public.promesas_donacion add column if not exists telefono text;
alter table public.promesas_donacion add column if not exists integrante_banda text;

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

-- ---------------------------------------------------------
-- Tabla NUEVA: graduandos (Promocion 2026)
-- ---------------------------------------------------------
create table if not exists public.graduandos (
  id uuid primary key default gen_random_uuid(),
  nombre_estudiante text not null,
  whatsapp text,
  monto_total numeric(10,2) not null check (monto_total > 0),
  fecha_pago date not null,
  cobra text not null check (cobra in ('samuel','betzaida','jiral','mirian')),
  numero_recibo integer generated always as identity,
  creado_en timestamptz not null default now(),
  salon text
);

-- Si la tabla "graduandos" ya existia de antes (sin la columna "salon"),
-- esto la agrega sin borrar nada de lo que ya tenias guardado.
alter table public.graduandos add column if not exists salon text;
create index if not exists graduandos_salon_idx on public.graduandos (salon);

alter table public.graduandos enable row level security;

drop policy if exists "graduandos_select" on public.graduandos;
create policy "graduandos_select" on public.graduandos for select using (true);

drop policy if exists "graduandos_insert" on public.graduandos;
create policy "graduandos_insert" on public.graduandos for insert with check (true);

drop policy if exists "graduandos_update" on public.graduandos;
create policy "graduandos_update" on public.graduandos for update using (true) with check (true);

drop policy if exists "graduandos_delete" on public.graduandos;
create policy "graduandos_delete" on public.graduandos for delete using (true);

grant select, insert, update, delete on public.graduandos to anon;

-- ---------------------------------------------------------
-- Tabla NUEVA: abonos (pagos parciales) de un graduando
-- ---------------------------------------------------------
create table if not exists public.abonos_graduando (
  id uuid primary key default gen_random_uuid(),
  graduando_id uuid not null references public.graduandos(id) on delete cascade,
  monto numeric(10,2) not null check (monto > 0),
  fecha date not null,
  cobra text not null check (cobra in ('samuel','betzaida','jiral','mirian')),
  numero_abono integer generated always as identity,
  creado_en timestamptz not null default now()
);

alter table public.abonos_graduando enable row level security;

drop policy if exists "abonos_grad_select" on public.abonos_graduando;
create policy "abonos_grad_select" on public.abonos_graduando for select using (true);

drop policy if exists "abonos_grad_insert" on public.abonos_graduando;
create policy "abonos_grad_insert" on public.abonos_graduando for insert with check (true);

drop policy if exists "abonos_grad_update" on public.abonos_graduando;
create policy "abonos_grad_update" on public.abonos_graduando for update using (true) with check (true);

drop policy if exists "abonos_grad_delete" on public.abonos_graduando;
create policy "abonos_grad_delete" on public.abonos_graduando for delete using (true);

create index if not exists abonos_graduando_idx on public.abonos_graduando (graduando_id);

grant select, insert, update, delete on public.abonos_graduando to anon;

-- ---------------------------------------------------------
-- Tabla NUEVA: fotos_grad (pago de la foto de graduación, Promocion 2026)
-- Misma logica que "graduandos" pero para el cobro de la foto ($17.00).
-- ---------------------------------------------------------
create table if not exists public.fotos_grad (
  id uuid primary key default gen_random_uuid(),
  nombre_estudiante text not null,
  whatsapp text,
  monto_total numeric(10,2) not null check (monto_total > 0),
  fecha_pago date not null,
  cobra text not null check (cobra in ('samuel','betzaida','jiral','mirian','wendy')),
  numero_recibo integer generated always as identity,
  creado_en timestamptz not null default now(),
  salon text
);

create index if not exists fotos_grad_salon_idx on public.fotos_grad (salon);

alter table public.fotos_grad enable row level security;

drop policy if exists "fotos_grad_select" on public.fotos_grad;
create policy "fotos_grad_select" on public.fotos_grad for select using (true);

drop policy if exists "fotos_grad_insert" on public.fotos_grad;
create policy "fotos_grad_insert" on public.fotos_grad for insert with check (true);

drop policy if exists "fotos_grad_update" on public.fotos_grad;
create policy "fotos_grad_update" on public.fotos_grad for update using (true) with check (true);

drop policy if exists "fotos_grad_delete" on public.fotos_grad;
create policy "fotos_grad_delete" on public.fotos_grad for delete using (true);

grant select, insert, update, delete on public.fotos_grad to anon;

-- ---------------------------------------------------------
-- Tabla NUEVA: abonos (pagos parciales) de un pago de foto de graduación
-- ---------------------------------------------------------
create table if not exists public.abonos_foto (
  id uuid primary key default gen_random_uuid(),
  foto_id uuid not null references public.fotos_grad(id) on delete cascade,
  monto numeric(10,2) not null check (monto > 0),
  fecha date not null,
  cobra text not null check (cobra in ('samuel','betzaida','jiral','mirian','wendy')),
  numero_abono integer generated always as identity,
  creado_en timestamptz not null default now()
);

alter table public.abonos_foto enable row level security;

drop policy if exists "abonos_foto_select" on public.abonos_foto;
create policy "abonos_foto_select" on public.abonos_foto for select using (true);

drop policy if exists "abonos_foto_insert" on public.abonos_foto;
create policy "abonos_foto_insert" on public.abonos_foto for insert with check (true);

drop policy if exists "abonos_foto_update" on public.abonos_foto;
create policy "abonos_foto_update" on public.abonos_foto for update using (true) with check (true);

drop policy if exists "abonos_foto_delete" on public.abonos_foto;
create policy "abonos_foto_delete" on public.abonos_foto for delete using (true);

create index if not exists abonos_foto_idx on public.abonos_foto (foto_id);

grant select, insert, update, delete on public.abonos_foto to anon;
