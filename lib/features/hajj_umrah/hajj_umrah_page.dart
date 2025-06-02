import 'package:flutter/material.dart';

class HajjUmrahPage extends StatelessWidget {
  const HajjUmrahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hajjTopics = [
      {
        'title': 'হজের ধাপসমূহ',
        'subtitle': 'ধাপে ধাপে হজের কার্যক্রম',
        'icon': Icons.directions_walk,
      },
      {
        'title': 'উমরার ধাপসমূহ',
        'subtitle': 'উমরার নিয়মাবলী',
        'icon': Icons.directions_run,
      },
      {
        'title': 'চেকলিস্ট',
        'subtitle': 'প্রস্তুতির জন্য চেকলিস্ট',
        'icon': Icons.checklist,
      },
      {
        'title': 'দোআ ও জিকির',
        'subtitle': 'হজ ও উমরার জন্য দোআ',
        'icon': Icons.menu_book,
      },
      {
        'title': 'পবিত্র স্থানসমূহ',
        'subtitle': 'মক্কা, মদিনা ও অন্যান্য স্থান',
        'icon': Icons.map,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('হজ ও উমরা'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: hajjTopics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final t = hajjTopics[idx];
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
