class DuaModel {
  final String title;
  final String arabic;
  final String translation;
  final String transliteration;
  final String category;
  final String? audioAsset;

  DuaModel({
    required this.title,
    required this.arabic,
    required this.translation,
    required this.transliteration,
    required this.category,
    this.audioAsset,
  });
}

final List<DuaModel> duas = [
  DuaModel(
    title: 'Morning Dua',
    arabic: 'اللّهـمَّ أَنْتَ رَبِّـي لا إلهَ إلاّ أَنْتَ...',
    translation: 'O Allah, You are my Lord, there is no deity except You...',
    transliteration: 'Allahumma anta rabbi la ilaha illa anta...',
    category: 'Morning',
    audioAsset: null,
  ),
  DuaModel(
    title: 'Evening Dua',
    arabic: 'اللّهـمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ...',
    translation: 'O Allah, as I reach the evening, I call You to witness...',
    transliteration: 'Allahumma inni amsaytu ush-hiduka...',
    category: 'Evening',
    audioAsset: null,
  ),
  DuaModel(
    title: 'Before Eating',
    arabic: 'بِسْمِ اللهِ',
    translation: 'In the name of Allah.',
    transliteration: 'Bismillah.',
    category: 'Daily',
    audioAsset: null,
  ),
  DuaModel(
    title: 'After Eating',
    arabic: 'الْـحَمْـدُ للهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ...',
    translation:
        'All praise is for Allah who fed me this and provided it for me...',
    transliteration: 'Alhamdu lillahi allathee at’amani hatha wa razaqanihi...',
    category: 'Daily',
    audioAsset: 'audio/after_eating.mp3',
  ),
  DuaModel(
    title: 'Entering Home',
    arabic: 'بِسْمِ اللهِ وَلَجْنَا وَبِسْمِ اللهِ خَرَجْنَا...',
    translation:
        'In the name of Allah we enter and in the name of Allah we leave...',
    transliteration: 'Bismillahi walajna wa bismillahi kharajna...',
    category: 'Daily',
    audioAsset: null,
  ),
  DuaModel(
    title: 'Before Sleeping',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    translation: 'In Your name, O Allah, I die and I live.',
    transliteration: 'Bismika Allahumma amutu wa ahya.',
    category: 'Night',
    audioAsset: 'audio/before_sleeping.mp3',
  ),
  // Add more duas as needed
];
