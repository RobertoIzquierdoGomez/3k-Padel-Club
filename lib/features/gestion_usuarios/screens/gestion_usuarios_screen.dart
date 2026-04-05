import 'package:app_3k_padel/features/gestion_usuarios/widget/user_card.dart';
import 'package:app_3k_padel/features/gestion_usuarios/widget/user_edit.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  late Future<List<UserModel>> _usersFuture;

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
                  onDeactivate: () => _confirmDisableUser(
                    usuario.idUsuario,
                    usuario.nombre,
                    usuario.apellidos,
                  ),
                  onEditing: () {
                    showDialog(
                      context: context,
                      builder: (_) => UserEdit(
                        user: usuario,
                        onEdit: (updatedUser) => _confirmEditUser(updatedUser),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDisableUser(
    String id,
    String nombre,
    String apellidos,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Desactivar usuario"),
          content: Text(
            "¿Seguro que quieres desactivar a $apellidos, $nombre?",
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
      await UserService().disableUser(id);
      setState(() {
        _usersFuture = UserService().getAllUsers();
      });
    }
  }

  Future<void> _confirmEditUser(UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar usuario"),
          content: Text("¿Seguro que quieres modificar al usuario?"),
          actions: [
            CustomButton(
              text: "No",
              isLoading: false,
              primary: true,
              onPressFunction: () => Navigator.pop(context, false),
            ),
            CustomButton(
              text: "Sí",
              isLoading: false,
              primary: false,
              onPressFunction: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await UserService().updateUserByAdmin(
        user.idUsuario,
        user.nombre,
        user.apellidos,
        user.nivel,
        user.tipoMiembro,
      );
      setState(() {
        _usersFuture = UserService().getAllUsers();
      });
      Navigator.pop(context); 
    }
  }
}
