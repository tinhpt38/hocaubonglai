// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:print_ticket/models/ticket.dart';
// import 'package:printing/printing.dart';

// class PrintTicket {
//   final Ticket ticket;

//   PrintTicket(this.ticket);

//   print() async {
//     final doc = pw.Document();

//     doc.addPage(pw.Page(
//         pageFormat: PdfPageFormat.roll57,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text('Tên khách: ${ticket.customer?.fullname ?? ""}'),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text('SĐT: ${ticket.customer?.phone ?? ""}'),
//               ),
//               pw.Divider(
//                 height: 2,
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text('Giá vé: ${ticket.price.toString()} K'),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text('Vị trí: ${ticket.seats}'),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text(
//                     'Loại cần: ${ticket.fishingrod?.name ?? ""} - ${ticket.fishingrodQuantity} cần'),
//               ),
//               pw.Divider(
//                 height: 2,
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text(
//                     'Giờ vào: ${DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeIn!)}'),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text(
//                     'Giờ ra: ${DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeOut!)}'),
//               ),
//             ],
//           ); // Center
//         })); // Page

//     await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => doc.save());
//   }
// }
