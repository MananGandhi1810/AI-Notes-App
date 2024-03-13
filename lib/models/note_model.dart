class NoteModel {
  final int id;
  final String title;
  final String content;
  String? summary;
  final DateTime date;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.summary,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      summary: json['summary'],
    );
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    String? summary,
    DateTime? date,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary ?? '',
      'date': date.toIso8601String(),
    };
  }
}
