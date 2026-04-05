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
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          // Datos
          final usuario = snapshot.data;

          if (usuario == null) {
            return const Center(
              child: Text("No se ha cargado ningún usuario"),
            );
          }

          // Usuario OK
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