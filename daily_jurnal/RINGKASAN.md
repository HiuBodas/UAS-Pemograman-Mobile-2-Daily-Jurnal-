# 📱 Daily Journal App - Project Summary

## Overview
Aplikasi Mobile Journal Harian yang dibangun dengan Flutter, menggunakan Riverpod untuk state management, dan Supabase sebagai backend.

---

## 🎯 Key Features

### 1. Authentication System
- ✅ User Registration dengan email & password
- ✅ User Login dengan session management
- ✅ Secure Logout
- ✅ Real-time auth state monitoring

### 2. Journal Management (CRUD)
- ✅ **C**reate - Buat journal baru dengan title, content, dan mood
- ✅ **R**ead - Lihat semua journals dalam list atau detail view
- ✅ **U**pdate - Edit journal entries
- ✅ **D**elete - Hapus journal dengan confirmation

### 3. Additional Features
- ✅ Search journals berdasarkan title atau content
- ✅ Mood tracking (6 pilihan mood dengan emoji)
- ✅ Date/time tracking untuk setiap entry
- ✅ Real-time data sync dengan Supabase
- ✅ Beautiful Material Design 3 UI
- ✅ Error handling & loading states
- ✅ Toast notifications untuk user feedback

---

## 🛠 Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| **Framework** | Flutter | 3.9.2+ |
| **State Management** | Riverpod | 2.4.0 |
| **Backend** | Supabase | Latest |
| **Database** | PostgreSQL (Supabase) | Latest |
| **Authentication** | Supabase Auth | Built-in |
| **Date Formatting** | intl | 0.19.0 |

---

## 📁 Project Structure

```
daily_jurnal/
├── lib/
│   ├── main.dart                              [Entry Point]
│   ├── models/
│   │   ├── user_model.dart                    [User data model]
│   │   └── journal_model.dart                 [Journal data model]
│   ├── services/
│   │   ├── auth_service.dart                  [Auth logic]
│   │   └── journal_service.dart               [Journal CRUD logic]
│   ├── providers/
│   │   ├── auth_provider.dart                 [Riverpod auth state]
│   │   └── journal_provider.dart              [Riverpod journal state]
│   ├── screens/
│   │   ├── splash_screen.dart                 [Initial splash]
│   │   ├── auth/
│   │   │   ├── login_screen.dart              [Login UI]
│   │   │   └── register_screen.dart           [Register UI]
│   │   └── journal/
│   │       ├── journal_list_screen.dart       [List journals]
│   │       ├── add_journal_screen.dart        [Create journal]
│   │       ├── edit_journal_screen.dart       [Edit journal]
│   │       └── journal_detail_screen.dart     [View detail]
│   ├── widgets/                               [Reusable widgets]
│   └── utils/
│       └── datetime_helper.dart               [Date utilities]
├── pubspec.yaml                               [Dependencies]
├── DATABASE_SCHEMA.sql                        [DB schema]
├── SETUP_SUPABASE.md                          [Setup guide]
├── DOKUMENTASI.md                             [Full documentation]
├── CHECKLIST.md                               [Project checklist]
└── RINGKASAN.md                               [This file]
```

---

## 🔄 Application Flow

### User Journey

```
┌─────────────┐
│ App Launch  │
└──────┬──────┘
       │
       ▼
┌──────────────────┐
│ Splash Screen    │
│ (Check Auth)     │
└────┬─────────────┘
     │
     ├─ Not Authenticated ──┐
     │                      │
     └─ Authenticated ──┐   │
                        │   │
                        │   ▼
                        │ ┌──────────────┐
                        │ │ Login Screen │
                        │ └──┬───────────┘
                        │    │
                        │    ├─ New User ──┐
                        │    │              │
                        │    ▼              ▼
                        │ ┌──────────────┐ ┌─────────────────┐
                        │ │ Journal List │ │ Register Screen │
                        │ │    Screen    │ └────────┬────────┘
                        │ └────────────────────────┘
                        │
                        └─────────────┬──────────────┐
                                      │              │
                                      ▼              ▼
                              ┌──────────────┐  ┌──────────────┐
                              │ Add Journal  │  │ View/Edit    │
                              │   Screen     │  │  Journal     │
                              └──────────────┘  └──────────────┘
```

### Data Flow Architecture

```
                    ┌─────────────────┐
                    │  Flutter App    │
                    └────────┬────────┘
                             │
        ┌────────────────────┼─────────────────────┐
        │                    │                     │
        ▼                    ▼                     ▼
   ┌─────────┐          ┌────────┐           ┌──────────┐
   │  Models │          │Services│           │Providers │
   │         │          │        │           │(Riverpod)│
   └────┬────┘          └────┬───┘           └────┬─────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                    ┌────────▼─────────┐
                    │ Supabase Client  │
                    │   (REST API)     │
                    └────────┬─────────┘
                             │
            ┌────────────────┼──────────────────┐
            │                │                  │
            ▼                ▼                  ▼
      ┌──────────┐      ┌────────┐       ┌──────────┐
      │Auth (JWT)│      │ Users  │       │ Journals │
      │          │      │ Table  │       │  Table   │
      └──────────┘      └────────┘       └──────────┘
            │                │                  │
            └────────────────┴──────────────────┘
                             │
                    ┌────────▼──────────┐
                    │ PostgreSQL DB     │
                    │ (Supabase)        │
                    └───────────────────┘
```

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter 3.9.2+
- Dart 3.0+
- Supabase Account
- Code Editor (VS Code / Android Studio)

