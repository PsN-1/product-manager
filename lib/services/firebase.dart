import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_manager/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _storageRef = FirebaseStorage.instance.ref();
final _firestore = FirebaseFirestore.instance;

class FirebaseService {
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

  static Future<String> getImageUrl(String image) async {
    final pathReference = _storageRef.child('$image.jpg');
    try {
      final imageUrl = await pathReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return "";
    }
  }

  Future<String> getImage(String image) async {
    final pathReference = _storageRef.child('$image.jpg');
    final imageUrl = await pathReference.getDownloadURL();
    return imageUrl;
  }

  static Future<String> uploadImage(String imagePath) async {
    final imageRef = _storageRef.child(imagePath);
    File imageFile = File(imagePath);

    await imageRef.putFile(imageFile);
    String imageUrl = await imageRef.getDownloadURL();
    return imageUrl;
  }

  static Future removeImage(String imageUrl) async {
    final imageRef = FirebaseStorage.instance.refFromURL(imageUrl) ;
    await imageRef.delete();
  }
}
