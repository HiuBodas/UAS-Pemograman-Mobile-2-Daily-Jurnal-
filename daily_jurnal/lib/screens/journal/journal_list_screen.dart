import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_note/providers/auth_provider.dart';
import 'package:daily_note/providers/journal_provider.dart';
import 'package:intl/intl.dart';

class JournalListScreen extends ConsumerStatefulWidget {
  const JournalListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends ConsumerState<JournalListScreen> {
  final searchController = TextEditingController();
  String? searchQuery;
  String? selectedCategory;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, st) => Scaffold(
        appBar: AppBar(title: const Text('Journal')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User tidak ditemukan')),
          );
        }

        final journalsAsync = searchQuery != null
            ? ref.watch(
                searchJournalsProvider(
                  (userId: user.id, query: searchQuery!),
                ),
              )
            : ref.watch(journalsProvider(user.id));

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            title: const Text('DailyNote'),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF2C3E50),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'stats') {
                    Navigator.of(context).pushNamed('/statistics');
                  } else if (value == 'profile') {
                    Navigator.of(context).pushNamed('/profile');
                  } else if (value == 'favorites') {
                    Navigator.of(context).pushNamed('/favorites');
                  } else if (value == 'logout') {
                    final authNotifier =
                        ref.read(currentUserProvider.notifier);
                    authNotifier.logout();
                    Navigator.of(context)
                        .pushReplacementNamed('/login');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'stats',
                    child: Row(
                      children: [
                        Icon(Icons.bar_chart, size: 20),
                        SizedBox(width: 12),
                        Text('Statistik'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'favorites',
                    child: Row(
                      children: [
                        Icon(Icons.favorite, size: 20),
                        SizedBox(width: 12),
                        Text('Favorit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 20),
                        SizedBox(width: 12),
                        Text('Profil'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 12),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari journal...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF95A5A6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFECF0F1),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFECF0F1),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2C3E50),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.isEmpty ? null : value;
                    });
                  },
                ),
              ),
              // Category Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip(
                        'Semua',
                        null,
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        'Personal',
                        'personal',
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        'Kerja',
                        'work',
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        'Kesehatan',
                        'health',
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        'Travel',
                        'travel',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: journalsAsync.when(
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
                            ref.refresh(journalsProvider(user.id));
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
                            const Icon(
                              Icons.book_outlined,
                              size: 64,
                              color: Color(0xFFBDC3C7),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada journal',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C3E50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/add-journal');
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Buat Journal Baru',
                                style: TextStyle(color: Colors.white),
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
                                    // Category Badge
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
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(toggleFavoriteProvider
                                                .notifier)
                                            .toggleFavorite(
                                              journal.id!,
                                              journal.isFavorite,
                                              user.id,
                                            );
                                      },
                                      child: Icon(
                                        journal.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: const Color(0xFFE74C3C),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              position: PopupMenuPosition.under,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: const Row(
                                    children: [
                                      Icon(Icons.edit, size: 18),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      '/edit-journal',
                                      arguments: journal,
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Color(0xFFE74C3C),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Hapus',
                                        style: TextStyle(
                                          color: Color(0xFFE74C3C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    _showDeleteConfirmation(
                                      context,
                                      journal.id!,
                                      user.id,
                                    );
                                  },
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
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add-journal');
            },
            backgroundColor: const Color(0xFF2C3E50),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

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

  Widget _buildCategoryChip(String label, String? categoryValue) {
    final isSelected = selectedCategory == categoryValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = categoryValue;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C3E50) : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2C3E50)
                : const Color(0xFFECF0F1),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF7F8C8D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String journalId,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Hapus Journal',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text('Apakah Anda yakin ingin menghapus journal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF7F8C8D)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final deleteNotifier =
                  ref.read(deleteJournalProvider.notifier);
              try {
                await deleteNotifier.deleteJournal(journalId, userId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Journal berhasil dihapus'),
                      backgroundColor: Color(0xFF27AE60),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: const Color(0xFFE74C3C),
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Color(0xFFE74C3C)),
            ),
          ),
        ],
      ),
    );
  }
}
