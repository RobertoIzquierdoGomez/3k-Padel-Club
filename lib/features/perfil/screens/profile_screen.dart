import 'package:app_3k_padel/features/auth/screens/reset_password_Screen.dart';
import 'package:app_3k_padel/features/perfil/widget/perfil_label_widget.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/widgets/custom_appbar.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(),
      body: Fondo(
        imagePath: 'assets/backgrounds/fondo_perfil.png',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 50,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 217, 221, 63),
                    width: 3.0,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.all(40),
                constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
                child: FutureBuilder(
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        PerfilLabelWidget(
                          label: "Nombre:",
                          field: usuario.nombre,
                        ),
                        PerfilLabelWidget(
                          label: "Apellidos:",
                          field: usuario.apellidos,
                        ),
                        PerfilLabelWidget(
                          label: "Email:",
                          field: usuario.correo,
                        ),
                        PerfilLabelWidget(
                          label: "Nivel:",
                          field: usuario.nivel.toString(),
                        ),
                        PerfilLabelWidget(
                          label: "Miembro:",
                          field: usuario.tipoMiembro ? "Miembro 3K" : "Miembro",
                        ),
                      ],
                    );
                  },
                ),
              ),
              CustomButton(
                text: "Cambiar Contraseña",
                isLoading: false,
                primary: false,
                onPressFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
