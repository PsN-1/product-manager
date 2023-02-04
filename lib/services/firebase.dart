import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_manager/models/product.dart';

final _firestore = FirebaseFirestore.instance;

class Firebase {
  static Stream<QuerySnapshot<Product>> getStreamSnapshotProducts() {
    return _firestore
        .collection('Products')
        .withConverter(
          fromFirestore: Product.fromFirestore,
          toFirestore: (Product product, _) => product.toFirestore(),
        )
        .snapshots();
  }

  static Future updateProduct(String id, Product product) async {
    await _firestore
        .collection('Products')
        .withConverter(
          fromFirestore: Product.fromFirestore,
          toFirestore: (Product product, _) => product.toFirestore(),
        )
        .doc(id)
        .update(
          product.toFirestore(),
        );
  }
}
