enum HistoryUnity {
  quantity,
  box,
  description,
  price,
}

extension HistoryUnityExtension on HistoryUnity {
  String get rawValue {
    switch (this) {
      case HistoryUnity.quantity:
        return "Qtd";
      case HistoryUnity.box:
        return "Caixa";
      case HistoryUnity.description:
        return "Desc";
      case HistoryUnity.price:
        return "\$";
    }
  }

  // create fromString method
  static HistoryUnity fromString(String value) {
    switch (value) {
      case "Qtd":
        return HistoryUnity.quantity;
      case "Caixa":
        return HistoryUnity.box;
      case "Desc":
        return HistoryUnity.description;
      case "\$":
        return HistoryUnity.price;
      default:
        return HistoryUnity.quantity;
    }
  }
}
