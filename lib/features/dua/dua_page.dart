import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dua_data.dart';
import 'dua_favorites_repository.dart';
// import 'dua_notification_service.dart'; // Disabled for now
import 'package:timezone/data/latest.dart' as tz;

class DuaPage extends StatefulWidget {
  const DuaPage({super.key});

  @override
  State<DuaPage> createState() => _DuaPageState();
}

class _DuaPageState extends State<DuaPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? playingIndex;
  String selectedCategory = 'All';
  String searchQuery = '';
  final DuaFavoritesRepository _favoritesRepo = DuaFavoritesRepository();
  Set<String> favoriteTitles = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    tz.initializeTimeZones();
  }

  Future<void> _loadFavorites() async {
    final favs = await _favoritesRepo.getFavorites();
    setState(() {
      favoriteTitles = favs.toSet();
    });
  }

  Future<void> _toggleFavorite(String title) async {
    if (favoriteTitles.contains(title)) {
      await _favoritesRepo.removeFavorite(title);
    } else {
      await _favoritesRepo.addFavorite(title);
    }
    _loadFavorites();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...duas.map((d) => d.category).toSet()];
    final filteredDuas = duas.where((d) {
      final matchesCategory =
          selectedCategory == 'All' || d.category == selectedCategory;
      final matchesSearch = d.title
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          d.arabic.contains(searchQuery) ||
          d.translation.toLowerCase().contains(searchQuery.toLowerCase()) ||
          d.transliteration.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('দোআ (Dua)'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Show Favorites',
            onPressed: () {
              setState(() {
                selectedCategory = 'All';
                searchQuery = '';
                filteredDuas.clear();
                filteredDuas.addAll(
                    duas.where((d) => favoriteTitles.contains(d.title)));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'দোআ খুঁজুন... (Search Duas)',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) => setState(() => searchQuery = val),
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedCategory = val);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDuas.length,
              itemBuilder: (context, idx) {
                final dua = filteredDuas[idx];
                final isFav = favoriteTitles.contains(dua.title);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(dua.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => _toggleFavorite(dua.title),
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.alarm),
                        //   tooltip: 'Set Reminder',
                        //   onPressed: () => _scheduleReminder(dua),
                        // ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dua.arabic,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Amiri'),
                                textAlign: TextAlign.right),
                            const SizedBox(height: 8),
                            Text('Transliteration:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            Text(dua.transliteration,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                            Text('Translation:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            Text(dua.translation),
                            if (dua.audioAsset != null)
                              IconButton(
                                icon: Icon(playingIndex == idx
                                    ? Icons.stop
                                    : Icons.play_arrow),
                                onPressed: () async {
                                  if (playingIndex == idx) {
                                    await _audioPlayer.stop();
                                    setState(() => playingIndex = null);
                                  } else {
                                    await _audioPlayer
                                        .play(AssetSource(dua.audioAsset!));
                                    setState(() => playingIndex = idx);
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
