import 'package:hive/hive.dart';
import 'package:print_ticket/models/customer.dart';
import 'package:print_ticket/models/fishingrod.dart';

class FishingrodRepository {
  static final FishingrodRepository _instance =
      FishingrodRepository._internal();

  late Box box;
  factory FishingrodRepository() => _instance;
  FishingrodRepository._internal();

  var dbName = "fishingrods";

  getBox() async {
    box = await Hive.openBox<FishingRod>(dbName);
    return box;
  }

  Box add(FishingRod data) {
    box.add(data);
    return box;
  }

  Box update(FishingRod data) {
    data.save();
    return box;
  }

  gets() {
    return box.values.toList();
  }

  delete(FishingRod value) {
    value.delete();
  }
}
