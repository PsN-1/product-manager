import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_manager/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _storageRef = FirebaseStorage.instance.ref();
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
const _productsCollection = 'Products';

class FirebaseService {
  static var dbRef = _firestore.collection(_productsCollection).withConverter(
        fromFirestore: Product.fromFirestore,
        toFirestore: (Product product, _) => product.toFirestore(),
      );

  static Stream<QuerySnapshot<Product>> getStreamSnapshotProducts() {
    return dbRef.where("ownerId", isEqualTo: getUserUID()).snapshots();
  }

  static Future createProduct(Product product) async {
    await dbRef.add(product);
  }

  static Future deleteProduct(String id) async {
    await dbRef.doc(id).delete();
  }

  static Future updateProduct(String id, Product product) async {
    await dbRef.doc(id).update(product.toFirestore());
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

    await imageRef.putFile(imageFile);
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
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    return _auth.currentUser != null;
  }

  static Future signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
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
