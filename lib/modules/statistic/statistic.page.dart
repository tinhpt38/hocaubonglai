import 'package:flutter/material.dart';
import 'package:print_ticket/modules/statistic/statistic.model.dart';
import 'package:provider/provider.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  final StatisticModel _model = StatisticModel();
  int year = 2022;

  DateTime time = DateTime.now();

  @override
  void initState() {
    super.initState();
    _model.getMonth(year);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text('Thống kê')),
        body: ChangeNotifierProvider<StatisticModel>(
          create: (_) => _model,
          builder: (((context, child) =>
              Consumer<StatisticModel>(builder: (context, model, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: (DateTime.now().year - year) + 1 > 8
                            ? size.height / 8
                            : size.height / 10,
                        width: size.width,
                        child: GridView.count(
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 7,
                          children: [
                            ...List.generate(
                              (DateTime.now().year - year) + 1,
                              (index) => InkWell(
                                onTap: () async {
                                  setState(() {
                                    year = 2022 + index;
                                  });
                                  await model.getMonth(year);
                                },
                                child: Chip(
                                  label: Text(
                                    (2022 + index).toString(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      model.listPrice.length == 12
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 12,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                      title: index < 9
                                          ? Text('Tháng 0${index + 1} : ',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold))
                                          : Text('Tháng ${index + 1} :',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                      subtitle: model.listPrice[index] != 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '- Tổng vé: ${model.totalTicket[index]}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.green),
                                                  ),
                                                  Text(
                                                      '- Tổng tiền: ${model.listPrice[index]} K',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.green))
                                                ],
                                              ))
                                          : const Center(
                                              child: Text('Chưa có dữ liệu'),
                                            ));
                                },
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                                title: Text(
                                  'Năm $year',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: model.listPrice.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '- Tổng vé: ${model.totalTicket.reduce((value, element) => value + element)}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green),
                                            ),
                                            Text(
                                                '- Tổng tiền: ${model.listPrice.reduce((value, element) => value + element)} K',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green))
                                          ],
                                        ),
                                      )
                                    : const Center(
                                        child: Text('Chưa có dữ liệu!'),
                                      ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }))),
        ));
  }
}
