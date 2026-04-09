import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/gestion_pistas/screens/gestion_pistas_screen.dart';
import 'package:app_3k_padel/features/gestion_usuarios/screens/gestion_usuarios_screen.dart';
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
                  AppLogger.info(
                    "Acceso a Gestión de usuarios",
                    tag: "NAV_ADMIN",
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GestionUsuariosScreen(),
                    ),
                  );
                },
              ),
              ClickableCard(
                text: "Gestión de reservas",
                imagePath: "assets/backgrounds/fondo_gestion_reservas.png",
                onTap: () {
                  AppLogger.info(
                    "Acceso a Gestión de reservas",
                    tag: "NAV_ADMIN",
                  );
                },
              ),
              ClickableCard(
                text: "Gestión de clases",
                imagePath: "assets/backgrounds/fondo_gestion_clases.png",
                onTap: () {
                  AppLogger.info(
                    "Acceso a Gestión de clases",
                    tag: "NAV_ADMIN",
                  );
                },
              ),
              ClickableCard(
                text: "Gestión de pistas",
                imagePath: "assets/backgrounds/fondo_perfil.png",
                onTap: () {
                  AppLogger.info(
                    "Acceso a Gestión de pistas",
                    tag: "NAV_ADMIN",
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GestionPistasScreen()));
                },
              ),
              ClickableCard(
                text: "Mi perfil",
                imagePath: "assets/backgrounds/fondo_perfil.png",
                onTap: () {
                  AppLogger.info(
                    "Acceso a Perfil desde Admin",
                    tag: "NAV_ADMIN",
                  );
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
