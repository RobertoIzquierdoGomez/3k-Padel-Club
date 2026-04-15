import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/clases/widget/asignar_usuarios_sheet.dart';
import 'package:app_3k_padel/features/clases/widget/clase_card_admin.dart';
import 'package:app_3k_padel/features/clases/widget/clases_edit_admin.dart';
import 'package:app_3k_padel/features/clases/widget/clases_insert_admin.dart';
import 'package:app_3k_padel/model/clases_model.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/asignacion_clase_service.dart';
import 'package:app_3k_padel/services/clases_service.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GestionClasesAdminScreen extends StatefulWidget {
  const GestionClasesAdminScreen({super.key});

  @override
  State<GestionClasesAdminScreen> createState() =>
      _GestionClasesAdminScreenState();
}

class _GestionClasesAdminScreenState extends State<GestionClasesAdminScreen> {
  late Future<List<ClasesModel>> _clasesFuture;
  late Future<List<UserModel>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      "Cargando pantalla de gestión de clases",
      tag: "CLASES_ADMIN",
    );
    _clasesFuture = ClasesService().getAllClasesAdmin();
    _usuariosFuture = UserService().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: Fondo(
        imagePath: "assets/backgrounds/fondo_gestion_clases.png",
        child: FutureBuilder<List<ClasesModel>>(
          future: _clasesFuture,
          builder: (context, snapshot) {
            // Cargando
            if (snapshot.connectionState == ConnectionState.waiting) {
              AppLogger.info("Cargando lista de clases", tag: "CLASES_ADMIN");
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (snapshot.hasError) {
              AppLogger.error(
                "Error cargando clases: ${snapshot.error}",
                tag: "CLASES_ADMIN",
              );
              return Center(child: Text(snapshot.error.toString()));
            }

            // Datos
            final clases = snapshot.data;

            if (clases == null || clases.isEmpty) {
              AppLogger.warning("Lista de clases vacía", tag: "CLASES_ADMIN");
              return const Center(child: Text("No hay clases disponibles"));
            }

            AppLogger.info(
              "Clases cargadas correctamente: ${clases.length}",
              tag: "CLASES_ADMIN",
            );

            return ListView.builder(
              itemCount: clases.length,
              itemBuilder: (context, i) {
                final clase = clases[i];

                return ClaseCardAdmin(
                  clase: clase,
                  onManageUsers: () async {
                    final usuarios = await _usuariosFuture;

                    final resultado = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => AsignarUsuariosSheet(
                        usuarios: usuarios,
                        usuariosAsignados: clase.usuarios,
                      ),
                    );
                    if (resultado == null) return;
                    final seleccionados = Set<String>.from(resultado);

                    if (seleccionados.length == clase.usuarios.length &&
                        seleccionados.containsAll(
                          clase.usuarios.map((u) => u.idUsuario),
                        )) {
                      AppLogger.info(
                        "Sin cambios en usuarios",
                        tag: "CLASES_ADMIN",
                      );
                      return;
                    }

                    try {
                      await AsignacionClaseService().syncUsuariosClase(
                        clase.idClase,
                        seleccionados.toList(),
                      );

                      setState(() {
                        _clasesFuture = ClasesService().getAllClasesAdmin();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Usuarios actualizados correctamente"),
                        ),
                      );
                    } catch (e) {
                      AppLogger.error(
                        "Error sincronizando usuarios: $e",
                        tag: "CLASES_ADMIN",
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error al actualizar usuarios"),
                        ),
                      );
                    }

                    setState(() {
                      _clasesFuture = ClasesService().getAllClasesAdmin();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Usuarios actualizados correctamente"),
                      ),
                    );
                  },
                  onEditing: () async {
                    final usuarios = await _usuariosFuture;
                    AppLogger.info(
                      "Editando reserva ${clase.idClase}",
                      tag: "CLASES_ADMIN",
                    );

                    showDialog(
                      context: context,
                      builder: (_) => ClasesEditAdmin(
                        clase: clase,
                        usuarios: usuarios,
                        onEdit: (updatedClase) =>
                            _confirmEditClase(updatedClase),
                      ),
                    );
                  },
                  onDelete: () => _confirmDeleteClase(
                    clase.idClase,
                    clase.diaSemanaNombre,
                    clase.horaInicioFormateada,
                    clase.horaFinFormateada,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AppLogger.info("Insertando clase", tag: "CLASES_ADMIN");

          showDialog(
            context: context,
            builder: (_) => ClasesInsertAdmin(onCreate: _confirmInsertClase),
          );
        },
        tooltip: 'Añadir Pista',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _confirmInsertClase(
    int diaSemana,
    String horaInicio,
    String horaFin,
  ) async {
    AppLogger.info(
      "Intento de insertar clase el día $diaSemana de $horaInicio a $horaFin",
      tag: "CLASES_ADMIN",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Añadir clase"),
          content: Text("¿Seguro que quieres añadir la clase?"),
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
        "Confirmada inserción de clase el día $diaSemana de $horaInicio a $horaFin",
        tag: "CLASES_ADMIN",
      );

      try {
        await ClasesService().insertClase(diaSemana, horaInicio, horaFin);

        AppLogger.info("Clase añadida correctamente", tag: "CLASES_ADMIN");

        setState(() {
          _clasesFuture = ClasesService().getAllClasesAdmin();
        });

        if (!mounted) return null;
        Navigator.pop(context);

        return null;
      } catch (e) {
        AppLogger.error("Error insertando clase: $e", tag: "CLASES_ADMIN");
        if (e is PostgrestException) {
          return e.message;
        }
        return "Error inesperado";
      }
    } else {
      AppLogger.info("Cancelada inserción de clase", tag: "CLASES_ADMIN");
      return null;
    }
  }

  Future<String?> _confirmEditClase(ClasesModel clase) async {
    AppLogger.info(
      "Intento de editar clase ${clase.idClase}",
      tag: "CLASES_ADMIN",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar clase"),
          content: Text("¿Seguro que quieres modificar la clase?"),
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
        "Confirmada edición de CLASE ${clase.idClase}",
        tag: "CLASES_ADMIN",
      );

      try {
        await ClasesService().updateClase(
          clase.idClase,
          clase.diaSemana,
          clase.horaInicio,
          clase.horaFin,
          clase.estadoClase,
        );

        AppLogger.info("Clase actualizada correctamente", tag: "CLASES_ADMIN");

        setState(() {
          _clasesFuture = ClasesService().getAllClasesAdmin();
        });

        if (!mounted) return null;
        Navigator.pop(context);

        return null;
      } catch (e) {
        AppLogger.error("Error editando clase: $e", tag: "CLASES_ADMIN");
        if (e is PostgrestException) {
          return e.message;
        }
        return "Error inesperado";
      }
    } else {
      AppLogger.info(
        "Cancelada edición de clase ${clase.idClase}",
        tag: "CLASES_ADMIN",
      );
      return null;
    }
  }

  Future<void> _confirmDeleteClase(
    String idClase,
    String diaSemana,
    String horaInicio,
    String horaFin,
  ) async {
    AppLogger.info(
      "Intento de eliminar clase $idClase del día $diaSemana de $horaInicio a $horaFin.",
      tag: "CLASES_ADMIN",
    );
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar reserva"),
          content: Text(
            "¿Seguro que quieres eliminar la clase del día $diaSemana de $horaInicio a $horaFin?",
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
        "Confirmada eliminación de clase $idClase",
        tag: "CLASES_ADMIN",
      );

      await ClasesService().deleteCalse(idClase);

      AppLogger.info(
        "Reserva $idClase eliminada correctamente",
        tag: "CLASES_ADMIN",
      );

      setState(() {
        _clasesFuture = ClasesService().getAllClasesAdmin();
      });
    } else {
      AppLogger.info(
        "Cancelada eliminación de clase $idClase",
        tag: "CLASES_ADMIN",
      );
    }
  }
}
