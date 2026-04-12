import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/clases_model.dart';
import 'package:app_3k_padel/widgets/custom_badge.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ClaseCardAdmin extends StatelessWidget {
  final ClasesModel clase;
  final VoidCallback onEditing;
  final VoidCallback onDelete;
  final VoidCallback onManageUsers;

  const ClaseCardAdmin({
    super.key,
    required this.clase,
    required this.onEditing,
    required this.onDelete,
    required this.onManageUsers,
  });

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
              child: Icon(Icons.calendar_month, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clase.diaSemanaNombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${clase.horaInicioFormateada} - ${clase.horaFinFormateada}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Participantes: ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 10),
                      CustomBadge(text: "${clase.usuarios.length}/4"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Nivel medio: ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 20),
                      CustomBadge(text: clase.nivelPromedioTexto),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      CustomButton(
                        text: "Usuarios",
                        isLoading: false,
                        primary: true,
                        onPressFunction: () {
                          AppLogger.info(
                            "Pulsado gestionar usuarios clase ${clase.idClase}",
                            tag: "CLASES_ADMIN",
                          );
                          onManageUsers();
                        },
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        text: "Editar",
                        isLoading: false,
                        primary: true,
                        onPressFunction: () {
                          AppLogger.info(
                            "Pulsado editar clase ${clase.idClase}",
                            tag: "CLASES_ADMIN",
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
                            "Pulsado eliminar clase ${clase.idClase}",
                            tag: "CLASES_ADMIN",
                          );
                          onDelete();
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
          child: Icon(Icons.calendar_month, color: Colors.black),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clase.diaSemanaNombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${clase.horaInicioFormateada} - ${clase.horaFinFormateada}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "Participantes: ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 10),
                  CustomBadge(text: "${clase.usuarios.length}/4"),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "Nivel medio: ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 20),
                  CustomBadge(text: clase.nivelPromedioTexto),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            CustomButton(
              text: "Usuarios",
              isLoading: false,
              primary: true,
              onPressFunction: () {
                AppLogger.info(
                  "Pulsado gestionar usuarios clase ${clase.idClase}",
                  tag: "CLASES_ADMIN",
                );
                onManageUsers();
              },
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Editar",
              isLoading: false,
              primary: true,
              onPressFunction: () {
                AppLogger.info(
                  "Pulsado editar clase ${clase.idClase}",
                  tag: "CLASES_ADMIN",
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
                  "Pulsado eliminar clase ${clase.idClase}",
                  tag: "CLASES_ADMIN",
                );
                onDelete();
              },
            ),
          ],
        ),
      ],
    );
  }
}
