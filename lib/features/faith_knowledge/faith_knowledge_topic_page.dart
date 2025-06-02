import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FaithKnowledgeTopicPage extends StatelessWidget {
  final String title;
  final String category;
  final Map<String, dynamic> content;
  final VoidCallback onMarkAsRead;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;
  final bool isRead;

  const FaithKnowledgeTopicPage({
    super.key,
    required this.title,
    required this.category,
    required this.content,
    required this.onMarkAsRead,
    required this.onToggleFavorite,
    required this.isFavorite,
    required this.isRead,
  });

  void _shareContent() {
    final shareText = '''
$title
$category

${content['introduction']}

${content['details'] ?? ''}

${content['references'] ?? ''}

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
                  child: Row(
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
                              title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF185A9D),
                                fontFamily: 'NotoSansBengali',
                              ),
                            ),
                            Text(
                              category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'NotoSansBengali',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Action Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: const Color(0xFF185A9D),
                            ),
                            onPressed: onToggleFavorite,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.share_rounded,
                              color: Color(0xFF185A9D),
                            ),
                            onPressed: _shareContent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildContentSection(
                      'সংক্ষিপ্ত পরিচিতি',
                      content['introduction'] ?? 'কনটেন্ট শীঘ্রই আসছে...',
                      Icons.info_outline,
                    ),
                    if (content['details'] != null) ...[
                      const SizedBox(height: 24),
                      _buildContentSection(
                        'বিস্তারিত আলোচনা',
                        content['details'],
                        Icons.menu_book,
                      ),
                    ],
                    if (content['references'] != null) ...[
                      const SizedBox(height: 24),
                      _buildContentSection(
                        'তথ্যসূত্র',
                        content['references'],
                        Icons.source,
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (!isRead)
                      _buildActionButton(
                        context,
                        'পড়া শেষ করেছি',
                        Icons.check_circle_outline,
                        onMarkAsRead,
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

  Widget _buildContentSection(String title, String content, IconData icon) {
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
          // Section Header
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
                  child: Icon(
                    icon,
                    color: const Color(0xFF185A9D),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF185A9D),
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF333333),
                fontFamily: 'NotoSansBengali',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF185A9D),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansBengali',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 