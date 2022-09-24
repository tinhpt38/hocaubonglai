import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:print_ticket/modules/fishingrod/fishingrod.model.dart';
import 'package:provider/provider.dart';

class FishingrodCreateView extends StatefulWidget {
  const FishingrodCreateView({super.key});

  @override
  State<FishingrodCreateView> createState() => _FishingrodCreateViewState();
}

class _FishingrodCreateViewState extends State<FishingrodCreateView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller:
                        context.read<FishingrodModel>().fishingrodCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Mã cần câu *',
                    )),
              )),
          Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller:
                        context.read<FishingrodModel>().fishingrodNameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên cần câu *',
                    )),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller:
                        context.read<FishingrodModel>().fishingrodPriceController,
                      keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Giá cần (K)*',
                    )),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child:
                    ElevatedButton(onPressed:  context.read<FishingrodModel>().createFishingrod, child: const Text('Tạo')),
              )),
        ],
      ),
    );
  }
}
