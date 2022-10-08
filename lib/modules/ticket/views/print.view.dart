import 'package:flutter/material.dart';
import 'package:print_ticket/modules/ticket/ticket.model.dart';
import 'package:provider/provider.dart';

class TicketPrintView extends StatelessWidget {
  const TicketPrintView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketModel>(
      builder: (context, model, child) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'VÉ CÂU',
                  ),
                ),
              ),
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('HỒ BỒNG LAI'),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Giờ vào: ${model.timeIn}'),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Giờ ra: ${model.timeOut}')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Vị trí ngồi: ${model.seatsController.text}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Số cần: ${model.fishingroldQuantityController.text} Loại cần: '),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Giá vé: ${model.total} K'),
              ),
              const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lưu ý: Cần giứ vé cẩn thận trong suốt ca câu'),
                  )),
              const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('LIÊN HỆ: MR. THANH 0868211119'),
              )),
            ],
          ),
        );
      },
    );
  }
}
