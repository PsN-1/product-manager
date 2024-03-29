import 'package:flutter/foundation.dart';
import 'package:product_manager/models/log.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/models/raw_product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;
final _auth = _supabase.auth;
final _storageRef = _supabase.storage.from("product-manager");
const _productsCollection = 'Products';
const _productsListCollection = 'ProductsList';
const _logs = 'Logs';

class SupabaseService {
  static var productsRef = _supabase.from(_productsCollection);

  static var listOfProductsRef = _supabase.from(_productsListCollection);

  static var logsRef = _supabase.from(_logs);

  static Stream<dynamic> getProductsFiltered({
    required String searchText,
    required String column,
  }) {
    if (searchText.isEmpty) {
      return productsRef.select().asStream();
    }

    if (column == "box") {
      return productsRef.select().eq(column, searchText).asStream();
    }

    if (column == "log") {
      return logsRef
          .select('product_id')
          .like("date", '%$searchText%')
          .then((response) {
        final productIds =
            response.map((e) => e['product_id'].toString()).toSet().toList();
        return productsRef.select().inFilter('id', productIds);
      }).asStream();
    }

    return productsRef.select().ilike(column, '%$searchText%').asStream();
  }

  static var getFutureProductsList =
      listOfProductsRef.stream(primaryKey: ['id']);

  static Future<List<LogItem>> getLogs(String productId) async {
    final response = await logsRef.select().eq('product_id', productId);
    return response.map((e) => LogItem.fromMap(e)).toList().reversed.toList();
  }

  static Future saveLog(LogItem log) async {
    try {
      await logsRef.insert(log.toMap());
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static Future<bool> deleteProduct(int? id) async {
    try {
      if (id != null) {
        await productsRef.delete().match({'id': id});
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProduct(int? id, Product product) async {
    try {
      if (id != null) {
        await productsRef.update(product.toMap()).match({'id': id});
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future createProduct(Product product) async {
    await productsRef.insert(product.toMap());
  }

  static Future createRawProduct(RawProduct product) async {
    await listOfProductsRef.insert(product.toMap());
  }

  // Image

  static Future<String> getImageUrl(String image) async {
    final pathReference = await _storageRef.createSignedUrl(image, 3600);

    return pathReference;
  }

  static Future<String> uploadImage(
      Uint8List imagePath, String imageName) async {
    final userId = getUserUID();
    final path = 'photos/$userId/$imageName';

    try {
      await _storageRef.uploadBinary(
        path,
        imagePath,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error while uploading the image");
        print(e);
      }
    }

    const tenYears = 60 * 60 * 24 * 365 * 10;
    return _storageRef.createSignedUrl(path, tenYears);
  }

  static Future removeImage(String imageUrl) async {
    try {
      await _storageRef.remove([imageUrl]);
    } catch (e) {
      if (kDebugMode) {
        print("Error while removing the image");
        print(e);
      }
    }
  }

  // Login

  static Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
      return _auth.currentUser != null;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  static Future<bool> signUp(String email, String password) async {
    try {
      await _auth.signUp(email: email, password: password);
      return _auth.currentUser != null;
    } catch (e) {
      if (kDebugMode) print(e);
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
