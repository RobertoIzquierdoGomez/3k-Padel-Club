import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/widgets/custom_badge.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AsignarUsuariosSheet extends StatefulWidget {
  final List<UserModel> usuarios;
  final List<UserModel> usuariosAsignados;

  const AsignarUsuariosSheet({
    super.key,
    required this.usuarios,
    required this.usuariosAsignados,
  });

  @override
  State<AsignarUsuariosSheet> createState() => _AsignarUsuariosSheetState();
}

class _AsignarUsuariosSheetState extends State<AsignarUsuariosSheet> {
  static const int maxUsuarios = 4;
  late Set<String> usuariosSeleccionados;

  @override
  void initState() {
    super.initState();

    usuariosSeleccionados = widget.usuariosAsignados
        .map((u) => u.idUsuario)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Text(
              "Máximo $maxUsuarios usuarios por clase",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.usuarios.length,
                itemBuilder: (context, i) {
                  final usuario = widget.usuarios[i];
                  final estaSeleccionado = usuariosSeleccionados.contains(
                    usuario.idUsuario,
                  );

                  final puedeSeleccionar =
                      estaSeleccionado ||
                      usuariosSeleccionados.length < maxUsuarios;
                  return CheckboxListTile(
                    value: estaSeleccionado,
                    onChanged: puedeSeleccionar
                        ? (value) {
                            setState(() {
                              if (value == true) {
                                usuariosSeleccionados.add(usuario.idUsuario);
                              } else {
                                usuariosSeleccionados.remove(usuario.idUsuario);
                              }
                            });
                          }
                        : null,
                    title: Text("${usuario.nombre} ${usuario.apellidos}"),
                  );
                },
              ),
            ),
            CustomButton(
              text: "Guardar",
              isLoading: false,
              primary: true,
              onPressFunction: () {
                Navigator.pop(context, usuariosSeleccionados);
              },
            ),
          ],
        ),
      ),
    );
  }
}
