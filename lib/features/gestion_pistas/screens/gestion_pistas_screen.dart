import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/gestion_pistas/widget/insert_pista.dart';
import 'package:app_3k_padel/features/gestion_pistas/widget/pista_card.dart';
import 'package:app_3k_padel/features/gestion_pistas/widget/pista_edit.dart';
import 'package:app_3k_padel/model/pista_model.dart';
import 'package:app_3k_padel/services/pista_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class GestionPistasScreen extends StatefulWidget {
  const GestionPistasScreen({super.key});

  @override
  State<GestionPistasScreen> createState() => _GestionPistasScreenState();
}

class _GestionPistasScreenState extends State<GestionPistasScreen> {
  late Future<List<PistaModel>> _pistasFuture;

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      "Cargando pantalla de gestión de pistas",
      tag: "PISTAS_ADMIN",
    );
    _pistasFuture = PistaService().getAllPistas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: Fondo(
        imagePath: "assets/backgrounds/fondo_gestion_pistas.jpg",
        child: FutureBuilder<List<PistaModel>>(
          future: _pistasFuture,
          builder: (context, snapshot) {
            // Cargando
            if (snapshot.connectionState == ConnectionState.waiting) {
              AppLogger.info("Cargando lista de pistas", tag: "PISTAS_ADMIN");
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (snapshot.hasError) {
              AppLogger.error(
                "Error cargando pistas: ${snapshot.error}",
                tag: "PISTAS_ADMIN",
              );
              return Center(child: Text(snapshot.error.toString()));
            }

            // Datos
            final pistas = snapshot.data;

            if (pistas == null || pistas.isEmpty) {
              AppLogger.warning("Lista de pistas vacía", tag: "PISTAS_ADMIN");
              return const Center(child: Text("No hay pistas"));
            }

            AppLogger.info(
              "Pistas cargadas correctamente: ${pistas.length}",
              tag: "PISTAS_ADMIN",
            );

            return ListView.builder(
              itemCount: pistas.length,
              itemBuilder: (context, i) {
                final pista = pistas[i];
                return PistaCard(
                  pista: pista,
                  onDeactivate: () =>
                      _confirmDeletePista(pista.idPista, pista.nombre),
                  onEditing: () {
                    AppLogger.info(
                      "Editando pista ${pista.idPista}",
                      tag: "PISTAS_ADMIN",
                    );
                    showDialog(
                      context: context,
                      builder: (_) => PistaEdit(
                        pista: pista,
                        onEdit: (updatedUser) => _confirmEditPista(updatedUser),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppLogger.info("Insertando pista", tag: "PISTAS_ADMIN");
          showDialog(
            context: context,
            builder: (_) => InsertPista(onCreate: _confirmInsertPista),
          );
        },
        tooltip: 'Añadir Pista',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDeletePista(String id, String nombre) async {
    AppLogger.info(
      "Intento de eliminar pista $id ($nombre)",
      tag: "PISTAS_ADMIN",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar pista"),
          content: Text("¿Seguro que quieres eliminar $nombre?"),
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
        "Confirmada eliminación de pista $id",
        tag: "PISTAS_ADMIN",
      );
      await PistaService().deletePista(id);
      AppLogger.info("Pista $id eliminada correctamente", tag: "PISTAS_ADMIN");

      setState(() {
        _pistasFuture = PistaService().getAllPistas();
      });
    } else {
      AppLogger.info("Cancelada eliminación de pista $id", tag: "PISTAS_ADMIN");
    }
  }

  Future<String?> _confirmEditPista(PistaModel pista) async {
    AppLogger.info(
      "Intento de editar pista ${pista.idPista}",
      tag: "PISTAS_ADMIN",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar pista"),
          content: Text("¿Seguro que quieres modificar la pista?"),
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
        "Confirmada edición de pista ${pista.idPista}",
        tag: "PISTAS_ADMIN",
      );

      try {
        await PistaService().updatePista(
          pista.idPista,
          pista.nombre,
          pista.estado,
        );

        AppLogger.info(
          "Pista ${pista.idPista} actualizada correctamente",
          tag: "PISTAS_ADMIN",
        );

        setState(() {
          _pistasFuture = PistaService().getAllPistas();
        });

        if (!mounted) return null;
        Navigator.pop(context);

        return null; // ✅ OK
      } catch (e) {
        AppLogger.error("Error editando pista: $e", tag: "PISTAS_ADMIN");
        return e.toString(); // 🔥 DEVUELVES ERROR
      }
    } else {
      AppLogger.info(
        "Cancelada edición de pista ${pista.idPista}",
        tag: "PISTAS_ADMIN",
      );
    }
  }

  Future<String?> _confirmInsertPista(String nombre, bool estado) async {
    AppLogger.info("Intento de insertar pista $nombre", tag: "PISTAS_ADMIN");

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Añadir pista"),
          content: Text("¿Seguro que quieres añadir la pista?"),
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
        "Confirmada inserción de pista $nombre",
        tag: "PISTAS_ADMIN",
      );

      try {
        await PistaService().insertPista(nombre, estado);

        AppLogger.info(
          "Pista $nombre añadida correctamente",
          tag: "PISTAS_ADMIN",
        );

        setState(() {
          _pistasFuture = PistaService().getAllPistas();
        });

        if (!mounted) return null;
        Navigator.pop(context);

        return null;
      } catch (e) {
        AppLogger.error("Error insertando pista: $e", tag: "PISTAS_ADMIN");
        return e.toString();
      }
    } else {
      AppLogger.info(
        "Cancelada inserción de pista $nombre",
        tag: "PISTAS_ADMIN",
      );
    }
  }
}
