import 'package:app_3k_padel/features/home/widget/clickable_card.dart';
import 'package:app_3k_padel/features/perfil/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class AdminHomeContent extends StatelessWidget {
  const AdminHomeContent({super.key});

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
                text: "Gestión de usuarios",
                imagePath: "assets/backgrounds/fondo_gestion_usuarios.png",
                onTap: () {
                  print("Pulsado gestion usuarios");
                },
              ),
              ClickableCard(
                text: "Gestión de reservas",
                imagePath: "assets/backgrounds/fondo_gestion_reservas.png",
                onTap: () {
                  print("Pulsado gestion reservas");
                },
              ),
              ClickableCard(
                text: "Gestión de clases",
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