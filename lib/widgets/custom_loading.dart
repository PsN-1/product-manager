import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';

class CustomModalHUD extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const CustomModalHUD(
      {super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator(color: kPrimaryColor),
      child: child,
    );
  }
}
