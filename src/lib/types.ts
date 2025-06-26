export interface Product {
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

export interface ProductInsert {
  title: string;
  description: string;
  image: string;
  category: string;
  features: string[];
  brochure_url?: string;
  is_active?: boolean;
  display_order?: number;
}

export interface ProductUpdate {
  id: string;
  title?: string;
  description?: string;
  image?: string;
  category?: string;
  features?: string[];
  brochure_url?: string;
  is_active?: boolean;
  display_order?: number;
}