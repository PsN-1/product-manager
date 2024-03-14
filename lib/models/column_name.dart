enum ColumnName { product, description, box, log }

extension ColumnNameExtension on ColumnName {
  String get name {
    switch (this) {
      case ColumnName.product:
        return "product";
      case ColumnName.description:
        return "description";
      case ColumnName.box:
        return "box";
      case ColumnName.log:
        return "log";
    }
  }
}
