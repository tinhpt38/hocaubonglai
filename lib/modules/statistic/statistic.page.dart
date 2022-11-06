import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

String? month;

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thống kê')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thống kê theo tháng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {
                  DatePicker.showPicker(context, onConfirm: (time) {
                    setState(() {
                      month = '${time.month}/${time.year}';
                      // (model.rootPath != null)
                      //     ? model.exportExcel(context, month, false)
                      //     : null;
                    });
                    print(month);
                  },
                      pickerModel: CustomMonthPicker(
                          minTime: DateTime(2022, 9, 1),
                          maxTime: DateTime.now(),
                          currentTime: DateTime.now(),
                          locale: LocaleType.vi));
                },
                child: const Text('Chọn tháng')),
            const Text(
              'Thống kê theo năm',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {
                  DatePicker.showPicker(context, onConfirm: (time) {
                    setState(() {
                      month = '${time.month}/${time.year}';
                      // (model.rootPath != null)
                      //     ? model.exportExcel(context, month, false)
                      //     : null;
                    });
                    print(month);
                  },
                      pickerModel: CustomMonthPicker(
                          minTime: DateTime(2022, 9, 1),
                          maxTime: DateTime.now(),
                          currentTime: DateTime.now(),
                          locale: LocaleType.vi));
                },
                child: const Text('Chọn năm'))
          ],
        ),
      ),
    );
  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker(
      {required DateTime currentTime,
      required DateTime minTime,
      required DateTime maxTime,
      required LocaleType locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
