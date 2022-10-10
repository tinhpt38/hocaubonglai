
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:print_ticket/models/fishingrods.dart';

class FishingrodRepository {
  final CollectionReference fishingRods =
      FirebaseFirestore.instance.collection('FishingRod');

  Future<List<FishingRods>> retrieveFishingRods() async {
    List<FishingRods> getFishingRods = [];
    await fishingRods.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getFishingRods.add(FishingRods(
          id: doc.id,
          name: doc['name'].toString(),
          codeRod: doc['codeRod'].toString(),
          price: doc['price'].toString(),
        ));
      }
    });
    return getFishingRods;
  }
}
