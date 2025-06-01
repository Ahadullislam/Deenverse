import 'package:hive/hive.dart';

class DuaFavoritesRepository {
  static const String boxName = 'dua_favorites';

  Future<Box<String>> _openBox() async {
    return await Hive.openBox<String>(boxName);
  }

  Future<List<String>> getFavorites() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> addFavorite(String duaTitle) async {
    final box = await _openBox();
    if (!box.values.contains(duaTitle)) {
      await box.add(duaTitle);
    }
  }

  Future<void> removeFavorite(String duaTitle) async {
    final box = await _openBox();
    final key = box.keys.firstWhere(
      (k) => box.get(k) == duaTitle,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
    }
  }

  Future<bool> isFavorite(String duaTitle) async {
    final box = await _openBox();
    return box.values.contains(duaTitle);
  }
}
