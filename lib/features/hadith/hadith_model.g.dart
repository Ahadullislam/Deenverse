// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HadithModelAdapter extends TypeAdapter<HadithModel> {
  @override
  final int typeId = 0;

  @override
  HadithModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HadithModel(
      topic: fields[0] as String,
      text: fields[1] as String,
      lastShown: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HadithModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.topic)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.lastShown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HadithModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
