import { supabase } from './supabase';
import type { Product, ProductInsert, ProductUpdate } from './types';

export async function getProducts(activeOnly: boolean = true): Promise<Product[]> {
  let query = supabase
    .from('products')
    .select('*')
    .order('display_order', { ascending: true });
  
  if (activeOnly) {
    query = query.eq('is_active', true);
  }
  
  const { data, error } = await query;
  
  if (error) {
    console.error('Error fetching products:', error);
    throw new Error('Failed to fetch products');
  }
  
  return data || [];
}

export async function getProductsByCategory(category: string): Promise<Product[]> {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('category', category)
    .eq('is_active', true)
    .order('display_order', { ascending: true });
  
  if (error) {
    console.error('Error fetching products by category:', error);
    throw new Error('Failed to fetch products by category');
  }
  
  return data || [];
}

export async function getProductById(id: string): Promise<Product | null> {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('id', id)
    .single();
  
  if (error) {
    console.error('Error fetching product:', error);
    return null;
  }
  
  return data;
}

export async function createProduct(product: ProductInsert): Promise<Product | null> {
  const { data, error } = await supabase
    .from('products')
    .insert({
      ...product,
      is_active: product.is_active ?? true,
      display_order: product.display_order ?? 999
    })
    .select()
    .single();
  
  if (error) {
    console.error('Error creating product:', error);
    throw new Error('Failed to create product');
  }
  
  return data;
}

export async function updateProduct(product: ProductUpdate): Promise<Product | null> {
  const { id, ...updateData } = product;
  
  const { data, error } = await supabase
    .from('products')
    .update({
      ...updateData,
      updated_at: new Date().toISOString()
    })
    .eq('id', id)
    .select()
    .single();
  
  if (error) {
    console.error('Error updating product:', error);
    throw new Error('Failed to update product');
  }
  
  return data;
}

export async function deleteProduct(id: string): Promise<boolean> {
  const { error } = await supabase
    .from('products')
    .delete()
    .eq('id', id);
  
  if (error) {
    console.error('Error deleting product:', error);
    throw new Error('Failed to delete product');
  }
  
  return true;
}

export async function toggleProductStatus(id: string): Promise<Product | null> {
  // First get the current status
  const product = await getProductById(id);
  if (!product) return null;
  
  // Toggle the status
  return updateProduct({
    id,
    is_active: !product.is_active
  });
}

export async function getCategories(): Promise<string[]> {
  const { data, error } = await supabase
    .from('products')
    .select('category')
    .eq('is_active', true);
  
  if (error) {
    console.error('Error fetching categories:', error);
    return [];
  }
  
  // Get unique categories
  const categories = [...new Set(data?.map(item => item.category) || [])];
  return categories.sort();
} 