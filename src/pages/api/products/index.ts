import type { APIRoute } from 'astro';
import { getProducts, getCategories } from '../../../lib/supabase-products';

export const GET: APIRoute = async ({ url }) => {
  try {
    const searchParams = new URL(url).searchParams;
    const includeInactive = searchParams.get('includeInactive') === 'true';
    const categoriesOnly = searchParams.get('categoriesOnly') === 'true';
    
    if (categoriesOnly) {
      const categories = await getCategories();
      return new Response(JSON.stringify({ categories }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    const products = await getProducts(!includeInactive);
    
    return new Response(JSON.stringify({ products }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Error in products API:', error);
    return new Response(JSON.stringify({ 
      error: 'Failed to fetch products',
      message: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}; 