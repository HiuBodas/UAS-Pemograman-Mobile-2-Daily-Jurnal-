import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_note/models/journal_model.dart';

class JournalService {
  final SupabaseClient _supabaseClient;

  JournalService(this._supabaseClient);

  // Create/Add journal entry
  Future<JournalModel> createJournal(JournalModel journal) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .insert(journal.toJson())
          .select()
          .single();

      return JournalModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal membuat jurnal: ${e.toString()}');
    }
  }

  // Get all journals for current user
  Future<List<JournalModel>> getJournals(String userId) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((journal) => JournalModel.fromJson(journal))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil jurnal: ${e.toString()}');
    }
  }

  // Get single journal by id
  Future<JournalModel> getJournalById(String journalId) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select()
          .eq('id', journalId)
          .single();

      return JournalModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil jurnal: ${e.toString()}');
    }
  }

  // Update journal entry
  Future<JournalModel> updateJournal(JournalModel journal) async {
    try {
      if (journal.id == null) {
        throw Exception('ID jurnal tidak ditemukan');
      }

      final updateData = {
        'title': journal.title,
        'content': journal.content,
        'mood': journal.mood,
        'category': journal.category,
        'is_favorite': journal.isFavorite,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabaseClient
          .from('journals')
          .update(updateData)
          .eq('id', journal.id!)
          .select()
          .single();

      return JournalModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengupdate jurnal: ${e.toString()}');
    }
  }

  // Delete journal entry
  Future<void> deleteJournal(String journalId) async {
    try {
      await _supabaseClient.from('journals').delete().eq('id', journalId);
    } catch (e) {
      throw Exception('Gagal menghapus jurnal: ${e.toString()}');
    }
  }

  // Search journals by title or content
  Future<List<JournalModel>> searchJournals(
    String userId,
    String query,
  ) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select()
          .eq('user_id', userId)
          .or('title.ilike.%$query%,content.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((journal) => JournalModel.fromJson(journal))
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari jurnal: ${e.toString()}');
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String journalId, bool currentValue) async {
    try {
      await _supabaseClient
          .from('journals')
          .update({'is_favorite': !currentValue})
          .eq('id', journalId);
    } catch (e) {
      throw Exception('Gagal update favorit: ${e.toString()}');
    }
  }

  // Get favorite journals
  Future<List<JournalModel>> getFavoriteJournals(String userId) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select()
          .eq('user_id', userId)
          .eq('is_favorite', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((journal) => JournalModel.fromJson(journal))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil favorit: ${e.toString()}');
    }
  }

  // Get journals by category
  Future<List<JournalModel>> getJournalsByCategory(
    String userId,
    String category,
  ) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select()
          .eq('user_id', userId)
          .eq('category', category)
          .order('created_at', ascending: false);

      return (response as List)
          .map((journal) => JournalModel.fromJson(journal))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil jurnal: ${e.toString()}');
    }
  }

  // Get mood statistics
  Future<Map<String, int>> getMoodStats(String userId) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select('mood')
          .eq('user_id', userId);

      final stats = <String, int>{};
      for (var item in response as List) {
        final mood = item['mood'] as String? ?? 'neutral';
        stats[mood] = (stats[mood] ?? 0) + 1;
      }
      return stats;
    } catch (e) {
      throw Exception('Gagal mengambil statistik: ${e.toString()}');
    }
  }

  // Get category statistics
  Future<Map<String, int>> getCategoryStats(String userId) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select('category')
          .eq('user_id', userId);

      final stats = <String, int>{};
      for (var item in response as List) {
        final category = item['category'] as String? ?? 'personal';
        stats[category] = (stats[category] ?? 0) + 1;
      }
      return stats;
    } catch (e) {
      throw Exception('Gagal mengambil statistik: ${e.toString()}');
    }
  }

  // Get total journals count
  Future<int> getTotalJournalsCount(String userId) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select('id')
          .eq('user_id', userId);

      return (response as List).length;
    } catch (e) {
      throw Exception('Gagal menghitung jurnal: ${e.toString()}');
    }
  }
}
