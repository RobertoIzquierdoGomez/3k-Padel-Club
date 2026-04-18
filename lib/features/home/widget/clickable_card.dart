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

    double cardSize;
    if (screenWidth < 360) {
      cardSize = 135;
    } else if (screenWidth < 600) {
      cardSize = 150;
    } else {
      cardSize = 200;
    }

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
                Positioned.fill(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallCard = constraints.maxWidth < 145;

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 217, 221, 63),
                            width: 3.0,
                          ),
                          color: const Color.fromARGB(199, 255, 255, 255),
                        ),
                        padding: EdgeInsets.all(isSmallCard ? 12 : 20),
                        child: Center(
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallCard ? 16 : 19,
                              height: 1.2,
                            ),
                          ),
                        ),
                      );
                    },
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