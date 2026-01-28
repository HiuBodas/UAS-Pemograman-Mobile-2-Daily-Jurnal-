import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_note/providers/journal_provider.dart';
import 'package:daily_note/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
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
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, st) => Scaffold(
        appBar: AppBar(title: const Text('Favorit')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User tidak ditemukan')),
          );
        }

        final favoritesAsync = ref.watch(favoriteJournalsProvider(user.id));

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            title: const Text('Jurnal Favorit'),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF2C3E50),
          ),
          body: favoritesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, st) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Color(0xFFE74C3C),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ada kesalahan',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                    ),
                    onPressed: () {
                      ref.refresh(favoriteJournalsProvider(user.id));
                    },
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            data: (journals) {
              if (journals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada journal favorit',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: journals.length,
                itemBuilder: (context, index) {
                  final journal = journals[index];
                  final dateFormatter = DateFormat('dd MMM yyyy');
                  final formattedDate =
                      dateFormatter.format(journal.createdAt);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        journal.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            journal.content.length > 80
                                ? '${journal.content.substring(0, 80)}...'
                                : journal.content,
                            style: TextStyle(
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFA),
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                                child: Text(
                                  journal.category.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF7F8C8D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _getMoodEmoji(journal.mood ?? 'neutral'),
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.favorite,
                                color: const Color(0xFFE74C3C),
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/journal-detail',
                          arguments: journal.id,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
