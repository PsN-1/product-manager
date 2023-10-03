import 'package:product_manager/services/firebase.dart';

class Product {
  final int? id;
  final String? product;
  String? description;
  final String? box;
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

  factory Product.fromFirestore(
    DocumentSnapshotMapStringDynamic snapshot,
    ObjectSnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Product(
      product: data?['product'],
      description: data?['description'],
      box: data?['box'],
      code: data?['code'],
      ownerId: data?['owner_id'],
      image: data?['photo'],
      price: data?['price'],
      quantity: data?['quantity'],
      history:
          data?['Historico'] is Iterable ? List.from(data?['Historico']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (product != null) "Produto": product,
      if (description != null) "Descricao": description,
      if (box != null) "Caixa": box,
      if (code != null) "Codigo": code,
      if (ownerId != null) "ownerId": ownerId,
      if (image != null) "Foto": image,
      if (price != null) "Preco": price,
      if (quantity != null) "Quantidade": quantity,
      if (history != null) "Historico": history,
    };
  }

  factory Product.fromMap(Map<String, dynamic>? data) {
    return Product(
      product: data?['product']['name'],
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

  void saveToHistory(String oldValue, String newValue) {
    final date = _getDate();

    history ??= [];
    final newEntry = "$date - Qtd: $oldValue  ->  $newValue";

    history?.insert(0, newEntry);

    if (history!.length > 3) {
      history?.removeLast();
    }
  }

  Future saveNewImage(String imagePath) async {
    if (image != null) {
      await FirebaseService.removeImage(image!);
    }

    final newImageUrl =
        await FirebaseService.uploadImage(imagePath, _createImageName());
    image = newImageUrl;
  }

  static Future createNewInstance(Product product) async {
    await FirebaseService.createProduct(product);
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
