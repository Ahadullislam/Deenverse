import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hijri/hijri_calendar.dart';
import '../salah/salah_guide_page.dart';
import '../hadith/hadith_page.dart';
import '../quran/quran_page.dart';
import '../calendar/calendar_page.dart';
import '../books/books_page.dart';

class ModernDashboardPage extends StatelessWidget {
  const ModernDashboardPage({super.key});

  String _getHijriDateTime() {
    final now = DateTime.now();
    final hijri = HijriCalendar.fromDate(now);
    final hijriDate =
        '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} হিজরি';
    final time = DateFormat.Hm('bn').format(now);
    return '$hijriDate, $time';
  }

  // Only show completed features first, then placeholders
  static final List<_DashboardItem> _items = [
    // 🕌 Top Priority Features (Daily & Core Religious Duties)
    _DashboardItem(Icons.access_time, 'আজানের সময়'), // Azan Time (Prayer Times)
    _DashboardItem(Icons.mosque, 'নামাজ শিক্ষা', SalahGuidePage()),
    _DashboardItem(Icons.menu_book, 'কুরআন', QuranPage()),
    _DashboardItem(
        Icons.menu_book_rounded, 'দোআ', null), // DuaPage() if implemented
    // 📘 Second Priority (Knowledge & Belief Strengthening)
    _DashboardItem(Icons.menu_book, 'হাদিস', HadithPage()),
    _DashboardItem(Icons.lightbulb_outline, 'ঈমানী জ্ঞানচর্চা'),
    _DashboardItem(Icons.menu_book_outlined, 'তাফসীর'),
    // 📖 Third Priority (Occasional Acts & Pillars of Islam)
    _DashboardItem(Icons.nightlight_round, 'রোযা'),
    _DashboardItem(Icons.volunteer_activism, 'যাকাত'),
    _DashboardItem(Icons.hail, 'হজ ও উমরা'),
    _DashboardItem(Icons.people, 'বিবাহ'),
    _DashboardItem(Icons.assignment_turned_in, 'কাফফারা'),
    // 📚 Fourth Priority (Learning & Development)
    _DashboardItem(Icons.library_books, 'কিতাব', BooksPage()),
    _DashboardItem(Icons.edit_note, 'প্রবন্ধ'),
    _DashboardItem(Icons.comment, 'ব্যাখ্যা'),
    _DashboardItem(Icons.school, 'কুরআনের শিক্ষা'),
    _DashboardItem(Icons.language, 'আরবি'),
    // 🧭 Fifth Priority (Life, Names, Calendar)
    _DashboardItem(Icons.badge, 'ইসলামিক নাম'),
    _DashboardItem(Icons.event_available, 'গুরুত্বপূর্ণ দিন'),
    _DashboardItem(Icons.check_circle, 'মুসলমানের করণীয়'),
    // 🎙️ Sixth Priority (Media & Community)
    _DashboardItem(Icons.podcasts, 'মিডিয়া ফাইল'),
    _DashboardItem(Icons.event, 'মাহফিল মুক্তিযুদ্ধ'),
    // 🧩 Optional/Utility Features
    _DashboardItem(Icons.attach_money, 'দান'),
    _DashboardItem(Icons.calendar_month, 'ক্যালেন্ডার', CalendarPage()),
    _DashboardItem(Icons.topic, 'বিষয়'),
    _DashboardItem(Icons.grid_view, 'অন্যান্য'),
  ];

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('bn');
    final dateText = _getHijriDateTime();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB8F2E6),
              Color(0xFF46C6E8),
              Color(0xFF6D5FFD),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.85),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    dateText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF185A9D), // Deep blue for visibility
                      fontFamily: 'NotoSansBengali',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _AnimatedDashboardItem(item: item);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardItem {
  final IconData icon;
  final String label;
  final Widget? page;
  const _DashboardItem(this.icon, this.label, [this.page]);
}

class _AnimatedDashboardItem extends StatefulWidget {
  final _DashboardItem item;
  const _AnimatedDashboardItem({required this.item});

  @override
  State<_AnimatedDashboardItem> createState() => _AnimatedDashboardItemState();
}

class _AnimatedDashboardItemState extends State<_AnimatedDashboardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.item.page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => widget.item.page!),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Coming Soon'),
          content: Text('The feature "${widget.item.label}" is coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white
                .withOpacity(0.7), // Lighter background for icon visibility
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.item.icon, size: 32, color: const Color(0xFF185A9D)),
              const SizedBox(height: 10),
              Text(
                widget.item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF185A9D),
                  fontFamily: 'NotoSansBengali',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
