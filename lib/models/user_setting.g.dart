// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingAdapter extends TypeAdapter<UserSetting> {
  @override
  final int typeId = 0;

  @override
  UserSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSetting(
      startDate: fields[0] as DateTime,
      cigPrice: fields[1] as double,
      alcPrice: fields[2] as double,
      cigCurrency: fields[3] as String,
      alcCurrency: fields[4] as String,
      alcDay: fields[5] as int,
      cigDay: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserSetting obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.cigPrice)
      ..writeByte(2)
      ..write(obj.alcPrice)
      ..writeByte(3)
      ..write(obj.cigCurrency)
      ..writeByte(4)
      ..write(obj.alcCurrency)
      ..writeByte(5)
      ..write(obj.alcDay)
      ..writeByte(6)
      ..write(obj.cigDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
