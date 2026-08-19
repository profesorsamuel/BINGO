# Bingo & Donaciones C.E.B.G El Jiral — Control de cobros

Pagina web para registrar dos cosas:
1. **Boletos del bingo** — quien compra, cuanto pago, y su telefono.
2. **Donaciones para la Banda C.E.B.G El Jiral** — quien dona, cuanto dona,
   la fecha de la donacion, un mensaje de agradecimiento y una frase para el
   donante, y quien recibe la donacion (Samuel, Betzaida o el propio
   C.E.B.G El Jiral).

Al iniciar sesion, cada cobrador elige que tipo de recibo va a generar
(Bingo o Donacion). Los recibos se descargan automaticamente en PDF apenas
se guardan, y cualquier registro se puede corregir despues por si hubo un
error.

## Archivos
- `index.html` → la pagina completa (login + seleccion de tipo de recibo +
  formularios + historial + recibos en PDF).
- `schema.sql` → crea las tablas en Supabase donde se guardan los pagos y
  las donaciones.

## Paso 1 — Actualizar la tabla en Supabase

Usa tu proyecto actual (`control-notas-jiral`).

1. Entra al proyecto en supabase.com/dashboard.
2. Ve a **SQL Editor** → **New query**.
3. Pega TODO el contenido de `schema.sql` y presiona **Run**.

Esto:
- Deja la tabla `pagos` (boletos del bingo) igual que antes.
- Crea la tabla nueva `donaciones` con: nombre del donante, monto, fecha de
  la donacion, quien la recibe (`samuel`, `betzaida` o `jiral`),
  agradecimiento y frase para el donante.
- Da permisos (`grant`) a la llave publica para leer, insertar, actualizar
  y borrar en ambas tablas, igual que ya tenias configurado para `pagos`.

> Si ya tenias la tabla `pagos` creada, no pasa nada: el script no la
> vuelve a crear ni borra tus datos. Solo agrega lo nuevo.

## Paso 2 — Conectar la pagina a tu Supabase

Esto ya deberia estar configurado desde antes (`SUPABASE_URL` y
`SUPABASE_ANON_KEY` dentro de `index.html`). No hay que tocar nada mas para
que funcionen las donaciones — usan la misma conexion.

## Paso 3 — Subir el `index.html` y `schema.sql` actualizados a GitHub

1. Entra a tu repositorio `profesorsamuel/BINGO` en GitHub.
2. Abre `index.html`, dale click al lapiz (editar), borra todo y pega el
   contenido nuevo. Guarda los cambios ("Commit changes").
3. Repite lo mismo con `schema.sql`.
4. Corre el `schema.sql` actualizado en Supabase (Paso 1) antes de usar la
   pagina, para que exista la tabla `donaciones`.

## Como se usa

1. El cobrador entra con su usuario y clave (igual que antes).
2. Aparece una pantalla para elegir: **Recibo de Bingo** o
   **Recibo de Donacion**.
3. **Bingo:** igual que siempre — nombre, telefono, boletos, monto.
4. **Donacion:** nombre del donante, cuanto dona, fecha de la donacion,
   quien recibe la donacion, mensaje de agradecimiento y una frase (se
   puede cambiar con el boton "Otra frase" o escribir una propia).
5. Al guardar, el recibo en PDF se descarga automaticamente.
6. En el historial se puede corregir cualquier dato por error, volver a
   descargar el recibo, o borrar el registro.
7. El boton **"Cambiar tipo de recibo"** (arriba, junto a "Cerrar sesion")
   permite pasar de Bingo a Donacion sin cerrar sesion.
