import 'package:flutter/services.dart';
import 'package:product_manager/models/history_unity.dart';
import 'package:product_manager/models/log.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:uuid/uuid.dart';

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
  String? imageLastPath;

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
    this.imageLastPath,
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
      imageLastPath: data?['imageLastPath'],
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
      if (imageLastPath != null) "imageLastPath": imageLastPath,
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
    LogItem.saveLog(
      productId: id ?? 0,
      oldValue: oldValue,
      newValue: newValue,
      unity: unity,
    );
  }

  Future saveNewImage(Uint8List imagePath) async {
    try {
      if (image != null) {
        await SupabaseService.removeImage(image!);
      }

      final newImageUrl =
          await SupabaseService.uploadImage(imagePath, _createImageName());
      image = newImageUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future getImageUrl() async {
    if (image != null) {
      return await SupabaseService.getImageUrl(image!);
    }
  }

  static Future createNewInstance(Product product) async {
    final createdProduct = await SupabaseService.createProduct(product);
    createdProduct.saveToHistory(
      oldValue: '',
      newValue: "Produto Criado.",
      unity: HistoryUnity.observation,
    );
  }

  String _createImageName() {
    const uuid = Uuid();

    return "$uuid-${DateTime.now()}";
  }
}
