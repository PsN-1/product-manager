import 'package:product_manager/services/supabase.dart';

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
}

class Product {
  final int? id;
  final String? product;
  String? description;
  String? box;
  final String? code;
  final String? ownerId;
  String? price;
  String? image;
  String? quantity;
  List<String?>? history;

  Product({
    this.id,
    this.product,
    this.description,
    this.box,
    this.code,
    this.ownerId,
    this.price,
    this.image,
    this.quantity,
    this.history,
  });

  factory Product.fromMap(Map<String, dynamic>? data) {
    return Product(
      product: data?['product'],
      id: data?['id'],
      description: data?['description'],
      box: data?['box'],
      code: data?['code'],
      ownerId: data?['owner_id'],
      image: data?['photo'],
      price: data?['price'],
      quantity: data?['quantity'],
      history:
          data?['history'] is Iterable ? List.from(data?['history']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      if (product != null) "product": product,
      if (description != null) "description": description,
      if (box != null) "box": box,
      if (code != null) "code": code,
      if (ownerId != null) "owner_id": ownerId,
      if (image != null) "photo": image,
      if (price != null) "price": price,
      if (quantity != null) "quantity": quantity,
      if (history != null) "history": history,
    };
  }

  void addQuantity() {
    if (quantity != null) {
      quantity = (int.parse(quantity!) + 1).toString();
    }
  }

  void decreaseQuantity() {
    if (quantity != null) {
      if (quantity == "0") {
        return;
      }
      quantity = (int.parse(quantity!) - 1).toString();
    }
  }

  void saveToHistory({
    required String oldValue,
    required String newValue,
    HistoryUnity unity = HistoryUnity.quantity,
  }) {
    final date = _getDate();

    history ??= [];

    String item = unity.rawValue;
    final newEntry = "$date - $item: $oldValue  ⇨  $newValue";

    history?.insert(0, newEntry);
  }

  Future saveNewImage(String imagePath) async {
    if (image != null) {
      await SupabaseService.removeImage(image!);
    }

    final newImageUrl =
        await SupabaseService.uploadImage(imagePath, _createImageName());
    image = newImageUrl;
  }

  Future getImageUrl() async {
    if (image != null) {
      return await SupabaseService.getImageUrl(image!);
    }
  }

  static Future createNewInstance(Product product) async {
    await SupabaseService.createProduct(product);
  }

  String _createImageName() {
    return "$product-$description-${DateTime.now()}";
  }

  String _getDate() {
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var year = DateTime.now().year - 2000;

    return "$day/$month/$year";
  }
}
