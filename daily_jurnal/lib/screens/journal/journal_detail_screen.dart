import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_note/providers/journal_provider.dart';
import 'package:intl/intl.dart';

class JournalDetailScreen extends ConsumerWidget {
  final String journalId;

  const JournalDetailScreen({
    Key? key,
    required this.journalId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(singleJournalProvider(journalId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Journal'),
      ),
      body: journalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, st) => Center(child: Text('Error: $error')),
        data: (journal) {
          final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');
          final formattedDate = dateFormatter.format(journal.createdAt);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          journal.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      if (journal.mood != null) ...[
                        const SizedBox(width: 16),
                        Text(_getMoodEmoji(journal.mood!),
                            style: const TextStyle(fontSize: 32)),
                      ]
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    journal.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/edit-journal',
                          arguments: journal,
                        );
                      },
                      child: const Text('Edit'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
}
