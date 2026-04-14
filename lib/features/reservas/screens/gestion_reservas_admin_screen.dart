import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/reservas/widget/insert_reserva_admin.dart';
import 'package:app_3k_padel/features/reservas/widget/reserva_card_admin.dart';
import 'package:app_3k_padel/features/reservas/widget/reserva_edit_admin.dart';
import 'package:app_3k_padel/model/pista_model.dart';
import 'package:app_3k_padel/model/reservas_model.dart';
import 'package:app_3k_padel/services/participacion_reserva_service.dart';
import 'package:app_3k_padel/services/pista_service.dart';
import 'package:app_3k_padel/services/reservas_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GestionReservasAdminScreen extends StatefulWidget {
  const GestionReservasAdminScreen({super.key});

  @override
  State<GestionReservasAdminScreen> createState() =>
      _GestionReservasAdminScreenState();
}

class _GestionReservasAdminScreenState
    extends State<GestionReservasAdminScreen> {
  late Future<List<ReservasModel>> _reservasFuture;
  late Future<List<PistaModel>> _pistasFuture;

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      "Cargando pantalla de gestión de reservas",
      tag: "RESERVAS_ADMIN",
    );
    _reservasFuture = ReservasService().getAllReservas();
    _pistasFuture = PistaService().getAllPistasActivas();
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
                  onEditing: () async {
                    final pistas = await _pistasFuture;

                    AppLogger.info(
                      "Editando reserva ${reserva.idReserva}",
                      tag: "RESERVAS_ADMIN",
                    );

                    showDialog(
                      context: context,
                      builder: (_) => ReservaEdit(
                        reserva: reserva,
                        pistas: pistas,
                        onEdit: (updatedReserva) =>
                            _confirmEditReserva(updatedReserva),

                        onDeleteParticipacion: _deleteParticipacion,
                      ),
                    );
                  },
                  onDelete: () => _confirmDeleteReserva(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pistas = await _pistasFuture;
          AppLogger.info("Insertando pista", tag: "PISTAS_ADMIN");

          showDialog(
            context: context,
            builder: (_) => InsertReservaAdmin(
              pistas: pistas,
              onCreate: _confirmInsertReserva,
            ),
          );
        },
        tooltip: 'Añadir Pista',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteParticipacion(String idReserva, String idUsuario) async {
    AppLogger.info(
      "Eliminando participación (reserva: $idReserva, usuario: $idUsuario)",
      tag: "RESERVAS_ADMIN",
    );

    await ParticipacionReservaService().deleteParticipacion(
      idReserva,
      idUsuario,
    );

    AppLogger.info(
      "Participación eliminada correctamente (reserva: $idReserva, usuario: $idUsuario)",
      tag: "RESERVAS_ADMIN",
    );

    setState(() {
      _reservasFuture = ReservasService().getAllReservas();
    });
  }

  Future<void> _confirmDeleteReserva(
    String id,
    String nombrePista,
    String fecha,
    String horaInicio,
    String horaFin,
  ) async {
    AppLogger.info(
      "Intento de eliminar reserva $id. Pista $nombrePista con fecha $fecha de $horaInicio a $horaFin",
      tag: "RESERVAS_ADMIN",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar reserva"),
          content: Text(
            "¿Seguro que quieres eliminar la reserva de la pista $nombrePista el día $fecha de $horaInicio a $horaFin?",
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

  Future<String?> _confirmInsertReserva(
    String idPista,
    DateTime fecha,
    String horaInicio,
    String horaFin, {
    int? capacidadMaxima,
  }) async {
    AppLogger.info(
      "Intento de insertar reserva de $idPista para el día $fecha de $horaInicio a $horaFin",
      tag: "RESERVAS_ADMIN",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Añadir reserva"),
          content: Text("¿Seguro que quieres añadir la reserva?"),
          actions: [
            CustomButton(
              text: "No",
              isLoading: false,
              primary: false,
              onPressFunction: () => Navigator.pop(context, false),
            ),
            CustomButton(
              text: "Sí",
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
        "Confirmada inserción de reserva de $idPista para el día $fecha de $horaInicio a $horaFin",
        tag: "RESERVAS_ADMIN",
      );

      try {
        await ReservasService().insertReserva(
          idPista,
          fecha,
          horaInicio,
          horaFin,
          capacidadMaxima: capacidadMaxima,
        );

        AppLogger.info("Reserva añadida correctamente", tag: "RESERVAS_ADMIN");

        setState(() {
          _reservasFuture = ReservasService().getAllReservas();
        });

        if (!mounted) return null;
        Navigator.pop(context);

        return null;
      } catch (e) {
        AppLogger.error("Error insertando reserva: $e", tag: "RESERVAS_ADMIN");
        if (e is PostgrestException) {
          return e.message;
        }
        return "Error inesperado";
      }
    } else {
      AppLogger.info("Cancelada inserción de reserva", tag: "RESERVAS_ADMIN");
      return null;
    }
  }

  Future<String?> _confirmEditReserva(ReservasModel reserva) async {
    AppLogger.info(
      "Intento de editar reserva ${reserva.idReserva}",
      tag: "RESERVAS_ADMIN",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar reserva"),
          content: Text("¿Seguro que quieres modificar la reserva?"),
          actions: [
            CustomButton(
              text: "No",
              isLoading: false,
              primary: false,
              onPressFunction: () => Navigator.pop(context, false),
            ),
            CustomButton(
              text: "Sí",
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
        "Confirmada edición de reserva ${reserva.idReserva}",
        tag: "RESERVAS_ADMIN",
      );

      try {
        await ReservasService().updateReserva(
          reserva.idReserva,
          reserva.idPista,
          reserva.fecha,
          reserva.horaInicio,
          reserva.horaFin,
          reserva.estado,
          capacidadMaxima: reserva.capacidadMaxima,
        );

        AppLogger.info(
          "Reserva actualizada correctamente",
          tag: "RESERVAS_ADMIN",
        );

        setState(() {
          _reservasFuture = ReservasService().getAllReservas();
        });

        if (!mounted) return null;
        Navigator.pop(context);

        return null;
      } catch (e) {
        AppLogger.error("Error editando reserva: $e", tag: "RESERVAS_ADMIN");
        if (e is PostgrestException) {
          return e.message;
        }
        return "Error inesperado";
      }
    } else {
      AppLogger.info(
        "Cancelada edición de reserva ${reserva.idReserva}",
        tag: "RESERVAS_ADMIN",
      );
      return null;
    }
  }
}
