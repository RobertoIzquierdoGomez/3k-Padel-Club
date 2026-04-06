import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/home/widget/admin_home_content.dart';
import 'package:app_3k_padel/features/home/widget/user_home_content.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    AppLogger.info("Cargando HomeScreen", tag: "HOME");
    _userFuture = UserService().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            AppLogger.info("Cargando datos del usuario en Home", tag: "HOME");
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            AppLogger.error("Error cargando usuario en Home: ${snapshot.error}", tag: "HOME");
            return Center(child: Text(snapshot.error.toString()));
          }

          // Datos
          final usuario = snapshot.data;

          if (usuario == null) {
            AppLogger.warning("Usuario null en Home", tag: "HOME");
            return const Center(
              child: Text("No se ha cargado ningún usuario"),
            );
          }

          AppLogger.info("Usuario cargado correctamente en Home", tag: "HOME");

          // Usuario OK
          return _buildHome(usuario);
        },
      ),
    );
  }

  Widget _buildHome(UserModel user) {
    final isAdmin = user.rol == "admin";

    AppLogger.info(
      isAdmin
          ? "Usuario admin → mostrando AdminHomeContent"
          : "Usuario normal → mostrando UserHomeContent",
      tag: "HOME",
    );

    return Fondo(
      imagePath: isAdmin
          ? "assets/backgrounds/panel_administrador.png"
          : "assets/backgrounds/fondo_panel_usuario.png",
      child: isAdmin ? AdminHomeContent() : UserHomeContent(),
    );
  }
}