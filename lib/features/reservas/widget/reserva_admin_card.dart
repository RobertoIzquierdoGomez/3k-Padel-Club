import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/reservas_model.dart';
import 'package:app_3k_padel/widgets/custom_badge.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ReservaAdminCard extends StatelessWidget {
  final ReservasModel reserva;
  final VoidCallback onEditing;
  final VoidCallback onDelete;

  const ReservaAdminCard({
    super.key,
    required this.reserva,
    required this.onEditing,
    required this.onDelete,
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
                    "${reserva.fechaFormateada} - ${reserva.pista}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${reserva.horaInicioFormateada} - ${reserva.horaFinFormateada}",
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
                      CustomBadge(
                        text:
                            "${reserva.usuarios.length}/${reserva.capacidadMaxima}",
                      ),
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
                      CustomBadge(text: reserva.nivelPromedioTexto),
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
                            "Pulsado editar reserva ${reserva.idReserva}",
                            tag: "RESERVAS_ADMIN",
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
                            "Pulsado eliminar reserva ${reserva.idReserva}",
                            tag: "RESERVAS_ADMIN",
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
                "${reserva.fechaFormateada} - ${reserva.pista}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${reserva.horaInicioFormateada} - ${reserva.horaFinFormateada}",
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
                  CustomBadge(
                    text:
                        "${reserva.usuarios.length}/${reserva.capacidadMaxima}",
                  ),
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
                  CustomBadge(text: reserva.nivelPromedioTexto),
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
                  "Pulsado editar reserva ${reserva.idReserva}",
                  tag: "RESERVAS_ADMIN",
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
                  "Pulsado eliminar reserva ${reserva.idReserva}",
                  tag: "RESERVAS_ADMIN",
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
