import 'package:flutter/cupertino.dart';
import 'package:print_ticket/models/tickets.dart';
import 'package:print_ticket/services/repositories/statistical_repository.dart';

class StatisticModel extends ChangeNotifier {
  final StatisticalRepository _ticketRepo = StatisticalRepository();

  List<Tickets> _tickets = [];
  List<Tickets> get tickets => _tickets;

  List<double> _listPrice = [];
  List<double> get listPrice => _listPrice;

  List<int> _totalTicket = [];
  List<int> get totalTicket => _totalTicket;

  DateTime time = DateTime.now();

  getMonth(int year) async {
    _listPrice = [];
    if (year == 2022) {
      _listPrice = [0, 0, 0, 0, 0, 0, 0, 0, 0];
      _totalTicket = [0, 0, 0, 0, 0, 0, 0, 0, 0];
      await getMonth10(year);
      await getMonth11(year);
      await getMonth12(year);
    } else if (time.year < year) {
    } else {
      await getMonth1(year);
      await getMonth2(year);
      await getMonth3(year);
      await getMonth4(year);
      await getMonth5(year);
      await getMonth6(year);
      await getMonth7(year);
      await getMonth8(year);
      await getMonth9(year);
      await getMonth10(year);
      await getMonth11(year);
      await getMonth12(year);
    }

    notifyListeners();
  }

  getMonth1(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('01/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }
    notifyListeners();
  }

  getMonth2(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('02/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }
    notifyListeners();
  }

  getMonth3(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('03/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }

    notifyListeners();
  }

  getMonth4(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('04/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }
    notifyListeners();
  }

  getMonth5(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('05/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }
    notifyListeners();
  }

  getMonth6(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('06/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }

    notifyListeners();
  }

  getMonth7(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('07/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }
    notifyListeners();
  }

  getMonth8(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('08/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }

    notifyListeners();
  }

  getMonth9(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('09/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }

    notifyListeners();
  }

  getMonth10(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('10/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }

    notifyListeners();
  }

  getMonth11(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('11/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }

    notifyListeners();
  }

  getMonth12(int year) async {
    List list = [];
    _tickets = await _ticketRepo.getMonth('12/$year');
    _totalTicket.add(_tickets.length);
    if (_tickets.isNotEmpty) {
      for (var i = 0; i < _tickets.length; i++) {
        var item = _tickets[i];
        list.add(item.price!);
      }
      _listPrice.add(list.reduce((value, element) => value + element));
    } else {
      _listPrice.add(0);
    }

    notifyListeners();
  }
}
