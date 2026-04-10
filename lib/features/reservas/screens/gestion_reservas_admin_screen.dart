import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/reservas/widget/reserva_admin_card.dart';
import 'package:app_3k_padel/model/reservas_model.dart';
import 'package:app_3k_padel/services/reservas_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class GestionReservasAdminScreen extends StatefulWidget {
  const GestionReservasAdminScreen({super.key});

  @override
  State<GestionReservasAdminScreen> createState() =>
      _GestionReservasAdminScreenState();
}

class _GestionReservasAdminScreenState
    extends State<GestionReservasAdminScreen> {
  late Future<List<ReservasModel>> _reservasFuture;

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      "Cargando pantalla de gestión de reservas",
      tag: "RESERVAS_ADMIN",
    );
    _reservasFuture = ReservasService().getAllReservas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: Fondo(
        imagePath: "assets/backgrounds/fondo_gestion_reservas.png",
        child: FutureBuilder<List<ReservasModel>>(
          future: _reservasFuture,
          builder: (context, snapshot) {
            // Cargando
            if (snapshot.connectionState == ConnectionState.waiting) {
              AppLogger.info(
                "Cargando lista de reservas",
                tag: "RESERVAS_ADMIN",
              );
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (snapshot.hasError) {
              AppLogger.error(
                "Error cargando reservas: ${snapshot.error}",
                tag: "RESERVAS_ADMIN",
              );
              return Center(child: Text(snapshot.error.toString()));
            }

            // Datos
            final reservas = snapshot.data;

            if (reservas == null || reservas.isEmpty) {
              AppLogger.warning(
                "Lista de reservas vacía",
                tag: "RESERVAS_ADMIN",
              );
              return const Center(child: Text("No hay reservas disponibles"));
            }

            AppLogger.info(
              "Reservas cargadas correctamente: ${reservas.length}",
              tag: "RESERVAS_ADMIN",
            );

            return ListView.builder(
              itemCount: reservas.length,
              itemBuilder: (context, i) {
                final reserva = reservas[i];
                return ReservaAdminCard(
                  reserva: reserva,
                  onEditing: () {},
                  onDelete: () => _confirmDeleteReserva(
                    reserva.idReserva,
                    reserva.fechaFormateada,
                    reserva.horaInicioFormateada,
                    reserva.horaFinFormateada,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteReserva(
    String id,
    String fecha,
    String horaInicio,
    String horaFin,
  ) async {
    AppLogger.info(
      "Intento de eliminar reserva $id. Fecha $fecha de $horaInicio a $horaFin",
      tag: "RESERVAS_ADMIN",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar reserva"),
          content: Text(
            "¿Seguro que quieres eliminar la reserva del $fecha de $horaInicio a $horaFin?",
          ),
          actions: [
            CustomButton(
              text: "Cancelar",
              isLoading: false,
              primary: true,
              onPressFunction: () => Navigator.pop(context, false),
            ),
            CustomButton(
              text: "Eliminar",
              isLoading: false,
              primary: false,
              onPressFunction: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      AppLogger.info(
        "Confirmada eliminación de reserva $id",
        tag: "RESERVAS_ADMIN",
      );
      await ReservasService().deleteReserva(id);
      AppLogger.info(
        "Reserva $id eliminada correctamente",
        tag: "RESERVAS_ADMIN",
      );

      setState(() {
        _reservasFuture = ReservasService().getAllReservas();
      });
    } else {
      AppLogger.info(
        "Cancelada eliminación de reserva $id",
        tag: "RESERVAS_ADMIN",
      );
    }
  }
}
