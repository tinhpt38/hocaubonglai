import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:print_ticket/models/ticket.dart';
import 'package:print_ticket/modules/dashboard/dashboard.model.dart';
import 'package:print_ticket/modules/dashboard/view/ticket.item.view.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:blue_print_pos/models/connection_status.dart';
import 'package:blue_print_pos/receipt/receipt_section_text.dart';
import 'package:blue_print_pos/receipt/receipt_text_size_type.dart';
import 'package:blue_print_pos/receipt/receipt_text_style_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as RB;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../configuation/demo.print.dart';
import '../ticket/ticket.page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardModel _model = DashboardModel();

  // final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  // List<BlueDevice> _blueDevices = <BlueDevice>[];
  // BlueDevice? _selectedDevice;
  // bool _isLoading = false;
  // int _loadingAtIndex = -1;

  // // BLE weighing
  // final flutterReactiveBle = RB.FlutterReactiveBle();
  // RB.DiscoveredDevice? deviceChipseaBle;
  // String mButtonText = "Connect Chipsea-BLE";
  // String mWeighingReading = "---";
  // String mUnit = "no";

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _model.getTicketBox();
    _model.onScanPressed();
  }

  // Future<void> _onScanPressed() async {
  //   if (Platform.isAndroid) {
  //     Map<Permission, PermissionStatus> statuses = await [
  //       Permission.bluetoothScan,
  //       Permission.bluetoothConnect,
  //     ].request();
  //     if (statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
  //         statuses[Permission.bluetoothConnect] != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   // setState(() => _isLoading = true);
  //   _bluePrintPos.scan().then((List<BlueDevice> devices) {
  //     if (devices.isNotEmpty) {
  //       print('UI: devices is not empty');
  //       setState(() {
  //         _blueDevices = devices;
  //         _isLoading = false;
  //       });
  //       _onSelectDevice(0);
  //     } else {
  //       // setState(() => _isLoading = false);
  //       print('UI: devices is  empty');
  //     }
  //   });
  // }

  // void _onDisconnectDevice() {
  //   _bluePrintPos.disconnect().then((ConnectionStatus status) {
  //     if (status == ConnectionStatus.disconnect) {
  //       setState(() {
  //         _selectedDevice = null;
  //       });
  //     }
  //   });
  // }

  // void _onSelectDevice(int index) {
  //   setState(() {
  //     _isLoading = true;
  //     _loadingAtIndex = index;
  //   });
  //   final BlueDevice blueDevice = _blueDevices[index];
  //   _bluePrintPos.connect(blueDevice).then((ConnectionStatus status) {
  //     if (status == ConnectionStatus.connected) {
  //       setState(() => _selectedDevice = blueDevice);
  //     } else if (status == ConnectionStatus.timeout) {
  //       _onDisconnectDevice();
  //     } else {
  //       if (kDebugMode) {
  //         print('$runtimeType - something wrong');
  //       }
  //     }
  //     // setState(() => _isLoading = false);
  //     print('UI: is Loading = false');
  //   });
  // }

  // Future<void> _onPrintReceipt(Ticket ticket) async {
  //   /// Example for Print Text
  //   final ReceiptSectionText receiptText = ReceiptSectionText();
  //   // receiptText.addSpacer();
  //   receiptText.addText(
  //     'VÉ CÂU HỒ BỒNG LAI',
  //     size: ReceiptTextSizeType.extraLarge,
  //     style: ReceiptTextStyleType.bold,
  //   );
  //   receiptText.addText(DateFormat('dd/MM/yyyy').format(ticket.timeIn!),
  //       size: ReceiptTextSizeType.extraLarge, style: ReceiptTextStyleType.bold);
  //   receiptText.addSpacer(useDashed: true);
  //   receiptText.addLeftRightText(
  //     'Giờ vào',
  //     DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeIn!),
  //     leftStyle: ReceiptTextStyleType.normal,
  //     leftSize: ReceiptTextSizeType.extraLarge,
  //     rightSize: ReceiptTextSizeType.extraLarge,
  //     rightStyle: ReceiptTextStyleType.bold,
  //   );
  //   receiptText.addSpacer(useDashed: true);
  //   receiptText.addLeftRightText(
  //     'Giờ ra',
  //     DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeOut!),
  //     leftStyle: ReceiptTextStyleType.normal,
  //     leftSize: ReceiptTextSizeType.extraLarge,
  //     rightSize: ReceiptTextSizeType.extraLarge,
  //     rightStyle: ReceiptTextStyleType.bold,
  //   );
  //   receiptText.addSpacer(useDashed: true);
  //   receiptText.addLeftRightText(
  //     'Vị trí',
  //     ticket.seats ?? '',
  //     leftStyle: ReceiptTextStyleType.normal,
  //     leftSize: ReceiptTextSizeType.extraLarge,
  //     rightSize: ReceiptTextSizeType.extraLarge,
  //     rightStyle: ReceiptTextStyleType.bold,
  //   );
  //   receiptText.addSpacer(useDashed: true);
  //   receiptText.addLeftRightText(
  //     'Loại cần',
  //     ticket.fishingrod?.name ?? '',
  //     leftStyle: ReceiptTextStyleType.normal,
  //     leftSize: ReceiptTextSizeType.extraLarge,
  //     rightSize: ReceiptTextSizeType.extraLarge,
  //     rightStyle: ReceiptTextStyleType.bold,
  //   );
  //   receiptText.addSpacer(useDashed: true);
  //   receiptText.addLeftRightText(
  //     'Số cần',
  //     ticket.fishingrodQuantity.toString(),
  //     leftStyle: ReceiptTextStyleType.normal,
  //     leftSize: ReceiptTextSizeType.extraLarge,
  //     rightSize: ReceiptTextSizeType.extraLarge,
  //     rightStyle: ReceiptTextStyleType.bold,
  //   );
  //   receiptText.addSpacer(useDashed: true);
  //   receiptText.addLeftRightText(
  //     'GIÁ',
  //     '${ticket.price.toString()} K',
  //     leftStyle: ReceiptTextStyleType.normal,
  //     leftSize: ReceiptTextSizeType.extraLarge,
  //     rightSize: ReceiptTextSizeType.extraLarge,
  //     rightStyle: ReceiptTextStyleType.bold,
  //   );
  //   receiptText.addSpacer(useDashed: true);
  //   receiptText.addText(
  //     'LƯU Ý:',
  //     size: ReceiptTextSizeType.large,
  //     style: ReceiptTextStyleType.normal,
  //   );
  //   receiptText.addText(
  //     'Cần thủ giữ  vé trong suốt ca câu',
  //     size: ReceiptTextSizeType.large,
  //     style: ReceiptTextStyleType.bold,
  //   );
  //   receiptText.addText(
  //     'Liên hệ: Mr Thanh - 0379080398',
  //     size: ReceiptTextSizeType.large,
  //     style: ReceiptTextStyleType.bold,
  //   );
  //   // receiptText.addSpacer(count: 2);`

  //   await _bluePrintPos.printReceiptText(receiptText);

  //   // /// Example for print QR
  //   // await _bluePrintPos.printQR('https://www.google.com/', size: 250);

  //   /// Text after QR
  //   // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
  //   // receiptSecondText.addText('Powered by Google',
  //   //     size: ReceiptTextSizeType.small);
  //   // receiptSecondText.addSpacer();
  //   // await _bluePrintPos.printReceiptText(receiptSecondText, feedCount: 1);
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardModel>(
      create: (_) => _model,
      builder: (context, widgets) => Consumer<DashboardModel>(
        builder: (context, model, widget) {
          Future.delayed(Duration.zero, () {
            if (model.isPrinting) {
              showTopSnackBar(
                  context,
                  const CustomSnackBar.success(
                    message: "ĐANG IN VÉ",
                  ),
                  displayDuration: Duration(seconds: 5));
            }
          });
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('CÁC VÉ HÔM NAY'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DemoPrintPage(
                                      title: 'Demo Print Page',
                                    )));
                      },
                      child: const Text(
                        'Kiểm tra máy in',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: "createTicket",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TicketPage()));
                },
                child: const Icon(Icons.add),
              ),
              backgroundColor: const Color(0xffEEEEEE),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: model.isLoading
                    ? const Center(
                        child: Text('Loading...'),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'TỔNG TIỀN HÔM NAY: ${model.totalPrice} K',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: RefreshIndicator(
                              onRefresh: (() async {
                                await model.getTicketBox();
                                // await _model.onScanPressed();
                              }),
                              child: ListView.builder(
                                  itemCount: model.tickets.length,
                                  itemBuilder: (context, index) {
                                    return TicketItemView(
                                      ticket: model.tickets[index],
                                      onDeleteClick: () {
                                        model
                                            .deleteTicket(model.tickets[index]);
                                      },
                                      onPrintClick: () async {
                                        // await model
                                        //     .onPrint(model.tickets[index]);
                                        await _model.onPrintReceipt(
                                            model.tickets[index]);
                                      },
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
