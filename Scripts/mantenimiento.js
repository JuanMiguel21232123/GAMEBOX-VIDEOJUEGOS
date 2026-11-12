// Página de Mantenimiento: no usa carrito ni productos, solo arma el enlace de WhatsApp.
const year = document.getElementById("year");
if (year) year.textContent = new Date().getFullYear();

const waLink = (number, text) => `https://wa.me/${number}${text ? "?text=" + encodeURIComponent(text) : ""}`;
const MSG = `Hola, quiero información sobre el servicio de mantenimiento de ${BUSINESS}.`;

function setWaLink(number) {
  const a = document.getElementById("maint-wa");
  if (a) a.href = waLink(number, MSG);
}

setWaLink(WHATSAPP); // número por defecto (Scripts/config.js) mientras carga el configurado

// Si el admin cambió el WhatsApp en Personalización, lo respetamos también aquí
fetch("/api/public/settings", { credentials: "same-origin" })
  .then((r) => (r.ok ? r.json() : null))
  .then((s) => {
    if (s && /^[0-9]{10,15}$/.test(s.whatsapp || "")) setWaLink(s.whatsapp);
  })
  .catch(() => {});