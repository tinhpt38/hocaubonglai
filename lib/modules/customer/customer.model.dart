import 'package:flutter/material.dart';

import 'package:print_ticket/models/customers.dart';

import '../../services/repositories/customer_repository.dart';

class CustomerModel extends ChangeNotifier {
  final CustomerRepository customerRepo = CustomerRepository();

  List<Customers> _retrievedCustomersList = [];
  List<Customers> get retrievedCustomersList => _retrievedCustomersList;

  Future<List<Customers>>? _customersList;
  Future<List<Customers>>? get customersList => _customersList;

  final TextEditingController _fullNameController = TextEditingController();
  get fullNameController => _fullNameController;

  final TextEditingController _phoneController = TextEditingController();
  get phoneController => _phoneController;

  getCustomer() async {
    _retrievedCustomersList = await customerRepo.retrieveCustomers();
    _customersList = customerRepo.retrieveCustomers();
    notifyListeners();
  }

  deleteCustomers(String customerID) async {
    await customerRepo.customers.doc(customerID).delete();
    getCustomer();
    notifyListeners();
  }

  createCustomer() async {
    await customerRepo.customers.add(
        ({'fullname': fullNameController.text, 'phone': phoneController.text}));
    getCustomer();
    notifyListeners();
  }

  clearController() {
    _fullNameController.clear();
    _phoneController.clear();
  }
}
