import 'package:hive/hive.dart';
import 'package:print_ticket/models/ticket.dart';

class TicketRepository {
  static final TicketRepository _instance = TicketRepository._internal();

  late Box box;
  factory TicketRepository() => _instance;
  TicketRepository._internal();

  var dbName = "tickets";

  getBox() async {
    box = await Hive.openBox<Ticket>(dbName);
    return box;
  }

  Box add(Ticket data) {
    box.add(data);
    return box;
  }

  Box update(Ticket data) {
    data.save();
    return box;
  }

  gets() {
    return box.values.toList();
  }

  delete(Ticket value) {
    value.delete();
  }
}
