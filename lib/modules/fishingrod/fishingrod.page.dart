import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:print_ticket/modules/fishingrod/fishingrod.model.dart';
import 'package:print_ticket/modules/fishingrod/views/fishingrod.item.dart';
import 'package:print_ticket/services/repositories/fishingrod.repository.dart';
import 'package:provider/provider.dart';

import 'views/create.view.dart';

class FishingrodPage extends StatefulWidget {
  const FishingrodPage({super.key});

  @override
  State<FishingrodPage> createState() => _FishingrodPageState();
}

class _FishingrodPageState extends State<FishingrodPage> {
  final FishingrodModel _model = FishingrodModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getBoxs();
  }

  getBoxs() async {
    await _model.repoGetBox();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FishingrodModel>(
      create: (_) => _model,
      builder: ((context, child) =>
          Consumer<FishingrodModel>(builder: (context, model, child) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('Cần câu'),
                actions: [
                  ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 1/2,
                              color: Colors.grey[100],
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                              controller: model
                                                  .fishingrodCodeController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Điền mã cần';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                labelText: 'Mã cần câu *',
                                              )),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                              controller: model
                                                  .fishingrodNameController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Điền tên cần';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                labelText: 'Tên cần câu *',
                                              )),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                              controller: model
                                                  .fishingrodPriceController,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Điền giá cần';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                labelText: 'Giá cần (K)*',
                                              )),
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            model.createFishingrod();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Processing Data')),
                                            );
                                          }
                                        },
                                        child: const Text('Tạo')),
                                    const SizedBox(
                                      height: 64,
                                    )
                                    // ElevatedButton(
                                    //   child: const Text('Close BottomSheet'),
                                    //   onPressed: () => Navigator.pop(context),
                                    // ),
                                  ],
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
              body: Column(children: [
                Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: model.fishingrods.length,
                      itemBuilder: ((context, index) => FishingrodItem(
                            fishingRod: model.fishingrods[index],
                          )),
                    )),
              ]),
            );
          })),
    );
  }
}
