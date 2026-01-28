# 🚀 Quick Start Commands

## Setup & Running App

```bash
# Navigate to project
cd d:\flutter\daily_jurnal

# Install dependencies
flutter pub get

# Run app
flutter run

# Clean build (if error)
flutter clean && flutter pub get && flutter run
```

## Database Setup

**⚠️ IMPORTANT: Run this SQL in Supabase SQL Editor**

See: DATABASE_SCHEMA.sql or follow SETUP_SUPABASE.md

---

## Building for Distribution

### Android
```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle
```

### iOS (Requires Mac)
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

---

## Development Commands

```bash
# Format code
flutter format lib/

# Analyze code
flutter analyze

# Run tests (if any)
flutter test

# Get package info
flutter pub outdated

# Upgrade dependencies
flutter pub upgrade
```

---

## Troubleshooting Commands

```bash
# Full clean
flutter clean
rm -r build/
rm -r .dart_tool/

# Reinstall
flutter pub get

# Check Flutter version
flutter --version

# Check connected devices
flutter devices

# Run specific device
flutter run -d device_id

# Debug
flutter run -v
```

---

## Project Info

| Aspect | Details |
|--------|---------|
| **SDK** | Dart 3.0+, Flutter 3.9.2+ |
| **Main Packages** | riverpod, supabase_flutter, intl |
| **Platforms** | Android, iOS, Web |
| **Package Name** | com.daily_jurnal.app (customize) |

---

## Key Files to Know

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point & routing |
| `lib/services/` | Business logic |
| `lib/providers/` | State management |
| `lib/screens/` | UI screens |
| `pubspec.yaml` | Dependencies |
| `DATABASE_SCHEMA.sql` | Database setup |

---

## Important Notes

1. **Database MUST be setup before running**
   - Follow SETUP_SUPABASE.md
   - Run DATABASE_SCHEMA.sql

2. **Update Credentials**
   - Supabase URL in main.dart
   - Anon Key in main.dart

3. **Test Before Deploy**
   - Register & login
   - Create/edit/delete journals
   - Verify all features work

---

Last Updated: 2026-01-28
