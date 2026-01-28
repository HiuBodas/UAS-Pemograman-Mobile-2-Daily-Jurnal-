import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_note/models/user_model.dart';

class AuthService {
  final SupabaseClient _supabaseClient;

  AuthService(this._supabaseClient);

  // Register dengan email dan password
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

      if (response.user == null) {
        throw Exception('Gagal mendaftar');
      }

      // Simpan user ke database
      await _supabaseClient.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'display_name': displayName,
        'created_at': DateTime.now().toIso8601String(),
      });

      return UserModel(
        id: response.user!.id,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Register gagal: ${e.toString()}');
    }
  }

  // Login dengan email dan password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login gagal');
      }

      // Ambil data user dari database
      final user = await _supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(user);
    } catch (e) {
      throw Exception('Login gagal: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Logout gagal: ${e.toString()}');
    }
  }

  // Get current user
  UserModel? getCurrentUser() {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
      createdAt: DateTime.now(),
    );
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _supabaseClient.auth.currentUser != null;
  }

  // Get auth state stream
  Stream<AuthState> getAuthStateChanges() {
    return _supabaseClient.auth.onAuthStateChange;
  }
}
