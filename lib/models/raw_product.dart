
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_manager/services/firebase.dart';

class RawProduct {
  final String? name;
  final String? ownerId;

  RawProduct({
    this.name,
    this.ownerId,
  });

  factory RawProduct.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RawProduct(
      name: data?['Nome'],
      ownerId: data?['ownerId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "Nome": name,
      if (ownerId != null) "ownerId": ownerId,
    };
  }
  
  static Future createNewInstance(RawProduct product) async {
    await FirebaseService.createRawProduct(product);
  }
}
