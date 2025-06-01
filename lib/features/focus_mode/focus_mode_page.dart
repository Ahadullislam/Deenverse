import 'package:flutter/material.dart';

class FocusModePage extends StatelessWidget {
  const FocusModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Mode')),
      body: const Center(
        child: Text(
          'Focus Mode feature coming soon! (App lock, Islamic motivation, timer, stats, allow calls only)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
