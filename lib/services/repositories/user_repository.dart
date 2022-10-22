import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:print_ticket/models/users.dart';

class UserRepository {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  Future<List<Users>> retrieveUser() async {
    List<Users> getUser = [];
    await users.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getUser.add(Users(
          id: doc.id,
          uID: doc['uID'].toString(),
          displayName: doc['displayName'].toString(),
          email: doc['email'].toString(),
          photoURL: doc['photoUrl'].toString(),
          role: doc['role'].toString(),
        ));
      }
    });
    return getUser;
  }
}
