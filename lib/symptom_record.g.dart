// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SymptomRecordAdapter extends TypeAdapter<SymptomRecord> {
  @override
  final int typeId = 0;

  @override
  SymptomRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SymptomRecord(
      symptom: fields[0] as String,
      date: fields[1] as DateTime,
      severity: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SymptomRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.symptom)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.severity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymptomRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}