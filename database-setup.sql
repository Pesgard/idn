-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  image VARCHAR(500) NOT NULL,
  category VARCHAR(100) NOT NULL,
  features TEXT[] NOT NULL DEFAULT '{}',
  brochure_url VARCHAR(500),
  is_active BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 999,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_display_order ON products(display_order);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_products_updated_at BEFORE UPDATE
    ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access to active products
CREATE POLICY "Public can read active products" ON products
  FOR SELECT USING (is_active = true);

-- Create policies for authenticated users (admins) to manage all products
CREATE POLICY "Authenticated users can read all products" ON products
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert products" ON products
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update products" ON products
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Authenticated users can delete products" ON products
  FOR DELETE TO authenticated USING (true);

-- Insert sample data
INSERT INTO products (title, description, image, category, features, brochure_url, display_order) VALUES
('Mezcladores de Cinta', 
 'Mezcladores horizontales de alta eficiencia para materiales secos y húmedos.', 
 'https://images.pexels.com/photos/3862132/pexels-photo-3862132.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Mezclado',
 ARRAY['Mezclado homogéneo', 'Diseño robusto', 'Fácil descarga'],
 '/brochures/mezcladores-cinta.pdf',
 1),

('Mezcladores Cónicos',
 'Mezcladores cónicos para materiales de diferentes densidades.',
 'https://images.pexels.com/photos/3862125/pexels-photo-3862125.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Mezclado',
 ARRAY['Mezclado suave', 'Sin segregación', 'Limpieza fácil'],
 '/brochures/mezcladores-conicos.pdf',
 2),

('Básculas de Proceso',
 'Sistemas de pesaje para control de peso en línea de producción.',
 'https://images.pexels.com/photos/3862130/pexels-photo-3862130.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Pesaje',
 ARRAY['Alta precisión', 'Certificación OIML', 'Conectividad 4.0'],
 '/brochures/basculas-proceso.pdf',
 3),

('Básculas de Camión',
 'Básculas vehiculares para pesaje de camiones y remolques.',
 'https://images.pexels.com/photos/3862129/pexels-photo-3862129.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Pesaje',
 ARRAY['Estructura reforzada', 'Software de gestión', 'Conectividad remota'],
 '/brochures/basculas-camion.pdf',
 4),

('Dosificadores Gravimétricos',
 'Dosificadores de pérdida de peso para materiales en polvo.',
 'https://images.pexels.com/photos/3862131/pexels-photo-3862131.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Dosificación',
 ARRAY['Control PID', 'Alta precisión', 'Compensación automática'],
 '/brochures/dosificadores-gravimetricos.pdf',
 5),

('Dosificadores Volumétricos',
 'Dosificadores de tornillo para materiales granulados.',
 'https://images.pexels.com/photos/3862127/pexels-photo-3862127.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Dosificación',
 ARRAY['Control de velocidad', 'Diseño modular', 'Mantenimiento simple'],
 '/brochures/dosificadores-volumetricos.pdf',
 6),

('Transportadores Helicoidales',
 'Transportadores de tornillo para materiales en polvo y granulados.',
 'https://images.pexels.com/photos/3862128/pexels-photo-3862128.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Transporte',
 ARRAY['Transporte eficiente', 'Diseño sellado', 'Múltiples configuraciones'],
 '/brochures/transportadores-helicoidales.pdf',
 7),

('Transportadores Neumáticos',
 'Sistemas de transporte neumático para materiales finos.',
 'https://images.pexels.com/photos/3862126/pexels-photo-3862126.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Transporte',
 ARRAY['Transporte limpio', 'Flexibilidad de ruta', 'Bajo mantenimiento'],
 '/brochures/transportadores-neumaticos.pdf',
 8),

('Detectores de Metales',
 'Detectores de metales para seguridad alimentaria e industrial.',
 'https://images.pexels.com/photos/3862124/pexels-photo-3862124.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
 'Detección',
 ARRAY['Alta sensibilidad', 'Rechazo automático', 'Certificación HACCP'],
 '/brochures/detectores-metales.pdf',
 9);

-- Grant necessary permissions (if needed, depending on your Supabase setup)
-- GRANT ALL ON products TO anon, authenticated;
-- GRANT USAGE ON SCHEMA public TO anon, authenticated; 