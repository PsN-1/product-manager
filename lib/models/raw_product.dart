import 'package:product_manager/services/firebase.dart';

class RawProduct {
  final String? name;
  final String? ownerId;

  RawProduct({
    this.name,
    this.ownerId,
  });

  factory RawProduct.fromFirestore(
    DocumentSnapshotMapStringDynamic snapshot,
    ObjectSnapshotOptions? options,
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

  factory RawProduct.fromMap(Map<String, dynamic>? data) {
    return RawProduct(
      name: data?['Nome'],
      ownerId: data?['ownerId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (name != null) "Nome": name,
      if (ownerId != null) "ownerId": ownerId,
    };
  }

  static Future createNewInstance(RawProduct product) async {
    await FirebaseService.createRawProduct(product);
  }
}
