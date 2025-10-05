// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingHistoryAdapter extends TypeAdapter<UserSettingHistory> {
  @override
  final int typeId = 1;

  @override
  UserSettingHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettingHistory(
      startDate: fields[0] as DateTime,
      cigPrice: fields[2] as double,
      alcPrice: fields[3] as double,
      cigCurrency: fields[4] as String,
      alcCurrency: fields[5] as String,
      cigDay: fields[6] as int,
      alcDay: fields[7] as int,
      endDate: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingHistory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.endDate)
      ..writeByte(2)
      ..write(obj.cigPrice)
      ..writeByte(3)
      ..write(obj.alcPrice)
      ..writeByte(4)
      ..write(obj.cigCurrency)
      ..writeByte(5)
      ..write(obj.alcCurrency)
      ..writeByte(6)
      ..write(obj.cigDay)
      ..writeByte(7)
      ..write(obj.alcDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
