/* Punto de venta: guarda las pantallas en el teléfono para abrir al instante.
   Las ventas y la base de datos (supabase.co) nunca se guardan aquí: siempre van directo al servidor. */
const CACHE = 'pos-lacruz-v3';
const SHELL = ['./', './index.html', './informes.html', './config.js', './manifest.webmanifest', './icon-192.png', './icon-512.png',
  'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.58.0/dist/umd/supabase.js'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});

async function avisarNueva(){
  const cs = await self.clients.matchAll({type:'window'});
  cs.forEach(c => c.postMessage('nueva-version'));
}

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.hostname.endsWith('supabase.co')) return;            // datos: siempre en línea
  const propio = url.origin === self.location.origin;
  const cdn = url.hostname === 'cdn.jsdelivr.net' || url.hostname.endsWith('gstatic.com') || url.hostname === 'fonts.googleapis.com';
  if (!propio && !cdn) return;

  const esPagina = req.mode === 'navigate';
  const clave = esPagina ? (url.pathname.endsWith('/informes.html') ? './informes.html' : './index.html') : req;
  e.respondWith((async () => {
    const cache = await caches.open(CACHE);
    const guardada = await cache.match(clave, {ignoreSearch: esPagina || propio});
    const red = fetch(req).then(async res => {
      if (res && (res.ok || res.type === 'opaque')) {
        if (propio && guardada) {
          const a = guardada.headers.get('etag'), b = res.headers.get('etag');
          if (a && b && a !== b && (esPagina || url.pathname.endsWith('config.js'))) avisarNueva();
        }
        await cache.put(clave, res.clone());
      }
      return res;
    }).catch(() => null);
    if (guardada) { e.waitUntil(red); return guardada; }   // instantáneo; se actualiza por detrás
    const r = await red;
    return r || new Response('Sin conexión', {status: 503, headers: {'Content-Type': 'text/plain; charset=utf-8'}});
  })());
});