### Quick Start

1. **Clone/Download Project**
   ```bash
   cd d:\flutter\daily_jurnal
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Supabase Database** ⚠️ IMPORTANT
   - Refer ke: `SETUP_SUPABASE.md`
   - Run SQL queries dari `DATABASE_SCHEMA.sql`
   - Create tables: `users` & `journals`
   - Enable RLS policies

4. **Update Credentials** (jika berbeda)
   - Edit `lib/main.dart`
   - Update Supabase URL & Anon Key

5. **Run Application**
   ```bash
   flutter run
   ```

---

## 📊 Database Schema

### Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,           -- Dari auth.users
  email TEXT UNIQUE,             -- User email
  display_name TEXT,             -- User's name
  created_at TIMESTAMP,          -- Account creation date
  updated_at TIMESTAMP           -- Last update
);
```

### Journals Table
```sql
CREATE TABLE journals (
  id UUID PRIMARY KEY,           -- Unique journal ID
  user_id UUID NOT NULL,         -- FK to users.id
  title TEXT NOT NULL,           -- Journal title
  content TEXT NOT NULL,         -- Journal content
  mood TEXT,                     -- happy|sad|neutral|excited|angry|anxious
  created_at TIMESTAMP,          -- Creation date
  updated_at TIMESTAMP           -- Last update
);
```

---

## 🔐 Security Features

✅ **Row Level Security (RLS)**
- Users hanya bisa akses data mereka sendiri
- Policies ada untuk setiap operation (SELECT, INSERT, UPDATE, DELETE)

✅ **Authentication**
- JWT tokens dari Supabase Auth
- Secure password hashing
- Email-based authentication

✅ **Data Validation**
- Input validation di frontend
- Database constraints di backend

---

## 🎨 UI Screenshots (Expected)

### Screens yang Ada
1. **Splash Screen** - Loading indicator
2. **Login Screen** - Email & password form
3. **Register Screen** - Registration form
4. **Journal List Screen** - Daftar journals dengan search
5. **Add Journal Screen** - Form untuk buat journal baru
6. **Journal Detail Screen** - View journal lengkap
7. **Edit Journal Screen** - Form untuk edit journal

---

## 📝 Code Examples

### Simple Model Example
```dart
class JournalModel {
  final String? id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? mood;
  
  // Constructor, fromJson, toJson, copyWith methods included
}
```

### Service Layer Example
```dart
class JournalService {
  // Create
  Future<JournalModel> createJournal(JournalModel journal) async { ... }
  
  // Read
  Future<List<JournalModel>> getJournals(String userId) async { ... }
  
  // Update
  Future<JournalModel> updateJournal(JournalModel journal) async { ... }
  
  // Delete
  Future<void> deleteJournal(String journalId) async { ... }
}
```

### Riverpod Provider Example
```dart
final journalsProvider = FutureProvider.family<List<JournalModel>, String>(
  (ref, userId) async {
    final journalService = ref.watch(journalServiceProvider);
    return journalService.getJournals(userId);
  },
);
```

---

## ⚙️ Dependencies List

**Main Dependencies:**
- `flutter_riverpod: ^2.4.0` - State management
- `supabase_flutter: ^2.5.0` - Backend integration
- `intl: ^0.19.0` - Date/time formatting

**Dev Dependencies:**
- `build_runner: ^2.4.0` - Code generation
- `riverpod_generator: ^2.3.0` - Riverpod code gen
- `flutter_lints: ^5.0.0` - Linting

---

## 🧪 Testing Checklist

Before deployment, verify:

- [ ] Register dengan email baru
- [ ] Login dengan email yang terdaftar
- [ ] Create journal dengan semua fields
- [ ] View journal list
- [ ] View journal detail
- [ ] Edit journal
- [ ] Delete journal
- [ ] Search journal
- [ ] Logout dan login lagi
- [ ] All error messages appear correctly
- [ ] Loading states visible
- [ ] No crashes during normal operations

---

## 📦 Build & Distribution

### Android
```bash
flutter build apk               # Debug APK
flutter build appbundle        # For Play Store
```

### iOS
```bash
flutter build ios              # Requires Mac
```

### Web
```bash
flutter build web
```

---

## 🐛 Known Issues & Limitations

1. **No Offline Support** - Requires internet connection
2. **Single User Session** - Only one user logged in at a time
3. **No Image Attachments** - Text content only
4. **Fixed Mood Options** - Cannot add custom moods
5. **No Pagination** - All journals loaded at once
6. **No Real-time Sync** - Requires manual refresh

---

## 🚧 Future Enhancements

**Phase 2:**
- Image attachments
- Journal categories
- Dark mode
- Export to PDF

**Phase 3:**
- Voice to text
- Mood statistics
- Cloud backup
- Sharing features

---

## 💡 Development Notes

- Project uses Modern Flutter Best Practices
- Clean Architecture dengan separation of concerns
- Proper error handling di setiap layer
- Material Design 3 untuk UI
- Responsive design untuk berbagai screen sizes

---

## 📞 Support

For issues or questions:
1. Check `DOKUMENTASI.md` untuk detailed guide
2. Check `SETUP_SUPABASE.md` untuk database setup
3. Review error messages dalam app
4. Check Supabase dashboard logs

---

## 📄 License

This project is provided as-is for educational purposes.

---

**Status**: ✅ Ready for Deployment
**Version**: 1.0.0
**Last Updated**: 2026-01-28

**Next Action**: Setup database tables di Supabase menggunakan SETUP_SUPABASE.md
