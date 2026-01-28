class JournalModel {
  final String? id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? mood; // happy, sad, neutral, excited, etc
  final String category; // personal, work, health, travel, etc
  final bool isFavorite;

  JournalModel({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.mood,
    this.category = 'personal',
    this.isFavorite = false,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      mood: json['mood'] as String?,
      category: json['category'] as String? ?? 'personal',
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt?.toIso8601String(),
      'mood': mood,
      'category': category,
      'is_favorite': isFavorite,
    };
  }

  JournalModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? mood,
    String? category,
    bool? isFavorite,
  }) {
    return JournalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mood: mood ?? this.mood,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
