import 'dart:io';
import 'dart:io' as io;
import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:blue_print_pos/models/connection_status.dart';
import 'package:blue_print_pos/receipt/receipt.dart';
import 'package:blue_print_pos/receipt/receipt_section_text.dart';
import 'package:blue_print_pos/receipt/receipt_text_size_type.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:excel/excel.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/tickets.dart';
import '../../services/repositories/ticket_repository.dart';

class DashboardModel extends ChangeNotifier {
  double _totalPrice = 0;
  double get totalPrice => _totalPrice;

  String get getCurrentDate {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TicketRepository _ticketRepo = TicketRepository();
  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Tickets> _retrievedTickets = [];
  List<Tickets> get retrievedTickets => _retrievedTickets;

  List<Tickets> _getAllTicket = [];
  List<Tickets> get getAllTicket => _getAllTicket;

  Future<List<Tickets>>? _ticketsList;
  Future<List<Tickets>>? get ticketsList => _ticketsList;

  Future<List<Tickets>>? _ticketsList1;
  Future<List<Tickets>>? get ticketsList1 => _ticketsList1;
  List _listPrice = [];

  getTicketBox() async {
    setIsLoading(true);
    _listPrice = [];
    _retrievedTickets =
        await _ticketRepo.retrieveTicket(getCurrentDate.toString());
    _ticketsList = _ticketRepo.retrieveTicket(getCurrentDate.toString());

    // _getAllTicket = await _ticketRepo.retrieveAllTicket();

    // print(_retrievedTickets[0].timeIn.toString().substring(6, 16));
    for (var i = 0; i < _retrievedTickets.length; i++) {
      _listPrice.add(double.tryParse(_retrievedTickets[i].price.toString())!);
    }
    setIsLoading(false);
    getPriceToday();
    notifyListeners();
  }

  getPriceToday() {
    if (_listPrice.isNotEmpty) {
      _totalPrice = _listPrice.reduce((value, element) => value + element);
    }
    notifyListeners();
  }

  deleteTicket(String ticketID) async {
    await _ticketRepo.ticketBox.doc(ticketID).delete();
    getTicketBox();
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
    });
  }

  connectDevice() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? value = _prefs.getString('selectedDevice');
    if (value == null) {
      await onScanPressed();
    } else {
      final BlueDevice blueDevice = parseStringToBlueDevice(value);
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
      });
    }
  }

  BlueDevice parseStringToBlueDevice(String deviceString) {
//  return 'address/ ${device.address} - name/ ${device.name} - type/ ${device.type}';
    List<String> temp = deviceString.split('-');
    String address = temp[0].split("/")[1].trim();
    String name = temp[1].split("/")[1].trim();
    return BlueDevice(name: name, address: address);
  }

  Directory? _rootPath;
  Directory? get rootPath => _rootPath;
  String? dirPath;

  Future<void> prepareStorage() async {
    _rootPath = Directory('/storage/emulated/0/');
  }

  Future<void> exportExcel(BuildContext context, String time, bool day) async {
    _getAllTicket = await _ticketRepo.retrieveAllTicket(time);
    final now = DateTime.now();
    String? path = await FilesystemPicker.open(
      title: 'Select folder',
      context: context,
      rootDirectory: _rootPath!,
      fsType: FilesystemType.folder,
      pickText: 'Select this folder',
      folderIconColor: Colors.teal,
      requestPermission: () async =>
          await Permission.storage.request().isGranted,
    );
    dirPath = path;
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Vé ngày ${now.day}/${now.month}/${now.year}');
    Sheet sheetObject = excel['Vé ngày ${now.day}/${now.month}/${now.year}'];

    List<String> header = [
      'STT',
      'Tên khách hàng',
      'Số điện thoại',
      'Giá vé',
      'Vị trí',
      'Lọai cần',
      'Số cần',
      'Giờ vào',
      'Giờ ra'
    ];
    sheetObject.insertRowIterables(header, 1);
    int stt = 1;
    for (var element in (day == true ? _retrievedTickets : _getAllTicket)) {
      List<dynamic> row = [
        stt++,
        element.customer,
        element.phone,
        element.price,
        element.seats,
        element.fishingrod,
        element.fishingrodQuantity,
        element.timeIn,
        element.timeOut
      ];
      sheetObject.insertRowIterables(row, stt);
      final String fileName =
          '$path/${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_output1.xlsx';
      try {
        io.File excelFile = io.File(fileName);
        if (!excelFile.existsSync()) {
          excelFile.createSync();
        }
        excelFile.writeAsBytesSync(excel.encode()!);
        const snackBar = SnackBar(
          content: Text('Đã xuất file!'),
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print(e);
      }
    }

    notifyListeners();
  }

  DateTime convertStringToDateTime(String date) {
    var inputFormat = DateFormat('HH:mm dd/MM/yyyy');
    var value = inputFormat.parse(date);
    return value;
  }

  Future<void> onPrintReceipt(Tickets ticket) async {
    setIsPrinting(true);

    /// Example for Print Text
    final ReceiptSectionText receiptText = ReceiptSectionText();
    // receiptText.addSpacer();
    receiptText.addText(
      'VÉ CÂU HỒ BỒNG LAI',
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );
    receiptText.addText(
        DateFormat('dd/MM/yyyy')
            .format(convertStringToDateTime(ticket.timeIn!)),
        size: ReceiptTextSizeType.extraLarge,
        style: ReceiptTextStyleType.bold);
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      'Giờ vào',
      DateFormat('HH:mm dd/MM/yyyy')
          .format(convertStringToDateTime(ticket.timeIn!)),
      leftStyle: ReceiptTextStyleType.normal,
      leftSize: ReceiptTextSizeType.extraLarge,
      rightSize: ReceiptTextSizeType.extraLarge,
      rightStyle: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      'Giờ ra',
      DateFormat('HH:mm dd/MM/yyyy')
          .format(convertStringToDateTime(ticket.timeOut!)),
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
      ticket.fishingrod ?? '',
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

    await _bluePrintPos.printReceiptText(receiptText, 
    paperSize: PaperSize.mm72);
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
