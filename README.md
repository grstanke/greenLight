# Cadena de Aprobaciones — Territoria

Sistema web para gestionar flujos de aprobación secuencial entre usuarios del equipo.

---

## Estructura del proyecto

```
aprobaciones-territoria/
│
├── cadena-aprobacion.html   ← LA APLICACIÓN COMPLETA (un solo archivo)
├── worker.js                ← Backend Cloudflare (alternativa a Supabase, no usado)
├── wrangler.toml            ← Config Cloudflare (no usado actualmente)
├── .env.example             ← Plantilla de credenciales
└── docs/
    └── supabase-setup.sql   ← Script SQL para crear las tablas en Supabase
```

---

## Estado actual

### ✅ Funcionalidades implementadas

| Módulo | Descripción |
|--------|-------------|
| **Panel General** | Tabla de todas las solicitudes con estadísticas (total, en proceso, aprobadas, rechazadas) |
| **Mis Aprobaciones** | Filtra solo las solicitudes donde el usuario es aprobador |
| **Historial** | Vista del panel con todas las solicitudes |
| **Detalle de solicitud** | Vista completa con cadena de aprobación visual, progreso y acciones |
| **Nueva solicitud** | Formulario: tema, descripción, prioridad, fecha límite, selección de aprobadores en orden |
| **Aprobar / Rechazar** | Botones con campo de comentario y confirmación modal |
| **Índice SP-XXX** | Cada solicitud tiene un código único (SP-001, SP-002…) |
| **Ordenamiento** | Clic en columnas: Código, Tema, Creado, Vence, Estado (asc/desc) |
| **Filtros de estado** | Todas / En proceso / Aprobadas / Rechazadas |
| **Gestión de Usuarios** | Agregar, editar usuarios con nombre, correo, cargo, departamento, permisos |
| **Invitación por correo** | Genera link único con token (72h), abre cliente de correo pre-llenado |
| **Activación de cuenta** | El invitado abre el link, establece contraseña y activa su cuenta |
| **Persistencia** | Datos guardados en Supabase (nube) o localStorage (local) |
| **Sidebar dinámico** | Muestra el usuario activo con link a su perfil |

---

## Modos de funcionamiento

### Modo Local (sin internet / desarrollo)
- Los datos se guardan en `localStorage` del navegador
- Solo funciona en el mismo equipo
- `SB_URL` y `SB_KEY` vacíos en el HTML

### Modo Nube (producción)
- Los datos se guardan en Supabase (PostgreSQL)
- Cualquier usuario accede desde cualquier dispositivo
- Los links de invitación funcionan públicamente
- Requiere credenciales configuradas en el HTML

---

## Cómo publicar (sin Node.js, todo desde el navegador)

### Paso 1 — Configurar Supabase
1. Ir a [supabase.com](https://supabase.com) → crear proyecto gratis
2. Ir a **SQL Editor** → ejecutar el contenido de `docs/supabase-setup.sql`
3. Ir a **Settings → API** → copiar **Project URL** y **anon key**

### Paso 2 — Configurar el HTML
En `cadena-aprobacion.html`, buscar y editar:
```javascript
const SB_URL = 'https://TU-PROYECTO.supabase.co';
const SB_KEY = 'eyJhbGci...TU-ANON-KEY';
```

### Paso 3 — Publicar el HTML
**Opción A — Vercel:**
1. Subir `cadena-aprobacion.html` al repositorio GitHub
2. Ir a [vercel.com](https://vercel.com) → conectar repo → Deploy

**Opción B — Cloudflare Pages:**
1. Ir a [dash.cloudflare.com](https://dash.cloudflare.com) → Workers & Pages → Pages
2. Upload assets → arrastrar `cadena-aprobacion.html`

---

## Usuarios por defecto

| Nombre | Email | Rol | Estado |
|--------|-------|-----|--------|
| Gerardo Stanke | gstanke@territoria.cl | Administrador | Activo |
| Ana Torres | atorres@territoria.cl | Gerente de Proyectos | Activo |
| Carlos Rojas | crojas@territoria.cl | Director Financiero | Activo |
| María López | mlopez@territoria.cl | Jefa de Operaciones | Activo |
| Pedro Silva | psilva@territoria.cl | Gerente Comercial | Invitado |
| Laura Méndez | lmendez@territoria.cl | Directora Legal | Activo |

---

## Pendiente / Próximos pasos

- [ ] Configurar credenciales Supabase en el HTML
- [ ] Publicar en Vercel o Cloudflare Pages
- [ ] Verificar que links de invitación funcionan desde cualquier dispositivo
- [ ] Autenticación real (login con usuario/contraseña)
