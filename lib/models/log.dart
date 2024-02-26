import 'package:product_manager/models/history_unity.dart';
import 'package:product_manager/services/supabase.dart';

class LogItem {
  final String? ownerId;
  final int? productId;
  final String? date;
  final HistoryUnity? abbreviation;
  final String? oldValue;
  final String? newValue;

  LogItem({
    this.ownerId,
    this.productId,
    this.date,
    this.abbreviation,
    this.oldValue,
    this.newValue,
  });

  Map<String, dynamic> toMap() {
    return {
      if (ownerId != null) "owner_id": ownerId,
      if (productId != null) "product_id": productId,
      if (date != null) "date": date,
      if (abbreviation != null) "abbreviation": abbreviation?.rawValue,
      if (oldValue != null) "old_value": oldValue,
      if (newValue != null) "new_value": newValue,
    };
  }

  factory LogItem.fromMap(Map<String, dynamic>? data) {
    return LogItem(
      ownerId: data?['owner_id'],
      productId: data?['product_id'],
      date: data?['date'],
      abbreviation: HistoryUnityExtension.fromString(data?['abbreviation']),
      oldValue: data?['old_value'],
      newValue: data?['new_value'],
    );
  }

  static void saveLog({
    required int productId,
    required String oldValue,
    required String newValue,
    required HistoryUnity unity,
  }) {
    final log = LogItem(
      ownerId: SupabaseService.getUserUID(),
      productId: productId,
      date: _getDate(),
      abbreviation: unity,
      oldValue: oldValue,
      newValue: newValue,
    );

    SupabaseService.saveLog(log);
  }

  static String _getDate() {
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var year = DateTime.now().year - 2000;

    return "$day/$month/$year";
  }
}
