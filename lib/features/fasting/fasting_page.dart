import 'package:flutter/material.dart';

class FastingPage extends StatelessWidget {
  const FastingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fastingTopics = [
      {
        'title': 'রোযার নিয়ম',
        'subtitle': 'ফরজ, সুন্নত, নফল রোযার বিধান',
        'icon': Icons.rule,
      },
      {
        'title': 'সাহরি ও ইফতারের সময়',
        'subtitle': 'সঠিক সময় ও দোআ',
        'icon': Icons.access_time,
      },
      {
        'title': 'রোযা ভঙ্গের কারণ',
        'subtitle': 'কোন কোন কারণে রোযা ভেঙে যায়',
        'icon': Icons.warning,
      },
      {
        'title': 'রোযা কাযা ও কাফফারা',
        'subtitle': 'মিসড রোযা পূরণ ও কাফফারা',
        'icon': Icons.assignment_turned_in,
      },
      {
        'title': 'রোযার ফজিলত',
        'subtitle': 'রোযার গুরুত্ব ও উপকারিতা',
        'icon': Icons.star,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('রোযা (Fasting)'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: fastingTopics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final t = fastingTopics[idx];
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
