import 'package:hive_flutter/hive_flutter.dart';

class TafsirBookmarkService {
  static const String _boxName = 'tafsir_bookmarks';
  static late Box<Map<dynamic, dynamic>> _bookmarkBox;

  static Future<void> init() async {
    _bookmarkBox = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
  }

  static Future<void> addBookmark({
    required String surahName,
    required int surahNumber,
    required int verseNumber,
    required String tafsirType,
  }) async {
    final bookmark = {
      'surahName': surahName,
      'surahNumber': surahNumber,
      'verseNumber': verseNumber,
      'tafsirType': tafsirType,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final key = '${surahNumber}_${verseNumber}_$tafsirType';
    await _bookmarkBox.put(key, bookmark);
  }

  static Future<void> removeBookmark({
    required int surahNumber,
    required int verseNumber,
    required String tafsirType,
  }) async {
    final key = '${surahNumber}_${verseNumber}_$tafsirType';
    await _bookmarkBox.delete(key);
  }

  static bool isBookmarked({
    required int surahNumber,
    required int verseNumber,
    required String tafsirType,
  }) {
    final key = '${surahNumber}_${verseNumber}_$tafsirType';
    return _bookmarkBox.containsKey(key);
  }

  static List<Map<dynamic, dynamic>> getAllBookmarks() {
    return _bookmarkBox.values.toList();
  }

  static Future<void> clearAllBookmarks() async {
    await _bookmarkBox.clear();
  }
} 