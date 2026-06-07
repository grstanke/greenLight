-- ══════════════════════════════════════════════════════════════
-- SETUP SUPABASE — Cadena de Aprobaciones Territoria
-- Ejecutar UNA SOLA VEZ en: supabase.com → SQL Editor → Run
-- ══════════════════════════════════════════════════════════════

-- 1. Tabla de estado principal (una sola fila con todos los datos)
create table if not exists app_state (
  id           integer primary key default 1 check (id = 1),
  users        jsonb   not null default '[]',
  requests     jsonb   not null default '[]',
  next_user_id integer not null default 7,
  next_id      integer not null default 5,
  updated_at   timestamptz default now()
);

-- 2. Tabla de tokens de invitación
create table if not exists invite_tokens (
  token      text primary key,
  user_id    integer not null,
  created_at timestamptz default now()
);

-- 3. Permitir acceso público (app interna sin login)
alter table app_state     disable row level security;
alter table invite_tokens disable row level security;

-- 4. Limpiar tokens expirados automáticamente (opcional)
-- Se pueden eliminar manualmente o programar con pg_cron
