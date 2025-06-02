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
    title: 'সকালের দোআ (Morning Dua)',
    arabic: 'اللّهُـمَّ أَنْتَ رَبِّـي لا إلهَ إلاّ أَنْتَ...',
    translation: 'হে আল্লাহ! আপনি আমার রব, আপনি ছাড়া কোনো উপাস্য নেই...',
    transliteration: 'Allahumma anta rabbi la ilaha illa anta...',
    category: 'সকাল',
    audioAsset: null,
  ),
  DuaModel(
    title: 'বিকালের দোআ (Evening Dua)',
    arabic: 'اللّهُـمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ...',
    translation: 'হে আল্লাহ! আমি সন্ধ্যায় পৌঁছেছি, আপনাকে সাক্ষী রাখছি...',
    transliteration: 'Allahumma inni amsaytu ush-hiduka...',
    category: 'বিকাল',
    audioAsset: null,
  ),
  DuaModel(
    title: 'খাবার আগে (Before Eating)',
    arabic: 'بِسْمِ اللَّهِ',
    translation: 'আল্লাহর নামে শুরু করছি।',
    transliteration: 'Bismillah.',
    category: 'দৈনন্দিন',
    audioAsset: null,
  ),
  DuaModel(
    title: 'খাবার পরে (After Eating)',
    arabic: 'الْـحَمْـدُ لِلّٰهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ...',
    translation: 'সব প্রশংসা আল্লাহর, যিনি আমাকে এই খাবার দিয়েছেন...',
    transliteration: 'Alhamdu lillahi allathee at’amani hatha wa razaqanihi...',
    category: 'দৈনন্দিন',
    audioAsset: null,
  ),
  DuaModel(
    title: 'ঘুমানোর আগে (Before Sleeping)',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    translation: 'হে আল্লাহ! আপনার নামে আমি মরি ও বাঁচি।',
    transliteration: 'Bismika Allahumma amutu wa ahya.',
    category: 'রাত',
    audioAsset: null,
  ),
  // আরও দোআ যোগ করুন
];
