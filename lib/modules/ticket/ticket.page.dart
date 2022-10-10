import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:print_ticket/modules/ticket/ticket.model.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../dashboard/dashboard.model.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final TicketModel _model = TicketModel();
  final DashboardModel _modelDashboard = DashboardModel();
  final _addTicktFormKey = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
    initialData();
  }

  initialData() async {
    await _model.getCustomer();
    await _model.getFishingRod();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TicketModel>(
      create: (_) => _model,
      builder: ((context, child) =>
          Consumer<TicketModel>(builder: (context, model, child) {
            Future.delayed(Duration.zero, () {
              if (model.isCreatedSuccessfully) {
                Navigator.pop(context);
              }
            });
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('THÊM VÉ'),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: _addTicktFormKey,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                color: const Color(0xffF7F5F2),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //THÔNG TIN KHÁCH HÀNG
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Center(
                                          child: Text(
                                            'THÔNG TIN KHÁCH',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    TextFormField(
                                        controller: model.phoneController,
                                        keyboardType: TextInputType.number,
                                        onChanged: _model.setNameFromPhone,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Điền số điện thoại khách hàng';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Số điện thoại:',
                                        )),
                                    TextFormField(
                                        controller: model.fullNameController
                                          ..text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Điền họ tên khách hàng';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Họ tên:',
                                        )),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Center(
                                          child: Text(
                                            'THÔNG TIN VÉ',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black87, width: 1)),
                                      child: TextButton(
                                          onPressed: () {
                                            DatePicker.showTimePicker(context,
                                                showTitleActions: true,
                                                onConfirm: model.setTimeIn,
                                                currentTime: DateTime.now());
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Giờ vào: ${model.timeIn}',
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          controller: model.liveStageController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (_) {
                                            model.setTimeOut();
                                            model.getPrice();
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Nhập vào số ca',
                                            labelText: 'Số ca:',
                                          )),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 12),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black87,
                                                width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child:
                                              Text('Giờ ra: ${model.timeOut}'),
                                        )),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                                controller:
                                                    model.seatsController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Vị trí ngồi:',
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          controller: model
                                              .fishingroldQuantityController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (_) {
                                            model.getPrice();
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Số cần:',
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      '  Loại cần',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          hint: const Text(''),
                                          isExpanded: true,
                                          items: model.fishingRodName
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      '$item VNĐ',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: model.selectedValue,
                                          onChanged: (_) {
                                            model.onChangeTypeFishingRod(_);
                                            model.getPrice();
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(32),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black87, width: 1)),
                                      child: Text(
                                        'Giá vé: ${model.total} VNĐ',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            model.createTicket();
                                            Navigator.pop(context);
                                            _modelDashboard.getTicketBox();
                                          },
                                          child: const Text('TẠO VÀ IN VÉ')),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // const Expanded(
                            //   flex: 2,
                            //   child: Center(child: TicketPrintView()),
                            // )
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          })),
    );
  }
}
