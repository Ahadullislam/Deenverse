import 'package:flutter/material.dart';

class ZakatPage extends StatelessWidget {
  const ZakatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final zakatTopics = [
      {
        'title': 'যাকাতের নিয়ম',
        'subtitle': 'কার জন্য ফরজ, কত শতাংশ',
        'icon': Icons.calculate,
      },
      {
        'title': 'নিসাব ও সম্পদের ধরন',
        'subtitle': 'স্বর্ণ, রূপা, নগদ, ব্যবসা, কৃষি',
        'icon': Icons.account_balance_wallet,
      },
      {
        'title': 'যাকাতের হিসাব',
        'subtitle': 'সহজ ক্যালকুলেটর',
        'icon': Icons.functions,
      },
      {
        'title': 'যাকাত বিতরণ',
        'subtitle': 'কারা পাবে, কিভাবে বিতরণ করবেন',
        'icon': Icons.people,
      },
      {
        'title': 'রিমাইন্ডার',
        'subtitle': 'বার্ষিক যাকাত স্মরণ করিয়ে দেবে',
        'icon': Icons.alarm,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('যাকাত (Zakat)'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: zakatTopics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final t = zakatTopics[idx];
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
