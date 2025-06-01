import 'package:flutter/material.dart';
import 'hadith_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hadith_details_page.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';
  final List<String> _categories = [
    'All',
    'Faith',
    'Prayer',
    'Charity',
    'Fasting',
    'Pilgrimage',
    'Manners'
  ];
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Hadith...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor:
                              isDark ? Colors.grey[800] : Colors.grey[100],
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        final newHadith =
                            await HadithRepository.fetchNewHadiths();
                        if (newHadith != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('New hadith added successfully!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Failed to fetch new hadith. Please try again.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Fetch new hadith',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedCategoryIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_categories[index]),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                          backgroundColor:
                              isDark ? Colors.grey[800] : Colors.grey[100],
                          selectedColor: primaryColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? primaryColor
                                : isDark
                                    ? Colors.white70
                                    : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All Hadith'),
              Tab(text: 'Favorites'),
            ],
            labelColor: primaryColor,
            unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
            indicatorColor: primaryColor,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHadithList(),
                _buildFavoritesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithList() {
    return ValueListenableBuilder(
      valueListenable: HadithRepository.hadithBox.listenable(),
      builder: (context, Box box, _) {
        final hadiths = box.values.toList();
        final filteredHadiths = hadiths.where((hadith) {
          final matchesSearch = _searchQuery.isEmpty ||
              hadith['text']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
          final matchesCategory = _selectedCategoryIndex == 0 ||
              hadith['category'] == _categories[_selectedCategoryIndex];
          return matchesSearch && matchesCategory;
        }).toList();

        if (filteredHadiths.isEmpty) {
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
                      ? 'No hadiths found in this category'
                      : 'No hadiths found for "$_searchQuery"',
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
          itemCount: filteredHadiths.length,
          itemBuilder: (context, index) {
            final hadith = filteredHadiths[index];
            return _buildHadithCard(hadith);
          },
        );
      },
    );
  }

  Widget _buildFavoritesList() {
    return ValueListenableBuilder(
      valueListenable: HadithRepository.favoritesBox.listenable(),
      builder: (context, Box box, _) {
        final favorites = box.values.toList();

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorite hadiths yet',
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
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final hadith = favorites[index];
            return _buildHadithCard(hadith);
          },
        );
      },
    );
  }

  Widget _buildHadithCard(Map<dynamic, dynamic> hadith) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isFavorite = HadithRepository.isFavorite(hadith['id']);

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
              builder: (context) => HadithDetailsPage(hadith: hadith),
            ),
          );
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
                      hadith['category'] ?? 'Uncategorized',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isFavorite) {
                          HadithRepository.removeFavorite(hadith['id']);
                        } else {
                          HadithRepository.addFavorite(hadith);
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                hadith['text'],
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.format_quote,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Narrated by ${hadith['narrator']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
