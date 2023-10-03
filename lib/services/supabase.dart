import 'package:product_manager/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;
final _auth = _supabase.auth;

const _productsCollection = 'Products';
const _productsListCollection = 'ProductsList';

class SupabaseService {
  static var productsRef = _supabase.from(_productsCollection);
  // .withConverter<Product>((data) => Product.fromMap(data));

  static var listOfProductsRef = _supabase.from(_productsListCollection);
  // .withConverter<RawProduct>((data) => RawProduct.fromMap(data));

  static var getStreamSnapshotProducts =
      _supabase.from(_productsCollection).select<List<Product>>();

  static Future deleteProduct(int? id) async {
    if (id != null) {
      await productsRef.delete().match({'id': id});
    }
  }

  static Future updateProduct(int? id, Product product) async {
    if (id != null) {
      await productsRef.update(product.toMap()).match({'id': id});
    }
  }

  // Login

  static Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
      return _auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signUp(String email, String password) async {
    try {
      await _auth.signUp(email: email, password: password);
      return _auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  static String getUserUID() {
    return (_auth.currentUser != null) ? _auth.currentUser!.id : "";
  }

  static Future signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
