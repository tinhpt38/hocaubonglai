import 'package:intl/intl.dart';

parseDDMMYYYYHHM(String date) {
  var inputFormat = DateFormat('HH:mm dd/MM/yyyy');
  var value = inputFormat.parse(date);
  return value;
}

parseDDMMYYYY(String date) {
  var inputFormat = DateFormat('HH:mm dd/MM/yyyy');
  var value = inputFormat.parse(date);
  return value;
}
