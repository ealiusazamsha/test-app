class WordPressPost {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String date;
  final String status;
  final String link;
  final int authorId;

  WordPressPost({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.date,
    required this.status,
    required this.link,
    required this.authorId,
  });

  factory WordPressPost.fromJson(Map<String, dynamic> json) {
    return WordPressPost(
      id: json['id'] ?? 0,
      title: _extractRendered(json['title']),
      content: _extractRendered(json['content']),
      excerpt: _extractRendered(json['excerpt']),
      date: json['date'] ?? '',
      status: json['status'] ?? 'publish',
      link: json['link'] ?? '',
      authorId: json['author'] ?? 0,
    );
  }

  static String _extractRendered(dynamic field) {
    if (field is Map && field.containsKey('rendered')) {
      return field['rendered'] ?? '';
    }
    return field?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': {'rendered': title},
      'content': {'rendered': content},
      'excerpt': {'rendered': excerpt},
      'date': date,
      'status': status,
      'link': link,
      'author': authorId,
    };
  }
}
