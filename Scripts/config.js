// Backend con Turso + Cloudflare Pages Functions (ver functions/api/[[path]].js y functions/_lib/db.js).
// No usa Supabase.

// WhatsApp del negocio: código de país + número, sin + ni espacios
// (también se puede cambiar desde el panel admin > Personalización)
const WHATSAPP = "573000000000";

// Nombre del negocio: se usa en el título de las páginas y en el mensaje de WhatsApp. CÁMBIALO AQUÍ.
const BUSINESS = "Gamebox Videojuegos Manizales";
// Ciudad para el mapa de domicilios del panel admin. CÁMBIALA AQUÍ.
const CITY = "Manizales, Colombia";
// Iniciales que se muestran cuando un producto no tiene foto
const INITIALS = BUSINESS.split(/\s+/).map((w) => w[0]).join("").slice(0, 2).toUpperCase();