import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hijri/hijri_calendar.dart'; // Fixed import for hijri
import '../salah/salah_guide_page.dart';
import '../hadith/hadith_page.dart';
import '../quran/quran_page.dart';
import '../calendar/calendar_page.dart';
import '../books/books_page.dart';
import '../dua/dua_page.dart';
import '../salah/salah_page.dart';
import '../faith_knowledge/faith_knowledge_page.dart';
import '../tafsir/tafsir_page.dart';
import '../fasting/fasting_page.dart';
import '../zakat/zakat_page.dart';
import '../hajj_umrah/hajj_umrah_page.dart';
import '../marriage/marriage_page.dart';
import '../kaffara/kaffara_page.dart';
import '../articles/articles_page.dart';

class ModernDashboardPage extends StatelessWidget {
  const ModernDashboardPage({super.key});

  String _getHijriDateTime() {
    final now = DateTime.now();
    try {
      final hijri = HijriCalendar.fromDate(now);
      final hijriDate = '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} হিজরি';
      final time = DateFormat.Hm('bn').format(now);
      return '$hijriDate\n$time';
    } catch (e) {
      final date = DateFormat.yMMMMd('bn').format(now);
      final time = DateFormat.Hm('bn').format(now);
      return '$date\n$time';
    }
  }

  // Only show completed features first, then placeholders
  static final List<_DashboardItem> _items = [
    // 🕌 Top Priority Features (Daily & Core Religious Duties)
    _DashboardItem(Icons.access_time, 'আজানের সময়',
        SalahPage()), // Azan Time (Prayer Times)
    _DashboardItem(Icons.mosque, 'নামাজ শিক্ষা', SalahGuidePage()),
    _DashboardItem(Icons.menu_book, 'কুরআন', QuranPage()),
    _DashboardItem(Icons.menu_book_rounded, 'দোআ', DuaPage()),
    // 📘 Second Priority (Knowledge & Belief Strengthening)
    _DashboardItem(Icons.menu_book, 'হাদিস', HadithPage()),
    _DashboardItem(
        Icons.lightbulb_outline, 'ঈমানী জ্ঞানচর্চা', FaithKnowledgePage()),
    _DashboardItem(Icons.menu_book_outlined, 'তাফসীর', TafsirPage()),
    // 📖 Third Priority (Occasional Acts & Pillars of Islam)
    _DashboardItem(Icons.nightlight_round, 'রোযা', FastingPage()),
    _DashboardItem(Icons.volunteer_activism, 'যাকাত', ZakatPage()),
    _DashboardItem(Icons.hail, 'হজ ও উমরা', HajjUmrahPage()),
    _DashboardItem(Icons.people, 'বিবাহ', MarriagePage()),
    _DashboardItem(Icons.assignment_turned_in, 'কাফফারা', KaffaraPage()),
    // 📚 Fourth Priority (Learning & Development)
    _DashboardItem(Icons.library_books, 'কিতাব', BooksPage()),
    _DashboardItem(Icons.edit_note, 'প্রবন্ধ', ArticlesPage()),
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

  static const List<Map<String, dynamic>> _features = [
    {
      'name': 'কুরআন',
      'name_en': 'Quran',
      'icon': Icons.menu_book_rounded,
      'route': '/quran',
      'color': Color(0xFF185A9D),
    },
    {
      'name': 'হাদিস',
      'name_en': 'Hadith',
      'icon': Icons.format_quote_rounded,
      'route': '/hadith',
      'color': Color(0xFF2E7D32),
    },
    {
      'name': 'দোয়া',
      'name_en': 'Dua',
      'icon': Icons.favorite_rounded,
      'route': '/dua',
      'color': Color(0xFFC62828),
    },
    {
      'name': 'তাফসীর',
      'name_en': 'Tafsir',
      'icon': Icons.auto_stories_rounded,
      'route': '/tafsir',
      'color': Color(0xFF1565C0),
    },
    {
      'name': 'নামাজের সময়',
      'name_en': 'Prayer Times',
      'icon': Icons.access_time_rounded,
      'route': '/prayer-times',
      'color': Color(0xFF00897B),
    },
    {
      'name': 'ইসলামি ক্যালেন্ডার',
      'name_en': 'Islamic Calendar',
      'icon': Icons.calendar_month_rounded,
      'route': '/islamic-calendar',
      'color': Color(0xFF7B1FA2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('bn');
    final dateText = _getHijriDateTime();
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 3;
              double aspectRatio = 0.95;
              return Column(
                children: [
                  // Modern Date Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF185A9D).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF185A9D).withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.9),
                                  blurRadius: 8,
                                  offset: const Offset(-2, -2),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Icon shadow
                                Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.black.withOpacity(0.1),
                                    size: 24,
                                  ),
                                ),
                                // Main icon
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: const Color(0xFF185A9D),
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              dateText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF185A9D),
                                fontFamily: 'NotoSansBengali',
                                letterSpacing: 0.5,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Grid Section
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          try {
                            return _AnimatedDashboardItem(item: item);
                          } catch (e) {
                            print('Error building dashboard item: ${item.label} - $e');
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(item.icon, size: 32, color: Colors.grey[600]),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.label,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
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
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _rotationAnim = Tween<double>(begin: 0, end: 0.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        if (widget.item.page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.item.page!),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
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
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleAnim.value * 0.1),
            child: Transform.rotate(
              angle: _rotationAnim.value,
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(context).primaryColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.9),
                            blurRadius: 8,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Icon glow
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Icon shadow
                          Positioned(
                            right: 1,
                            bottom: 1,
                            child: Icon(
                              widget.item.icon,
                              size: 28,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          // Main icon
                          Icon(
                            widget.item.icon,
                            size: 28,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.item.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSansBengali',
                        color: Color(0xFF185A9D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
