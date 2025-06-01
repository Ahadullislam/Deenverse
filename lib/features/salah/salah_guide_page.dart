import 'package:flutter/material.dart';

class SalahGuidePage extends StatelessWidget {
  const SalahGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('নামাজ শিক্ষা'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF185A9D),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle('নামাজের ধাপসমূহ'),
          _StepCard(
            step: 1,
            title: 'নিয়ত ও তাকবির',
            description:
                'নামাজ শুরু করার জন্য নিয়ত করুন এবং "আল্লাহু আকবার" বলে তাকবির দিন।',
            imageAsset: null,
          ),
          _StepCard(
            step: 2,
            title: 'কিয়াম (দাঁড়ানো)',
            description:
                'কিয়ামের সময় সূরা ফাতিহা ও কুরআনের অন্য একটি সূরা পড়ুন।',
            imageAsset: null,
          ),
          _StepCard(
            step: 3,
            title: 'রুকু',
            description:
                'রুকুতে যান এবং তিনবার "সুবহানা রাব্বিয়াল আজিম" বলুন।',
            imageAsset: null,
          ),
          _StepCard(
            step: 4,
            title: 'সিজদা',
            description:
                'সিজদায় যান এবং তিনবার "সুবহানা রাব্বিয়াল আ’লা" বলুন।',
            imageAsset: null,
          ),
          _StepCard(
            step: 5,
            title: 'তাশাহহুদ ও সালাম',
            description: 'তাশাহহুদ, দরুদ ও দোআ পড়ে ডান ও বামে সালাম ফিরান।',
            imageAsset: null,
          ),
          const SizedBox(height: 24),
          _SectionTitle('ফরজ, সুন্নত, নফল নামাজ'),
          _InfoCard(
            title: 'ফরজ নামাজ',
            description:
                'প্রতিদিন ৫ ওয়াক্ত ফরজ নামাজ পড়া মুসলিমদের জন্য বাধ্যতামূলক।',
          ),
          _InfoCard(
            title: 'সুন্নত নামাজ',
            description:
                'ফরজ নামাজের আগে ও পরে সুন্নত নামাজ পড়া অত্যন্ত ফজিলতপূর্ণ।',
          ),
          _InfoCard(
            title: 'নফল নামাজ',
            description:
                'নফল নামাজ ইচ্ছাকৃতভাবে পড়া যায়, এতে অতিরিক্ত সওয়াব পাওয়া যায়।',
          ),
          const SizedBox(height: 24),
          _SectionTitle('শিশুদের জন্য নামাজ শিক্ষা'),
          _InfoCard(
            title: 'শিশুদের নামাজ শেখানো',
            description:
                'শিশুদের ছোটবেলা থেকেই নামাজ শেখাতে উৎসাহিত করুন এবং ধাপে ধাপে শেখান।',
          ),
          const SizedBox(height: 24),
          _SectionTitle('সাধারণ ভুলসমূহ'),
          _InfoCard(
            title: 'ভুল নিয়ত',
            description: 'নিয়ত ভুলে যাওয়া বা ভুল নিয়ত করা এড়িয়ে চলুন।',
          ),
          _InfoCard(
            title: 'রুকু ও সিজদায় তাড়াহুড়া',
            description:
                'রুকু ও সিজদায় ধীরস্থিরভাবে থাকুন এবং তাসবিহ সম্পূর্ণ পড়ুন।',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF185A9D),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int step;
  final String title;
  final String description;
  final String? imageAsset;
  const _StepCard(
      {required this.step,
      required this.title,
      required this.description,
      this.imageAsset});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF46C6E8),
          child: Text('$step', style: const TextStyle(color: Colors.white)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        // Optionally show image if provided
        trailing:
            imageAsset != null ? Image.asset(imageAsset!, width: 40) : null,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String description;
  const _InfoCard({required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
