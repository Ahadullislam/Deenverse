import 'package:flutter/material.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Islamic Books')),
      body: const Center(
        child: Text(
          'Books feature coming soon! (PDF/ePub, categories, bookmarks, highlights, notes, offline reading)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
