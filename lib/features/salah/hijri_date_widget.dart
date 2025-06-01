import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriDateWidget extends StatelessWidget {
  const HijriDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final today = HijriCalendar.now();
    return Card(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.amber),
        title: Text('Hijri Date'),
        subtitle: Text(
          '${today.hDay} ${today.longMonthName} ${today.hYear} AH',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
