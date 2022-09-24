import 'dart:io';

import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:blue_print_pos/models/connection_status.dart';
import 'package:blue_print_pos/receipt/receipt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/ticket.dart';
import '../../services/repositories/ticket_repository.dart';
import '../ticket/ticket.print.dart';

class DashboardModel extends ChangeNotifier {
  final TicketRepository _ticketRepository = TicketRepository();

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  double _totalPrice = 0;
  double get totalPrice => _totalPrice;

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

  getTicketBox() async {
    setIsLoading(true);
    await _ticketRepository.getBox();
    List<Ticket> temp = _ticketRepository.gets();
    DateTime now = DateTime.now();
    String currentDate = DateFormat('dd/MM/yyyy').format(now);
    _tickets = temp.where((element) {
      String ticketDate = DateFormat('dd/MM/yyyy').format(element.date!);
      // return ticketDate == currentDate;
      return true;
    }).toList();
    _tickets = _tickets.reversed.toList();
    _totalPrice =
        _tickets.map((e) => e.price ?? 0).toList().reduce((i, j) => i + j);
    setIsLoading(false);
    notifyListeners();
  }

  deleteTicket(Ticket ticket) async {
    setIsLoading(true);
    _tickets.remove(ticket);
    ticket.delete();
    await getTicketBox();
    notifyListeners();
  }

  final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  List<BlueDevice> _blueDevices = <BlueDevice>[];
  BlueDevice? _selectedDevice;
  // bool _isLoading = false;
  int _loadingAtIndex = -1;

  bool _isPrinting = false;
  bool get isPrinting => _isPrinting;

  setIsPrinting(bool isPrinting) {
    _isPrinting = isPrinting;
    notifyListeners();
  }

  Future<void> onScanPressed() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();
      if (statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
          statuses[Permission.bluetoothConnect] != PermissionStatus.granted) {
        return;
      }
    }

    // setState(() => _isLoading = true);
    _bluePrintPos.scan().then((List<BlueDevice> devices) {
      if (devices.isNotEmpty) {
        print('UI: devices is not empty');
        _blueDevices = devices;
        _isLoading = false;
        notifyListeners();
        onSelectDevice(0);
      } else {
        // setState(() => _isLoading = false);
        print('UI: devices is  empty');
      }
    });
  }

  void _onDisconnectDevice() {
    _bluePrintPos.disconnect().then((ConnectionStatus status) {
      if (status == ConnectionStatus.disconnect) {
        _selectedDevice = null;
        notifyListeners();
      }
    });
  }

  void onSelectDevice(int index) {
    _isLoading = true;
    _loadingAtIndex = index;
    notifyListeners();
    final BlueDevice blueDevice = _blueDevices[index];
    _bluePrintPos.connect(blueDevice).then((ConnectionStatus status) {
      if (status == ConnectionStatus.connected) {
        _selectedDevice = blueDevice;
        notifyListeners();
      } else if (status == ConnectionStatus.timeout) {
        _onDisconnectDevice();
      } else {
        if (kDebugMode) {
          print('$runtimeType - something wrong');
        }
      }
      // setState(() => _isLoading = false);
      print('UI: is Loading = false');
    });
  }

  Future<void> onPrintReceipt(Ticket ticket) async {
    setIsPrinting(true);

    /// Example for Print Text
    final ReceiptSectionText receiptText = ReceiptSectionText();
    // receiptText.addSpacer();
    receiptText.addText(
      'VÉ CÂU HỒ BỒNG LAI',
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );
    receiptText.addText(DateFormat('dd/MM/yyyy').format(ticket.timeIn!),
        size: ReceiptTextSizeType.extraLarge, style: ReceiptTextStyleType.bold);
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      'Giờ vào',
      DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeIn!),
      leftStyle: ReceiptTextStyleType.normal,
      leftSize: ReceiptTextSizeType.extraLarge,
      rightSize: ReceiptTextSizeType.extraLarge,
      rightStyle: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      'Giờ ra',
      DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeOut!),
      leftStyle: ReceiptTextStyleType.normal,
      leftSize: ReceiptTextSizeType.extraLarge,
      rightSize: ReceiptTextSizeType.extraLarge,
      rightStyle: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      'Vị trí',
      ticket.seats ?? '',
      leftStyle: ReceiptTextStyleType.normal,
      leftSize: ReceiptTextSizeType.extraLarge,
      rightSize: ReceiptTextSizeType.extraLarge,
      rightStyle: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      'Loại cần',
      ticket.fishingrod?.name ?? '',
      leftStyle: ReceiptTextStyleType.normal,
      leftSize: ReceiptTextSizeType.extraLarge,
      rightSize: ReceiptTextSizeType.extraLarge,
      rightStyle: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      'Số cần',
      ticket.fishingrodQuantity.toString(),
      leftStyle: ReceiptTextStyleType.normal,
      leftSize: ReceiptTextSizeType.extraLarge,
      rightSize: ReceiptTextSizeType.extraLarge,
      rightStyle: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      'GIÁ',
      '${ticket.price.toString()} K',
      leftStyle: ReceiptTextStyleType.normal,
      leftSize: ReceiptTextSizeType.extraLarge,
      rightSize: ReceiptTextSizeType.extraLarge,
      rightStyle: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addText(
      'LƯU Ý:',
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.normal,
    );
    receiptText.addText(
      'Cần thủ giữ  vé trong suốt ca câu',
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
    );
    receiptText.addText(
      'Liên hệ: Mr Thanh - 0868211119',
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
    );
    // receiptText.addSpacer(count: 2);`

    await _bluePrintPos.printReceiptText(receiptText);
    setIsPrinting(false);

    // /// Example for print QR
    // await _bluePrintPos.printQR('https://www.google.com/', size: 250);

    /// Text after QR
    // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
    // receiptSecondText.addText('Powered by Google',
    //     size: ReceiptTextSizeType.small);
    // receiptSecondText.addSpacer();
    // await _bluePrintPos.printReceiptText(receiptSecondText, feedCount: 1);
  }
}
