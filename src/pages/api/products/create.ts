import type { APIRoute } from 'astro';
import { createProduct } from '../../../lib/supabase-products';
import type { ProductInsert } from '../../../lib/types';

export const POST: APIRoute = async ({ request }) => {
  try {
    const body = await request.json();
    
    // Validate required fields
    const requiredFields = ['title', 'description', 'image', 'category', 'features'];
    for (const field of requiredFields) {
      if (!body[field]) {
        return new Response(JSON.stringify({ 
          error: `Missing required field: ${field}` 
        }), {
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        });
      }
    }
    
    if (!Array.isArray(body.features)) {
      return new Response(JSON.stringify({ 
        error: 'Features must be an array' 
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    const productData: ProductInsert = {
      title: body.title,
      description: body.description,
      image: body.image,
      category: body.category,
      features: body.features,
      brochure_url: body.brochure_url || null,
      is_active: body.is_active !== undefined ? body.is_active : true,
      display_order: body.display_order || 999
    };
    
    const newProduct = await createProduct(productData);
    
    return new Response(JSON.stringify({ product: newProduct }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error creating product:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to create product',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}; 