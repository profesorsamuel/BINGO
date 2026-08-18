# Bingo C.E.B.G El Jiral — Control de cobros

Pagina web para registrar quien compra boletos del bingo, cuanto pago, y su
telefono. Tiene acceso separado para dos cobradores (Betzaida y Samuel),
cada uno puede descargar su propio Excel e imprimir recibos en PDF.

## Archivos
- `index.html` → la pagina completa (login + formulario + historial + recibos).
- `schema.sql` → crea la tabla en Supabase donde se guardan los pagos.

## Paso 1 — Crear la tabla en Supabase

Puedes usar tu proyecto actual (`control-notas-jiral`) o crear uno nuevo
llamado **BINGO** desde supabase.com/dashboard → "New project".

1. Entra al proyecto que vayas a usar.
2. Ve a **SQL Editor** → **New query**.
3. Pega el contenido de `schema.sql` y presiona **Run**.

Esto crea la tabla `pagos` con: nombre del comprador, telefono, cantidad de
boletos, monto pagado, cobrador y fecha — y dos cobradores validos:
`samuel` y `betzaida`.

## Paso 2 — Conectar la pagina a tu Supabase

1. En Supabase ve a **Settings → API**.
2. Copia el **Project URL** y la llave **anon public**.
3. Abre `index.html` con un editor de texto, busca esta parte (cerca del
   final del archivo, dentro de `<script>`):

```js
   const SUPABASE_URL = "PON_AQUI_TU_SUPABASE_URL";
   const SUPABASE_ANON_KEY = "PON_AQUI_TU_SUPABASE_ANON_KEY";
```

4. Reemplaza esos dos valores por los tuyos y guarda el archivo.

> Mientras no pongas estos datos, la pagina funciona igual pero guarda los
> pagos solo temporalmente en el navegador (se pierden al cerrar la pestana).
> Es util para probar, pero para el bingo real necesitas conectar Supabase.

## Paso 3 — Subir a tu repositorio BINGO en GitHub

Desde la carpeta donde tengas `index.html` y `schema.sql`:
