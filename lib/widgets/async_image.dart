import 'package:flutter/material.dart';

class AsyncImage extends StatefulWidget {
  final String image;

  const AsyncImage({super.key, required this.image});

  @override
  State<AsyncImage> createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  @override
  Widget build(BuildContext context) {
    return (!widget.image.startsWith("https"))
        ? const SizedBox()
        : Image.network(widget.image);
  }
}
