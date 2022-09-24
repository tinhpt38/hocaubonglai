// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketAdapter extends TypeAdapter<Ticket> {
  @override
  final int typeId = 2;

  @override
  Ticket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ticket(
      id: fields[0] as String?,
      date: fields[1] as DateTime?,
      timeIn: fields[2] as DateTime?,
      timeOut: fields[3] as DateTime?,
      seats: fields[4] as String?,
      fishingrod: fields[5] as FishingRod?,
      fishingrodQuantity: fields[6] as int?,
      price: fields[8] as double?,
      customer: fields[9] as Customer?,
    )..fishingrodType = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, Ticket obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.timeIn)
      ..writeByte(3)
      ..write(obj.timeOut)
      ..writeByte(4)
      ..write(obj.seats)
      ..writeByte(5)
      ..write(obj.fishingrod)
      ..writeByte(6)
      ..write(obj.fishingrodQuantity)
      ..writeByte(7)
      ..write(obj.fishingrodType)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.customer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
