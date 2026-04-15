import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/clases/widget/clase_card_user.dart';
import 'package:app_3k_padel/model/clases_model.dart';
import 'package:app_3k_padel/services/clases_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:flutter/material.dart';

class ClasesActivasUserScreen extends StatefulWidget {
  const ClasesActivasUserScreen({super.key});

  @override
  State<ClasesActivasUserScreen> createState() =>
      _ClasesActivasUserScreenState();
}

class _ClasesActivasUserScreenState extends State<ClasesActivasUserScreen> {
  late Future<List<ClasesModel>> _clasesFuture;

  @override
  void initState() {
    super.initState();
    AppLogger.info("Cargando pantalla de clases activas", tag: "CLASES_USER");
    _clasesFuture = ClasesService().getAllClasesUser();
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
          builder: (context, snapshot){
            // Cargando
            if (snapshot.connectionState == ConnectionState.waiting) {
              AppLogger.info("Cargando lista de clases activas", tag: "CLASES_USER");
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (snapshot.hasError) {
              AppLogger.error(
                "Error cargando clases activas: ${snapshot.error}",
                tag: "CLASES_USER",
              );
              return Center(child: Text(snapshot.error.toString()));
            }

            // Datos
            final clases = snapshot.data;

            if (clases == null || clases.isEmpty) {
              AppLogger.warning("Lista de clases activas vacía", tag: "CLASES_USER");
              return const Center(child: Text("No hay clases disponibles"));
            }

            AppLogger.info(
              "Clases activas cargadas correctamente: ${clases.length}",
              tag: "CLASES_USER",
            );

            return ListView.builder(
              itemCount: clases.length,
              itemBuilder: (context, i){
                final clase = clases[i];
                return ClaseCardUser(clase: clase);
              }
            );
          },
        ),
      ),
    );
  }
}
