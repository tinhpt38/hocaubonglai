import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:print_ticket/models/customer.dart';
import 'package:print_ticket/models/ticket.dart';
import 'package:print_ticket/modules/ticket/ticket.print.dart';
import 'package:print_ticket/services/repositories/customer_repository.dart';
import 'package:print_ticket/services/repositories/ticket_repository.dart';

import '../../models/fishingrod.dart';
import '../../services/repositories/fishingrod.repository.dart';

class TicketModel extends ChangeNotifier {
  final FishingrodRepository _fishingrodRepository = FishingrodRepository();
  final CustomerRepository _customerRepository = CustomerRepository();
  final TicketRepository _ticketRepository = TicketRepository();
  // final TextEditingController _timeInController = TextEditingController();
  // TextEditingController get timeInController => _timeInController;

  String _timeIn = '';
  String get timeIn => _timeIn;

  String _timeOut = '';
  String get timeOut => _timeOut;

  setTimeIn(DateTime value) {
    var format = DateFormat('HH:mm dd/MM/yyyy');
    _timeIn = format.format(value);
    setTimeOut();
    notifyListeners();
  }

  setTimeOut() {
    var inputFormat = DateFormat('HH:mm dd/MM/yyyy');
    var value = inputFormat.parse(_timeIn);
    int? liveStage = int.tryParse(_liveStageController.text);
    liveStage ??= 1;
    var ttimeout = value.add(Duration(hours: liveStage * 5));
    var format = DateFormat('HH:mm dd/MM/yyyy');
    _timeOut = format.format(ttimeout);
    notifyListeners();
  }

  final TextEditingController _liveStageController =
      TextEditingController(text: "1");
  TextEditingController get liveStageController => _liveStageController;

  final TextEditingController _seatsController = TextEditingController();
  TextEditingController get seatsController => _seatsController;

  final TextEditingController _phoneController = TextEditingController();
  TextEditingController get phoneController => _phoneController;

  final TextEditingController _fullNameController = TextEditingController();
  TextEditingController get fullNameController => _fullNameController;

  final TextEditingController _fishingroldQuantityController =
      TextEditingController(); //
  TextEditingController get fishingroldQuantityController =>
      _fishingroldQuantityController;

  List<FishingRod> _fishingrods = [];
  List<FishingRod> get fishingrods => _fishingrods;

  List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  FishingRod? _selectedFishingrod;
  FishingRod? get selectedFishingrod => _selectedFishingrod;

  int _liveStageConvert = 1;
  int get liveStageConvert => _liveStageConvert;

  setLiveStage(int value) {
    _liveStageConvert = value;
    notifyListeners();
  }

  double _total = 0;
  double get total => _total;

  getFishingrodsBox() async {
    await _fishingrodRepository.getBox();
    _fishingrods = _fishingrodRepository.gets();
    notifyListeners();
  }

  getCustomerBox() async {
    await _customerRepository.getBox();
    _customers = _customerRepository.gets();
    notifyListeners();
  }

  getTicketBox() async {
    await _ticketRepository.getBox();
    _tickets = _ticketRepository.gets();
    notifyListeners();
  }

  onChangeFhisingrod(FishingRod? value) {
    _selectedFishingrod = value;
    getPrice();
    notifyListeners();
  }

  getPrice() {
    var quantity = double.tryParse(_fishingroldQuantityController.text);
    var price = _selectedFishingrod?.price ?? 0;
    var liveStage = int.tryParse(_liveStageController.text);
    liveStage ??= 1;
    quantity ??= 1;
    _total = quantity * price * liveStage;
    notifyListeners();
  }

  parseDDMMYYYYHHM(String date) {
    var inputFormat = DateFormat('HH:mm dd/MM/yyyy');
    var value = inputFormat.parse(date);
    return value;
  }

  parseDDMMYYYY(String date) {
    var inputFormat = DateFormat('HH:mm dd/MM/yyyy');
    var value = inputFormat.parse(date);
    return value;
  }

  bool _isCreatedSuccessfully = false;
  bool get isCreatedSuccessfully => _isCreatedSuccessfully;

  createTicket() async {
    Customer? customer;
 
    List<Customer> ctmp = _customers.where((element) {
      return element.phone == phoneController.text.trim();
    }).toList();

    if (ctmp.isNotEmpty) {
      customer = ctmp[0];
    }

    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (customer == null) {
      customer = Customer(
        phone: phoneController.text,
        fullname: fullNameController.text,
      );
      _customerRepository.add(customer);
    }

    var ticket = Ticket(
        id: '',
        date: parseDDMMYYYY(_timeIn),
        timeIn: parseDDMMYYYYHHM(_timeIn),
        timeOut: parseDDMMYYYYHHM(_timeOut),
        seats: _seatsController.text,
        fishingrod: _selectedFishingrod,
        fishingrodQuantity: int.tryParse(_fishingroldQuantityController.text),
        price: total,
        customer: customer);

    await _printTicket(ticket);

    _ticketRepository.add(ticket);
    _isCreatedSuccessfully = true;
    notifyListeners();
  }

  _printTicket(Ticket ticket) async {
    // PrintTicket _printHepler = PrintTicket(ticket);
    // await _printHepler.print();
  }
}
