# Punto de venta · Rectoría del Templo de la Cruz

Punto de venta para celular. Registra las ventas de artículos religiosos, imprime el recibo en una mini impresora térmica Bluetooth de 58 mm y genera el corte del día.

- **Pantallas:** se publican gratis con GitHub Pages (este repositorio).
- **Base de datos:** Supabase, proyecto `punto-de-venta-lacruz`.

## Archivos

| Archivo | Para qué sirve |
|---|---|
| `index.html` | Todas las pantallas (un solo archivo) |
| `config.js` | Dirección y llave pública del proyecto de Supabase |
| `supabase-esquema.sql` | Tablas, reglas de seguridad, funciones y usuarios iniciales |

## Entrar

Abre la dirección de GitHub Pages en **Chrome para Android** (menú ⋮ ▸ **Agregar a la pantalla principal** para tenerla como app).

Usuarios: **Mauricio**, **Alejandro** y **Fabiola**. La contraseña inicial la tiene la encargada (no se publica aquí). Cada quien puede cambiarla en **Ajustes ▸ Mi contraseña**.

## Conectar la mini impresora (celular, Bluetooth)

1. Enciende la impresora (papel de 58 mm).
2. Haz una venta y en el recibo toca **Imprimir por Bluetooth**. Chrome muestra la lista de dispositivos: elige la impresora.
3. Mientras siga conectada, cada venta nueva se imprime sola.

### Impresora USB en la computadora (Windows)

1. Instala la impresora térmica en Windows con su driver y haz una página de prueba desde Windows.
2. En **Configuración ▸ Impresoras y escáneres**, márcala como **predeterminada**. En sus **Preferencias de impresión**, elige el papel de 58 mm (por ejemplo "58 x 3276 mm" o "Roll paper 58").
3. En el sistema: **Ajustes ▸ Impresora de este dispositivo ▸ Al registrar una venta: Imprimir por USB**. Cada computadora o celular guarda su propia opción.
4. **Para que imprima directo, sin ventana de impresión**, crea un acceso directo en el escritorio (clic derecho ▸ Nuevo ▸ Acceso directo) con esta ubicación, en una sola línea:

   ```
   "C:\Program Files\Google\Chrome\Application\chrome.exe" --user-data-dir="C:\PuntoDeVentaChrome" --kiosk-printing --app=https://marbellacruzaley-jpg.github.io/punto-de-venta-lacruz/
   ```

   Nómbralo **Punto de venta** y ábrelo siempre desde ahí. La primera vez pide iniciar sesión. Si Chrome está en otra carpeta, cambia la ruta del `chrome.exe`.
5. Sin el acceso directo también funciona: Chrome muestra la ventana de impresión. Elige la impresora térmica, márgenes **Ninguno** y escala **100 %**.

Si la impresora no aparece o no imprime, usa el respaldo **RawBT**: instala la app gratuita RawBT de Play Store, vincúlala con la impresora y en el recibo toca **Imprimir con RawBT**. En **Ajustes ▸ Mini impresora** hay un ticket de prueba.

## Uso diario

- **Nueva venta:** toca los productos. Sal ($20), Aceite ($20) y Microdosis ($30) tienen precio fijo; los demás piden el precio al tocarlos.
- **Cobrar:** efectivo (calcula el cambio), transferencia o tarjeta. El folio lo asigna la base de datos.
- **Sin internet:** la venta se guarda en el teléfono, el recibo dice "Folio pendiente" y se envía sola al volver la conexión. El estado se ve arriba a la derecha: ● verde **En línea** · ● amarillo **N por enviar** · ● rojo **Sin conexión**.
- **Corte:** elige el día. Total por producto, por forma de pago y por usuario, con ticket imprimible y CSV.
- **Cancelar venta:** desde el recibo. Queda marcada como cancelada y no cuenta en el corte.

## Ajustes

- **Productos y precios:** marca "Fijo" y pon el precio para que el producto se agregue con un toque.
- **Usuarios:** agregar personas (entran con la contraseña inicial), desactivarlas o restablecer su contraseña.
- **Reportes y respaldo:** CSV de ventas por rango de fechas (se abre en Excel) y respaldo completo `.json`. Haz un respaldo al menos una vez al mes.

## Supabase

- Ver las ventas directamente: Supabase ▸ **Table Editor** ▸ `ventas` y `partidas`.
- El plan gratis **pausa el proyecto si pasa una semana sin uso**. Si un día el sistema dice "Sin conexión" aunque haya internet, entra a supabase.com ▸ proyecto `punto-de-venta-lacruz` ▸ **Restore project**. Los datos no se pierden.
- Si algún día se crea un proyecto nuevo: en `supabase-esquema.sql` reemplaza `CAMBIA-ESTA-CONTRASENA` por la contraseña inicial, ejecútalo en **SQL Editor ▸ Run** (sin guardar esa versión en GitHub) y cambia la dirección y la llave en `config.js`.

## Actualizar las pantallas

Edita `index.html` en GitHub (ícono de lápiz ▸ **Commit changes**). GitHub Pages publica el cambio en uno o dos minutos. Las ventas no se tocan: viven en Supabase.
