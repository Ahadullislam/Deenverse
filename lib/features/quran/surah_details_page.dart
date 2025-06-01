import 'package:flutter/material.dart';
import 'quran_repository.dart';

class SurahDetailsPage extends StatefulWidget {
  final Map<dynamic, dynamic> surah;

  const SurahDetailsPage({
    super.key,
    required this.surah,
  });

  @override
  State<SurahDetailsPage> createState() => _SurahDetailsPageState();
}

class _SurahDetailsPageState extends State<SurahDetailsPage> {
  bool _showTranslation = true;
  double _fontSize = 18.0;
  bool _isPlaying = false;
  int? _currentVerse;

  @override
  void initState() {
    super.initState();
    final settings = QuranRepository.getSettings();
    _showTranslation = settings['showTranslation'] ?? true;
    _fontSize = settings['fontSize'] ?? 18.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.surah['arabicName'],
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.surah['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.surah['verses']} verses • ${widget.surah['type']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _showTranslation ? Icons.translate : Icons.translate_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showTranslation = !_showTranslation;
                    QuranRepository.updateSettings({
                      ...QuranRepository.getSettings(),
                      'showTranslation': _showTranslation,
                    });
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: _showFontSizeDialog,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.surah['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildVersesList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isPlaying = !_isPlaying;
            // TODO: Implement audio playback
          });
        },
        child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  Widget _buildVersesList() {
    final verses = widget.surah['versesData'] as List<dynamic>? ?? [];
    print('Number of verses: ${verses.length}'); // Debug print

    if (verses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No verses available',
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final verse = verses[index];
        print('Verse ${verse['number']}: ${verse['text']}'); // Debug print
        final isBookmarked = QuranRepository.isBookmarked(
          widget.surah['id'],
          verse['number'] as int,
        );

        return _buildVerseCard(verse, isBookmarked);
      },
    );
  }

  Widget _buildVerseCard(Map<dynamic, dynamic> verse, bool isBookmarked) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      verse['number'].toString(),
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    QuranRepository.toggleBookmark(
                      widget.surah['id'],
                      verse['number'] as int,
                      verse,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    _currentVerse == verse['number'] && _isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_currentVerse == verse['number'] && _isPlaying) {
                        _isPlaying = false;
                      } else {
                        _currentVerse = verse['number'];
                        _isPlaying = true;
                      }
                      // TODO: Implement verse-specific audio playback
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              verse['text'],
              style: TextStyle(
                fontSize: _fontSize + 4,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.8,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            if (_showTranslation) ...[
              const SizedBox(height: 16),
              Text(
                verse['translation'],
                style: TextStyle(
                  fontSize: _fontSize,
                  color: isDark ? Colors.white70 : Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Font Size'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: _fontSize,
                    min: 14,
                    max: 30,
                    divisions: 8,
                    label: _fontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                  Text(
                    'Sample Text',
                    style: TextStyle(fontSize: _fontSize),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      QuranRepository.updateSettings({
                        ...QuranRepository.getSettings(),
                        'fontSize': _fontSize,
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
