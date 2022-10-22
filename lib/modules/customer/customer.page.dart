import 'package:flutter/material.dart';
import 'package:print_ticket/models/customers.dart';
import 'package:print_ticket/modules/customer/customer.model.dart';
import 'package:print_ticket/modules/home/home.model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerModel _model = CustomerModel();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _model.getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomerModel>(
      create: (_) => _model,
      builder: (context, widgets) => Consumer<CustomerModel>(
        builder: (context, model, widget) {
          return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Danh sách khách hàng'),
                    actions: [
                      ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              enableDrag: false,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        1 /
                                        3,
                                    color: Colors.grey[100],
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                    controller: model
                                                        .fullNameController,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Điền tên khách hàng';
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Tên khách hàng *',
                                                    )),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        model.phoneController,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Điền số điện thoại';
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Số điện thoại *',
                                                    )),
                                              )),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  model.createCustomer();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('Tạo')),
                                          const SizedBox(
                                            height: 64,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm'))
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                      onPressed: model.getCustomer,
                      child: const Icon(Icons.refresh)),
                  backgroundColor: const Color(0xffEEEEEE),
                  body: FutureBuilder(
                      future: _model.customersList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Customers>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.retrievedCustomersList.length,
                            itemBuilder: (context, index) {
                              final Customers customers =
                                  model.retrievedCustomersList[index];
                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(customers.fullname.toString()),
                                  subtitle: Text(customers.phone.toString()),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              var url = Uri.parse(
                                                  "tel:${customers.phone}");
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.call,
                                              color: Colors.green,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (
                                                    BuildContext context,
                                                  ) =>
                                                      AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                              'Xóa khách hàng?'),
                                                        ),
                                                        content: Text(
                                                          customers.fullname
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Không'),
                                                            child: const Text(
                                                                'Không'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              model.deleteCustomers(
                                                                  customers.id
                                                                      .toString());
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Xóa'),
                                                          ),
                                                        ],
                                                      ));
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })));
        },
      ),
    );
  }
}
