
import 'package:app_3k_padel/features/auth/widget/auth_gate.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget  implements PreferredSizeWidget{
  const CustomAppbar ({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,

        title: SizedBox(
          height: 40,
          child: Image.asset('assets/logo/3k_logo.PNG', fit: BoxFit.contain),
        ),

        actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),

        actions: [
          CustomButton(
            text: "Logout",
            isLoading: false,
            primary: false,
            onPressFunction: () {
              supabase.auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthGate()),
              (route) => false,
            );
            },
          ),
        ],
      );
  }
}