import 'package:flutter/material.dart';

class MarriagePage extends StatelessWidget {
  const MarriagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final marriageTopics = [
      {
        'title': 'নিকাহ্ প্রক্রিয়া',
        'subtitle': 'বিবাহের ইসলামী নিয়ম',
        'icon': Icons.favorite,
      },
      {
        'title': 'পরামর্শ ও দিকনির্দেশনা',
        'subtitle': 'দাম্পত্য জীবনের জন্য পরামর্শ',
        'icon': Icons.chat_bubble_outline,
      },
      {
        'title': 'মাহর ও দেনমোহর',
        'subtitle': 'মাহর নির্ধারণ ও আদায়',
        'icon': Icons.attach_money,
      },
      {
        'title': 'দায়িত্ব ও অধিকার',
        'subtitle': 'স্বামী-স্ত্রীর অধিকার ও দায়িত্ব',
        'icon': Icons.people_outline,
      },
      {
        'title': 'বিবাহ সংক্রান্ত প্রশ্নোত্তর',
        'subtitle': 'সাধারণ প্রশ্ন ও উত্তর',
        'icon': Icons.question_answer,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('বিবাহ (Marriage)'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: marriageTopics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final t = marriageTopics[idx];
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(t['icon'] as IconData,
                    color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(t['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(t['subtitle'] as String),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(t['title'] as String),
                    content: const Text('বিস্তারিত কনটেন্ট শীঘ্রই আসছে...'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ঠিক আছে'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
