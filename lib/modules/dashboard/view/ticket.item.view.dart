import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../models/ticket.dart';

class TicketItemView extends StatelessWidget {
  final DateTime _now = DateTime.now();
  final Ticket ticket;
  final VoidCallback? onDeleteClick;
  final VoidCallback? onPrintClick;

  TicketItemView({super.key, required this.ticket, this.onDeleteClick, this.onPrintClick});
  

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
            color: _now.isAfter(ticket.timeOut!)
                ? Colors.red[400]
                : Colors.white70,
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Tên khách: ${ticket.customer?.fullname ?? ""}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('SĐT: ${ticket.customer?.phone ?? ""}'),
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
                  'Loại cần: ${ticket.fishingrod?.name ?? ""} - ${ticket.fishingrodQuantity} cần'),
            ),
            const Divider(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Giờ vào: ${DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeIn!)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Giờ ra: ${DateFormat('HH:mm dd/MM/yyyy').format(ticket.timeOut!)}'),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      onDeleteClick != null
                          ? onDeleteClick!()
                          : null;
                    },
                    child: const Text('XOÁ'),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      onPrintClick != null
                          ? onPrintClick!()
                          : null;
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
