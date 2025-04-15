
import 'package:bookly/constants/navigations.dart';
import 'package:bookly/constants/textWidget.dart';
import 'package:bookly/view/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/mainProvider.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void navigateToHome(BuildContext context) async {
    await Future.delayed(Duration(seconds: 5));
    try {
      await Provider.of<MainProvider>(context, listen: false).fetchBooks(context);
      callNextPushReplacement(context, HomeScreen());

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load books')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToHome(context);
    });

    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text_Widget(text:
              "Bookly",fontSize: 30, fontweight: FontWeight.bold),

            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}