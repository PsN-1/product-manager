import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/models/raw_product.dart';
import 'package:product_manager/screens/home_page.dart';
import 'package:product_manager/screens/login.dart';
import 'package:product_manager/screens/signup.dart';
import 'package:product_manager/services/firebase.dart';
import 'firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await updateProducts();
  // await updateOnwer();
  // await updateProductsList();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: (FirebaseService.getCurrentUser() != null)
          ? HomePage.id
          : LoginPage.id,
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        SignupPage.id: (context) => SignupPage(),
        HomePage.id: (context) => const HomePage(),
      },
    );
  }
}

Future updateProductsList() async {
  var dbref = FirebaseService.listOfProductsRef;
  final productsData = await _loadDefaultProducts();
  final products = productsData.split("\n").toList();

  for (var product in products) {
    const ownerId = "oGTtnKtEG5eyoqTX1YVZo39pM7f2";
    await dbref.add(RawProduct(name: product, ownerId: ownerId));
  print("$product uploaded");
  }
  print("finish update");
}

Future<String> _loadDefaultProducts() async {
  return await rootBundle.loadString('assets/products.txt');
}

Future updateOnwer() async {
  var dbRef = FirebaseService.productsRef;

  var products = await dbRef.get();
  for (var product in products.docs) {
    if (product.data().ownerId == null) {
      //   final newProduct = product.data();
      //   newProduct.ownerId = "oGTtnKtEG5eyoqTX1YVZo39pM7f2";
      //   await FirebaseService.updateProduct(product.id, newProduct);
      //   print("${product.id} updated");
    }
  }
  // print('FinishUpdate');
}

Future updateProducts() async {
  var db = FirebaseFirestore.instance;
  var productsCollection = db.collection('Products').withConverter(
        fromFirestore: Product.fromFirestore,
        toFirestore: (Product product, _) => product.toFirestore(),
      );

  var products = await productsCollection.get();
  for (var product in products.docs) {
    if (product.data().image != null) {
      if (product.data().image!.isNotEmpty) {
        if (product.data().image!.startsWith("https")) {
          continue;
        }

        var imageUrl =
            await FirebaseService.getImageUrl(product.data().image ?? "");

        if (imageUrl.isNotEmpty) {
          if (product.data().image != imageUrl) {
            await productsCollection.doc(product.id).update({"Foto": imageUrl});
          }
        }
      }
    }
  }
}
