import 'package:hive/hive.dart';

class HiveDatabase {
  static final HiveDatabase _instance = HiveDatabase._internal();

  factory HiveDatabase() => _instance;
  HiveDatabase._internal();

  var dbName = "print_ticket";

  getBox() async {
    var box = await Hive.openBox(dbName);
    return box;
  }
}
