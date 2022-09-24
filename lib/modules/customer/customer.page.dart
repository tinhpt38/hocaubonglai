import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:print_ticket/modules/customer/customer.model.dart';
import 'package:print_ticket/modules/dashboard/dashboard.model.dart';
import 'package:print_ticket/modules/dashboard/view/ticket.item.view.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerModel _model = CustomerModel();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _model.getCustomerBox();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomerModel>(
      create: (_) => _model,
      builder: (context, widgets) => Consumer<CustomerModel>(
        builder: (context, model, widget) {
          return SafeArea(
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.refresh),
                onPressed: ()async{
                  model.getCustomerBox();
                },
              ),
              backgroundColor: const Color(0xffEEEEEE),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: model.isLoading ? const Center( child:   Text('Loading...'),): RefreshIndicator(
                  onRefresh: (()async{
                      await model.getCustomerBox();
                  }),
                  child: Column(
                    children: [
                               const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'DANH SÁCH KHÁCH HÀNG',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: model.customers.length,
                            itemBuilder: (context, index) {
                              return  Container(
                                color: Colors.white70,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12 ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${model.customers[index].fullname?.toUpperCase()}', textAlign: TextAlign.start,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('SĐT: ${model.customers[index].phone}'),
                                    )
                                  ],
                                )
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
