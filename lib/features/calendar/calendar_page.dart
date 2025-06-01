import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hijri Calendar')),
      body: const Center(
        child: Text(
          'Islamic calendar feature coming soon! (Hijri/Gregorian sync, events, Ramadan, Eid, Hajj, etc.)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
