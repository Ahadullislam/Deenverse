import 'package:flutter/material.dart';
import 'package:deenverse/core/theme/app_theme.dart';
import 'package:deenverse/features/quran/quran_repository.dart';
import 'package:deenverse/features/tafsir/tafsir_detail_page.dart';

class TafsirPage extends StatefulWidget {
  const TafsirPage({super.key});

  @override
  State<TafsirPage> createState() => _TafsirPageState();
}

class _TafsirPageState extends State<TafsirPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  List<Map<String, dynamic>> _surahs = [];
  List<Map<String, dynamic>> _filteredSurahs = [];
  String _selectedTafsir = 'বাংলা তাফসীর';
  final List<String> _availableTafsirs = [
    'বাংলা তাফসীর',
    'ইবনে কাসীর',
    'তাফসীরে মাযহারী',
    'তাফসীরে জালালাইন',
    'তাফসীরে কুরতুবী',
    'তাফসীরে তাবারী',
    'তাফসীরে বাগভী',
    'তাফসীরে নাসাফী',
    'তাফসীরে মাআরেফুল কুরআন',
    'তাফসীরে আহসানুল বায়ান',
  ];

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    setState(() => _isLoading = true);
    try {
      final surahs = await QuranRepository.getSurahs();
      setState(() {
        _surahs = surahs;
        _filteredSurahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('সূরা লোড করতে সমস্যা হয়েছে'),
            backgroundColor: Color(0xFF185A9D),
          ),
        );
      }
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredSurahs = _surahs;
      } else {
        _filteredSurahs = _surahs.where((surah) {
          final name = surah['name'] as String;
          final nameTranslation = surah['nameTranslation'] as String;
          final number = surah['number'].toString();
          return name.toLowerCase().contains(query.toLowerCase()) ||
              nameTranslation.toLowerCase().contains(query.toLowerCase()) ||
              number.contains(query);
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
                            'তাফসীর',
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
                          onChanged: _filterSurahs,
                          decoration: InputDecoration(
                            hintText: 'সূরা খুঁজুন...',
                            prefixIcon: const Icon(Icons.search,
                                color: Color(0xFF185A9D)),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tafsir Selector
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedTafsir,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Color(0xFF185A9D)),
                                  style: const TextStyle(
                                    color: Color(0xFF185A9D),
                                    fontSize: 16,
                                    fontFamily: 'NotoSansBengali',
                                  ),
                                  items: _availableTafsirs.map((String tafsir) {
                                    return DropdownMenuItem<String>(
                                      value: tafsir,
                                      child: Text(tafsir),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(
                                          () => _selectedTafsir = newValue);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF185A9D).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.headphones,
                                    color: Color(0xFF185A9D),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ক্বারী',
                                    style: TextStyle(
                                      color: const Color(0xFF185A9D)
                                          .withOpacity(0.8),
                                      fontSize: 14,
                                      fontFamily: 'NotoSansBengali',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                        itemCount: _filteredSurahs.length,
                        itemBuilder: (context, index) {
                          final surah = _filteredSurahs[index];
                          return _buildSurahCard(context, surah);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahCard(BuildContext context, Map<String, dynamic> surah) {
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
          onTap: () => _navigateToTafsir(context, surah),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Surah Number
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF185A9D).withOpacity(0.1),
                        const Color(0xFF185A9D).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF185A9D).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      surah['number'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF185A9D),
                        fontFamily: 'NotoSansBengali',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Surah Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah['name'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF185A9D),
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        surah['nameTranslation'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${surah['versesCount']} আয়াত',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF185A9D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Color(0xFF185A9D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTafsir(BuildContext context, Map<String, dynamic> surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TafsirDetailPage(
          surah: surah,
          tafsirType: _selectedTafsir,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class QuranRepository {
  static Future<List<Map<String, dynamic>>> getSurahs() async {
    // Replace the following with actual data fetching logic
    // Example dummy data:
    return [
      {
        'number': 1,
        'name': 'الفاتحة',
        'nameTranslation': 'The Opening',
        'versesCount': 7,
      },
      {
        'number': 2,
        'name': 'البقرة',
        'nameTranslation': 'The Cow',
        'versesCount': 286,
      },
      // Add more surahs as needed
    ];
  }
}
