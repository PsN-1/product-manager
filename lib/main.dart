import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/home_page.dart';
import 'package:product_manager/widgets/async_image.dart';
import 'firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await updateProducts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
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

        var imageUrl = await AsyncImage.getImageUrl(product.data().image ?? "");

        if (imageUrl.isNotEmpty) {
          if (product.data().image != imageUrl) {
            await productsCollection.doc(product.id).update({"Foto": imageUrl});
          }
        }
      }
    }
  }
}
