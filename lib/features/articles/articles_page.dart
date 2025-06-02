import 'package:flutter/material.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final articlesTopics = [
      {
        'title': 'প্রবন্ধ ও নিবন্ধ',
        'subtitle': 'সমসাময়িক ও ধর্মীয় বিষয়',
        'icon': Icons.article,
      },
      {
        'title': 'স্কলার ইনসাইট',
        'subtitle': 'বিশেষজ্ঞদের মতামত',
        'icon': Icons.lightbulb_outline,
      },
      {
        'title': 'কমেন্ট ও আলোচনা',
        'subtitle': 'পাঠকের মতামত ও প্রশ্ন',
        'icon': Icons.comment,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রবন্ধ (Articles)'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: articlesTopics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final t = articlesTopics[idx];
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
