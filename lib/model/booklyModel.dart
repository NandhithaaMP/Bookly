class Book {
  final String title;
  final List<String> authors;
  final int? coverId;
  final int? firstPublishYear;

  Book({
    required this.title,
    required this.authors,
    this.coverId,
    this.firstPublishYear,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> authorList = [];
    if (json['author_name'] != null) {
      authorList = List<String>.from(json['author_name']);
    }

    return Book(
      title: json['title'] ?? 'Unknown Title',
      authors: authorList,
      coverId: json['cover_i'],
      firstPublishYear: json['first_publish_year'],
    );
  }

  String get coverUrl {
    if (coverId != null) {
      return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
    }
    return 'https://via.placeholder.com/150x200?text=No+Cover';
  }
}
