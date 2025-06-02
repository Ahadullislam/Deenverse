import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:deenverse/features/hadith/hadith_bookmark_service.dart';

class HadithDetailPage extends StatefulWidget {
  final Map<String, dynamic> hadith;

  const HadithDetailPage({
    super.key,
    required this.hadith,
  });

  @override
  State<HadithDetailPage> createState() => _HadithDetailPageState();
}

class _HadithDetailPageState extends State<HadithDetailPage> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarkStatus();
  }

  Future<void> _loadBookmarkStatus() async {
    final isBookmarked = HadithBookmarkService.isBookmarked(
      hadithId: widget.hadith['id'] as String,
    );
    setState(() => _isBookmarked = isBookmarked);
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await HadithBookmarkService.removeBookmark(
        hadithId: widget.hadith['id'] as String,
      );
    } else {
      await HadithBookmarkService.addBookmark(
        hadith: widget.hadith,
      );
    }
    setState(() => _isBookmarked = !_isBookmarked);
  }

  void _shareHadith() {
    final shareText = '''
${widget.hadith['category']}

${widget.hadith['arabic']}

${widget.hadith['bengali']}

${widget.hadith['reference']}

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
                                  widget.hadith['category'] as String,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF185A9D),
                                    fontFamily: 'NotoSansBengali',
                                  ),
                                ),
                                Text(
                                  widget.hadith['reference'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontFamily: 'NotoSansBengali',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: const Color(0xFF185A9D),
                            ),
                            onPressed: _toggleBookmark,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.share_rounded,
                              color: Color(0xFF185A9D),
                            ),
                            onPressed: _shareHadith,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Arabic Text
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
                        child: Text(
                          widget.hadith['arabic'] as String,
                          style: const TextStyle(
                            fontSize: 24,
                            height: 1.5,
                            color: Color(0xFF185A9D),
                            fontFamily: 'NotoNaskhArabic',
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Bengali Translation
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'বাংলা অনুবাদ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF185A9D),
                                fontFamily: 'NotoSansBengali',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.hadith['bengali'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Color(0xFF333333),
                                fontFamily: 'NotoSansBengali',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Additional Information
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'অতিরিক্ত তথ্য',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF185A9D),
                                fontFamily: 'NotoSansBengali',
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('বর্ণনাকারী', widget.hadith['narrator'] as String),
                            const SizedBox(height: 8),
                            _buildInfoRow('অধ্যায়', widget.hadith['chapter'] as String),
                            const SizedBox(height: 8),
                            _buildInfoRow('গ্রেড', widget.hadith['grade'] as String),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontFamily: 'NotoSansBengali',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
              fontFamily: 'NotoSansBengali',
            ),
          ),
        ),
      ],
    );
  }
} 