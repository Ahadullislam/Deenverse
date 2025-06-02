import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deenverse/core/theme/app_theme.dart';
import 'faith_knowledge_topic_page.dart';

class FaithKnowledgePage extends StatefulWidget {
  const FaithKnowledgePage({super.key});

  @override
  State<FaithKnowledgePage> createState() => _FaithKnowledgePageState();
}

class _FaithKnowledgePageState extends State<FaithKnowledgePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Set<String> _favorites = {};
  Map<String, bool> _readTopics = {};
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadReadTopics();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('faith_knowledge_favorites')?.toSet() ?? {};
    });
  }

  Future<void> _loadReadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _readTopics = Map.fromEntries(
        (prefs.getStringList('faith_knowledge_read') ?? []).map(
          (topic) => MapEntry(topic, true),
        ),
      );
    });
  }

  Future<void> _toggleFavorite(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(topic)) {
        _favorites.remove(topic);
      } else {
        _favorites.add(topic);
      }
    });
    await prefs.setStringList('faith_knowledge_favorites', _favorites.toList());
  }

  Future<void> _markAsRead(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _readTopics[topic] = true;
    });
    await prefs.setStringList('faith_knowledge_read', _readTopics.keys.toList());
  }

  List<String> _filterTopics(List<String> topics) {
    if (_searchQuery.isEmpty && !_showOnlyFavorites) return topics;
    
    return topics.where((topic) {
      final matchesSearch = topic.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFavorite = !_showOnlyFavorites || _favorites.contains(topic);
      return matchesSearch && matchesFavorite;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topicContent = _getTopicContent();
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF8FBFF),
              const Color(0xFFE8ECF3).withOpacity(0.8),
              const Color(0xFFFFFFFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                      color: const Color(0xFF185A9D),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ঈমানী জ্ঞানচর্চা',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF185A9D),
                        fontFamily: 'NotoSansBengali',
                      ),
                    ),
                  ],
                ),
              ),
              // Search and Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'বিষয় খুঁজুন...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF185A9D)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
                              color: const Color(0xFF185A9D),
                            ),
                            onPressed: () => setState(() => _showOnlyFavorites = !_showOnlyFavorites),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Progress Indicator
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_up, color: Color(0xFF185A9D)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'আপনার অগ্রগতি',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF185A9D),
                                    fontFamily: 'NotoSansBengali',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: _readTopics.length / 25, // Total topics
                                  backgroundColor: const Color(0xFF185A9D).withOpacity(0.1),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF185A9D)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_readTopics.length}/25',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF185A9D),
                              fontFamily: 'NotoSansBengali',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildCategoryCard(
                      context,
                      'আকিদা',
                      'ইসলামের মৌলিক বিশ্বাস',
                      Icons.auto_awesome,
                      [
                        'তাওহীদ',
                        'রিসালাত',
                        'আখিরাত',
                        'কদর',
                        'মালাইকা',
                      ],
                      topicContent,
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'ইবাদত',
                      'আল্লাহর ইবাদতের পদ্ধতি',
                      Icons.mosque,
                      [
                        'নামাজ',
                        'রোজা',
                        'যাকাত',
                        'হজ',
                        'দোয়া',
                      ],
                      topicContent,
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'আখলাক',
                      'ইসলামি চরিত্র ও নৈতিকতা',
                      Icons.volunteer_activism,
                      [
                        'সততা',
                        'ধৈর্য',
                        'ক্ষমা',
                        'দয়া',
                        'ন্যায়পরায়ণতা',
                      ],
                      topicContent,
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'ইতিহাস',
                      'ইসলামের ইতিহাস ও ঐতিহ্য',
                      Icons.history_edu,
                      [
                        'নবী-রাসূল',
                        'সাহাবা',
                        'আউলিয়া',
                        'ইসলামি সভ্যতা',
                        'মুসলিম বিজ্ঞানী',
                      ],
                      topicContent,
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'ফিকহ',
                      'ইসলামি আইন ও বিধান',
                      Icons.gavel,
                      [
                        'পরিবার',
                        'সমাজ',
                        'অর্থনীতি',
                        'রাজনীতি',
                        'আন্তর্জাতিক',
                      ],
                      topicContent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    List<String> topics,
    Map<String, Map<String, dynamic>> topicContent,
  ) {
    final filteredTopics = _filterTopics(topics);
    if (filteredTopics.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).primaryColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.9),
                        blurRadius: 8,
                        offset: const Offset(-2, -2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Icon glow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).primaryColor.withOpacity(0.2),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Icon shadow
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: Icon(
                          icon,
                          size: 28,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                      // Main icon
                      Icon(
                        icon,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF185A9D),
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Topics
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filteredTopics.map((topic) => _buildTopicChip(
                topic,
                () => _navigateToTopic(
                  context,
                  topic,
                  title,
                  topicContent[topic] ?? {
                    'introduction': 'এই বিষয়ে বিস্তারিত কনটেন্ট শীঘ্রই আসছে...',
                  },
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChip(String topic, VoidCallback onTap) {
    final isRead = _readTopics[topic] ?? false;
    final isFavorite = _favorites.contains(topic);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isRead 
              ? const Color(0xFF185A9D).withOpacity(0.2)
              : const Color(0xFF185A9D).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFavorite 
                ? const Color(0xFF185A9D)
                : const Color(0xFF185A9D).withOpacity(0.2),
            width: isFavorite ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              topic,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF185A9D),
                fontFamily: 'NotoSansBengali',
                fontWeight: isRead ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isRead) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle,
                size: 16,
                color: Color(0xFF185A9D),
              ),
            ],
            if (isFavorite) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.favorite,
                size: 16,
                color: Color(0xFF185A9D),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToTopic(BuildContext context, String title, String category, Map<String, dynamic> content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaithKnowledgeTopicPage(
          title: title,
          category: category,
          content: content,
          onMarkAsRead: () => _markAsRead(title),
          onToggleFavorite: () => _toggleFavorite(title),
          isFavorite: _favorites.contains(title),
          isRead: _readTopics[title] ?? false,
        ),
      ),
    );
  }

  Map<String, Map<String, dynamic>> _getTopicContent() {
    return {
      'তাওহীদ': {
        'introduction': 'তাওহীদ হল আল্লাহর একত্ববাদে বিশ্বাস করা। এটি ইসলামের সবচেয়ে গুরুত্বপূর্ণ মৌলিক বিশ্বাস।',
        'details': 'তাওহীদ তিন প্রকার:\n\n১. তাওহীদুর রুবুবিয়্যাহ: আল্লাহর একক সৃষ্টিকর্তা হিসেবে বিশ্বাস\n২. তাওহীদুল উলুহিয়্যাহ: আল্লাহর একক ইবাদতের অধিকারী হিসেবে বিশ্বাস\n৩. তাওহীদুল আসমা ওয়াস সিফাত: আল্লাহর নাম ও গুণাবলীর ক্ষেত্রে একত্ববাদ',
        'references': 'কুরআন: সূরা ইখলাস, সূরা বাকারা ২৫৫\nহাদিস: বুখারী শরীফ, মুসলিম শরীফ',
      },
      'রিসালাত': {
        'introduction': 'রিসালাত হল আল্লাহর পক্ষ থেকে মনোনীত নবী-রাসূলদের মাধ্যমে মানুষের কাছে আল্লাহর বাণী পৌঁছে দেওয়া।',
        'details': 'রাসূলগণের বৈশিষ্ট্য:\n\n১. তারা আল্লাহর পক্ষ থেকে মনোনীত\n২. তারা নিষ্পাপ\n৩. তারা আল্লাহর বাণী সঠিকভাবে পৌঁছে দেন\n৪. তারা মানুষের জন্য উত্তম আদর্শ',
        'references': 'কুরআন: সূরা আহযাব ৪০\nহাদিস: বুখারী শরীফ',
      },
      'নামাজ': {
        'introduction': 'নামাজ হল ইসলামের দ্বিতীয় স্তম্ভ এবং মুসলমানের জন্য সবচেয়ে গুরুত্বপূর্ণ ইবাদত।',
        'details': 'নামাজের গুরুত্ব:\n\n১. এটি ঈমানের আলামত\n২. এটি আল্লাহর সাথে সম্পর্ক স্থাপনের মাধ্যম\n৩. এটি মানুষকে পাপ থেকে বিরত রাখে\n৪. এটি শৃঙ্খলা ও নিয়মানুবর্তিতা শিক্ষা দেয়',
        'references': 'কুরআন: সূরা বাকারা ২৩৮\nহাদিস: বুখারী শরীফ',
      },
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
