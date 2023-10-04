import 'package:product_manager/services/supabase.dart';

class RawProduct {
  final int? id;
  final String? name;
  final String? ownerId;

  RawProduct({
    this.id,
    this.name,
    this.ownerId,
  });

  factory RawProduct.fromMap(Map<String, dynamic>? data) {
    return RawProduct(
      id: data?['id'],
      name: data?['name'],
      ownerId: data?['owner_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (ownerId != null) "owner_id": ownerId,
    };
  }

  static Future createNewInstance(RawProduct product) async {
    await SupabaseService.createRawProduct(product);
  }
}
