import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:deenverse/features/tafsir/tafsir_bookmark_service.dart';
import 'package:deenverse/features/tafsir/tafsir_audio_service.dart';

class TafsirDetailPage extends StatefulWidget {
  final Map<String, dynamic> surah;
  final String tafsirType;

  const TafsirDetailPage({
    super.key,
    required this.surah,
    required this.tafsirType,
  });

  @override
  State<TafsirDetailPage> createState() => _TafsirDetailPageState();
}

class _TafsirDetailPageState extends State<TafsirDetailPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _verses = [];
  final ScrollController _scrollController = ScrollController();
  int _selectedVerse = 0;
  Map<int, bool> _bookmarkedVerses = {};
  final TafsirAudioService _audioService = TafsirAudioService();
  String _selectedReciter = 'মিশারী রশীদ আল-আফাসী';
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadTafsir();
    _loadBookmarks();
  }

  Future<void> _loadTafsir() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement actual tafsir loading from repository
      await Future.delayed(const Duration(seconds: 1)); // Simulated loading
      setState(() {
        _verses = List.generate(
          widget.surah['versesCount'] as int,
          (index) => {
            'number': index + 1,
            'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            'bengali': 'পরম করুণাময় অতি দয়ালু আল্লাহর নামে',
            'tafsir': 'এই আয়াতের তাফসীর শীঘ্রই আসছে...',
          },
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('তাফসীর লোড করতে সমস্যা হয়েছে'),
            backgroundColor: Color(0xFF185A9D),
          ),
        );
      }
    }
  }

  Future<void> _loadBookmarks() async {
    for (var verse in _verses) {
      final isBookmarked = TafsirBookmarkService.isBookmarked(
        surahNumber: widget.surah['number'] as int,
        verseNumber: verse['number'] as int,
        tafsirType: widget.tafsirType,
      );
      setState(() {
        _bookmarkedVerses[verse['number'] as int] = isBookmarked;
      });
    }
  }

  Future<void> _toggleBookmark(Map<String, dynamic> verse) async {
    final verseNumber = verse['number'] as int;
    final isCurrentlyBookmarked = _bookmarkedVerses[verseNumber] ?? false;

    if (isCurrentlyBookmarked) {
      await TafsirBookmarkService.removeBookmark(
        surahNumber: widget.surah['number'] as int,
        verseNumber: verseNumber,
        tafsirType: widget.tafsirType,
      );
    } else {
      await TafsirBookmarkService.addBookmark(
        surahName: widget.surah['name'] as String,
        surahNumber: widget.surah['number'] as int,
        verseNumber: verseNumber,
        tafsirType: widget.tafsirType,
      );
    }

    setState(() {
      _bookmarkedVerses[verseNumber] = !isCurrentlyBookmarked;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCurrentlyBookmarked
                ? 'বুকমার্ক সরানো হয়েছে'
                : 'বুকমার্ক করা হয়েছে',
          ),
          backgroundColor: const Color(0xFF185A9D),
        ),
      );
    }
  }

  Future<void> _toggleAudio(Map<String, dynamic> verse) async {
    try {
      if (_isPlaying) {
        await _audioService.stop();
        setState(() => _isPlaying = false);
      } else {
        await _audioService.playVerse(
          reciter: _selectedReciter,
          surahNumber: widget.surah['number'] as int,
          verseNumber: verse['number'] as int,
        );
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('অডিও প্লে করতে সমস্যা হয়েছে'),
            backgroundColor: Color(0xFF185A9D),
          ),
        );
      }
    }
  }

  void _showReciterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'ক্বারী নির্বাচন করুন',
          style: TextStyle(
            fontFamily: 'NotoSansBengali',
            color: Color(0xFF185A9D),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _audioService.availableReciters.length,
            itemBuilder: (context, index) {
              final reciter = _audioService.availableReciters[index];
              return ListTile(
                title: Text(
                  reciter,
                  style: const TextStyle(
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                selected: reciter == _selectedReciter,
                onTap: () {
                  setState(() => _selectedReciter = reciter);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _shareVerse(Map<String, dynamic> verse) {
    final shareText = '''
${widget.surah['name']} - ${verse['number']} নং আয়াত

${verse['arabic']}

${verse['bengali']}

${verse['tafsir']}

Shared from DeenVerse App
''';
    Share.share(shareText);
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.surah['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF185A9D),
                                    fontFamily: 'NotoSansBengali',
                                  ),
                                ),
                                Text(
                                  widget.tafsirType,
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
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _verses.length,
                        itemBuilder: (context, index) {
                          final verse = _verses[index];
                          return _buildVerseCard(verse);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerseCard(Map<String, dynamic> verse) {
    final isSelected = verse['number'] == _selectedVerse;
    final isBookmarked = _bookmarkedVerses[verse['number'] as int] ?? false;
    final isCurrentVersePlaying = _isPlaying && 
        _audioService.currentSurah == widget.surah['number'] &&
        _audioService.currentVerse == verse['number'];
    
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
          color: isSelected 
              ? const Color(0xFF185A9D)
              : Colors.white.withOpacity(0.5),
          width: isSelected ? 2 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verse Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF185A9D).withOpacity(0.1),
                  const Color(0xFF185A9D).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF185A9D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${verse['number']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF185A9D),
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isCurrentVersePlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xFF185A9D),
                  ),
                  onPressed: () => _toggleAudio(verse),
                ),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: const Color(0xFF185A9D),
                  ),
                  onPressed: () => _toggleBookmark(verse),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share_rounded,
                    color: Color(0xFF185A9D),
                  ),
                  onPressed: () => _shareVerse(verse),
                ),
              ],
            ),
          ),
          // Verse Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Arabic Text
                Text(
                  verse['arabic'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.5,
                    color: Color(0xFF185A9D),
                    fontFamily: 'NotoNaskhArabic',
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                // Bengali Translation
                Text(
                  verse['bengali'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF333333),
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                const SizedBox(height: 16),
                // Tafsir
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF185A9D).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF185A9D).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'তাফসীর',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF185A9D),
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        verse['tafsir'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF333333),
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _audioService.dispose();
    super.dispose();
  }
} 