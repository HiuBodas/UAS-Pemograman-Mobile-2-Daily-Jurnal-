import 'package:supabase_flutter/supabase_flutter.dart';

class StatsService {
  final SupabaseClient _supabaseClient;

  StatsService(this._supabaseClient);

  // Get writing streak (consecutive days with at least 1 journal)
  Future<int> getWritingStreak(String userId) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select('created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if ((response as List).isEmpty) return 0;

      int streak = 1;
      DateTime? previousDate;

      for (var item in response) {
        final date =
            DateTime.parse(item['created_at'] as String).toLocal();
        final dateOnly =
            DateTime(date.year, date.month, date.day);

        if (previousDate == null) {
          previousDate = dateOnly;
          continue;
        }

        final difference = previousDate
            .difference(dateOnly)
            .inDays;

        if (difference == 1) {
          streak++;
          previousDate = dateOnly;
        } else if (difference == 0) {
          // Same day, skip
          continue;
        } else {
          break;
        }
      }

      return streak;
    } catch (e) {
      throw Exception('Gagal menghitung streak: ${e.toString()}');
    }
  }

  // Get this month's journal count
  Future<int> getThisMonthCount(String userId) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final response = await _supabaseClient
          .from('journals')
          .select('id')
          .eq('user_id', userId)
          .gte('created_at', startOfMonth.toIso8601String())
          .lte('created_at', endOfMonth.toIso8601String());

      return (response as List).length;
    } catch (e) {
      throw Exception('Gagal menghitung jurnal bulan ini: ${e.toString()}');
    }
  }

  // Get this week's journal count
  Future<int> getThisWeekCount(String userId) async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      final response = await _supabaseClient
          .from('journals')
          .select('id')
          .eq('user_id', userId)
          .gte('created_at', startOfWeek.toIso8601String())
          .lte('created_at', endOfWeek.toIso8601String());

      return (response as List).length;
    } catch (e) {
      throw Exception('Gagal menghitung jurnal minggu ini: ${e.toString()}');
    }
  }

  // Get favorite count
  Future<int> getFavoriteCount(String userId) async {
    try {
      final response = await _supabaseClient
          .from('journals')
          .select('id')
          .eq('user_id', userId)
          .eq('is_favorite', true);

      return (response as List).length;
    } catch (e) {
      throw Exception('Gagal menghitung favorit: ${e.toString()}');
    }
  }
}
