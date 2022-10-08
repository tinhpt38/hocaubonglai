import 'package:flutter/material.dart';
import 'package:print_ticket/models/fishingrods.dart';

import '../../services/repositories/fishingrod.repository.dart';

class FishingrodModel extends ChangeNotifier {
  final FishingrodRepository fishingRodRepo = FishingrodRepository();
  final TextEditingController _fishingrodNameController =
      TextEditingController();
  get fishingrodNameController => _fishingrodNameController;
  final TextEditingController _fishingrodCodeController =
      TextEditingController();
  get fishingrodCodeController => _fishingrodCodeController;
  final TextEditingController _fishingrodPriceController =
      TextEditingController();
  get fishingrodPriceController => _fishingrodPriceController;

  List<FishingRods> _retrievedFishinGrods = [];
  List<FishingRods> get retrievedFishinGrods => _retrievedFishinGrods;

  Future<List<FishingRods>>? _fishinGrodsList;
  Future<List<FishingRods>>? get fishinGrodsList => _fishinGrodsList;

  getFishingRods() async {
    _retrievedFishinGrods = await fishingRodRepo.retrieveFishingRods();
    _fishinGrodsList = fishingRodRepo.retrieveFishingRods();
    notifyListeners();
  }

  createFishingrod() async {
    await fishingRodRepo.fishingRods.add({
      'name': _fishingrodNameController.text,
      'codeRod': _fishingrodCodeController.text,
      'price': double.tryParse(_fishingrodPriceController.text)
    });
    clearController();
    getFishingRods();
    notifyListeners();
  }

  updateFishingRod(String fishingRodsID) async {
    await fishingRodRepo.fishingRods.doc(fishingRodsID).update({
      'name': _fishingrodNameController.text,
      'codeRod': _fishingrodCodeController.text,
      'price': double.tryParse(_fishingrodPriceController.text)
    });
    clearController();
    getFishingRods();
    notifyListeners();
  }

  deleteFishingRod(String fishingRodsID) async {
    await fishingRodRepo.fishingRods.doc(fishingRodsID).delete();
    getFishingRods();
    notifyListeners();
  }

  clearController() {
    _fishingrodCodeController.clear();
    _fishingrodNameController.clear();
    _fishingrodPriceController.clear();
  }
}
