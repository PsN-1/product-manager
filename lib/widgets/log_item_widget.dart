import 'package:flutter/material.dart';
import 'package:product_manager/models/history_unity.dart';
import 'package:product_manager/models/log.dart';

class LogItemWidget extends StatelessWidget {
  final LogItem logItem;

  const LogItemWidget({super.key, required this.logItem});

  @override
  Widget build(BuildContext context) {
    final abbreviation = logItem.abbreviation?.rawValue ?? "";
    final oldValue = logItem.oldValue ?? "";
    final newValue = logItem.newValue ?? "";
    final date = logItem.date ?? "";

    const logTextStyle = TextStyle(
      fontSize: 18,
      color: Colors.black,
    );

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            date,
            textAlign: TextAlign.center,
            style: logTextStyle,
          ),
        ),
        Text(" - $abbreviation: $oldValue", style: logTextStyle),
        const Icon(Icons.arrow_right),
        Text(newValue, style: logTextStyle),
      ],
    );
  }
}
