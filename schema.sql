-- Esquema para Turso, inferido a partir del código de functions/api/[[path]].js.
-- IMPORTANTE: no me pasaste el .sql real de tu plantilla; si ya tienes uno
-- (el que usas para "Para ellas" u otro proyecto con este mismo backend),
-- úsalo en su lugar y solo corre el INSERT de categorías que está al final.
-- Revísalo contra tu plantilla original antes de ejecutarlo en producción.

CREATE TABLE IF NOT EXISTS admins (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  email         TEXT UNIQUE NOT NULL,
  name          TEXT NOT NULL,
  password_hash TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
  slug          TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  description   TEXT DEFAULT '',
  accent        TEXT NOT NULL DEFAULT 'gold',   -- gold | blue | green
  variant_label TEXT NOT NULL DEFAULT 'Opción',
  sort_order    INTEGER NOT NULL DEFAULT 0,
  active        INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS subcategories (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  category   TEXT NOT NULL REFERENCES categories(slug) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  active     INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS products (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  category       TEXT NOT NULL REFERENCES categories(slug),
  subcategory_id INTEGER REFERENCES subcategories(id) ON DELETE SET NULL,
  name           TEXT NOT NULL,
  description    TEXT DEFAULT '',
  price          INTEGER NOT NULL,
  image_url      TEXT,
  stock          INTEGER,              -- NULL = sin control de existencias
  active         INTEGER NOT NULL DEFAULT 1,
  created_at     TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS product_variants (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  price      INTEGER,                  -- NULL = usa el precio del producto
  stock      INTEGER,                  -- NULL = sin control de existencias
  active     INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS orders (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  code            TEXT UNIQUE NOT NULL,
  customer_name   TEXT NOT NULL,
  customer_phone  TEXT NOT NULL,
  delivery_type   TEXT NOT NULL,        -- domicilio | tienda
  address         TEXT,
  neighborhood    TEXT,
  payment_method  TEXT,                 -- efectivo | nequi
  preferred_time  TEXT,
  notes           TEXT,
  total           INTEGER NOT NULL,
  status          TEXT NOT NULL DEFAULT 'pending',  -- pending | confirmed | delivered | cancelled
  status_at       TEXT NOT NULL DEFAULT (datetime('now')),
  created_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS order_items (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id      INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id    INTEGER REFERENCES products(id) ON DELETE SET NULL,
  variant_id    INTEGER,
  name          TEXT NOT NULL,
  variant_name  TEXT,
  price         INTEGER NOT NULL,
  quantity      INTEGER NOT NULL,
  category      TEXT
);

CREATE TABLE IF NOT EXISTS expenses (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  spent_at    TEXT NOT NULL,            -- AAAA-MM-DD
  description TEXT NOT NULL,
  amount      INTEGER NOT NULL,
  category    TEXT REFERENCES categories(slug)
);

CREATE TABLE IF NOT EXISTS site_settings (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- ---------- Categorías iniciales de Game Zone ----------
-- Cámbialas luego desde el panel: Productos › Categorías.
INSERT INTO categories (slug, name, description, accent, variant_label, sort_order, active) VALUES
  ('consolas', 'Consolas',
   'Las mejores plataformas para jugar, nuevas y seleccionadas con criterio. Equipos, controles y accesorios con garantía.',
   'green', 'Modelo', 1, 1),
  ('juegos', 'Juegos',
   'Títulos para todos los gustos y todas las plataformas: lanzamientos, clásicos y ediciones especiales.',
   'blue', 'Plataforma', 2, 1),
  ('servicios', 'Servicio técnico',
   'Diagnóstico, reparación y mantenimiento con repuestos de calidad y trabajo garantizado.',
   'gold', 'Tipo de servicio', 3, 1);

-- Crea tu primer usuario admin aparte, con el hash que genera hashPassword()
-- de functions/_lib/db.js (no un password en texto plano).
