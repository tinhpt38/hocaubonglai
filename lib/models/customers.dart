

class Customers {
  final String? id;
  final String? fullname;
  final String? phone;

  Customers({this.id, this.phone, this.fullname});

  // Map<String, dynamic> toJson() =>
  //     {'id': id, 'phone': phone, 'fullname': fullname};

  // factory Customers.fromJson(Map<String, dynamic> map) {
  //   return Customers(
  //       id: map['id'], fullname: map['fullname'], phone: map['phone']);
  // }

  // Customers.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
  //     : id = doc.id,
  //       fullname = doc.data()!["fullname"],
  //       phone = doc.data()!["phone"];
}
