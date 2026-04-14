import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/reservas/widget/reserva_disponible_card_user.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/model/reservas_model.dart';
import 'package:app_3k_padel/services/participacion_reserva_service.dart';
import 'package:app_3k_padel/services/reservas_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ReservasUserScreen extends StatefulWidget {
  const ReservasUserScreen({super.key});

  @override
  State<ReservasUserScreen> createState() => _ReservasUserScreenState();
}

class _ReservasUserScreenState extends State<ReservasUserScreen> {
  late Future<List<ReservasModel>> _reservasFuture;

  @override
  void initState() {
    super.initState();
    AppLogger.info("Cargando pantalla de reservas", tag: "RESERVAS_USER");
    _reservasFuture = ReservasService().getAllReservasUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: Fondo(
        imagePath: "assets/backgrounds/fondo_reservas_disponibles.jpg",
        child: FutureBuilder<List<ReservasModel>>(
          future: _reservasFuture,
          builder: (context, snapshot) {
            // Cargando
            if (snapshot.connectionState == ConnectionState.waiting) {
              AppLogger.info(
                "Cargando lista de reservas",
                tag: "RESERVAS_USER",
              );
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (snapshot.hasError) {
              AppLogger.error(
                "Error cargando reservas: ${snapshot.error}",
                tag: "RESERVAS_USER",
              );
              return Center(child: Text(snapshot.error.toString()));
            }

            // Datos
            final reservas = snapshot.data;

            if (reservas == null || reservas.isEmpty) {
              AppLogger.warning(
                "Lista de reservas vacía",
                tag: "RESERVAS_USER",
              );
              return const Center(child: Text("No hay reservas disponibles"));
            }

            AppLogger.info(
              "Reservas cargadas correctamente: ${reservas.length}",
              tag: "RESERVAS_USER",
            );

            return ListView.builder(
              itemCount: reservas.length,
              itemBuilder: (context, i) {
                final reserva = reservas[i];
                return ReservaDisponibleCardUser(
                  reserva: reserva,
                  onADding: () => _confirmAddingParticipacion(
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


  String _getReservaErrorMessage(Object error) {
  final errorText = error.toString().toLowerCase();

  if (errorText.contains('23505') ||
      errorText.contains('duplicate key') ||
      errorText.contains('duplicate')) {
    return 'Ya estás apuntado a esta reserva.';
  }

  if (errorText.contains('capacidad máxima')) {
    return 'La reserva ya está completa y no admite más usuarios.';
  }

  return 'Ha ocurrido un error al apuntarte a la reserva.';
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
      AppLogger.error("No hay usuario autenticado", tag: "RESERVAS_USER");
      return;
    }

    final idUsuario = currentUser.id;

    AppLogger.info(
      "Intento de insertar usuario $idUsuario en reserva $idReserva",
      tag: "RESERVAS_USER",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Apuntarme en reserva"),
          content: Text(
            "¿Seguro que quieres apuntarte a la reserva de la pista $nombrePista el día $fecha de $horaInicio a $horaFin?",
          ),
          actions: [
            CustomButton(
              text: "Cancelar",
              isLoading: false,
              primary: false,
              onPressFunction: () => Navigator.pop(context, false),
            ),
            CustomButton(
              text: "Apuntarme",
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
        "Confirmado apuntarse a reserva $idReserva por el usuario $idUsuario",
        tag: "RESERVAS_USER",
      );

      try {
        await ParticipacionReservaService().insertParticipacionUsuario(
          idReserva,
          idUsuario,
        );

        AppLogger.info(
          "Participación insertada correctamente (reserva: $idReserva, usuario: $idUsuario)",
          tag: "PARTICIPACION_RESERVA_SERVICE",
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Te has apuntado correctamente a la reserva."),
          ),
        );

        setState(() {
          _reservasFuture = ReservasService().getAllReservasUser();
        });
      } catch (e) {
        AppLogger.error(
          "Error al apuntarse a la reserva: $e",
          tag: "RESERVAS_USER",
        );

        if (!mounted) return;

        final errorMessage = _getReservaErrorMessage(e);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } else {
      AppLogger.info(
        "Cancelado apuntarse reserva $idReserva por el usuario $idUsuario",
        tag: "RESERVAS_USER",
      );
    }
  }
}
