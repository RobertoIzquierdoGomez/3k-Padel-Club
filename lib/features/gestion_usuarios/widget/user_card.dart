import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onDeactivate;
  final VoidCallback onEditing;

  const UserCard({super.key, required this.user, required this.onDeactivate, required this.onEditing});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color.fromARGB(255, 217, 221, 63),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 500) {
                  return _buildMobileLayout();
                }
                return _buildDesktopLayout();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color.fromARGB(255, 217, 221, 63),
              child: Icon(Icons.person, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.apellidos}, ${user.nombre}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.correo,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            _buildBadge("Nivel ${user.nivel}"),
            const SizedBox(width: 8),
            _buildBadge(user.tipoMiembro ? "Miembro 3K" : "Miembro"),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              text: "Editar",
              isLoading: false,
              primary: true,
              onPressFunction: () {
                AppLogger.info(
                  "Pulsado editar usuario ${user.idUsuario}",
                  tag: "USERS_ADMIN",
                );
                onEditing();
              },
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Eliminar",
              isLoading: false,
              primary: false,
              onPressFunction: () {
                AppLogger.info(
                  "Pulsado eliminar usuario ${user.idUsuario}",
                  tag: "USERS_ADMIN",
                );
                onDeactivate();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Color.fromARGB(255, 217, 221, 63),
          child: Icon(Icons.person, color: Colors.black),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.apellidos}, ${user.nombre}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.correo,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _buildBadge("Nivel ${user.nivel}"),
                  const SizedBox(width: 8),
                  _buildBadge(user.tipoMiembro ? "Miembro 3K" : "Miembro"),
                ],
              ),
            ],
          ),
        ),

        Row(
          children: [
            CustomButton(
              text: "Editar",
              isLoading: false,
              primary: true,
              onPressFunction: () {
                AppLogger.info(
                  "Pulsado editar usuario ${user.idUsuario}",
                  tag: "USERS_ADMIN",
                );
                onEditing();
              },
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Eliminar",
              isLoading: false,
              primary: false,
              onPressFunction: () {
                AppLogger.info(
                  "Pulsado eliminar usuario ${user.idUsuario}",
                  tag: "USERS_ADMIN",
                );
                onDeactivate();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}