# Sistema de Gestión de Productos - IDN Industrial

Este documento explica cómo configurar y usar el sistema de gestión de productos integrado con Supabase.

## Configuración Inicial

### 1. Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables:

```env
SUPABASE_URL=tu_supabase_url
SUPABASE_ANON_KEY=tu_supabase_anon_key
```

### 2. Configuración de Supabase

1. Ve a tu proyecto en [Supabase](https://supabase.com)
2. Navega a SQL Editor
3. Ejecuta el script contenido en `database-setup.sql` para crear la tabla y configurar las políticas de seguridad

### 3. Políticas de Seguridad (RLS)

El sistema incluye Row Level Security con las siguientes políticas:

- **Lectura pública**: Los usuarios no autenticados pueden ver solo productos activos
- **Gestión completa**: Los usuarios autenticados pueden gestionar todos los productos
- **Operaciones CRUD**: Solo usuarios autenticados pueden crear, actualizar y eliminar productos

## Estructura de la Base de Datos

### Tabla `products`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID | Identificador único (generado automáticamente) |
| `title` | VARCHAR(255) | Nombre del producto |
| `description` | TEXT | Descripción detallada |
| `image` | VARCHAR(500) | URL de la imagen del producto |
| `category` | VARCHAR(100) | Categoría del producto |
| `features` | TEXT[] | Array de características |
| `brochure_url` | VARCHAR(500) | URL del folleto (opcional) |
| `is_active` | BOOLEAN | Estado activo/inactivo |
| `display_order` | INTEGER | Orden de visualización |
| `created_at` | TIMESTAMPTZ | Fecha de creación |
| `updated_at` | TIMESTAMPTZ | Fecha de última actualización |

## Uso del Sistema

### Para Usuarios Públicos

Los productos activos se muestran automáticamente en la página `/productos`. La página:

- Obtiene datos de Supabase automáticamente
- Incluye filtrado por categoría
- Maneja errores de conectividad con datos de respaldo
- Es completamente responsive

### Para Administradores

#### Acceso al Panel de Administración

Visita `/admin/productos` para acceder al panel de gestión (requiere autenticación).

#### Funcionalidades Disponibles

1. **Visualizar Productos**
   - Lista todos los productos (activos e inactivos)
   - Filtros por categoría, estado y búsqueda de texto
   - Información resumida en formato tabla

2. **Crear Productos**
   - Formulario completo con validación
   - Soporte para múltiples características
   - Configuración de orden de visualización

3. **Editar Productos**
   - Modificación de todos los campos
   - Previsualización en tiempo real
   - Validación de datos

4. **Gestionar Estado**
   - Activar/desactivar productos sin eliminarlos
   - Control granular de visibilidad

5. **Eliminar Productos**
   - Eliminación permanente con confirmación
   - Limpieza automática de referencias

## API Endpoints

### Públicos (Solo Lectura)

```
GET /api/products
- Obtiene productos activos
- Query params: ?categoriesOnly=true para solo categorías

GET /api/products/[id]
- Obtiene un producto específico por ID
```

### Privados (Requieren Autenticación)

```
GET /api/products?includeInactive=true
- Obtiene todos los productos (activos e inactivos)

POST /api/products/create
- Crea un nuevo producto
- Body: ProductInsert

PUT /api/products/[id]
- Actualiza un producto existente
- Body: ProductUpdate

DELETE /api/products/[id]
- Elimina un producto permanentemente
```

## Tipos TypeScript

```typescript
interface Product {
  id: string;
  title: string;
  description: string;
  image: string;
  category: string;
  features: string[];
  brochure_url?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  display_order?: number;
}
```

## Manejo de Errores

El sistema incluye manejo robusto de errores:

- **Errores de conexión**: Muestra datos de respaldo
- **Errores de API**: Mensajes informativos al usuario
- **Validación**: Validación tanto en cliente como servidor
- **Fallbacks**: Graceful degradation en caso de fallas

## Migración de Datos

Para migrar productos existentes:

1. Ejecuta el script SQL para crear la estructura
2. Los productos de ejemplo se insertan automáticamente
3. Modifica o elimina los productos de ejemplo según necesites
4. La página de productos se actualizará automáticamente

## Desarrollo y Personalización

### Agregar Nuevos Campos

1. Modifica la tabla en Supabase
2. Actualiza los tipos en `src/lib/types.ts`
3. Modifica las funciones en `src/lib/supabase-products.ts`
4. Actualiza el formulario en `/admin/productos`

### Personalizar la UI

- Los componentes están en `src/components/Products/`
- Los estilos siguen el sistema de diseño IDN
- Responsive design con Tailwind CSS

## Troubleshooting

### Problemas Comunes

1. **Error de conexión a Supabase**
   - Verifica las variables de entorno
   - Confirma que el proyecto Supabase esté activo

2. **Productos no aparecen**
   - Verifica que `is_active = true`
   - Revisa las políticas RLS

3. **Error en admin panel**
   - Confirma que el usuario esté autenticado
   - Verifica permisos en Supabase

### Logs y Debugging

Los errores se registran en:
- Console del navegador (client-side)
- Logs de Astro (server-side)
- Dashboard de Supabase (database)

## Seguridad

- Row Level Security habilitado
- Validación en cliente y servidor
- Sanitización de inputs
- Políticas granulares de acceso
- HTTPS requerido en producción 