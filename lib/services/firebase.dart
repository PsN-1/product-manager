import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:product_manager/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:product_manager/models/raw_product.dart';
import 'package:product_manager/widgets/pickable_async_image.dart';

final _storageRef = FirebaseStorage.instance.ref();
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
const _productsCollection = 'Products';
const _productsListCollection = 'ProductsList';

typedef QuerySnapshotRawProduct = QuerySnapshot<RawProduct>;
typedef QuerySnapshotProduct = QuerySnapshot<Product>;
typedef DocumentSnapshotMapStringDynamic
    = DocumentSnapshot<Map<String, dynamic>>;
typedef ObjectSnapshotOptions = SnapshotOptions;

class FirebaseService {
  static var productsRef =
      _firestore.collection(_productsCollection).withConverter(
            fromFirestore: Product.fromFirestore,
            toFirestore: (Product product, _) => product.toFirestore(),
          );

  static var listOfProductsRef =
      _firestore.collection(_productsListCollection).withConverter(
            fromFirestore: RawProduct.fromFirestore,
            toFirestore: (RawProduct rawProduct, _) => rawProduct.toFirestore(),
          );

  static Stream<QuerySnapshot<RawProduct>> getStreamSnapshotProductsList() {
    return listOfProductsRef
        .where("ownerId", isEqualTo: getUserUID())
        .snapshots();
  }

  static Stream<QuerySnapshot<Product>> getStreamSnapshotProducts() {
    return productsRef.where("ownerId", isEqualTo: getUserUID()).snapshots();
  }

  static Future createRawProduct(RawProduct product) async {
    await listOfProductsRef.add(product);
  }

  static Future createProduct(Product product) async {
    await productsRef.add(product);
  }

  static Future deleteProduct(String id) async {
    await productsRef.doc(id).delete();
  }

  static Future updateProduct(String id, Product product) async {
    await productsRef.doc(id).update(product.toFirestore());
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

  static Future<String> uploadImage(String imagePath, String imageName) async {
    final imageRef = _storageRef.child(imageName);
    File imageFile = File(imagePath);

    if (kIsWeb) {
      await imageRef.putData(newImageForWeb);
    } else {
      await imageRef.putFile(imageFile);
    }

    String imageUrl = await imageRef.getDownloadURL();
    return imageUrl;
  }

  static Future removeImage(String imageUrl) async {
    try {
      final imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await imageRef.delete();
    } catch (e) {
      print("Error while removing the image");
      print(e);
    }
  }

  static Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  static Future checkUser() async {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  static String getUserUID() {
    return (_auth.currentUser != null) ? _auth.currentUser!.uid : "";
  }

  static Future signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
