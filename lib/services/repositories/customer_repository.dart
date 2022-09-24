import 'package:hive/hive.dart';
import 'package:print_ticket/models/customer.dart';

class CustomerRepository {
  static final CustomerRepository _instance = CustomerRepository._internal();

  late Box box;
  factory CustomerRepository() => _instance;
  CustomerRepository._internal();

  var dbName = "customers";

  getBox() async {
    box = await Hive.openBox<Customer>(dbName);
    return box;
  }

  Box add(Customer data) {
    box.add(data);
    return box;
  }

  Box update(Customer data) {
    data.save();
    return box;
  }

  gets() {
    return box.values.toList();
  }

  delete(Customer value) {
    value.delete();
  }
}
