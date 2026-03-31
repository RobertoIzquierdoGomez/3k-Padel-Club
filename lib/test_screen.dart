import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _LoginState();
}

class _LoginState extends State<TestScreen> {
  late Future<UserModel?> futureUsuario;

  @override
  void initState(){
    super.initState();
    futureUsuario = UserService().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Fondo(
        imagePath: 'assets/backgrounds/grupo_personas_padel.png',
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            width: 200,
            height: 200,
            child: Center(
              child: Column(
                children: [
                  FutureBuilder<UserModel?>(
                    future: futureUsuario,
                    builder: (context, snapshot){
                      //Mientras está cargando
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      //Si hay error
                      if(snapshot.hasError){
                        return Text(snapshot.error.toString());
                      }
                      //Cuando ya terminó
                      final usuario = snapshot.data;
                      //Si no hay usuario
                      if(usuario == null){
                        return const Text("Invitado");
                      }
                      //Usuario OK
                      return Text("Bienvenido ${usuario.correo}");
                    }
                  ),

                  CustomButton(
                    text: "Logout",
                    isLoading: false,
                    primary: true,
                    onPressFunction: () async => await supabase.auth.signOut(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
