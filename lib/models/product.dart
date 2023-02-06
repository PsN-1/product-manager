import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_manager/services/firebase.dart';

class Product {
  final String? product;
  String? description;
  final String? box;
  final String? code;
  String? price;
  String? image;
  String? quantity;
  List<String?>? history;

  Product({
    this.product,
    this.description,
    this.box,
    this.code,
    this.price,
    this.image,
    this.quantity,
    this.history,
  });

  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Product(
      product: data?['Produto'],
      description: data?['Descricao'],
      box: data?['Caixa'],
      code: data?['Codigo'],
      image: data?['Foto'],
      price: data?['Preco'],
      quantity: data?['Quantidade'],
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
      if (image != null) "Foto": image,
      if (price != null) "Preco": price,
      if (quantity != null) "Quantidade": quantity,
      if (history != null) "Historico": history,
    };
  }

  void addQuantity() {
    if (quantity != null) {
      quantity = (int.parse(quantity!) + 1).toString();
    }
  }

  void decreaseQuantity() {
    if (quantity != null) {
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

  static Future delete(String id) async {
    await FirebaseService.deleteProduct(id);
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
