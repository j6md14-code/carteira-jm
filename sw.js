// Guarda a "casca" do app para abrir rápido e funcionar como app instalado.
// Os dados nunca ficam aqui: eles vêm sempre do Supabase.
const CACHE = "carteira-jm-v8";
const ARQUIVOS = ["./", "./index.html", "./manifest.webmanifest", "./logo-mark.png", "./logo-mark-pablo.png", "./favicon.png", "./icon-192.png", "./icon-512.png", "./apple-touch-icon.png"];

self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(ARQUIVOS)).then(() => self.skipWaiting()));
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys().then((ks) => Promise.all(ks.filter((k) => k !== CACHE).map((k) => caches.delete(k)))).then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (e) => {
  const url = new URL(e.request.url);
  // Só arquivos do próprio site; Supabase e fontes passam direto.
  if (e.request.method !== "GET" || url.origin !== self.location.origin) return;
  // Rede primeiro (sempre a versão mais nova); sem internet, usa a cópia guardada.
  e.respondWith(
    fetch(e.request)
      .then((r) => {
        const copia = r.clone();
        caches.open(CACHE).then((c) => c.put(e.request, copia));
        return r;
      })
      .catch(() => caches.match(e.request).then((r) => r || caches.match("./index.html")))
  );
});
