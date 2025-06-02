import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:deenverse/core/theme/app_theme.dart';
import 'package:adhan/adhan.dart';
import 'package:deenverse/features/calendar/prayer_time_service.dart';
import 'package:deenverse/features/calendar/date_converter_page.dart';
import 'dart:async';

class IslamicCalendarPage extends StatefulWidget {
  const IslamicCalendarPage({super.key});

  @override
  State<IslamicCalendarPage> createState() => _IslamicCalendarPageState();
}

class _IslamicCalendarPageState extends State<IslamicCalendarPage> {
  late HijriCalendar _hijriDate;
  late DateTime _gregorianDate;
  PrayerTimes? _prayerTimes;
  bool _isLoadingPrayerTimes = true;
  Timer? _prayerTimeTimer;
  final List<Map<String, dynamic>> _importantDates = [
    {
      'name': 'মহররম',
      'date': '১ মহররম',
      'description': 'ইসলামি নববর্ষ',
      'isHoliday': true,
    },
    {
      'name': 'আশুরা',
      'date': '১০ মহররম',
      'description': 'মহররমের ১০ তারিখ',
      'isHoliday': true,
    },
    {
      'name': 'রবিউল আউয়াল',
      'date': '১২ রবিউল আউয়াল',
      'description': 'ঈদে মিলাদুন্নবী',
      'isHoliday': true,
    },
    {
      'name': 'রজব',
      'date': '২৭ রজব',
      'description': 'শবে মেরাজ',
      'isHoliday': true,
    },
    {
      'name': 'শাবান',
      'date': '১৫ শাবান',
      'description': 'শবে বরাত',
      'isHoliday': true,
    },
    {
      'name': 'রমজান',
      'date': '১ রমজান',
      'description': 'রমজান মাসের শুরু',
      'isHoliday': true,
    },
    {
      'name': 'লাইলাতুল কদর',
      'date': '২৭ রমজান',
      'description': 'শবে কদর',
      'isHoliday': true,
    },
    {
      'name': 'ঈদুল ফিতর',
      'date': '১ শাওয়াল',
      'description': 'রমজানের পরের ঈদ',
      'isHoliday': true,
    },
    {
      'name': 'ঈদুল আযহা',
      'date': '১০ জিলহজ',
      'description': 'কুরবানির ঈদ',
      'isHoliday': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateDates();
    _loadPrayerTimes();
    _startPrayerTimeTimer();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final prayerTimes = await PrayerTimeService.getPrayerTimes();
      setState(() {
        _prayerTimes = prayerTimes;
        _isLoadingPrayerTimes = false;
      });
    } catch (e) {
      setState(() => _isLoadingPrayerTimes = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('নামাজের সময় লোড করতে সমস্যা হয়েছে'),
            backgroundColor: Color(0xFF185A9D),
          ),
        );
      }
    }
  }

  void _startPrayerTimeTimer() {
    _prayerTimeTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _loadPrayerTimes();
    });
  }

  @override
  void dispose() {
    _prayerTimeTimer?.cancel();
    super.dispose();
  }

  void _updateDates() {
    _hijriDate = HijriCalendar.now();
    _gregorianDate = DateTime.now();
  }

  void _navigateMonth(int months) {
    setState(() {
      int newMonth = _hijriDate.hMonth + months;
      int newYear = _hijriDate.hYear;

      if (newMonth > 12) {
        newMonth = 1;
        newYear++;
      } else if (newMonth < 1) {
        newMonth = 12;
        newYear--;
      }

      _hijriDate = HijriCalendar()
        ..hYear = newYear
        ..hMonth = newMonth
        ..hDay = _hijriDate.hDay;
      _gregorianDate = HijriCalendar().hijriToGregorian(
          _hijriDate.hYear, _hijriDate.hMonth, _hijriDate.hDay);
    });
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => Navigator.pop(context),
                            color: const Color(0xFF185A9D),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ইসলামি ক্যালেন্ডার',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF185A9D),
                              fontFamily: 'NotoSansBengali',
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.calendar_month_rounded),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DateConverterPage(),
                                ),
                              );
                            },
                            color: const Color(0xFF185A9D),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Current Date Card
                      _buildCurrentDateCard(),
                      const SizedBox(height: 24),
                      // Calendar Navigation
                      _buildCalendarNavigation(),
                      const SizedBox(height: 24),
                      // Important Dates
                      _buildImportantDatesSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentDateCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF185A9D),
                const Color(0xFF185A9D).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF185A9D).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                _hijriDate.getLongMonthName(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'NotoSansBengali',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_hijriDate.hYear} হিজরি',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'NotoSansBengali',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('EEEE, d MMMM yyyy', 'bn_BD')
                      .format(_gregorianDate),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Prayer Times Card
        if (_isLoadingPrayerTimes)
          const Center(child: CircularProgressIndicator())
        else if (_prayerTimes != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'আজকের নামাজের সময়',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF185A9D),
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                const SizedBox(height: 16),
                _buildPrayerTimeRow('ফজর', _prayerTimes!.fajr),
                _buildPrayerTimeRow('সূর্যোদয়', _prayerTimes!.sunrise),
                _buildPrayerTimeRow('যোহর', _prayerTimes!.dhuhr),
                _buildPrayerTimeRow('আসর', _prayerTimes!.asr),
                _buildPrayerTimeRow('মাগরিব', _prayerTimes!.maghrib),
                _buildPrayerTimeRow('এশা', _prayerTimes!.isha),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPrayerTimeRow(String name, DateTime time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
              fontFamily: 'NotoSansBengali',
            ),
          ),
          Text(
            DateFormat('hh:mm a', 'bn_BD').format(time),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF185A9D),
              fontFamily: 'NotoSansBengali',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => _navigateMonth(-1),
                color: const Color(0xFF185A9D),
              ),
              Text(
                '${_hijriDate.getLongMonthName()} ${_hijriDate.hYear}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF185A9D),
                  fontFamily: 'NotoSansBengali',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () => _navigateMonth(1),
                color: const Color(0xFF185A9D),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 35,
            itemBuilder: (context, index) {
              final day = index + 1;
              final isCurrentDay = day == _hijriDate.hDay;
              return Container(
                decoration: BoxDecoration(
                  color: isCurrentDay
                      ? const Color(0xFF185A9D).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCurrentDay
                        ? const Color(0xFF185A9D)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: isCurrentDay
                          ? const Color(0xFF185A9D)
                          : const Color(0xFF333333),
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImportantDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'গুরুত্বপূর্ণ তারিখসমূহ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF185A9D),
            fontFamily: 'NotoSansBengali',
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _importantDates.length,
          itemBuilder: (context, index) {
            final date = _importantDates[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF185A9D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    date['date'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF185A9D),
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                ),
                title: Text(
                  date['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                subtitle: Text(
                  date['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                trailing: date['isHoliday']
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ছুটির দিন',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontFamily: 'NotoSansBengali',
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
