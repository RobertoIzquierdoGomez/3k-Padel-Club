
import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final bool? activa;
  const CustomBadge ({super.key, required this.text, this.activa});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activa ?? true ? Colors.grey[200] : Colors.grey[400],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}



