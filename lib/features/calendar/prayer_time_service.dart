import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimeService {
  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';
  static const String _calculationMethodKey = 'calculation_method';
  static const String _madhabKey = 'madhab';

  static Future<PrayerTimes> getPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude =
        prefs.getDouble(_latitudeKey) ?? 23.8103; // Default to Dhaka
    final longitude = prefs.getDouble(_longitudeKey) ?? 90.4125;
    final calculationMethod =
        prefs.getString(_calculationMethodKey) ?? 'karachi';
    final madhab = prefs.getString(_madhabKey) ?? 'hanafi';

    final coordinates = Coordinates(latitude, longitude);
    final params = _getCalculationParameters(calculationMethod);
    final dateTime = DateTime.now();
    final prayerTimes = PrayerTimes.today(coordinates, params);

    return prayerTimes;
  }

  static Future<void> updateLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestPermission = await Geolocator.requestPermission();
        if (requestPermission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_latitudeKey, position.latitude);
      await prefs.setDouble(_longitudeKey, position.longitude);
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  static Future<void> setCalculationMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calculationMethodKey, method);
  }

  static Future<void> setMadhab(String madhab) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_madhabKey, madhab);
  }

  static CalculationParameters _getCalculationParameters(String method) {
    switch (method) {
      case 'karachi':
        return CalculationMethod.karachi.getParameters();
      case 'egyptian':
        return CalculationMethod.egyptian.getParameters();
      case 'muslim_world_league':
        return CalculationMethod.muslim_world_league.getParameters();
      case 'north_america':
        return CalculationMethod.north_america.getParameters();
      case 'dubai':
        return CalculationMethod.dubai.getParameters();
      case 'qatar':
        return CalculationMethod.qatar.getParameters();
      case 'kuwait':
        return CalculationMethod.kuwait.getParameters();
      case 'singapore':
        return CalculationMethod.singapore.getParameters();
      case 'turkey':
        return CalculationMethod.turkey.getParameters();
      default:
        return CalculationMethod.karachi.getParameters();
    }
  }

  static String getNextPrayer(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    if (now.isBefore(prayerTimes.fajr)) {
      return 'ফজর';
    } else if (now.isBefore(prayerTimes.sunrise)) {
      return 'সূর্যোদয়';
    } else if (now.isBefore(prayerTimes.dhuhr)) {
      return 'যোহর';
    } else if (now.isBefore(prayerTimes.asr)) {
      return 'আসর';
    } else if (now.isBefore(prayerTimes.maghrib)) {
      return 'মাগরিব';
    } else if (now.isBefore(prayerTimes.isha)) {
      return 'এশা';
    } else {
      return 'ফজর';
    }
  }

  static Future<Duration> getTimeUntilNextPrayer(
      PrayerTimes prayerTimes) async {
    final now = DateTime.now();
    if (now.isBefore(prayerTimes.fajr)) {
      return prayerTimes.fajr.difference(now);
    } else if (now.isBefore(prayerTimes.sunrise)) {
      return prayerTimes.sunrise.difference(now);
    } else if (now.isBefore(prayerTimes.dhuhr)) {
      return prayerTimes.dhuhr.difference(now);
    } else if (now.isBefore(prayerTimes.asr)) {
      return prayerTimes.asr.difference(now);
    } else if (now.isBefore(prayerTimes.maghrib)) {
      return prayerTimes.maghrib.difference(now);
    } else if (now.isBefore(prayerTimes.isha)) {
      return prayerTimes.isha.difference(now);
    } else {
      final prefs = await SharedPreferences.getInstance();
      final latitude = prefs.getDouble(_latitudeKey) ?? 23.8103;
      final longitude = prefs.getDouble(_longitudeKey) ?? 90.4125;
      final calculationMethod =
          prefs.getString(_calculationMethodKey) ?? 'karachi';
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final tomorrowDateComponents =
          DateComponents(tomorrow.year, tomorrow.month, tomorrow.day);
      final tomorrowPrayerTimes = PrayerTimes(
        Coordinates(latitude, longitude),
        tomorrowDateComponents,
        _getCalculationParameters(calculationMethod),
      );
      return tomorrowPrayerTimes.fajr.difference(now);
    }
  }
}
