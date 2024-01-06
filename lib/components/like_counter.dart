import 'package:flutter/material.dart';

class LikeCounter extends StatelessWidget {
  final int _qty;
  const LikeCounter({
    super.key,
    required int qty,
  }) : _qty = qty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Text(
        "$_qty Likes",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
