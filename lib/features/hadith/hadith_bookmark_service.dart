import 'package:hive_flutter/hive_flutter.dart';

class HadithBookmarkService {
  static const String _boxName = 'hadith_bookmarks';
  static late Box<Map<dynamic, dynamic>> _bookmarkBox;

  static Future<void> init() async {
    _bookmarkBox = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
  }

  static Future<void> addBookmark({
    required Map<String, dynamic> hadith,
  }) async {
    final bookmark = {
      ...hadith,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await _bookmarkBox.put(hadith['id'], bookmark);
  }

  static Future<void> removeBookmark({
    required String hadithId,
  }) async {
    await _bookmarkBox.delete(hadithId);
  }

  static bool isBookmarked({
    required String hadithId,
  }) {
    return _bookmarkBox.containsKey(hadithId);
  }

  static List<Map<dynamic, dynamic>> getAllBookmarks() {
    return _bookmarkBox.values.toList();
  }

  static Future<void> clearAllBookmarks() async {
    await _bookmarkBox.clear();
  }
} 