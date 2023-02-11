import 'package:flutter/material.dart';

class WhiteBox extends StatefulWidget {
  final Widget child;

  const WhiteBox({super.key, required this.child});

  @override
  State<WhiteBox> createState() => _WhiteBoxState();
}

class _WhiteBoxState extends State<WhiteBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 6,
              color: const Color(0xff000000).withOpacity(0.16),
            )
          ],
        ),
        height: 50,
        child: widget.child);
  }
}

class BoxTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscure;

  const BoxTextField(
      {super.key,
      required this.controller,
      this.hintText,
      this.obscure = false});

  @override
  State<BoxTextField> createState() => _BoxTextFieldState();
}

class _BoxTextFieldState extends State<BoxTextField> {
  @override
  Widget build(BuildContext context) {
    return WhiteBox(
      child: TextField(
        obscureText: widget.obscure,
        style: const TextStyle(backgroundColor: Colors.white),
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          border: InputBorder.none,
          hintText: widget.hintText,
        ),
        controller: widget.controller,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
