import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _storageRef = FirebaseStorage.instance.ref();

class AsyncImage extends StatelessWidget {
  final String image;
  const AsyncImage({super.key, required this.image});

  Future<String> getImage() async {
    final pathReference = _storageRef.child('$image.jpg');
    final imageUrl = await pathReference.getDownloadURL();
    return imageUrl;
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

  @override
  Widget build(BuildContext context) {
    if (!image.startsWith("https")) {
      return const SizedBox();
    }
    return Image(image: NetworkImage(image));

    // return FutureBuilder(
    //   future: getImage(),
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> imageData) {
    //     if (imageData.hasData) Image(image: NetworkImage(imageData.data));
    //
    //     if (imageData.hasError) const Text("Error loading image");
    //
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
  }
}
