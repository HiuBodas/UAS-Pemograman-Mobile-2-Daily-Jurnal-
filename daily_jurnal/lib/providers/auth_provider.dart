import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_note/models/user_model.dart';
import 'package:daily_note/services/auth_service.dart';

// Supabase client provider
final supabaseClientProvider = Provider((ref) {
  return Supabase.instance.client;
});

// Auth service provider
final authServiceProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AuthService(supabaseClient);
});

// Auth state provider
final authStateProvider = StreamProvider((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getAuthStateChanges();
});

// Current user provider
final currentUserProvider = StateNotifierProvider<
    CurrentUserNotifier,
    AsyncValue<UserModel?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return CurrentUserNotifier(authService);
});

class CurrentUserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  CurrentUserNotifier(this._authService)
      : super(const AsyncValue.loading()) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      final user = _authService.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
