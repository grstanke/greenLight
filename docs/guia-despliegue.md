# Guía Completa de Despliegue
## Sistema de Cadena de Aprobaciones — Territoria

> **Tiempo total estimado:** 25–30 minutos  
> **Requisitos:** Solo un navegador web. Sin instalaciones.

---

## Resumen del proceso

```
[1] Supabase    →  crear base de datos gratis en la nube
[2] HTML        →  pegar las credenciales (2 líneas)
[3] GitHub      →  subir los archivos del proyecto
[4] Vercel      →  publicar la app con URL pública
[5] Probar      →  verificar que todo funciona
```

---

# PARTE 1 — Supabase (Base de datos)

## 1.1 Crear cuenta

1. Abrir **[https://supabase.com](https://supabase.com)**
2. Clic en **"Start your project"** o **"Sign Up"**
3. Registrarse con tu cuenta de **GitHub** (recomendado, más rápido) o con email
4. Confirmar el email si te lo pide

---

## 1.2 Crear el proyecto

1. Una vez dentro del panel, clic en **"New project"**
2. Completar:
   - **Name:** `aprobaciones-territoria`
   - **Database Password:** elige una contraseña segura y **guárdala** (la necesitarás si algún día accedes directo a la base de datos)
   - **Region:** `South America (São Paulo)` o `US East (N. Virginia)` — la más cercana
3. Clic en **"Create new project"**
4. ⏳ Esperar ~2 minutos mientras Supabase configura todo

---

## 1.3 Crear las tablas

1. En el menú lateral izquierdo, clic en **"SQL Editor"**
2. Clic en **"New query"**
3. Copiar y pegar el siguiente SQL:

```sql
-- Tabla de estado principal (una sola fila con todos los datos)
create table if not exists app_state (
  id           integer primary key default 1 check (id = 1),
  users        jsonb   not null default '[]',
  requests     jsonb   not null default '[]',
  next_user_id integer not null default 7,
  next_id      integer not null default 5,
  updated_at   timestamptz default now()
);

-- Tabla de tokens de invitación
create table if not exists invite_tokens (
  token      text primary key,
  user_id    integer not null,
  created_at timestamptz default now()
);

-- Permitir acceso público (app interna sin login)
alter table app_state     disable row level security;
alter table invite_tokens disable row level security;
```

> 💡 También puedes copiar este SQL desde el archivo `docs/supabase-setup.sql` de este proyecto.

4. Clic en el botón **"Run"** (o `Ctrl+Enter`)
5. Debe aparecer el mensaje: `Success. No rows returned`

---

## 1.4 Obtener las credenciales

1. En el menú lateral, clic en **"Project Settings"** (ícono de engranaje ⚙️)
2. Clic en **"API"**
3. Copiar los dos valores:

   | Campo | Dónde está | Para qué sirve |
   |-------|-----------|----------------|
   | **Project URL** | Sección "Project URL" | Dirección de tu base de datos |
   | **anon / public key** | Sección "Project API keys" → fila "anon" | Contraseña de acceso público |

   Se ven así:
   ```
   Project URL:  https://abcdefghijkl.supabase.co
   anon key:     eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZ...
   ```

---

# PARTE 2 — Configurar el HTML

## 2.1 Abrir el archivo

Abrir en Claude Code (o cualquier editor de texto):
```
aprobaciones-territoria/cadena-aprobacion.html
```

## 2.2 Pegar las credenciales

Buscar las líneas (están al inicio del bloque `<script>`, alrededor de la línea 766):

```javascript
const SB_URL = '';   // Ej: 'https://abcdefgh.supabase.co'
const SB_KEY = '';   // Ej: 'eyJhbGciOiJIUzI1NiIs...'
```

Reemplazar con tus valores reales:

```javascript
const SB_URL = 'https://TU-PROYECTO.supabase.co';
const SB_KEY = 'eyJhbGci...TU-CLAVE-COMPLETA';
```

> ⚠️ Las comillas simples `' '` son obligatorias. No dejes espacios al inicio ni al final.

## 2.3 Guardar el archivo

`Ctrl + S`

---

# PARTE 3 — GitHub (subir archivos)

## 3.1 Ir a tu repositorio

Abrir en el navegador tu repositorio de GitHub (el que ya creaste).

## 3.2 Subir los archivos

1. En la página principal del repo, clic en **"Add file"** → **"Upload files"**
2. Arrastrar **todos los archivos** de la carpeta `aprobaciones-territoria/`:
   - `cadena-aprobacion.html` ✅ (con las credenciales ya pegadas)
   - `vercel.json` ✅
   - `.gitignore` ✅
   - `README.md` ✅
   - Carpeta `docs/` con `supabase-setup.sql` y `guia-despliegue.md`

   > ⚠️ **NO subir** el archivo `.env.example` con credenciales reales.  
   > ⚠️ **NO subir** `worker.js` ni `wrangler.toml` (no se usan en esta configuración).

3. En el campo **"Commit changes"** escribir: `Configuración inicial del proyecto`
4. Clic en **"Commit changes"**

---

# PARTE 4 — Vercel (publicar la app)

## 4.1 Crear cuenta en Vercel

1. Abrir **[https://vercel.com](https://vercel.com)**
2. Clic en **"Sign Up"**
3. Elegir **"Continue with GitHub"** — se conecta automáticamente a tu cuenta

## 4.2 Importar el proyecto

1. En el panel de Vercel, clic en **"Add New..."** → **"Project"**
2. Buscar tu repositorio en la lista y clic en **"Import"**
3. En la configuración del proyecto:
   - **Framework Preset:** `Other` (no es un framework, es HTML estático)
   - Todo lo demás dejar como está
4. Clic en **"Deploy"**
5. ⏳ Esperar ~1 minuto

## 4.3 Obtener la URL pública

Cuando termine el deploy verás:
```
🎉 Congratulations!
Your project has been successfully deployed.
URL: https://aprobaciones-territoria-XXXX.vercel.app
```

**Esa es tu URL pública.** Cualquier persona con esa URL puede acceder al sistema.

---

# PARTE 5 — Verificar que todo funciona

## 5.1 Prueba básica

1. Abrir la URL de Vercel en el navegador
2. Debe aparecer la pantalla de carga "Conectando con Supabase…"
3. En 1–2 segundos carga el Panel General con las 4 solicitudes de ejemplo

   ✅ Si carga → Supabase conectado correctamente  
   ❌ Si se queda en "Conectando…" → revisar que SB_URL y SB_KEY estén correctos en el HTML

## 5.2 Prueba de invitación

1. Ir a la pestaña **Usuarios**
2. Buscar a **Pedro Silva** (está en estado "Invitado")
3. Clic en **"Reenviar"** (el botón azul de su tarjeta)
4. En el modal, clic en **"Copiar enlace"**
5. Pegar el enlace en una nueva pestaña del navegador
6. Debe aparecer la pantalla **"Activar tu Cuenta"** con los datos de Pedro Silva
7. Ingresar una contraseña de prueba → clic **"Activar mi cuenta"**
8. Volver a la pestaña de Usuarios → Pedro Silva debe aparecer como **"Activo"**

   ✅ Si funciona → el sistema de invitaciones está operativo

## 5.3 Prueba en otro dispositivo

1. Abrir la URL de Vercel en tu teléfono o en otro computador
2. Los datos deben ser los mismos que ves en tu computador
3. Si creas una solicitud en un equipo, debe aparecer en el otro

   ✅ Si los datos están sincronizados → Supabase funcionando correctamente

---

# Actualizar la app en el futuro

Cuando necesites hacer cambios en la app:

1. Editar `cadena-aprobacion.html` en Claude Code
2. Subir el archivo actualizado a GitHub (mismo proceso del Paso 3.2, reemplaza el archivo)
3. Vercel detecta el cambio automáticamente y redespliega en ~1 minuto

---

# Solución de problemas frecuentes

| Problema | Causa probable | Solución |
|----------|---------------|----------|
| Se queda en "Conectando con Supabase…" | Credenciales incorrectas | Verificar SB_URL y SB_KEY en el HTML |
| Link de invitación dice "no válido" | App ejecutándose en local (no en Vercel) | Abrir desde la URL de Vercel, no desde el archivo local |
| Los datos no se sincronizan | SB_URL o SB_KEY vacíos | Pegar las credenciales y volver a subir a GitHub |
| Error al guardar | Tablas no creadas en Supabase | Ejecutar el SQL del Paso 1.3 nuevamente |

---

# Estructura final del proyecto

```
aprobaciones-territoria/
│
├── cadena-aprobacion.html   ← La aplicación completa
├── vercel.json              ← Configuración de enrutamiento para Vercel
├── .gitignore               ← Archivos que no se suben a GitHub
├── README.md                ← Resumen del proyecto
└── docs/
    ├── supabase-setup.sql   ← SQL para crear las tablas
    └── guia-despliegue.md   ← Este documento
```

---

*Generado con Claude Code · Territoria SPA · 2026*
