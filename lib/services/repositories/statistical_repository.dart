import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/tickets.dart';

class StatisticalRepository {
  final CollectionReference statis =
      FirebaseFirestore.instance.collection('Tickets');

  Future<List<Tickets>> getMonth(String month) async {
    List<Tickets> getStatis = [];
    await statis
        .where("createAtMonth", isEqualTo: month)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getStatis.add(Tickets(
            id: doc.id, price: double.tryParse(doc['price'].toString())));
      }
    });
    return getStatis;
  }
}
