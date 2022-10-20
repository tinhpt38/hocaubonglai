import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:print_ticket/models/customers.dart';
import 'package:print_ticket/models/fishingrods.dart';
import '../../services/repositories/customer_repository.dart';
import '../../services/repositories/fishingrod.repository.dart';
import '../../services/repositories/ticket_repository.dart';

class TicketModel extends ChangeNotifier {
  TicketRepository ticketRepo = TicketRepository();

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

  final TextEditingController _fullNameController =
      TextEditingController(text: '');
  TextEditingController get fullNameController => _fullNameController;

  final TextEditingController _fishingroldQuantityController =
      TextEditingController(); //
  TextEditingController get fishingroldQuantityController =>
      _fishingroldQuantityController;

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

  final bool _isCreatedSuccessfully = false;
  bool get isCreatedSuccessfully => _isCreatedSuccessfully;

  //hiep code

  setNameFromPhone(String text) {
    if (text.isNotEmpty && _customersMap.containsKey(int.parse(text))) {
      _fullNameController.text = _customersMap[int.parse(text)].toString();
      notifyListeners();
    } else {
      _fullNameController.text = '';
    }
  }

  final CustomerRepository customerRepo = CustomerRepository();

  final Map<int, String> _customersMap = {};
  Map<int, String> get customersMap => _customersMap;

  List<String> phoneCustomers = [];

  List<Customers> _retrievedCustomersList = [];
  getCustomer() async {
    _retrievedCustomersList = await customerRepo.retrieveCustomers();
    for (int i = 0; i < _retrievedCustomersList.length; i++) {
      _customersMap[int.parse(_retrievedCustomersList[i].phone.toString())] =
          _retrievedCustomersList[i].fullname.toString();
      phoneCustomers.add(_retrievedCustomersList[i].phone.toString());
      notifyListeners();
    }
  }

  final FishingrodRepository fishingRodRepo = FishingrodRepository();
  List<FishingRods> _retrievedFishingRodList = [];
  final List<String> _fishingRodName = [];
  List<String> get fishingRodName => _fishingRodName;
  final List<String> _fishingRodPrice = [];
  List<String> get fishingRodPrice => _fishingRodPrice;
  final Map<String, String> _fishingRodMap = {};
  Map<String, String> get fishingRodMap => _fishingRodMap;

  getFishingRod() async {
    _retrievedFishingRodList = await fishingRodRepo.retrieveFishingRods();
    for (int i = 0; i < _retrievedFishingRodList.length; i++) {
      _fishingRodName.add(
          '${_retrievedFishingRodList[i].name} -- ${_retrievedFishingRodList[i].price}');
      _fishingRodPrice.add(_retrievedFishingRodList[i].price.toString());
      _fishingRodMap[_retrievedFishingRodList[i].name.toString()] =
          _retrievedFishingRodList[i].price.toString();
      notifyListeners();
    }
  }

  String? _selectedValue;
  String? get selectedValue => _selectedValue;

  onChangeTypeFishingRod(String? value) {
    _selectedValue = value;
    listNameFishingRod = value!.split(' -- ');
    notifyListeners();
  }

  List<String> listNameFishingRod = [];
  double? price;
  getPrice() {
    var quantity = double.tryParse(_fishingroldQuantityController.text);
    var liveStage = int.tryParse(_liveStageController.text);
    liveStage ??= 1;
    quantity ??= 1;

    if (listNameFishingRod.isNotEmpty) {
      price =
          double.tryParse(_fishingRodMap[listNameFishingRod[0]].toString()) ??
              1;
    }
    if (price != null) {
      _total = quantity * price! * liveStage;
    }
    notifyListeners();
  }

  double _total = 0;
  double get total => _total;

  String get getCurrentDate {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }

  createTicket() async {
    await ticketRepo.ticketBox.add(({
      'customer': fullNameController.text,
      'phone': phoneController.text,
      'price': _total,
      'fishingRod': listNameFishingRod[0],
      'fishingrodQuantity': _fishingroldQuantityController.text,
      'seats': _seatsController.text,
      'timeIn': _timeIn,
      'timeOut': _timeOut,
      'createAt': getCurrentDate,
      'createAtMonth': getCurrentDate.substring(3, 10),
      'count': int.parse(liveStageController.text),
    }));
    if (phoneCustomers.contains(phoneController.text)) {
    } else {
      await customerRepo.customers.add(({
        'fullname': fullNameController.text,
        'phone': phoneController.text
      }));
    }
  }
}
