# Instruksi Setup Database di Supabase

## Step 1: Login ke Supabase Dashboard
1. Buka https://supabase.com
2. Login dengan akun Anda
3. Pilih project: `xaeevfdlspuubmnxnblu`

## Step 2: Buat Tables Menggunakan SQL Editor

1. Pergi ke **SQL Editor** di sidebar kiri
2. Click **New Query** atau **New SQL**
3. Copy-paste semua SQL queries dibawah ini

### Query 1: Buat Users Table

```sql
-- Tabel Users
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own profile
CREATE POLICY "Users can view their own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update their own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);
```

Klik **Run** untuk execute query ini.

### Query 2: Buat Journals Table

```sql
-- Tabel Journals
CREATE TABLE IF NOT EXISTS journals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  mood TEXT,
  category TEXT DEFAULT 'personal',
  is_favorite BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS
ALTER TABLE journals ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own journals
CREATE POLICY "Users can view their own journals"
  ON journals FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can insert their own journals
CREATE POLICY "Users can insert their own journals"
  ON journals FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own journals
CREATE POLICY "Users can update their own journals"
  ON journals FOR UPDATE
  USING (auth.uid() = user_id);

-- Policy: Users can delete their own journals
CREATE POLICY "Users can delete their own journals"
  ON journals FOR DELETE
  USING (auth.uid() = user_id);

-- Create indexes untuk performa
CREATE INDEX idx_journals_user_id ON journals(user_id);
CREATE INDEX idx_journals_created_at ON journals(created_at DESC);
CREATE INDEX idx_journals_category ON journals(category);
CREATE INDEX idx_journals_is_favorite ON journals(is_favorite);
```

Klik **Run** untuk execute query ini.

## Step 3: Verifikasi Tables

1. Pergi ke **Table Editor** di sidebar kiri
2. Anda seharusnya bisa melihat 2 tables:
   - `users`
   - `journals`

3. Klik pada setiap table untuk verify columns-nya:

**Users Table Columns:**
- id (UUID, Primary Key)
- email (TEXT)
- display_name (TEXT)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)

**Journals Table Columns:**
- id (UUID, Primary Key)
- user_id (UUID, Foreign Key ke users)
- title (TEXT)
- content (TEXT)
- mood (TEXT)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)

## Step 4: Setup Authentication

1. Pergi ke **Authentication** di sidebar kiri
2. Click **Providers**
3. Enable **Email** provider (biasanya sudah enabled by default)
4. Configure settings sesuai kebutuhan Anda:
   - Auto Confirm Email: Disable (untuk production)
   - Double Confirm Changes: Enable
   - etc.

## Step 5: Setup Row Level Security (RLS)

1. Pergi ke **Table Editor**
2. Click pada table `users`
3. Verify bahwa RLS sudah enabled:
   - Click **🔒 RLS** button di top
   - Harus show status "RLS is enabled"
4. Lakukan hal yang sama untuk table `journals`

## Step 6: Test Koneksi

Sekarang aplikasi Flutter Anda sudah siap!

1. Run aplikasi:
   ```bash
   flutter run
   ```

2. Test Register:
   - Buka Register screen
   - Input email, password (min 6 char), dan nama
   - Click "Daftar"
   - Verifikasi di Supabase Dashboard → Authentication → Users

3. Test Login:
   - Login dengan email dan password yang baru saja dibuat
   - Verifikasi user bisa login

4. Test CRUD Journal:
   - Create new journal dengan click (+)
   - Lihat di Supabase Dashboard → Table Editor → journals
   - Edit dan delete journal untuk test update dan delete functionality

## Troubleshooting

### Error: "relation 'users' already exists"
- Table sudah dibuat sebelumnya
- Skip query pertama, atau drop table dulu:
  ```sql
  DROP TABLE IF EXISTS journals CASCADE;
  DROP TABLE IF EXISTS users CASCADE;
  ```

### Error: "permission denied for schema public"
- User Supabase Anda tidak punya permission
- Gunakan service role key untuk admin operations
- Atau verifikasi role user di database

### Users tidak bisa insert journals
- Verify RLS policies sudah benar
- Check di Table Editor → journals → Policy
- Pastikan policy condition: `auth.uid() = user_id`

### Journal tidak muncul di app
- Verify di Supabase Dashboard → journals table
- Check apakah data ada
- Verify user_id sesuai dengan current user ID

## Struktur Data

### User Registration Flow
1. User register di app dengan email, password, display_name
2. Supabase Auth membuat auth user
3. App create record di `users` table dengan auth user id

### Journal Creation Flow
1. User logged in
2. Create journal entry
3. App insert ke `journals` table dengan:
   - user_id: current user's ID
   - title: journal title
   - content: journal content
   - mood: selected mood
   - created_at: timestamp now
   - updated_at: timestamp now

## Next Steps

Setelah database setup selesai:

1. ✅ Run `flutter pub get`
2. ✅ Run aplikasi: `flutter run`
3. ✅ Test semua features (register, login, CRUD journal)
4. ✅ Screenshots untuk dokumentasi
5. ✅ Buat video demo
6. ✅ Setup untuk production jika diperlukan

---

**Need Help?**
- Dokumentasi Supabase: https://supabase.com/docs
- Flutter Documentation: https://flutter.dev/docs
- Issues? Check logs di Supabase Dashboard → Logs
