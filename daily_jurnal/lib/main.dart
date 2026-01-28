import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_note/screens/auth/login_screen.dart';
import 'package:daily_note/screens/auth/register_screen.dart';
import 'package:daily_note/screens/auth/profile_screen.dart';
import 'package:daily_note/screens/journal/journal_list_screen.dart';
import 'package:daily_note/screens/journal/add_journal_screen.dart';
import 'package:daily_note/screens/journal/edit_journal_screen.dart';
import 'package:daily_note/screens/journal/journal_detail_screen.dart';
import 'package:daily_note/screens/journal/statistics_screen.dart';
import 'package:daily_note/screens/journal/favorites_screen.dart';
import 'package:daily_note/models/journal_model.dart';
import 'package:daily_note/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xaeevfdlspuubmnxnblu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhhZWV2ZmRsc3B1dWJtbnhuYmx1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk1NDcwOTMsImV4cCI6MjA4NTEyMzA5M30.y-3q-IwRXI_lW4ezPwrZ70ZWWfkciJWrkaPHR8Pfl7U',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyNote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C3E50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF2C3E50),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFECF0F1)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const _HomeRouter(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (context) => const JournalListScreen(),
            );
          case '/add-journal':
            return MaterialPageRoute(
              builder: (context) => const AddJournalScreen(),
            );
          case '/edit-journal':
            final journal = settings.arguments as JournalModel;
            return MaterialPageRoute(
              builder: (context) => EditJournalScreen(journal: journal),
            );
          case '/journal-detail':
            final journalId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => JournalDetailScreen(journalId: journalId),
            );
          case '/statistics':
            return MaterialPageRoute(
              builder: (context) => const StatisticsScreen(),
            );
          case '/profile':
            return MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            );
          case '/favorites':
            return MaterialPageRoute(
              builder: (context) => const FavoritesScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
        }
      },
    );
  }
}

class _HomeRouter extends ConsumerWidget {
  const _HomeRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, st) => const LoginScreen(),
      data: (user) {
        if (user != null) {
          return const JournalListScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
