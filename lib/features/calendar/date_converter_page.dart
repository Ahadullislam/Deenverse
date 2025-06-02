import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class DateConverterPage extends StatefulWidget {
  const DateConverterPage({super.key});

  @override
  State<DateConverterPage> createState() => _DateConverterPageState();
}

class _DateConverterPageState extends State<DateConverterPage> {
  DateTime _selectedDate = DateTime.now();
  late HijriCalendar _hijriDate;
  final TextEditingController _hijriYearController = TextEditingController();
  final TextEditingController _hijriMonthController = TextEditingController();
  final TextEditingController _hijriDayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateDates();
  }

  void _updateDates() {
    _hijriDate = HijriCalendar.fromDate(_selectedDate);
    _hijriYearController.text = _hijriDate.hYear.toString();
    _hijriMonthController.text = _hijriDate.hMonth.toString();
    _hijriDayController.text = _hijriDate.hDay.toString();
  }

  void _convertFromHijri() {
    try {
      final year = int.parse(_hijriYearController.text);
      final month = int.parse(_hijriMonthController.text);
      final day = int.parse(_hijriDayController.text);

      if (year < 1 || month < 1 || month > 12 || day < 1 || day > 30) {
        throw Exception('Invalid date');
      }

      final hijri = HijriCalendar()
        ..hYear = year
        ..hMonth = month
        ..hDay = day;
      setState(() {
        _selectedDate = hijri.hijriToGregorian(year, month, day);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অবৈধ তারিখ। দয়া করে সঠিক তারিখ লিখুন।'),
          backgroundColor: Color(0xFF185A9D),
        ),
      );
    }
  }

  void _convertFromGregorian() {
    setState(() {
      _updateDates();
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
                            'তারিখ রূপান্তর',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF185A9D),
                              fontFamily: 'NotoSansBengali',
                            ),
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
                      // Hijri to Gregorian
                      _buildHijriToGregorianSection(),
                      const SizedBox(height: 24),
                      // Gregorian to Hijri
                      _buildGregorianToHijriSection(),
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

  Widget _buildHijriToGregorianSection() {
    return Container(
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
            'হিজরি থেকে ইংরেজি',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF185A9D),
              fontFamily: 'NotoSansBengali',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hijriYearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'বছর',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _hijriMonthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'মাস',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _hijriDayController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'দিন',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _convertFromHijri,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF185A9D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'রূপান্তর করুন',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'NotoSansBengali',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGregorianToHijriSection() {
    return Container(
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
            'ইংরেজি থেকে হিজরি',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF185A9D),
              fontFamily: 'NotoSansBengali',
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                  _convertFromGregorian();
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('d MMMM yyyy', 'bn_BD').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF185A9D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_hijriDate.hDay} ${_hijriDate.getLongMonthName()} ${_hijriDate.hYear} হিজরি',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF185A9D),
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_hijriDate.getLongMonthName()} মাসের ${_hijriDate.hDay} তারিখ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hijriYearController.dispose();
    _hijriMonthController.dispose();
    _hijriDayController.dispose();
    super.dispose();
  }
}
