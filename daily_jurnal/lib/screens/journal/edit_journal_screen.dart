import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_note/models/journal_model.dart';
import 'package:daily_note/providers/journal_provider.dart';

class EditJournalScreen extends ConsumerStatefulWidget {
  final JournalModel journal;

  const EditJournalScreen({
    Key? key,
    required this.journal,
  }) : super(key: key);

  @override
  ConsumerState<EditJournalScreen> createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends ConsumerState<EditJournalScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  String? selectedMood;
  late String selectedCategory;
  bool isLoading = false;

  final moodOptions = [
    'happy',
    'sad',
    'neutral',
    'excited',
    'angry',
    'anxious',
  ];

  final categoryOptions = [
    'personal',
    'work',
    'health',
    'travel',
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.journal.title);
    contentController = TextEditingController(text: widget.journal.content);
    selectedMood = widget.journal.mood;
    selectedCategory = widget.journal.category;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateJournal() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan konten tidak boleh kosong')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final updatedJournal = widget.journal.copyWith(
        title: titleController.text,
        content: contentController.text,
        mood: selectedMood,
        category: selectedCategory,
      );

      final updateNotifier = ref.read(updateJournalProvider.notifier);
      await updateNotifier.updateJournal(updatedJournal);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal berhasil diupdate')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Journal',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF2C3E50),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Judul',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF2C3E50),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
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
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 24),
              Text(
                'Isi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF2C3E50),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
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
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                maxLines: 10,
              ),
              const SizedBox(height: 24),
              Text(
                'Suasana Hati',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF2C3E50),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: moodOptions.map((mood) {
                  final isSelected = selectedMood == mood;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = isSelected ? null : mood;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2C3E50)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2C3E50)
                              : const Color(0xFFECF0F1),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getMoodLabel(mood),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF2C3E50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Kategori',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF2C3E50),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categoryOptions.map((category) {
                  final isSelected = selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2C3E50)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2C3E50)
                              : const Color(0xFFECF0F1),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryLabel(category),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF2C3E50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleUpdateJournal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMoodLabel(String mood) {
    final moodMap = {
      'happy': '😊 Senang',
      'sad': '😢 Sedih',
      'neutral': '😐 Biasa Saja',
      'excited': '🤩 Bersemangat',
      'angry': '😠 Marah',
      'anxious': '😰 Cemas',
    };
    return moodMap[mood] ?? mood;
  }

  String _getCategoryLabel(String category) {
    final categoryMap = {
      'personal': 'Personal',
      'work': 'Kerja',
      'health': 'Kesehatan',
      'travel': 'Travel',
    };
    return categoryMap[category] ?? category;
  }
}
