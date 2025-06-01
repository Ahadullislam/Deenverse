# Deenverse

A modern, beautiful, and fully functional Flutter app for Islamic purposes with offline support and a spiritual, minimalist design.

## Features (Prioritized)

### 🕌 Top Priority Features (Daily & Core Religious Duties)
- **আজানের সময় (Azan Time)**: Accurate prayer times by location, Azan audio alerts, Qibla direction, Hijri date, custom reminders.
- **নামাজ শিক্ষা (Salah Guide)**: Step-by-step prayer guide, Fard/Sunnah/Nafl, mistakes to avoid, child-friendly version.
- **কুরআন (Quran)**: Arabic text, audio recitation, Bangla/English translation, tafsir, bookmarks, daily verse.
- **দোআ (Dua)**: Categorized duas (daily, food, travel, etc.), Arabic + Bangla + transliteration + audio, search, favorites.

### 📘 Second Priority (Knowledge & Belief Strengthening)
- **হাদিস (Hadith)**: Authentic books, search by topic, daily hadith, Bangla translation, chain info.
- **ঈমানী জ্ঞানচর্চা (Faith Knowledge)**: Articles, audio-visual content, learning tracks, Q&A.
- **তাফসীর (Tafsir)**: Tafsir Ibn Kathir/Jalalayn, word-by-word, context, linked with Quran.

### 📖 Third Priority (Occasional Acts & Pillars of Islam)
- **রোযা (Fasting)**: Rules, suhoor/iftar timing, missed fast tracking, reminders.
- **যাকাত (Zakat)**: Calculator, nisab info, guide by wealth type, reminders.
- **হজ ও উমরা (Hajj & Umrah)**: Step-by-step, checklist, duas, sacred places map.
- **বিবাহ (Marriage)**: Nikah process, counseling, dowry/mahr, responsibilities.
- **কাফফারা (Compensations)**: Penalty guides, how to fulfill, Zakat-ul-Fitr info.

### 📚 Fourth Priority (Learning & Development)
- **কিতাব (Books)**: Library of Islamic books (Bangla/Arabic), offline, categorized, ratings.
- **প্রবন্ধ (Articles)**: Essays, contemporary issues, scholar insights, comments.
- **ব্যাখ্যা (Explanation)**: Commentary on Quran/Hadith, doubts, visual explainers.
- **কুরআনের শিক্ষা (Quranic Lessons)**: Key teachings, real-life application, themes.
- **আরবি (Arabic)**: Learning, grammar, Quranic roots, flashcards/quizzes.

### 🧭 Fifth Priority (Life, Names, Calendar)
- **ইসলামিক নাম (Islamic Names)**: Baby names, meanings, Quranic reference, search.
- **গুরুত্বপূর্ণ দিন (Important Days)**: Islamic calendar, fasting reminders, Eid/Hijri dates.
- **মুসলমানের করণীয় (To-Do as a Muslim)**: Daily checklist, charity tracker, Sunnah acts.

### 🎙️ Sixth Priority (Media & Community)
- **মিডিয়া ফাইল (Media Files)**: Lectures, podcasts, video series, offline, categorized.
- **মাহফিল মুক্তিযুদ্ধ (Islamic Events / Freedom War)**: Programs, lectures, Bangladesh history.

### 🧩 Optional/Utility Features
- **দান (Donation)**: Local charity links, Zakat causes, donation tracker.
- **ক্যালেন্ডার (Calendar)**: Hijri sync, prayer times, important days.
- **বিষয় (Topic-based View)**: Tag-based navigation (Prayer, Marriage, etc.).
- **অন্যান্য (Others)**: App settings, about, feedback/support.

## Modern UI/UX
- Spiritual, minimalist design with a beautiful Islamic theme.
- Modular navigation via dashboard grid.

## Offline Support
- Uses Hive for offline storage of Hadith, Dua favorites, and more.
- SQLite planned for future features.

## Project Structure
- `lib/core/theme/` – App theme and styles
- `lib/features/` – Modular feature folders (salah, hadith, quran, dua, calendar, books, focus_mode, etc.)
- `local_plugins/` – Local plugin overrides (e.g., flutter_qiblah)

## Getting Started

1. **Clone the repository**
2. **Install dependencies**
   ```
   flutter pub get
   ```
3. **Run the app**
   ```
   flutter run
   ```
4. **Build for release**
   ```
   flutter build apk
   ```

### Android Build Notes
- JVM target is set to 17 for all modules and plugins (see `android/build.gradle`).
- If you encounter JVM target mismatch errors, ensure all plugins and subprojects use `jvmTarget = "17"`.

## Dependencies
- adhan_dart, geolocator, intl, flutter_qiblah (local override), hijri, permission_handler, hive, hive_flutter, path_provider, audioplayers, etc.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)

---
*This app is built for the benefit of the Ummah. May Allah accept and reward all contributors.*
