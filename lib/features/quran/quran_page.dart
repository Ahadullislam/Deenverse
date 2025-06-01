import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer' as developer;
import 'quran_repository.dart';
import 'surah_details_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      developer.log('Loading Quran data...');

      // Force reload data if box is empty
      if (QuranRepository.surahBox.isEmpty) {
        developer.log('Surah box is empty, initializing repository...');
        await QuranRepository.init();
      }

      developer.log('Quran data loaded successfully');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error loading Quran data',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load Quran data. Please try again.';
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('কুরআন'),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Bookmarks (coming soon)',
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'সূরা/আয়াত/অনুবাদ খুঁজুন...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: Colors.red[400]),
                      const SizedBox(height: 16),
                      Text(_error!,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reload'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Daily Verse section (stub)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('আজকের আয়াত',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor)),
                          const SizedBox(height: 8),
                          Text('"إِنَّ مَعَ الْعُسْرِ يُسْرًا"',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                              'নিশ্চয়ই কষ্টের সাথে স্বস্তি রয়েছে। (সূরা আশ-শারহ ৬)'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: QuranRepository.surahBox.listenable(),
                        builder: (context, Box<Map<dynamic, dynamic>> box, _) {
                          final surahs = box.values.where((surah) {
                            if (_searchQuery.isEmpty) return true;
                            final query = _searchQuery.toLowerCase();
                            return (surah['name']
                                        ?.toLowerCase()
                                        .contains(query) ??
                                    false) ||
                                (surah['arabicName']?.contains(query) ??
                                    false) ||
                                (surah['translation']
                                        ?.toLowerCase()
                                        .contains(query) ??
                                    false);
                          }).toList();
                          return ListView.separated(
                            itemCount: surahs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final surah = surahs[index];
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue[100],
                                    child: Text('${surah['id'] ?? index + 1}',
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  ),
                                  title: Text(surah['arabicName'] ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(surah['name'] ?? '',
                                          style: const TextStyle(fontSize: 14)),
                                      Text(surah['translation'] ?? '',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios,
                                        size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SurahDetailsPage(surah: surah),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSurahList() {
    return ValueListenableBuilder(
      valueListenable: QuranRepository.surahBox.listenable(),
      builder: (context, Box box, _) {
        final surahs = QuranRepository.searchSurahs(_searchQuery);
        print('Number of surahs: ${surahs.length}');

        if (surahs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty
                      ? 'No surahs found'
                      : 'No surahs found for "$_searchQuery"',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Reload Data'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final surah = surahs[index];
            return _buildSurahCard(surah);
          },
        );
      },
    );
  }

  Widget _buildBookmarksList() {
    return ValueListenableBuilder(
      valueListenable: QuranRepository.bookmarksBox.listenable(),
      builder: (context, Box box, _) {
        final bookmarks = QuranRepository.getBookmarks();

        if (bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No bookmarks yet',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = bookmarks[index];
            return _buildBookmarkCard(bookmark);
          },
        );
      },
    );
  }

  Widget _buildSurahCard(Map<dynamic, dynamic> surah) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahDetailsPage(surah: surah),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    surah['id'].toString(),
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${surah['englishName']} • ${surah['verses']} verses',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                surah['arabicName'],
                style: TextStyle(
                  fontSize: 20,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(Map<dynamic, dynamic> bookmark) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to the specific verse
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Surah ${bookmark['surahId']}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Verse ${bookmark['verseNumber']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.bookmark, color: Colors.amber),
                    onPressed: () {
                      QuranRepository.toggleBookmark(
                        bookmark['surahId'],
                        bookmark['verseNumber'],
                        bookmark['verse'],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                bookmark['verse']['text'] ?? 'Verse text not available',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
