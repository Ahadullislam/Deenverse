import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer' as developer;

class QuranRepository {
  static late Box<Map<dynamic, dynamic>> surahBox;
  static late Box<Map<dynamic, dynamic>> bookmarksBox;
  static late Box<Map<dynamic, dynamic>> settingsBox;

  static Future<void> init() async {
    try {
      developer.log('Initializing Quran repository...');
      // Open boxes with new names to avoid old data
      surahBox = await Hive.openBox<Map<dynamic, dynamic>>('surahs_dev');
      bookmarksBox =
          await Hive.openBox<Map<dynamic, dynamic>>('quran_bookmarks_dev');
      settingsBox =
          await Hive.openBox<Map<dynamic, dynamic>>('quran_settings_dev');

      developer.log('Boxes opened successfully');
      developer.log('Surah box size: ${surahBox.length}');
      developer.log('Bookmarks box size: ${bookmarksBox.length}');
      developer.log('Settings box size: ${settingsBox.length}');

      // Add sample surahs if the box is empty
      if (surahBox.isEmpty) {
        developer.log('Adding sample surahs...');
        await _addSampleSurahs();
        developer.log('Sample surahs added successfully');
      }

      // Initialize settings if empty
      if (settingsBox.isEmpty) {
        developer.log('Initializing settings...');
        await settingsBox.put('settings', {
          'showTranslation': true,
          'translationLanguage': 'en',
          'fontSize': 18.0,
          'theme': 'light',
        });
        developer.log('Settings initialized successfully');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing Quran repository',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  static Future<void> _addSampleSurahs() async {
    try {
      final sampleSurahs = [
        {
          'id': 1,
          'name': 'Al-Fatiha',
          'arabicName': 'الفاتحة',
          'englishName': 'The Opening',
          'verses': 7,
          'type': 'Meccan',
          'description':
              'The first chapter of the Quran, consisting of seven verses.',
          'versesData': [
            {
              'number': 1,
              'text': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              'translation':
                  'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
            },
            {
              'number': 2,
              'text': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
              'translation': 'All praise is due to Allah, Lord of the worlds.',
            },
            {
              'number': 3,
              'text': 'الرَّحْمَٰنِ الرَّحِيمِ',
              'translation': 'The Entirely Merciful, the Especially Merciful.',
            },
            {
              'number': 4,
              'text': 'مَالِكِ يَوْمِ الدِّينِ',
              'translation': 'Sovereign of the Day of Recompense.',
            },
            {
              'number': 5,
              'text': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
              'translation': 'It is You we worship and You we ask for help.',
            },
            {
              'number': 6,
              'text': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
              'translation': 'Guide us to the straight path.',
            },
            {
              'number': 7,
              'text':
                  'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
              'translation':
                  'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.',
            },
          ],
        },
        {
          'id': 2,
          'name': 'Al-Baqarah',
          'arabicName': 'البقرة',
          'englishName': 'The Cow',
          'verses': 286,
          'type': 'Medinan',
          'description':
              'The longest chapter of the Quran, containing the story of the cow.',
          'versesData': [
            {
              'number': 1,
              'text': 'الٓمٓ',
              'translation': 'Alif, Lam, Meem.',
            },
            {
              'number': 2,
              'text':
                  'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
              'translation':
                  'This is the Book about which there is no doubt, a guidance for those conscious of Allah.',
            },
            {
              'number': 3,
              'text':
                  'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ',
              'translation':
                  'Who believe in the unseen, establish prayer, and spend out of what We have provided for them.',
            },
          ],
        },
        {
          'id': 3,
          'name': 'Al-Imran',
          'arabicName': 'آل عمران',
          'englishName': 'Family of Imran',
          'verses': 200,
          'type': 'Medinan',
          'description':
              'Named after the family of Imran, including Mary and Jesus.',
        },
        {
          'id': 4,
          'name': 'An-Nisa',
          'arabicName': 'النساء',
          'englishName': 'The Women',
          'verses': 176,
          'type': 'Medinan',
          'description': 'Discusses women\'s rights and family matters.',
        },
        {
          'id': 5,
          'name': 'Al-Ma\'idah',
          'arabicName': 'المائدة',
          'englishName': 'The Table Spread',
          'verses': 120,
          'type': 'Medinan',
          'description': 'Named after the table spread with food from heaven.',
        },
      ];

      for (final surah in sampleSurahs) {
        await surahBox.put(surah['id'], surah);
        developer.log('Added surah: ${surah['name']}');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error adding sample surahs',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  static bool isBookmarked(int surahId, int verseNumber) {
    final key = '${surahId}_$verseNumber';
    return bookmarksBox.containsKey(key);
  }

  static Future<void> toggleBookmark(
      int surahId, int verseNumber, Map<dynamic, dynamic> verse) async {
    final key = '${surahId}_$verseNumber';
    if (isBookmarked(surahId, verseNumber)) {
      await bookmarksBox.delete(key);
    } else {
      await bookmarksBox.put(key, {
        'surahId': surahId,
        'verseNumber': verseNumber,
        'verse': verse,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  static List<Map<dynamic, dynamic>> getBookmarks() {
    return bookmarksBox.values.toList()
      ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
  }

  static Future<void> updateSettings(Map<dynamic, dynamic> settings) async {
    await settingsBox.put('settings', settings);
  }

  static Map<dynamic, dynamic> getSettings() {
    return settingsBox.get('settings') ??
        {
          'showTranslation': true,
          'translationLanguage': 'en',
          'fontSize': 18.0,
          'theme': 'light',
        };
  }

  static List<Map<dynamic, dynamic>> searchSurahs(String query) {
    try {
      final surahs = surahBox.values.toList();
      developer.log('Searching surahs. Total count: ${surahs.length}');

      if (query.isEmpty) {
        developer.log('Empty query, returning all surahs');
        return surahs;
      }

      final filteredSurahs = surahs.where((surah) {
        final name = surah['name'].toString().toLowerCase();
        final arabicName = surah['arabicName'].toString();
        final englishName = surah['englishName'].toString().toLowerCase();
        final description = surah['description'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
            arabicName.contains(searchQuery) ||
            englishName.contains(searchQuery) ||
            description.contains(searchQuery);
      }).toList();

      developer.log('Search results: ${filteredSurahs.length} surahs found');
      return filteredSurahs;
    } catch (e, stackTrace) {
      developer.log(
        'Error searching surahs',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }
}
