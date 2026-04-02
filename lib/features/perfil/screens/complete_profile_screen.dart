
import 'package:app_3k_padel/features/perfil/widget/complete_profile_form.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget{

  const CompleteProfileScreen ({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfileScreen>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Fondo(imagePath: "assets/backgrounds/fondo_complete_profile.png", child: CompleteProfileForm()
      )
    );
  }
}