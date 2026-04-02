import 'package:app_3k_padel/features/auth/widget/auth_gate.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ResetPasswordSuccess extends StatelessWidget {
  final bool isRecovery;
  const ResetPasswordSuccess({super.key, required this.isRecovery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 217, 221, 63),
            width: 3.0,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: EdgeInsets.all(40),
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20.0,
          children: [
            Text(
              "Contraseña actualizada",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
            ),
            Text(
              "Tu contraseña se ha cambiado correctamente.",
              textAlign: TextAlign.center,
            ),
            CustomButton(
              text: "Volver",
              isLoading: false,
              primary: true,
              onPressFunction: () {
                if (isRecovery) {
                  supabase.auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthGate(),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
