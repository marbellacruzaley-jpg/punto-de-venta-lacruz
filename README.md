# Punto de venta · Rectoría del Templo de la Cruz

Punto de venta para celular. Registra las ventas de artículos religiosos, imprime el recibo en una mini impresora térmica Bluetooth de 58 mm y genera el corte del día.

- **Pantallas:** se publican gratis con GitHub Pages (este repositorio).
- **Base de datos:** Supabase, proyecto `punto-de-venta-lacruz`.

## Archivos

| Archivo | Para qué sirve |
|---|---|
| `index.html` | Todas las pantallas (un solo archivo) |
| `config.js` | Dirección y llave pública del proyecto de Supabase |
| `supabase-esquema.sql` | Tablas, reglas de seguridad, funciones y usuarios iniciales (proyecto nuevo) |
| `supabase-actualizacion-egresos-cortes.sql` | Agrega egresos y cortes a una base que ya funciona (no borra nada) |
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
- **Listado del día**: el Resumen muestra solo las ventas de hoy. Cada día empieza un listado nuevo; las ventas anteriores quedan guardadas.

## Egresos (gastos)

En el Resumen toca **Egresos ▸ Registrar gasto**: elige la categoría (Mercancía, Servicios, Limpieza, Papelería, Mantenimiento, Transporte, Comida, Donativo, Otros), escribe el monto en el teclado, un detalle opcional y cómo se pagó. Si salió **en efectivo de la caja**, se descuenta del efectivo en caja. Para cancelar un gasto, tócalo en la lista. También se pueden registrar gastos de días anteriores (hasta una semana) eligiendo el día.

## Corte del día y corte mensual

- **Corte del día**: al cerrar la caja toca **Hacer corte de hoy**. Se guarda con tu nombre y la hora, y se imprime el ticket con ventas, gastos, neto y efectivo en caja (efectivo cobrado menos gastos pagados en efectivo). Si después hay otra venta, una cancelación o un gasto, el sistema avisa «Hubo cambios después del corte» para actualizarlo. Si un día se quedó sin corte, al día siguiente aparece el aviso en el Resumen.
- **Corte mensual**: total vendido, gastos, neto y efectivo neto del mes; tabla de cada día con su corte (✓ Hecho / Pendiente), totales por producto, forma de pago, usuario y categoría de gasto. Ticket imprimible y CSV de ventas y de gastos del mes.

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
