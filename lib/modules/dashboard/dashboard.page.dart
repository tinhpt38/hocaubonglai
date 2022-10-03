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

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _model.getTicketBox();
    _model.onScanPressed();
  }

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
                  displayDuration: const Duration(seconds: 5));
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
