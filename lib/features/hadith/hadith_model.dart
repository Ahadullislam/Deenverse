import 'package:hive/hive.dart';

part 'hadith_model.g.dart';

@HiveType(typeId: 0)
class HadithModel extends HiveObject {
  @HiveField(0)
  String topic;
  @HiveField(1)
  String text;
  @HiveField(2)
  DateTime? lastShown;

  HadithModel({required this.topic, required this.text, this.lastShown});
}
