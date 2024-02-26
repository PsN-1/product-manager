import 'package:product_manager/models/product.dart';
import 'package:product_manager/services/supabase.dart';

class ProductsStreamViewModel {
  String searchText = "";

  bool isFilteredProduct(Product product) {
    if (searchText.isEmpty) {
      return true;
    }

    bool hasProductText =
        product.product?.toLowerCase().contains(searchText.toLowerCase()) ??
            false;
    bool hasDescriptionText =
        product.description?.toLowerCase().contains(searchText.toLowerCase()) ??
            false;
    bool hasBoxNumber = product.box == searchText;

    // bool hasHistoryDate = await searchDate(searchText, product.id ?? 0);

    return hasProductText || hasDescriptionText || hasBoxNumber;
    // || hasHistoryDate;
  }

  Future<bool> searchDate(String searchText, int productId) async {
    final logs = await SupabaseService.getLogsIdByDate(searchText);
    return logs.contains(productId.toString());
  }

  bool checkHasHistoryDate(String searchText, List<String?>? history) {
    if (history == null) {
      return false;
    }

    for (final element in history) {
      if (element == null) {
        continue;
      }
      if (element.startsWith(searchText)) {
        return true;
      }
    }

    return false;
  }
}
