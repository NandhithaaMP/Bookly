import 'package:bookly/model/booklyModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/booklyServices.dart';

class MainProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;


  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;


  static const int _itemsPerPage = 10;


  Future<void> fetchBooks(BuildContext context, {String query = 'flutter'}) async {
    _isLoading = true;
    _error = '';
    _searchQuery = query;
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();

    try {
      _books = await BookService.fetchBooks(query: query, page: _currentPage, limit: _itemsPerPage);
      _isLoading = false;

      if (_books.length < _itemsPerPage) {
        _hasMoreData = false;
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $_error')),
      );
    }
  }

  Future<void> searchBooks(BuildContext context, {required String query}) async {

    _currentPage = 1;
    _hasMoreData = true;
    _isLoading = true;
    _error = '';
    _searchQuery = query;
    notifyListeners();

    try {
      _books = await BookService.fetchBooks(query: query, page: _currentPage, limit: _itemsPerPage);
      _isLoading = false;


      if (_books.length < _itemsPerPage) {
        _hasMoreData = false;
      }

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $_error')),
      );
    }
  }

  Future<void> loadMoreBooks(BuildContext context) async {

    if (_isLoadingMore || !_hasMoreData || _isLoading) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final moreBooks = await BookService.fetchBooks(
          query: _searchQuery,
          page: _currentPage,
          limit: _itemsPerPage
      );

      if (moreBooks.isEmpty || moreBooks.length < _itemsPerPage) {
        _hasMoreData = false;
      }

      _books.addAll(moreBooks);
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      _error = e.toString();
      notifyListeners();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading more books: $_error')),
      );
    }
  }
}

