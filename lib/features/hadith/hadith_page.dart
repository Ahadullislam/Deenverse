import 'package:flutter/material.dart';
import 'package:deenverse/core/theme/app_theme.dart';
import 'package:deenverse/features/hadith/hadith_repository.dart';
import 'package:deenverse/features/hadith/hadith_detail_page.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  List<Map<String, dynamic>> _hadiths = [];
  List<Map<String, dynamic>> _filteredHadiths = [];
  String _selectedCategory = 'সকল হাদিস';
  final List<String> _categories = [
    'সকল হাদিস',
    'বুখারী শরীফ',
    'মুসলিম শরীফ',
    'আবু দাউদ',
    'তিরমিযী',
    'ইবনে মাজাহ',
    'নাসাঈ',
    'মুয়াত্তা মালিক',
    'মুসনাদ আহমদ',
    'সুনান দারিমী',
    'সুনান দারাকুতনী',
    'সুনান বায়হাকী',
    'মুসনাদ আবু হানিফা',
    'মুসনাদ আবু ইয়ালা',
    'মুসনাদ আবু দাউদ তায়ালিসী',
  ];

  @override
  void initState() {
    super.initState();
    _loadHadiths();
  }

  Future<void> _loadHadiths() async {
    setState(() => _isLoading = true);
    try {
      final hadiths = await HadithRepository.getHadiths();
      setState(() {
        _hadiths = hadiths;
        _filteredHadiths = hadiths;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('হাদিস লোড করতে সমস্যা হয়েছে'),
            backgroundColor: Color(0xFF185A9D),
          ),
        );
      }
    }
  }

  void _filterHadiths(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredHadiths = _hadiths.where((hadith) {
          if (_selectedCategory == 'সকল হাদিস') return true;
          return hadith['category'] == _selectedCategory;
        }).toList();
      } else {
        _filteredHadiths = _hadiths.where((hadith) {
          final matchesCategory = _selectedCategory == 'সকল হাদিস' ||
              hadith['category'] == _selectedCategory;
          final matchesSearch = hadith['arabic']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              hadith['bengali']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              hadith['reference']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => Navigator.pop(context),
                            color: const Color(0xFF185A9D),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'হাদিস সংকলন',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF185A9D),
                              fontFamily: 'NotoSansBengali',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search Bar
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
                          onChanged: _filterHadiths,
                          decoration: InputDecoration(
                            hintText: 'হাদিস খুঁজুন...',
                            prefixIcon: const Icon(Icons.search,
                                color: Color(0xFF185A9D)),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Category Selector
                      Container(
                        height: 40,
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
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = category == _selectedCategory;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () {
                                  setState(() => _selectedCategory = category);
                                  _filterHadiths(_searchQuery);
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF185A9D)
                                        : const Color(0xFF185A9D)
                                            .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF185A9D),
                                        fontSize: 14,
                                        fontFamily: 'NotoSansBengali',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF185A9D),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredHadiths.length,
                        itemBuilder: (context, index) {
                          final hadith = _filteredHadiths[index];
                          return _buildHadithCard(context, hadith);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHadithCard(BuildContext context, Map<String, dynamic> hadith) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToHadithDetail(context, hadith),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF185A9D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hadith['category'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF185A9D),
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Arabic Text
                Text(
                  hadith['arabic'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    color: Color(0xFF185A9D),
                    fontFamily: 'NotoNaskhArabic',
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Bengali Translation
                Text(
                  hadith['bengali'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF333333),
                    fontFamily: 'NotoSansBengali',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Reference
                Text(
                  hadith['reference'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToHadithDetail(
      BuildContext context, Map<String, dynamic> hadith) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HadithDetailPage(hadith: hadith),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class HadithRepository {
  static Future<List<Map<String, dynamic>>> getHadiths() async {
    // TODO: Replace with actual data fetching logic
    // Example dummy data:
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'category': 'বুখারী শরীফ',
        'arabic': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
        'bengali': 'কর্মসমূহ নিয়তের উপর নির্ভরশীল।',
        'reference': 'সহীহ বুখারী, হাদিস ১',
      },
      // Add more hadiths as needed
    ];
  }
}
