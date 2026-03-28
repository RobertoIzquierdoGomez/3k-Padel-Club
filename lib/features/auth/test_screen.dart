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
  final user = supabase.auth.currentUser;

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
                  Text(user?.email ?? "Invitado"),
                  CustomButton(
                    text: "Logout",
                    isLoading: false,
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
