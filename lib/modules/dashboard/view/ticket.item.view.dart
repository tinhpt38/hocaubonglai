import 'package:flutter/material.dart';
import 'package:print_ticket/models/tickets.dart';
import 'package:print_ticket/modules/dashboard/dashboard.model.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketItemView extends StatelessWidget {
  final Tickets ticket;
  final DashboardModel? onDeleteClick;
  final VoidCallback? onPrintClick;

  const TicketItemView(
      {super.key, required this.ticket, this.onDeleteClick, this.onPrintClick});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
            color: ticket.timeOut == null ? Colors.red[400] : Colors.white70,
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Tên khách: ${ticket.customer ?? ""}'),
                    IconButton(
                        onPressed: () async {
                          var url = Uri.parse("tel:${ticket.phone}");
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ))
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('SĐT: ${ticket.phone ?? ""}'),
            ),
            const Divider(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Giá vé: ${ticket.price.toString()} K'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Vị trí: ${ticket.seats}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Loại cần: ${ticket.fishingrod ?? ""} - ${ticket.fishingrodQuantity} cần'),
            ),
            const Divider(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Giờ vào: ${ticket.timeIn}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Giờ ra: ${ticket.timeOut}'),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      onDeleteClick?.deleteTicket(ticket.id.toString());
                    },
                    child: const Text('XOÁ'),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      onPrintClick != null ? onPrintClick!() : null;
                    },
                    child: const Text('IN VÉ'),
                  ),
                )
              ],
            )
          ],
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //       decoration: BoxDecoration(
  //           color: Colors.white70, borderRadius: BorderRadius.circular(8)),
  //       padding: const EdgeInsets.all(12),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(ticket.customer?.fullname ?? ""),
  //           Text('SĐT: ${ticket.customer?.phone ?? ""}'),
  //           Text('Giá vé: ${ticket.price.toString()} K'),
  //           Text('Vị trí: ${ticket.seats}'),
  //           Text(
  //               'Loại cần: ${ticket.fishingrod?.name ?? ""} - ${ticket.fishingrodQuantity} cần'),
  //           Text(
  //               'Giờ vào: ${DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeIn!)}'),
  //           Text(
  //               'Giờ ra: ${DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeOut!)}'),
  //           const Spacer(),
  //           Row(
  //             children: [
  //               Expanded(
  //                 flex: 1,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       widget.onDeleteClick != null
  //                           ? widget.onDeleteClick!()
  //                           : null;
  //                     },
  //                     child: const Text('XOÁ'),
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 1,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       widget.onPrintClick != null
  //                           ? widget.onPrintClick!()
  //                           : null;
  //                     },
  //                     child: const Text('IN VÉ'),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           )
  //         ],
  //       ));
  // }
}
