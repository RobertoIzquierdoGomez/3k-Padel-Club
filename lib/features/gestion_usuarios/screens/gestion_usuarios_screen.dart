import 'package:app_3k_padel/features/gestion_usuarios/widget/user_card.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:flutter/material.dart';

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  late Future<List<UserModel>> _usersFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserService().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: Fondo(
        imagePath: "assets/backgrounds/fondo_gestion_usuarios.png",
        child: FutureBuilder<List<UserModel>>(
          future: _usersFuture,
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
            final usuarios = snapshot.data;

            if (usuarios == null || usuarios.isEmpty) {
              return const Center(child: Text("No hay usuarios"));
            }

            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, i) {
                final usuario = usuarios[i];
                return UserCard(
                  user: usuario,
                  onDeactivate: () => _disableUser(usuario.idUsuario),
                  onEditing: () => _editUser(usuario.idUsuario),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _disableUser(String id) async {
    if (_isLoading) return;

    _isLoading = true;

    await UserService().disableUser(id);

    setState(() {
      _usersFuture = UserService().getAllUsers();
    });

    _isLoading = false;
  }

  Future<void> _editUser(String id) async {
    await UserService().updateUserByAdmin(id);
  }
}
