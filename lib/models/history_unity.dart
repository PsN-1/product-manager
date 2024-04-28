enum HistoryUnity {
  quantity,
  box,
  description,
  price,
  observation,
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
        return "Preço";
      case HistoryUnity.observation:
        return "Obs";
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
      case "Preço":
        return HistoryUnity.price;
      case "Obs":
        return HistoryUnity.observation;
      default:
        return HistoryUnity.quantity;
    }
  }
}
