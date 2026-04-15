import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/clases/screens/clases_activas_user_screen.dart';
import 'package:app_3k_padel/features/home/widget/clickable_card.dart';
import 'package:app_3k_padel/features/perfil/screens/profile_screen.dart';
import 'package:app_3k_padel/features/reservas/screens/reservas_activas_user_screen.dart';
import 'package:app_3k_padel/features/reservas/screens/reservas_disponibles_user_screen.dart';
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
                  AppLogger.info(
                    "Acceso a Reservas disponibles",
                    tag: "NAV_USER",
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservasDisponiblesUserScreen(),
                    ),
                  );
                },
              ),
              ClickableCard(
                text: "Mis reservas activas",
                imagePath: "assets/backgrounds/fondo_mis_reservas.png",
                onTap: () {
                  AppLogger.info(
                    "Acceso a Mis reservas activas",
                    tag: "NAV_USER",
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservasActivasUserScreen(),
                    ),
                  );
                },
              ),
              ClickableCard(
                text: "Ver mis clases",
                imagePath: "assets/backgrounds/fondo_gestion_clases.png",
                onTap: () {
                  AppLogger.info("Acceso a Ver mis clases", tag: "NAV_USER");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClasesActivasUserScreen(),
                    ),
                  );
                },
              ),
              ClickableCard(
                text: "Mi perfil",
                imagePath: "assets/backgrounds/fondo_perfil.png",
                onTap: () {
                  AppLogger.info(
                    "Acceso a Perfil desde usuario",
                    tag: "NAV_USER",
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
