import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:print_ticket/models/fishingrod.dart';
import 'package:print_ticket/services/repositories/fishingrod.repository.dart';

class FishingrodModel extends ChangeNotifier {
  final TextEditingController _fishingrodNameController =
      TextEditingController();
  get fishingrodNameController => _fishingrodNameController;
  final TextEditingController _fishingrodCodeController =
      TextEditingController();
  get fishingrodCodeController => _fishingrodCodeController;
  final TextEditingController _fishingrodPriceController =
      TextEditingController();
  get fishingrodPriceController => _fishingrodPriceController;



  final FishingrodRepository _repo = FishingrodRepository();

  List<FishingRod> _fishingrods = [];
  List<FishingRod> get fishingrods => _fishingrods;

  repoGetBox() async {
    await _repo.getBox();
    _fishingrods = _repo.gets();
    notifyListeners();
  }

  createFishingrod() {
    FishingRod fishingRod = FishingRod(
        id: fishingrodCodeController.text,
        name: fishingrodNameController.text,
        price: double.tryParse(fishingrodPriceController.text));

    _repo.add(fishingRod);
    fishingrods.add(fishingRod);
    clearController();
    notifyListeners();
  }

  clearController(){
    _fishingrodCodeController.clear();
    _fishingrodNameController.clear();
    _fishingrodPriceController.clear();
  }
}
