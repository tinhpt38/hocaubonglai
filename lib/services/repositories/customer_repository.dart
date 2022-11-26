import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:print_ticket/models/customers.dart';

class CustomerRepository {
  final CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');

  Future<List<Customers>> retrieveCustomers() async {
    List<Customers> getCustomers = [];
    await customers.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getCustomers.add(Customers(
            id: doc.id,
            fullname: doc['fullname'].toString() == ''
                ? 'Admin Test'
                : doc['fullname'].toString(),
            phone: doc['phone'].toString() == ''
                ? '197420'
                : doc['phone'].toString()));
      }
    });

    return getCustomers;
  }
}
