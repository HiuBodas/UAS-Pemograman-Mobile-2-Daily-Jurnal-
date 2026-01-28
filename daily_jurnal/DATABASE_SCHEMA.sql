-- Daily Journal Database Schema
-- Untuk Supabase PostgreSQL

-- Tabel Users
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS (Row Level Security) untuk users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy untuk users - setiap user hanya bisa melihat data mereka sendiri
CREATE POLICY "Users can view their own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- Tabel Journals
CREATE TABLE IF NOT EXISTS journals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  mood TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS untuk journals table
ALTER TABLE journals ENABLE ROW LEVEL SECURITY;

-- Policy untuk journals - setiap user hanya bisa melihat jurnal mereka sendiri
CREATE POLICY "Users can view their own journals"
  ON journals FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own journals"
  ON journals FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own journals"
  ON journals FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own journals"
  ON journals FOR DELETE
  USING (auth.uid() = user_id);

-- Create indexes untuk performa query
CREATE INDEX idx_journals_user_id ON journals(user_id);
CREATE INDEX idx_journals_created_at ON journals(created_at DESC);
CREATE INDEX idx_journals_title_search ON journals USING gin(to_tsvector('english', title));
CREATE INDEX idx_journals_content_search ON journals USING gin(to_tsvector('english', content));
