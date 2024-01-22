import 'package:product_manager/models/product.dart';

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

    bool hasHistoryDate = checkHasHistoryDate(searchText, product.history);

    return hasProductText ||
        hasDescriptionText ||
        hasBoxNumber ||
        hasHistoryDate;
  }

  bool test(Product product) {
    if (searchText.isEmpty) {
      return true;
    }

    if (product.product?.toLowerCase().contains(searchText.toLowerCase()) ??
        false) {
      return true;
    }

    if (product.description?.toLowerCase().contains(searchText.toLowerCase()) ??
        false) {
      return true;
    }

    if (product.box == searchText) {
      return true;
    }

    if (checkHasHistoryDate(searchText, product.history)) {
      return true;
    }

    return false;
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
