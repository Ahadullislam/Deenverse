import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';

class SalahService {
  Future<PrayerTimes?> getPrayerTimes() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationParameters(
        method: "MuslimWorldLeague",
        fajrAngle: 18.0,
        ishaAngle: 17.0,
      );
      final now = DateTime.now();
      return PrayerTimes(
        coordinates: coordinates,
        date: now,
        calculationParameters: params,
      );
    } catch (e) {
      return null;
    }
  }
}
