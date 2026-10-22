-- ==============================================================================
-- Herd AI: Supabase Database Schema & Storage Configuration
-- Copy & paste this entire script into your Supabase Dashboard -> SQL Editor -> Run
-- ==============================================================================

-- 1. Farms Identity Table
CREATE TABLE IF NOT EXISTS public.farms (
  farm_id TEXT PRIMARY KEY,
  pin_hash TEXT,
  phone_number TEXT,
  total_cattle INTEGER DEFAULT 0,
  total_milk_records INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for phone number recovery lookups
CREATE INDEX IF NOT EXISTS idx_farms_phone ON public.farms (phone_number);

-- 2. Cattle Registry Table (Stores biometric vectors, pedigree, health & vaccinations)
CREATE TABLE IF NOT EXISTS public.cattle (
  id TEXT NOT NULL,
  farm_id TEXT NOT NULL REFERENCES public.farms(farm_id) ON DELETE CASCADE,
  data JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (farm_id, id)
);

CREATE INDEX IF NOT EXISTS idx_cattle_farm ON public.cattle (farm_id);

-- 3. Milk Production Records Table
CREATE TABLE IF NOT EXISTS public.milk_records (
  id TEXT NOT NULL,
  farm_id TEXT NOT NULL REFERENCES public.farms(farm_id) ON DELETE CASCADE,
  cattle_id TEXT NOT NULL,
  date TEXT NOT NULL,
  data JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (farm_id, id)
);

CREATE INDEX IF NOT EXISTS idx_milk_farm ON public.milk_records (farm_id);
CREATE INDEX IF NOT EXISTS idx_milk_cattle ON public.milk_records (farm_id, cattle_id);

-- 4. Enable Row Level Security (RLS) & Policies
ALTER TABLE public.farms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cattle ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.milk_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anon read/write on farms" ON public.farms FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon read/write on cattle" ON public.cattle FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon read/write on milk_records" ON public.milk_records FOR ALL USING (true) WITH CHECK (true);

-- 5. Storage Bucket for Cattle Photos (1 GB Free on Supabase, No Credit Card Required)
INSERT INTO storage.buckets (id, name, public)
VALUES ('cattle-photos', 'cattle-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Storage Bucket Policies
CREATE POLICY "Allow public read/write on cattle-photos"
ON storage.objects FOR ALL
USING (bucket_id = 'cattle-photos')
WITH CHECK (bucket_id = 'cattle-photos');
