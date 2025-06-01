import 'package:flutter/material.dart';
import 'salah_service.dart';
import 'qibla_widget.dart';
import 'hijri_date_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class SalahPage extends StatefulWidget {
  const SalahPage({super.key});

  @override
  State<SalahPage> createState() => _SalahPageState();
}

class _SalahPageState extends State<SalahPage>
    with SingleTickerProviderStateMixin {
  String? fajr;
  String? dhuhr;
  String? asr;
  String? maghrib;
  String? isha;
  bool loading = true;
  String? errorMessage;
  String? nextSalahName;
  Duration? nextSalahDuration;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool azanAlertEnabled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final status = await Permission.location.request();
      if (!status.isGranted) {
        setState(() {
          loading = false;
          errorMessage =
              'Location permission is required for accurate prayer times.';
        });
        return;
      }

      final service = SalahService();
      final times = await service.getPrayerTimes();

      if (times != null) {
        final now = DateTime.now();
        final prayerTimes = [
          {'name': 'Fajr', 'time': times.fajr, 'icon': Icons.nightlight_round},
          {'name': 'Dhuhr', 'time': times.dhuhr, 'icon': Icons.wb_sunny},
          {'name': 'Asr', 'time': times.asr, 'icon': Icons.wb_sunny_outlined},
          {'name': 'Maghrib', 'time': times.maghrib, 'icon': Icons.nightlight},
          {'name': 'Isha', 'time': times.isha, 'icon': Icons.nightlight_round},
        ];

        DateTime? next;
        String? nextName;

        for (final p in prayerTimes) {
          if ((p['time'] as DateTime).isAfter(now)) {
            next = p['time'] as DateTime;
            nextName = p['name'] as String;
            break;
          }
        }

        setState(() {
          fajr = DateFormat.jm().format(times.fajr!);
          dhuhr = DateFormat.jm().format(times.dhuhr!);
          asr = DateFormat.jm().format(times.asr!);
          maghrib = DateFormat.jm().format(times.maghrib!);
          isha = DateFormat.jm().format(times.isha!);
          nextSalahName = nextName;
          nextSalahDuration = next?.difference(now);
          loading = false;
        });
        _animationController.forward();
      } else {
        setState(() {
          loading = false;
          errorMessage =
              'Unable to fetch prayer times. Please check your location settings.';
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  void _toggleAzanAlert() {
    setState(() {
      azanAlertEnabled = !azanAlertEnabled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              azanAlertEnabled ? 'Azan alert enabled' : 'Azan alert disabled')),
    );
  }

  void _showReminderSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Reminder Settings'),
        content: const Text('Custom reminders coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('আজানের সময়'),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
                azanAlertEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: azanAlertEnabled ? Colors.red : primaryColor),
            tooltip: 'Toggle Azan Alert',
            onPressed: _toggleAzanAlert,
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            tooltip: 'Custom Reminders',
            onPressed: _showReminderSettings,
          ),
        ],
      ),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading prayer times...',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadPrayerTimes,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPrayerTimes,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Hijri date styled like dashboard
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 16),
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
                        child: const HijriDateWidget(),
                      ),
                      const SizedBox(height: 24),
                      if (nextSalahName != null && nextSalahDuration != null)
                        FadeTransition(
                          opacity: _animation,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.2),
                                  primaryColor.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Next Prayer',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  nextSalahName!,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDuration(nextSalahDuration!),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      _prayerTile('Fajr', fajr, Icons.nightlight_round),
                      _prayerTile('Dhuhr', dhuhr, Icons.wb_sunny),
                      _prayerTile('Asr', asr, Icons.wb_sunny_outlined),
                      _prayerTile('Maghrib', maghrib, Icons.nightlight),
                      _prayerTile('Isha', isha, Icons.nightlight_round),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.explore,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Qibla Direction',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const QiblaWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(d.inHours);
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$h:$m:$s remaining';
  }

  Widget _prayerTile(String name, String? time, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryColor),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: Text(
          time ?? '--:--',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
