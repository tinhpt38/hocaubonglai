// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fishingrod.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FishingRodAdapter extends TypeAdapter<FishingRod> {
  @override
  final int typeId = 1;

  @override
  FishingRod read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FishingRod(
      id: fields[0] as String?,
      name: fields[1] as String?,
      price: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, FishingRod obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FishingRodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
