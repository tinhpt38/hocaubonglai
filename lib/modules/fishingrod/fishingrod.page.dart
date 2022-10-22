import 'package:flutter/material.dart';
import 'package:print_ticket/models/fishingrods.dart';

import 'package:print_ticket/modules/fishingrod/fishingrod.model.dart';
import 'package:print_ticket/modules/home/home.model.dart';
import 'package:provider/provider.dart';

class FishingrodPage extends StatefulWidget {
  const FishingrodPage({super.key});

  @override
  State<FishingrodPage> createState() => _FishingrodPageState();
}

class _FishingrodPageState extends State<FishingrodPage> {
  final FishingrodModel _model = FishingrodModel();
  final HomeModel _modelHome = HomeModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _model.getFishingRods();
    await _modelHome.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FishingrodModel>(
      create: (_) => _model,
      builder:
          ((context, child) =>
              Consumer<FishingrodModel>(builder: (context, model, child) {
                return Scaffold(
                    resizeToAvoidBottomInset: false,
                    floatingActionButton: FloatingActionButton(
                        onPressed: model.getFishingRods,
                        child: const Icon(Icons.refresh)),
                    appBar: AppBar(
                      centerTitle: !_modelHome.isAdmin,
                      title: const Text('Cần câu'),
                      actions: [
                        _modelHome.isAdmin == true
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  show(model, true, '');
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Thêm'))
                            : Container()
                      ],
                    ),
                    body: FutureBuilder(
                        future: _model.fishinGrodsList,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<FishingRods>> snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.retrievedFishinGrods.length,
                              itemBuilder: (context, index) {
                                final FishingRods fishingRods =
                                    model.retrievedFishinGrods[index];
                                return Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: ListTile(
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            fishingRods.name.toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(fishingRods.codeRod.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text('${fishingRods.price} K',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                        trailing: SizedBox(
                                            width: 100,
                                            child: _modelHome.isAdmin == true
                                                ? Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () async {
                                                            await model.setData(
                                                                fishingRods
                                                                    .codeRod
                                                                    .toString(),
                                                                fishingRods.name
                                                                    .toString(),
                                                                fishingRods
                                                                    .price
                                                                    .toString());
                                                            show(
                                                                model,
                                                                false,
                                                                fishingRods.id
                                                                    .toString());
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color: Colors.green,
                                                          )),
                                                      IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (
                                                                  BuildContext
                                                                      context,
                                                                ) =>
                                                                    AlertDialog(
                                                                      title:
                                                                          const Center(
                                                                        child: Text(
                                                                            'Xóa cần câu?'),
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        fishingRods
                                                                            .name
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'Không'),
                                                                          child:
                                                                              const Text('Không'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            model.deleteFishingRod(fishingRods.id.toString());
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('Xóa'),
                                                                        ),
                                                                      ],
                                                                    ));
                                                          },
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.red)),
                                                    ],
                                                  )
                                                : Container())),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }));
              })),
    );
  }

  void show(FishingrodModel model, bool isAdd, String fishingRodsID) {
    showModalBottomSheet<void>(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: MediaQuery.of(context).size.height * 1 / 2,
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
                            controller: model.fishingrodCodeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                            controller: model.fishingrodNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                            controller: model.fishingrodPriceController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                        if (_formKey.currentState!.validate()) {
                          isAdd == true
                              ? model.createFishingrod()
                              : model.updateFishingRod(fishingRodsID);
                          Navigator.pop(context);
                        }
                      },
                      child: isAdd == true
                          ? const Text('Tạo')
                          : const Text('Cập nhật')),
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
  }
}
