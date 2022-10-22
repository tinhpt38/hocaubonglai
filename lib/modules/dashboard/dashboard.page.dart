import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:print_ticket/modules/auth/auth.model.dart';
import 'package:print_ticket/modules/auth/login.page.dart';
import 'package:print_ticket/modules/dashboard/dashboard.model.dart';
import 'package:print_ticket/modules/home/home.model.dart';
import 'package:print_ticket/modules/permission/permission.page.dart';
import 'package:provider/provider.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../models/tickets.dart';
import '../configuation/demo.print.dart';
import '../ticket/ticket.page.dart';
import 'view/ticket.item.view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardModel _model = DashboardModel();
  final AuthModel _auth = AuthModel();
  final HomeModel _modelHome = HomeModel();
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await _modelHome.getUser();
    await _model.getTicketBox();
    await _model.connectDevice();
    await _model.prepareStorage();
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
                centerTitle: !_modelHome.isAdmin,
                title: const Text('CÁC VÉ HÔM NAY'),
                actions: [
                ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TicketPage()));
                            model.getTicketBox();
                          },
                          label: const Text('Thêm'),
                        )
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 150,
                      child: DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  _auth.userLogined?.photoURL.toString() ??
                                      "")),
                          title: Text(
                            "${_auth.userLogined?.displayName.toString()} (${_modelHome.isAdmin == true ? "Admin" : "Nhân viên"})",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            _auth.userLogined?.email.toString() ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.print,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        'Tìm kiếm máy in',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DemoPrintPage(
                                    title: 'Tìm kiếm máy in')));
                      },
                    ),
                    _modelHome.isAdmin == true
                        ? ListTile(
                            leading: const Icon(
                              Icons.import_export,
                              color: Colors.blue,
                            ),
                            title: const Text(
                              'Xuất excel',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onTap: () {
                              _dialogExcel(context, model);
                            },
                          )
                        : Container(),
                    _modelHome.isAdmin == true
                        ? ListTile(
                            leading: const Icon(
                              Icons.verified_user,
                              color: Colors.blue,
                            ),
                            title: const Text(
                              'Phân quyền',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PermissionPage()));
                            },
                          )
                        : Container(),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () async {
                        await _auth.logout();
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const LoginPage())),
                            (route) => true);
                      },
                    ),
                  ],
                ),
              ),
              backgroundColor: const Color(0xffEEEEEE),
              body: RefreshIndicator(
                onRefresh: (() async {
                  await _model.getTicketBox();
                }),
                child: FutureBuilder(
                    future: _model.ticketsList,
                    builder: (context, AsyncSnapshot<List<Tickets>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _modelHome.isAdmin == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Center(
                                        child: Text(
                                          'TỔNG TIỀN HÔM NAY: ${model.totalPrice} K',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 10,
                                    ),
                              Expanded(
                                flex: 1,
                                child: ListView.builder(
                                    itemCount: model.retrievedTickets.length,
                                    itemBuilder: (context, index) {
                                      return TicketItemView(
                                        ticket: model.retrievedTickets[index],
                                        onDeleteClick: model,
                                        onPrintClick: () async {
                                          await _model.onPrintReceipt(
                                              model.retrievedTickets[index]);
                                        },
                                        isAdmin: _modelHome.isAdmin,
                                      );
                                    }),
                              )
                            ],
                          ),
                        );
                      } else {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await _model.getTicketBox();
                          },
                          child: const Center(
                            child: Text('Chưa có dữ liệu!'),
                          ),
                        );
                      }
                    }),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _dialogExcel(BuildContext context, var model) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String? month;
        return AlertDialog(
          title: const Center(child: Text('Xuất Excel')),
          content: const Text('Chọn xuất hôm nay hoặc chọn tháng'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Xuất hôm nay'),
              onPressed: () {
                Navigator.pop(context);
                (model.rootPath != null)
                    ? model.exportExcel(context, '', true)
                    : null;
              },
            ),
            TextButton(
                onPressed: () {
                  DatePicker.showPicker(context, onConfirm: (time) {
                    setState(() {
                      month = '${time.month}/${time.year}';
                      (model.rootPath != null)
                          ? model.exportExcel(context, month, false)
                          : null;
                    });
                  },
                      pickerModel: CustomMonthPicker(
                          minTime: DateTime(2022, 9, 1),
                          maxTime: DateTime.now(),
                          currentTime: DateTime.now(),
                          locale: LocaleType.vi));
                },
                child: const Text('Xuất tháng'))
          ],
        );
      },
    );
  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker(
      {required DateTime currentTime,
      required DateTime minTime,
      required DateTime maxTime,
      required LocaleType locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
