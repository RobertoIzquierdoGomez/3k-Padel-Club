import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onTap;

  const ClickableCard({
    super.key,
    required this.text,
    required this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = screenWidth < 600 ? 150.0 : 200.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: cardSize,
            width: cardSize,
            child: Stack(
              children: [
                // Fondo imagen
                Positioned.fill(
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),

                // Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 217, 221, 63),
                        width: 3.0,
                      ),
                      color: Color.fromARGB(199, 255, 255, 255),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
