import 'package:bookly/constants/navigations.dart';
import 'package:bookly/constants/textWidget.dart';
import 'package:bookly/controller/mainProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/booklyModel.dart';
import 'detailScreen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text_Widget(text: 'Bookly',fontSize: 20,),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: Column(
        children: [
          BookSearchBar(),
          Expanded(
            child: Consumer<MainProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.books.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.error.isNotEmpty && provider.books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text_Widget(text: 'Error: ${provider.error}', fontSize: 10,),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.fetchBooks(context),
                          child: Text_Widget(text: 'Try Again',fontSize: 12,),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text_Widget(text:
                          'No books found',fontSize: 18, color: Colors.grey[600]),

                        SizedBox(height: 8),
                        Text_Widget(text:
                          'Try a different search term',fontSize: 14, color: Colors.grey),

                      ],
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {

                    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {

                      if (provider.hasMoreData && !provider.isLoadingMore) {
                        provider.loadMoreBooks(context);
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: provider.books.length + (provider.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {

                      if (index == provider.books.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final book = provider.books[index];
                      return InkWell(
                        onTap: () {
                          callNext(context, BookDetailScreen(book: book));
                        },
                        child: BookCard(book: book),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Provider.of<MainProvider>(context, listen: false).fetchBooks(
              context,
              query: Provider.of<MainProvider>(context, listen: false).searchQuery.isNotEmpty
                  ? Provider.of<MainProvider>(context, listen: false).searchQuery
                  : 'flutter'
          );
        },
        backgroundColor: Colors.yellow,
        child: Icon(Icons.refresh, color: Colors.black),
        tooltip: 'Refresh books',
      ),
    );
  }
}

class BookSearchBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  BookSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize search controller with current query from provider
    final provider = Provider.of<MainProvider>(context, listen: false);
    _searchController.text = provider.searchQuery;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.yellow.withOpacity(0.2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  provider.searchBooks(context, query: value);
                }
              },
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              final query = _searchController.text.trim();
              if (query.isNotEmpty) {
                provider.searchBooks(context, query: query);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
    );
  }
}


class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.coverUrl,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.book, size: 40, color: Colors.grey[600]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 16),
            // Book details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text_Widget(text:
                    book.title,
                      fontSize: 18,
                      fontweight: FontWeight.bold,

                  ),
                  SizedBox(height: 8),
                  Text_Widget(text:
                    'Author(s): ${book.authors.isEmpty ? 'Unknown' : book.authors.join(", ")}',
                   fontSize: 14
                  ),
                  SizedBox(height: 4),
                  if (book.firstPublishYear != null)
                    Text_Widget(text:
                      'Published: ${book.firstPublishYear}',fontSize: 14
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

