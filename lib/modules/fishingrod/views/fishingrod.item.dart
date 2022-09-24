import 'package:flutter/material.dart';

import '../../../models/fishingrod.dart';

class FishingrodItem extends StatelessWidget {
  final FishingRod? fishingRod;
  const FishingrodItem({super.key, this.fishingRod});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black87, width: 0.5))),
      child: ListTile(
        leading: Text(fishingRod?.id ?? "",
            style: const TextStyle(
              fontSize: 14,
            )),
        title: Text(fishingRod?.name ?? "",
            style: const TextStyle(
              fontSize: 14,
            )),
        trailing: Text("${fishingRod?.price?.toStringAsFixed(0)} K",
            style: const TextStyle(
              fontSize: 14,
            )),
      ),
    );
  }
}
