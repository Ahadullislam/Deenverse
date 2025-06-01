import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HadithRepository {
  static late Box<Map<dynamic, dynamic>> hadithBox;
  static late Box<Map<dynamic, dynamic>> favoritesBox;
  static const String _apiUrl = 'https://api.hadith.gq/v1/hadiths/random';

  static Future<void> init() async {
    hadithBox = await Hive.openBox<Map<dynamic, dynamic>>('hadiths_dev');
    favoritesBox = await Hive.openBox<Map<dynamic, dynamic>>('favorites_dev');

    // Add sample hadiths if the box is empty
    if (hadithBox.isEmpty) {
      await _addSampleHadiths();
    }
  }

  static Future<Map<dynamic, dynamic>?> fetchNewHadiths() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final hadith = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'text': data['text'],
          'narrator': data['narrator'] ?? 'Unknown',
          'category': _determineCategory(data['text']),
          'source': data['source'] ?? 'Unknown',
        };
        await hadithBox.put(hadith['id'], hadith);
        return hadith;
      }
    } catch (e) {
      print('Error fetching hadith: $e');
    }
    return null;
  }

  static String _determineCategory(String text) {
    final textLower = text.toLowerCase();
    if (textLower.contains('pray') || textLower.contains('salah'))
      return 'Prayer';
    if (textLower.contains('charity') || textLower.contains('sadaqah'))
      return 'Charity';
    if (textLower.contains('fast') || textLower.contains('ramadan'))
      return 'Fasting';
    if (textLower.contains('hajj') || textLower.contains('pilgrimage'))
      return 'Pilgrimage';
    if (textLower.contains('manners') || textLower.contains('character'))
      return 'Manners';
    return 'Faith';
  }

  static Future<void> _addSampleHadiths() async {
    final sampleHadiths = [
      {
        'id': '1',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "Actions are judged by intentions, and each person will be rewarded according to their intention."',
        'narrator': 'Umar ibn Al-Khattab',
        'category': 'Faith',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '2',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "None of you truly believes until he loves for his brother what he loves for himself."',
        'narrator': 'Anas ibn Malik',
        'category': 'Manners',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '3',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "The best among you are those who have the best manners and character."',
        'narrator': 'Abdullah ibn Amr',
        'category': 'Manners',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '4',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "When one of you prays, he is conversing with his Lord."',
        'narrator': 'Abu Huraira',
        'category': 'Prayer',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '5',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "Charity does not decrease wealth."',
        'narrator': 'Abu Huraira',
        'category': 'Charity',
        'source': 'Sahih Muslim',
      },
      {
        'id': '6',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "Whoever fasts during Ramadan out of sincere faith and hoping to attain Allah\'s rewards, then all his past sins will be forgiven."',
        'narrator': 'Abu Huraira',
        'category': 'Fasting',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '7',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "Whoever performs Hajj for Allah\'s pleasure and does not have sexual relations with his wife, and does not do evil or sins then he will return (after Hajj free from all sins) as if he were born anew."',
        'narrator': 'Abu Huraira',
        'category': 'Pilgrimage',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '8',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "The strong person is not the one who can wrestle someone else down. The strong person is the one who can control himself when he is angry."',
        'narrator': 'Abu Huraira',
        'category': 'Manners',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '9',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "A Muslim is the one who avoids harming Muslims with his tongue and hands. And a Muhajir (emigrant) is the one who gives up (abandons) all what Allah has forbidden."',
        'narrator': 'Abdullah ibn Amr',
        'category': 'Manners',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '10',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "Whoever believes in Allah and the Last Day, let him speak good or remain silent."',
        'narrator': 'Abu Huraira',
        'category': 'Manners',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '11',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "The most beloved of people to Allah are those who are most beneficial to people."',
        'narrator': 'Jabir ibn Abdullah',
        'category': 'Manners',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '12',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "The best of you are those who are best to their families, and I am the best of you to my family."',
        'narrator': 'Aisha',
        'category': 'Manners',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '13',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "Whoever relieves a Muslim of a burden from the burdens of the world, Allah will relieve him of a burden from the burdens of the Day of Judgment."',
        'narrator': 'Abu Huraira',
        'category': 'Charity',
        'source': 'Sahih Muslim',
      },
      {
        'id': '14',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "The most complete of the believers in faith is the one with the best character."',
        'narrator': 'Abu Huraira',
        'category': 'Manners',
        'source': 'Sahih Al-Bukhari',
      },
      {
        'id': '15',
        'text':
            'The Prophet Muhammad (peace be upon him) said: "The most beloved of deeds to Allah are those that are most consistent, even if it is small."',
        'narrator': 'Aisha',
        'category': 'Faith',
        'source': 'Sahih Al-Bukhari',
      },
    ];

    for (final hadith in sampleHadiths) {
      await hadithBox.put(hadith['id'], hadith);
    }
  }

  static bool isFavorite(String id) {
    return favoritesBox.containsKey(id);
  }

  static Future<void> addFavorite(Map<dynamic, dynamic> hadith) async {
    await favoritesBox.put(hadith['id'], hadith);
  }

  static Future<void> removeFavorite(String id) async {
    await favoritesBox.delete(id);
  }

  static List<String> getCategories() {
    final categories = hadithBox.values
        .map((hadith) => hadith['category'] as String)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }
}
