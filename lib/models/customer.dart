import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'customer.g.dart';

@HiveType(typeId: 0)
class Customer extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? fullname;
  @HiveField(2)
  String? phone;

  Customer({this.id, this.phone, this.fullname});

  Map<String, dynamic> toJson() =>
      {'id': id, 'phone': phone, 'fullname': fullname};
}
