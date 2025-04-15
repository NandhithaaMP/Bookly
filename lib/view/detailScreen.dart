import 'package:bookly/constants/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/booklyModel.dart';


class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios)),
        title: Text_Widget(text: 'Book Details',fontSize: 18,),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.coverUrl,
                      width: 140,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 140,
                          height: 200,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(Icons.book, size: 60, color: Colors.grey[600]),
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
                            fontSize: 22,
                            fontweight: FontWeight.bold,

                        ),
                        SizedBox(height: 8),
                        Text_Widget(text:
                          'Author(s): ${book.authors.isEmpty ? 'Unknown' : book.authors.join(", ")}',
                          fontSize: 16, color: Colors.grey[800]),

                        SizedBox(height: 8),
                        if (book.firstPublishYear != null)
                          Text_Widget(text:
                            'First Published: ${book.firstPublishYear}',
                            fontSize: 16, color: Colors.grey[800]),

                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text_Widget(text:
                      'About this book',
                        fontSize: 18,
                        fontweight: FontWeight.bold,

                    ),
                    SizedBox(height: 8),

                    Text_Widget(text:
                      'No description available for this book.',

                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],

                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}