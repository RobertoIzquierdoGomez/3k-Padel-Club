import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/pista_model.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PistaCard extends StatelessWidget {
  final PistaModel pista;
  final VoidCallback onDeactivate;
  final VoidCallback onEditing;

  const PistaCard({
    super.key,
    required this.pista,
    required this.onDeactivate,
    required this.onEditing,
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
              child: Icon(Icons.grid_view, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pista.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildBadge(pista.estado ? "Activa" : "Incativa", pista.estado),
                ],
              ),
            ),
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
                  "Pulsado editar pista ${pista.idPista}",
                  tag: "PISTAS_ADMIN",
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
                  "Pulsado eliminar pista ${pista.idPista}",
                  tag: "PISTAS_ADMIN",
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
          child: Icon(Icons.grid_view, color: Colors.black),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                pista.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildBadge(pista.estado ? "Activa" : "Incativa", pista.estado),
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
                  "Pulsado editar pista ${pista.idPista}",
                  tag: "PISTAS_ADMIN",
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
                  "Pulsado eliminar pista ${pista.idPista}",
                  tag: "PISTAS_ADMIN",
                );
                onDeactivate();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String text, bool activa) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activa ? Colors.grey[200] : Colors.grey[400],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
