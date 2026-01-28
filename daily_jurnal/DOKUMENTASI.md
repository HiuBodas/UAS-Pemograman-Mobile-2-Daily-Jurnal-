# Daily Journal App

Aplikasi jurnal harian yang memungkinkan pengguna untuk mencatat hari mereka dengan fitur authentication, CRUD operations, dan state management menggunakan Riverpod.

## Fitur Utama

✅ **Authentication**
- Register dengan email dan password
- Login dengan email dan password
- Logout
- Session management otomatis

✅ **Journal Management**
- Create journal baru
- Read/View semua journals
- Update journal yang sudah ada
- Delete journal
- Search journal berdasarkan title atau content

✅ **Mood Tracking**
- Pilihan mood: Happy, Sad, Neutral, Excited, Angry, Anxious
- Emoji display untuk setiap mood

✅ **User Interface**
- Material Design 3
- Responsive layout
- Loading states
- Error handling
- Beautiful splash screen

## Teknologi yang Digunakan

- **Framework**: Flutter
- **State Management**: Riverpod 2.4.0
- **Backend**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Database**: PostgreSQL (Supabase)
- **Date Formatting**: intl package

## Struktur Project

```
lib/
├── main.dart                      # Entry point
├── models/
│   ├── user_model.dart           # Model untuk user
│   └── journal_model.dart        # Model untuk journal
├── services/
│   ├── auth_service.dart         # Service untuk authentication
│   └── journal_service.dart      # Service untuk journal operations
├── providers/
│   ├── auth_provider.dart        # Riverpod providers untuk auth
│   └── journal_provider.dart     # Riverpod providers untuk journal
├── screens/
│   ├── splash_screen.dart        # Splash screen
│   ├── auth/
│   │   ├── login_screen.dart     # Login screen
│   │   └── register_screen.dart  # Register screen
│   └── journal/
│       ├── journal_list_screen.dart      # List semua journals
│       ├── add_journal_screen.dart       # Create journal baru
│       ├── edit_journal_screen.dart      # Edit journal
│       └── journal_detail_screen.dart    # Detail journal
├── widgets/                       # Reusable widgets
└── utils/
    └── datetime_helper.dart      # Helper functions untuk datetime
```

## Setup Database di Supabase

### 1. Buat Project Supabase
- Kunjungi https://supabase.com
- Buat project baru
- Dapatkan URL dan Anon Key

### 2. Setup Database
Copy dan jalankan SQL queries dari file `DATABASE_SCHEMA.sql` di Supabase SQL Editor:

```sql
-- Buat tabel users
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Buat tabel journals
CREATE TABLE IF NOT EXISTS journals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  mood TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable RLS dan buat policies (lihat DATABASE_SCHEMA.sql)
```

### 3. Update Credentials
Ganti URL dan Anon Key di `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_ANON_KEY',
);
```

## Setup Project

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run App
```bash
flutter run
```

## User Flow

### 1. First Time User
- Lihat Splash Screen
- Redirect ke Login Screen
- Click "Daftar di sini" untuk register
- Input email, password (minimal 6 karakter), dan nama lengkap
- Register berhasil → Kembali ke login
- Login dengan email dan password

### 2. Logged In User
- Lihat Journal List Screen dengan semua journals mereka
- Click FAB (+) untuk create journal baru
- Input title, content, dan pilih mood
- View journal details by clicking on journal item
- Edit journal dengan click "Edit" button
- Delete journal dengan click "Hapus" dan confirm
- Search journals dengan search bar
- Logout dari menu (3 dots icon di AppBar)

## API Endpoints (Supabase RPC & Tables)

### Authentication
- `auth.signup()` - Register user
- `auth.signinWithPassword()` - Login user
- `auth.signout()` - Logout user

### Database Tables
- `users` - Tabel user profile
- `journals` - Tabel jurnal entries

## State Management dengan Riverpod

### Providers yang Digunakan

```dart
// Supabase client
supabaseClientProvider

// Auth service
authServiceProvider

// Current user state
currentUserProvider

// Journals list
journalsProvider(userId)

// Single journal detail
singleJournalProvider(journalId)

// Search journals
searchJournalsProvider({userId, query})

// Create journal
createJournalProvider

// Update journal
updateJournalProvider

// Delete journal
deleteJournalProvider
```

## Error Handling

Aplikasi menghandle berbagai error scenarios:
- Network errors
- Authentication errors
- Database validation errors
- Empty input validation
- Toast notifications untuk user feedback

## Testing Credentials (Development)

Anda bisa menggunakan kredensial test setelah setup Supabase:
- Email: `test@example.com`
- Password: `password123`

## Features yang Bisa Dikembangkan

- Photo attachments untuk journal entries
- Journal categories/tags
- Share journal functionality
- Export journal to PDF
- Dark mode
- Offline mode dengan local storage
- Voice to text untuk journal entries
- Statistics dan mood trends
- Cloud backup

## Build untuk Production

```bash
# Android
flutter build apk
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

## Troubleshooting

### Build errors
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Supabase connection errors
- Pastikan URL dan Anon Key benar di main.dart
- Pastikan database dan tables sudah dibuat
- Check Supabase dashboard untuk error logs

### Authentication errors
- Pastikan email belum terdaftar untuk register
- Pastikan email dan password benar untuk login
- Password minimal 6 karakter

## License

This project is open source and available under the MIT License.

## Author

Daily Journal App - 2026

---

**Note**: Jangan hardcode credentials di production. Gunakan environment variables atau secure storage.
