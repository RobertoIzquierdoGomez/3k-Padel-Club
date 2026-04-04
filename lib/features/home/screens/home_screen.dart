import 'package:app_3k_padel/features/home/widget/admin_home_content.dart';
import 'package:app_3k_padel/features/home/widget/user_home_content.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: FutureBuilder(
        future: UserService().getCurrentUser(),
        builder: (context, snapshot) {
          //Mientras está cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          //Si hay error
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          //Cuando ya terminó
          final usuario = snapshot.data;
          //Si no hay usuario
          if (usuario == null) {
            return const Text("No se ha cargado ningún usuario");
          }
          //Usuario OK
          return _buildHome(usuario);
        },
      ),
    );
  }

  Widget _buildHome(UserModel user) {
    final isAdmin = user.rol == "admin";

    return Fondo(
      imagePath: isAdmin
          ? "assets/backgrounds/panel_administrador.png"
          : "assets/backgrounds/fondo_panel_usuario.png",
      child: isAdmin ? AdminHomeContent() : UserHomeContent(),
    );
  }
}
