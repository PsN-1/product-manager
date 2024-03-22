import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';

class BoxButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final bool isPrimary;

  const BoxButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, right: 25, left: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isPrimary ? K.primaryColor : Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 6,
              color: const Color(0xff000000).withOpacity(0.16),
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isPrimary ? Colors.white : K.primaryColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
