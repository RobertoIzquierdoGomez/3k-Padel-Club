import 'package:flutter/material.dart';

class Fondo extends StatelessWidget{
  final String imagePath;
  final Widget child;
  const Fondo({super.key, required this.imagePath, required this.child});

  @override
  Widget build(BuildContext context){
    return Stack( //Permite poner widgets encima de otro
      children: [
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover, //Hace que se reparta la imagen por el tamaño pero sin deformarse
              ),
            ),
          ),
          Container(
            color: Color.fromARGB(200, 53, 95, 169) //Etablece un container con el color definido y transparencia
          ),
          child //Se añaden los contenedores hijo
      ],
    );
  }
}