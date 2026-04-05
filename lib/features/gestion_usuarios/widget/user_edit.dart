import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:app_3k_padel/widgets/custom_level_field.dart';
import 'package:flutter/material.dart';

class UserEdit extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onEdit;
  const UserEdit({super.key, required this.user, required this.onEdit});

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final GlobalKey<FormState> _userForm = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  double? nivel;
  bool? tipoMiembro;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    nombreCtrl.text = widget.user.nombre;
    apellidosCtrl.text = widget.user.apellidos;
    nivel = widget.user.nivel;
    tipoMiembro = widget.user.tipoMiembro;
  }

  String? Function(String?) validatorRellenarCampo = (String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar usuario"),
      content: Form(
        key: _userForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20.0,
          children: [
            CustomFormField(
              labelText: "Nombre",
              controller: nombreCtrl,
              validator: validatorRellenarCampo,
            ),
            CustomFormField(
              labelText: "Apellidos",
              controller: apellidosCtrl,
              validator: validatorRellenarCampo,
            ),
            CustomLevelField(
              onChanged: (value) {
                nivel = value;
              },
            ),
            SwitchListTile(
              title: const Text("Miembro 3K"),
              value: tipoMiembro ?? false,
              onChanged: (value) {
                setState(() {
                  tipoMiembro = value;
                });
              },
            ),
            if (errorMessage != null && errorMessage!.isNotEmpty)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                CustomButton(
                  text: "Cancelar",
                  isLoading: false,
                  primary: false,
                  onPressFunction: () {
                    Navigator.pop(this.context);
                  },
                ),
                CustomButton(
                  text: "Editar",
                  isLoading: false,
                  primary: true,
                  onPressFunction: () {
                    if (!_userForm.currentState!.validate()) return;

                    if (nivel == null || tipoMiembro == null) {
                      setState(() {
                        errorMessage = "Completa todos los campos";
                      });
                      return;
                    }

                    final updatedUser = UserModel(
                      idUsuario: widget.user.idUsuario,
                      nombre: nombreCtrl.text.trim(),
                      apellidos: apellidosCtrl.text.trim(),
                      correo: widget.user.correo,
                      nivel: nivel!,
                      tipoMiembro: tipoMiembro!,
                      rol: widget.user.rol,
                      perfilCompleto: widget.user.tipoMiembro,
                      activo: widget.user.activo
                    );

                    widget.onEdit(updatedUser);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
