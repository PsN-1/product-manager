import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? product;
  final String? description;
  final String? box;
  final String? code;
  final String? image;
  final String? quantity;

  Product({
    this.product,
    this.description,
    this.box,
    this.code,
    this.image,
    this.quantity,
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
      quantity: data?['Quantidade'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (product != null) "Produto": product,
      if (description != null) "Descricao": description,
      if (box != null) "Caixa": box,
      if (code != null) "Codigo": code,
      if (image != null) "Foto": image,
      if (quantity != null) "Quantidade": quantity,
    };
  }
}
