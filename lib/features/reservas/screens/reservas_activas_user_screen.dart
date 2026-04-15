import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/reservas/widget/reserva_activa_card_user.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/model/reservas_model.dart';
import 'package:app_3k_padel/services/participacion_reserva_service.dart';
import 'package:app_3k_padel/services/reservas_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ReservasActivasUserScreen extends StatefulWidget {
  const ReservasActivasUserScreen({super.key});

  @override
  State<ReservasActivasUserScreen> createState() => _ReservasActivasUserScreenState();
}

class _ReservasActivasUserScreenState extends State<ReservasActivasUserScreen> {
  late Future<List<ReservasModel>> _reservasActivasFuture;

  @override
  void initState() {
    super.initState();
    AppLogger.info("Cargando pantalla de reservas activas", tag: "RESERVAS_ACTIVAS_USER");
    _reservasActivasFuture = ReservasService().getReservasActivasUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: Fondo(
        imagePath: "assets/backgrounds/fondo_mis_reservas.jpg",
        child: FutureBuilder<List<ReservasModel>>(
          future: _reservasActivasFuture,
          builder: (context, snapshot) {
            // Cargando
            if (snapshot.connectionState == ConnectionState.waiting) {
              AppLogger.info(
                "Cargando lista de reservas activas",
                tag: "RESERVAS_ACTIVAS_USER",
              );
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (snapshot.hasError) {
              AppLogger.error(
                "Error cargando reservas activas: ${snapshot.error}",
                tag: "RESERVAS_ACTIVAS_USER",
              );
              return Center(child: Text(snapshot.error.toString()));
            }

            // Datos
            final reservas = snapshot.data;

            if (reservas == null || reservas.isEmpty) {
              AppLogger.warning(
                "Lista de reservas activas vacía",
                tag: "RESERVAS_ACTIVAS_USER",
              );
              return const Center(child: Text("No hay reservas activas disponibles"));
            }

            AppLogger.info(
              "Reservas activas cargadas correctamente: ${reservas.length}",
              tag: "RESERVAS_ACTIVAS_USER",
            );

            return ListView.builder(
              itemCount: reservas.length,
              itemBuilder: (context, i) {
                final reserva = reservas[i];
                return ReservaActivaCardUser(
                  reserva: reserva,
                  onDelete: () => _confirmAddingParticipacion(
                    reserva.idReserva,
                    reserva.pista,
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


  Future<void> _confirmAddingParticipacion(
    String idReserva,
    String nombrePista,
    String fecha,
    String horaInicio,
    String horaFin,
  ) async {
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      AppLogger.error("No hay usuario autenticado", tag: "RESERVAS_ACTIVAS_USER");
      return;
    }

    final idUsuario = currentUser.id;

    AppLogger.info(
      "Intento de eliminar usuario $idUsuario de reserva $idReserva",
      tag: "RESERVAS_ACTIVAS_USER",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Quitarme de reserva"),
          content: Text(
            "¿Seguro que quieres quitarte de la reserva de la pista $nombrePista del día $fecha de $horaInicio a $horaFin?",
          ),
          actions: [
            CustomButton(
              text: "Atrás",
              isLoading: false,
              primary: false,
              onPressFunction: () => Navigator.pop(context, false),
            ),
            CustomButton(
              text: "Quitarme",
              isLoading: false,
              primary: true,
              onPressFunction: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      AppLogger.info(
        "Confirmado quitarse de la reserva $idReserva por el usuario $idUsuario",
        tag: "RESERVAS_ACTIVAS_USER",
      );


        await ParticipacionReservaService().deleteParticipacion(
          idReserva,
          idUsuario,
        );

        AppLogger.info(
          "Participación eliminada correctamente (reserva: $idReserva, usuario: $idUsuario)",
          tag: "PARTICIPACION_RESERVA_SERVICE",
        );

        setState(() {
          _reservasActivasFuture = ReservasService().getReservasActivasUsuario();
        });

    } else {
      AppLogger.info(
        "Cancelado quitarse de reserva $idReserva por el usuario $idUsuario",
        tag: "RESERVAS_ACTIVAS_USER",
      );
    }
  }
}
