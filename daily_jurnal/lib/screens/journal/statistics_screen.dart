import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_note/providers/journal_provider.dart';
import 'package:daily_note/providers/auth_provider.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  String _getMoodEmoji(String mood) {
    final moodMap = {
      'happy': '😊',
      'sad': '😢',
      'neutral': '😐',
      'excited': '🤩',
      'angry': '😠',
      'anxious': '😰',
    };
    return moodMap[mood] ?? '😐';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C3E50),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, st) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User tidak ditemukan'));
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Total Journals Card
              _buildStatCard(
                ref,
                'Total Jurnal',
                totalJournalsCountProvider(user.id),
                Icons.book,
              ),
              const SizedBox(height: 16),

              // Writing Streak Card
              _buildStatCard(
                ref,
                'Lanjutan Menulis',
                writingStreakProvider(user.id),
                Icons.local_fire_department,
              ),
              const SizedBox(height: 16),

              // This Week Card
              _buildStatCard(
                ref,
                'Minggu Ini',
                thisWeekCountProvider(user.id),
                Icons.calendar_today,
              ),
              const SizedBox(height: 16),

              // This Month Card
              _buildStatCard(
                ref,
                'Bulan Ini',
                thisMonthCountProvider(user.id),
                Icons.date_range,
              ),
              const SizedBox(height: 16),

              // Favorite Count Card
              _buildStatCard(
                ref,
                'Favorit',
                favoriteCountProvider(user.id),
                Icons.favorite,
              ),
              const SizedBox(height: 24),

              // Mood Distribution
              Text(
                'Distribusi Mood',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF2C3E50),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildMoodDistribution(ref, user.id),
              const SizedBox(height: 24),

              // Category Distribution
              Text(
                'Distribusi Kategori',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF2C3E50),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildCategoryDistribution(ref, user.id),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    WidgetRef ref,
    String title,
    FutureProvider<int> provider,
    IconData icon,
  ) {
    return ref.watch(provider).when(
          loading: () => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFECF0F1),
                width: 1,
              ),
            ),
            child: const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, st) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFECF0F1),
                width: 1,
              ),
            ),
            child: Text('Error: ${error.toString()}'),
          ),
          data: (count) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFECF0F1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF2C3E50),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF7F8C8D),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildMoodDistribution(WidgetRef ref, String userId) {
    return ref.watch(moodStatsProvider(userId)).when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (error, st) => Text('Error: ${error.toString()}'),
          data: (stats) {
            if (stats.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFECF0F1),
                    width: 1,
                  ),
                ),
                child: const Text('Belum ada data mood'),
              );
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFECF0F1),
                  width: 1,
                ),
              ),
              child: Column(
                children: stats.entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                _getMoodEmoji(entry.key),
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.key.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF7F8C8D),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                entry.value.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF2C3E50),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        );
  }

  Widget _buildCategoryDistribution(WidgetRef ref, String userId) {
    return ref.watch(categoryStatsProvider(userId)).when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (error, st) => Text('Error: ${error.toString()}'),
          data: (stats) {
            if (stats.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFECF0F1),
                    width: 1,
                  ),
                ),
                child: const Text('Belum ada data kategori'),
              );
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFECF0F1),
                  width: 1,
                ),
              ),
              child: Column(
                children: stats.entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C3E50),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.key.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF7F8C8D),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                entry.value.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF2C3E50),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        );
  }
}
