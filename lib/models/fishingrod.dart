import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'fishingrod.g.dart';

@HiveType(typeId: 1)
class FishingRod extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  double? price;

  FishingRod({this.id, this.name, this.price});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price};
}
