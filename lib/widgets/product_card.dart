import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:product_manager/models/product.dart';

final _storageRef = FirebaseStorage.instance.ref();

class ImageHelper extends StatelessWidget {
  String? image;

  ImageHelper({this.image});

  Future<String> getImage() async {
    final pathReference = _storageRef.child('$image.jpg');
    final imageUrl = await pathReference.getDownloadURL();
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImage(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> something) {
          if (something.hasData) {
            return Image(image: NetworkImage(something.data));
          }
          return const Text('no Image Found');
        });
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final String? image;
  final void Function() onTap;

  const ProductCard(
      {super.key, required this.product, this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(15),
        child: PhysicalModel(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageHelper(image: product.image),
                Text(
                  product.product ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.description ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Caixa: ${product.box}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Qtd: ${product.quantity}',
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  // final product = Product(
  //   description: 'Lâmina de Ralar do Super Chef',
  //   box: "67",
  //   code: "1396",
  //   image: "lamina_3_super_chef_JPG",
  //   product: 'Lâmina Jullienne Super Chefe',
  //   quantity: '2',
  // );
