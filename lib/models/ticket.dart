import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:print_ticket/models/customer.dart';

import 'fishingrod.dart';

part 'ticket.g.dart';

@HiveType(typeId: 2)
class Ticket extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  DateTime? date;
  @HiveField(2)
  DateTime? timeIn;
  @HiveField(3)
  DateTime? timeOut;
  @HiveField(4)
  String? seats;
  @HiveField(5)
  FishingRod? fishingrod;
  @HiveField(6)
  int? fishingrodQuantity;
  @HiveField(7)
  String? fishingrodType;
  @HiveField(8)
  double? price;
  @HiveField(9)
  Customer? customer;
  @HiveField(10)
  Ticket(
      {this.id,
      this.date,
      this.timeIn,
      this.timeOut,
      this.seats,
      this.fishingrod,
      this.fishingrodQuantity,
      this.price,
      this.customer});

  toJson() => {
        'id': id,
        'date': date.toString(),
        'timeOut': timeOut,
        'timeIn': timeIn,
        'fishingrodId': fishingrod?.toJson(),
        'fishingrodQuantity': fishingrodQuantity,
        'fishingrodType': fishingrodType,
        'price': price,
        'customer': customer?.toJson()
      };
}
