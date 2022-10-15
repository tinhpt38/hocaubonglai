import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
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
    // _model.onScanPressed();
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
                centerTitle: !_modelHome.role,
                title: const Text('CÁC VÉ HÔM NAY'),
                actions: [
                  _modelHome.role == true
                      ? ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TicketPage()));
                          },
                          label: const Text('Thêm'),
                        )
                      : Container()
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
                            "${_auth.userLogined?.displayName.toString()} (${_modelHome.role == true ? "Admin" : "Nhân viên"})",
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>  const DemoPrintPage(title: 'Tìm kiếm máy in')
                        ));
 
                      },
                    ),
                    ListTile(
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
                    ),
                    _modelHome.role == true
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
                      onTap: () {
                        _auth.logout();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                              maintainState: false),
                        );
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    'TỔNG TIỀN HÔM NAY: ${model.totalPrice} K',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                                          // await model
                                          //     .onPrint(model.tickets[index]);
                                          await _model.onPrintReceipt(
                                              model.retrievedTickets[index]);
                                        },
                                        isAdmin: _modelHome.role,
                                      );
                                    }),
                              )
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text('Chưa có dữ liệu!'),
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
        return AlertDialog(
          title: const Center(child: Text('Xuất Excel')),
          content: const Text('Chọn xuất hôm nay hoặc chọn tháng'),
          actions: <Widget>[
            Center(
              child: TextButton(
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
            ),
            ExportExcel(
              model: model,
            ),
          ],
        );
      },
    );
  }
}

class ExportExcel extends StatefulWidget {
  final DashboardModel model;
  const ExportExcel({super.key, required this.model});

  @override
  State<ExportExcel> createState() => _ExportExcelState();
}

class _ExportExcelState extends State<ExportExcel> {
  List list = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  String dropdownValue = '01';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Xuất tháng'),
          onPressed: () {
            Navigator.pop(context);
            (widget.model.rootPath != null)
                ? widget.model.exportExcel(context, dropdownValue, false)
                : null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Chọn tháng: '),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: const Text(''),
                  isExpanded: false,
                  items: list
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              '  $item  ',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: dropdownValue,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
