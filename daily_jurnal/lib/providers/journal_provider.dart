import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_note/models/journal_model.dart';
import 'package:daily_note/services/journal_service.dart';
import 'package:daily_note/services/stats_service.dart';
import 'package:daily_note/providers/auth_provider.dart';

// Journal service provider
final journalServiceProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return JournalService(supabaseClient);
});

// Stats service provider
final statsServiceProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return StatsService(supabaseClient);
});

// All journals provider
final journalsProvider = FutureProvider.family<List<JournalModel>, String>((
  ref,
  userId,
) async {
  final journalService = ref.watch(journalServiceProvider);
  return journalService.getJournals(userId);
});

// Single journal provider
final singleJournalProvider =
    FutureProvider.family<JournalModel, String>((ref, journalId) async {
  final journalService = ref.watch(journalServiceProvider);
  return journalService.getJournalById(journalId);
});

// Search journals provider
final searchJournalsProvider =
    FutureProvider.family<List<JournalModel>, ({String userId, String query})>(
        (ref, params) async {
  final journalService = ref.watch(journalServiceProvider);
  return journalService.searchJournals(params.userId, params.query);
});

// Favorite journals provider
final favoriteJournalsProvider =
    FutureProvider.family<List<JournalModel>, String>((ref, userId) async {
  final journalService = ref.watch(journalServiceProvider);
  return journalService.getFavoriteJournals(userId);
});

// Journals by category provider
final journalsByCategoryProvider = FutureProvider.family<
    List<JournalModel>,
    ({String userId, String category})>((ref, params) async {
  final journalService = ref.watch(journalServiceProvider);
  return journalService.getJournalsByCategory(params.userId, params.category);
});

// Mood statistics provider
final moodStatsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, userId) async {
  final journalService = ref.watch(journalServiceProvider);
  return journalService.getMoodStats(userId);
});

// Category statistics provider
final categoryStatsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, userId) async {
  final journalService = ref.watch(journalServiceProvider);
  return journalService.getCategoryStats(userId);
});

// Total journals count provider
final totalJournalsCountProvider =
    FutureProvider.family<int, String>((ref, userId) async {
  final journalService = ref.watch(journalServiceProvider);
  return journalService.getTotalJournalsCount(userId);
});

// Writing streak provider
final writingStreakProvider =
    FutureProvider.family<int, String>((ref, userId) async {
  final statsService = ref.watch(statsServiceProvider);
  return statsService.getWritingStreak(userId);
});

// This month count provider
final thisMonthCountProvider =
    FutureProvider.family<int, String>((ref, userId) async {
  final statsService = ref.watch(statsServiceProvider);
  return statsService.getThisMonthCount(userId);
});

// This week count provider
final thisWeekCountProvider =
    FutureProvider.family<int, String>((ref, userId) async {
  final statsService = ref.watch(statsServiceProvider);
  return statsService.getThisWeekCount(userId);
});

// Favorite count provider
final favoriteCountProvider =
    FutureProvider.family<int, String>((ref, userId) async {
  final statsService = ref.watch(statsServiceProvider);
  return statsService.getFavoriteCount(userId);
});

// Create journal notifier
final createJournalProvider =
    StateNotifierProvider<CreateJournalNotifier, AsyncValue<JournalModel?>>((
  ref,
) {
  final journalService = ref.watch(journalServiceProvider);
  return CreateJournalNotifier(journalService, ref);
});

class CreateJournalNotifier extends StateNotifier<AsyncValue<JournalModel?>> {
  final JournalService _journalService;
  final Ref _ref;

  CreateJournalNotifier(this._journalService, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> createJournal(JournalModel journal) async {
    state = const AsyncValue.loading();
    try {
      final newJournal = await _journalService.createJournal(journal);
      state = AsyncValue.data(newJournal);
      // Refresh journals list
      _ref.refresh(journalsProvider(journal.userId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

// Update journal notifier
final updateJournalProvider =
    StateNotifierProvider<UpdateJournalNotifier, AsyncValue<JournalModel?>>((
  ref,
) {
  final journalService = ref.watch(journalServiceProvider);
  return UpdateJournalNotifier(journalService, ref);
});

class UpdateJournalNotifier extends StateNotifier<AsyncValue<JournalModel?>> {
  final JournalService _journalService;
  final Ref _ref;

  UpdateJournalNotifier(this._journalService, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> updateJournal(JournalModel journal) async {
    state = const AsyncValue.loading();
    try {
      final updatedJournal = await _journalService.updateJournal(journal);
      state = AsyncValue.data(updatedJournal);
      // Refresh journals list
      _ref.refresh(journalsProvider(journal.userId));
      _ref.refresh(singleJournalProvider(journal.id!));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

// Delete journal notifier
final deleteJournalProvider =
    StateNotifierProvider<DeleteJournalNotifier, AsyncValue<void>>((ref) {
  final journalService = ref.watch(journalServiceProvider);
  return DeleteJournalNotifier(journalService, ref);
});

class DeleteJournalNotifier extends StateNotifier<AsyncValue<void>> {
  final JournalService _journalService;
  final Ref _ref;

  DeleteJournalNotifier(this._journalService, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> deleteJournal(String journalId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _journalService.deleteJournal(journalId);
      state = const AsyncValue.data(null);
      // Refresh journals list
      _ref.refresh(journalsProvider(userId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

// Toggle favorite notifier
final toggleFavoriteProvider =
    StateNotifierProvider<ToggleFavoriteNotifier, AsyncValue<void>>((ref) {
  final journalService = ref.watch(journalServiceProvider);
  return ToggleFavoriteNotifier(journalService, ref);
});

class ToggleFavoriteNotifier extends StateNotifier<AsyncValue<void>> {
  final JournalService _journalService;
  final Ref _ref;

  ToggleFavoriteNotifier(this._journalService, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> toggleFavorite(
    String journalId,
    bool currentValue,
    String userId,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _journalService.toggleFavorite(journalId, currentValue);
      state = const AsyncValue.data(null);
      // Refresh journals list
      _ref.refresh(journalsProvider(userId));
      _ref.refresh(favoriteJournalsProvider(userId));
      _ref.refresh(favoriteCountProvider(userId));
      _ref.refresh(singleJournalProvider(journalId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
