import 'package:app_3k_padel/model/clases_model.dart';
import 'package:app_3k_padel/widgets/custom_badge.dart';
import 'package:flutter/material.dart';

class ClaseCardUser extends StatelessWidget {
  final ClasesModel clase;

  const ClaseCardUser({
    super.key,
    required this.clase,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Card(
          color: clase.estadoClase
              ? null
              : const Color.fromARGB(255, 230, 230, 230),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: clase.estadoClase
                  ? Color.fromARGB(255, 217, 221, 63)
                  : Color.fromARGB(255, 218, 84, 93),
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
            CircleAvatar(
              radius: 22,
              backgroundColor: clase.estadoClase
                  ? Color.fromARGB(255, 217, 221, 63)
                  : Color.fromARGB(255, 218, 84, 93),
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Estado: ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 20),
                      CustomBadge(
                        text: clase.estadoClase ? "Activa" : "Suspendida",
                        activa: clase.estadoClase,
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
        CircleAvatar(
          radius: 22,
          backgroundColor: clase.estadoClase
                  ? Color.fromARGB(255, 217, 221, 63)
                  : Color.fromARGB(255, 218, 84, 93),
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
              const SizedBox(height: 4),
              Row(
                children: [
                  Text("Estado: ", style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(width: 20),
                  CustomBadge(
                    text: clase.estadoClase ? "Activa" : "Suspendida",
                    activa: clase.estadoClase,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
