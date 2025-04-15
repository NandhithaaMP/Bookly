import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/booklyModel.dart';

class BookService {
  static Future<List<Book>> fetchBooks({
    required String query,
    int page = 1,
    int limit = 10
  }) async {

    int offset = (page - 1) * limit;

    // Add pagination parameters to the API call
    final url = Uri.parse(
        'https://openlibrary.org/search.json?q=${Uri.encodeComponent(query)}&limit=$limit&offset=$offset'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> docs = data['docs'] ?? [];

      return docs.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books. Status code: ${response.statusCode}');
    }
  }
}
