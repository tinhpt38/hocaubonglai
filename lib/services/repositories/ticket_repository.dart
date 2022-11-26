import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:print_ticket/models/tickets.dart';

class TicketRepository {
  final CollectionReference ticketBox =
      FirebaseFirestore.instance.collection('Tickets');
  Future<List<Tickets>> retrieveTicket(String getCurrentDate) async {
    List<Tickets> getTicket = [];

    await ticketBox
        .where("createAt", isEqualTo: getCurrentDate)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getTicket.add(Tickets(
          id: doc.id,
          timeIn: doc['timeIn'].toString(),
          timeOut: doc['timeOut'].toString(),
          // seats: doc['seats'].toString(),
          fishingrodQuantity: doc['fishingrodQuantity'].toString(),
          customer: doc['customer'].toString(),
          price: doc['price'].toDouble(),
          fishingrod: doc['fishingRod'].toString(),
          phone: doc['phone'].toString(),
          count: doc['count'].toInt(),
        ));
      }
    });

    return getTicket;
  }

  Future<List<Tickets>> retrieveAllTicket(String month) async {
    List<Tickets> getTicket = [];
    await ticketBox
        .where("createAtMonth", isEqualTo: month)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getTicket.add(Tickets(
          id: doc.id,
          timeIn: doc['timeIn'].toString(),
          timeOut: doc['timeOut'].toString(),
          fishingrodQuantity: doc['fishingrodQuantity'].toString(),
          customer: doc['customer'].toString(),
          price: doc['price'].toDouble(),
          fishingrod: doc['fishingRod'].toString(),
          phone: doc['phone'].toString(),
          count: doc['count'].toInt(),
        ));
      }
    });
    return getTicket;
  }
}
