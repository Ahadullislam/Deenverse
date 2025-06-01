import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/hadith/hadith_repository.dart';
import 'features/quran/quran_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/core/modern_dashboard_page.dart';
import 'features/dua/dua_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Flutter binding initialized');
  await Hive.initFlutter();
  print('Hive initialized');

  // Initialize repositories
  await HadithRepository.init();
  print('HadithRepository initialized');
  await QuranRepository.init();
  print('QuranRepository initialized');
  await DuaNotificationService.init();
  print('DuaNotificationService initialized');

  runApp(const MyApp());
  print('runApp called');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeenVerse',
      theme: appTheme,
      darkTheme: darkAppTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const ModernDashboardPage(), // Use the new dashboard
    );
  }
}
