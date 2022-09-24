import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:print_ticket/services/repositories/customer_repository.dart';

import '../../models/customer.dart';
import '../../models/ticket.dart';
import '../../services/repositories/ticket_repository.dart';

class CustomerModel extends ChangeNotifier {
  final CustomerRepository _cusRepository = CustomerRepository();

  List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  String get getCurrentDate {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  getCustomerBox() async {
    setIsLoading(true);
    await _cusRepository.getBox();
    _customers = _cusRepository.gets();
   _customers =  _customers.reversed.toList();
   setIsLoading(false);
    notifyListeners();
  }

  deleteCustomer(Ticket ticket) async{
    setIsLoading(true);
    _customers.remove(ticket);
    ticket.delete();
    await getCustomerBox();
    notifyListeners();
  }
}
