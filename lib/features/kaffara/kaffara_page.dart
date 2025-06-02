import 'package:flutter/material.dart';

class KaffaraPage extends StatelessWidget {
  const KaffaraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final kaffaraTopics = [
      {
        'title': 'কাফফারার ধরন',
        'subtitle': 'রোযা, কসম, হজ ইত্যাদির কাফফারা',
        'icon': Icons.assignment_turned_in,
      },
      {
        'title': 'কাফফারা আদায়ের নিয়ম',
        'subtitle': 'কিভাবে কাফফারা আদায় করবেন',
        'icon': Icons.rule_folder,
      },
      {
        'title': 'ফিদিয়া ও যাকাতুল ফিতর',
        'subtitle': 'ফিদিয়া ও যাকাতুল ফিতরের বিধান',
        'icon': Icons.volunteer_activism,
      },
      {
        'title': 'প্রশ্নোত্তর',
        'subtitle': 'সাধারণ প্রশ্ন ও উত্তর',
        'icon': Icons.question_answer,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('কাফফারা (Compensations)'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kaffaraTopics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final t = kaffaraTopics[idx];
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
