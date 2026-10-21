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
| `sw.js`, `manifest.webmanifest`, `icon-*.png` | App instalable y carga instantánea en el celular |

## Entrar e instalar en el celular

1. Abre la dirección de GitHub Pages en **Chrome para Android**.
2. Menú ⋮ ▸ **Instalar app** (o **Agregar a la pantalla principal**). Queda con ícono propio, abre a pantalla completa y carga al instante aunque la señal esté lenta.

Usuarios: **Mauricio**, **Alejandro** y **Fabiola**. La contraseña inicial la tiene la encargada (no se publica aquí). Cada quien puede cambiarla en **Ajustes ▸ Mi contraseña**. Mientras la sesión siga abierta, el sistema entra directo a la caja.

## Conectar la mini impresora (Bluetooth, 58 mm)

1. Enciende la impresora.
2. En la caja toca el **ícono de impresora** (arriba) y elige la impresora en la lista de Chrome. El punto verde indica que está conectada.
3. Listo: cada venta se imprime y se corta sola. Se conecta una vez cada que abres el sistema.

Si la impresora no aparece o no imprime, usa el respaldo **RawBT**: instala la app gratuita RawBT de Play Store, vincúlala con la impresora y en el recibo toca **Imprimir con RawBT**. En **Ajustes ▸ Mini impresora** hay un ticket de prueba y la opción de imprimir o no cada venta automáticamente.

## Vender rápido

- **Productos con precio fijo** (Sal $20, Aceite $20, Microdosis $30): un toque los agrega. El botón **−** del mosaico quita uno.
- **Productos sin precio fijo**: se abre un teclado numérico grande (no el del celular). Los últimos precios usados aparecen como botones **+ $50**: un toque y queda agregado.
- **Cobrar**: en efectivo, un solo toque registra la venta: **Pago exacto** o el billete con que pagan (el botón ya muestra el cambio). **Otra cantidad** abre el teclado. Para transferencia o tarjeta, elige la pestaña y toca **Registrar**.
- **Después de cobrar** la caja queda lista para la siguiente venta. Un aviso verde muestra el folio y el cambio, con botones para ver el recibo o reimprimir.
- La venta se guarda al instante en el teléfono y se envía al servidor por detrás, así nunca esperas a la red. Arriba se ve el estado: ● verde **En línea** · ● amarillo **N por enviar** · ● rojo **Sin conexión**. Sin internet se sigue vendiendo y todo se envía solo al volver la señal.
- **☰ (arriba a la izquierda)**: resumen del día, últimas ventas, corte, ajustes y cerrar sesión.
- **Cancelar venta**: desde el recibo. Queda marcada como cancelada y no cuenta en el corte.
- **Corte**: elige el día. Total por producto, por forma de pago y por usuario, con ticket imprimible y CSV.

## Ajustes

- **Productos y precios:** marca "Fijo" y pon el precio para que el producto se agregue con un toque.
- **Usuarios:** agregar personas (entran con la contraseña inicial), desactivarlas o restablecer su contraseña.
- **Reportes y respaldo:** CSV de ventas por rango de fechas (se abre en Excel) y respaldo completo `.json`. Haz un respaldo al menos una vez al mes.

## Supabase

- Ver las ventas directamente: Supabase ▸ **Table Editor** ▸ `ventas` y `partidas`.
- El plan gratis **pausa el proyecto si pasa una semana sin uso**. Si un día el sistema dice "Sin conexión" aunque haya internet, entra a supabase.com ▸ proyecto `punto-de-venta-lacruz` ▸ **Restore project**. Los datos no se pierden.
- Si algún día se crea un proyecto nuevo: en `supabase-esquema.sql` reemplaza `CAMBIA-ESTA-CONTRASENA` por la contraseña inicial, ejecútalo en **SQL Editor ▸ Run** (sin guardar esa versión en GitHub) y cambia la dirección y la llave en `config.js`.

## Actualizar las pantallas

Edita `index.html` en GitHub (ícono de lápiz ▸ **Commit changes**). GitHub Pages publica el cambio en uno o dos minutos. En el celular aparece el aviso «Hay una versión nueva · toca para actualizar». Las ventas no se tocan: viven en Supabase.
