import 'package:app_3k_padel/features/home/widget/clickable_card.dart';
import 'package:app_3k_padel/features/perfil/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class UserHomeContent extends StatelessWidget {
  const UserHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Wrap(
            spacing: 50,
            runSpacing: 50,
            alignment: WrapAlignment.center,
            children: [
              ClickableCard(
                text: "Reservas disponibles",
                imagePath: "assets/backgrounds/fondo_reservas_disponibles.jpg",
                onTap: () {
                  print("Pulsado gestion usuarios");
                },
              ),
              ClickableCard(
                text: "Mis reservas activas",
                imagePath: "assets/backgrounds/fondo_mis_reservas.png",
                onTap: () {
                  print("Pulsado gestion reservas");
                },
              ),
              ClickableCard(
                text: "Ver mis clases",
                imagePath: "assets/backgrounds/fondo_gestion_clases.png",
                onTap: () {
                  print("Pulsado gestion clases");
                },
              ),
              ClickableCard(
                text: "Mi perfil",
                imagePath: "assets/backgrounds/fondo_perfil.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PerfilScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
