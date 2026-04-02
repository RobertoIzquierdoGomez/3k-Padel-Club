import 'package:flutter/material.dart';

class PerfilLabelWidget extends StatelessWidget {
  final String label;
  final String field;
  const PerfilLabelWidget({
    super.key,
    required this.label,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 50,
      children: [
        SizedBox(width: 65,child:  Text(label, style: TextStyle(fontWeight: FontWeight.w600)),),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(              
              border: BoxBorder.all(width: 1, color: Color.fromARGB(255, 45, 68, 151)),
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(100, 217, 217, 217),
            ),
            child: Text(field, overflow: TextOverflow.ellipsis,),
          ),
        ),
      ],
    );
  }
}
