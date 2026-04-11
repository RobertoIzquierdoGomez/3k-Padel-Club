import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

class InsertPista extends StatefulWidget {
  final Function(String nombre, bool estado) onCreate;

  const InsertPista({super.key, required this.onCreate});

  @override
  State<InsertPista> createState() => _InsertPistaState();
}

class _InsertPistaState extends State<InsertPista> {
  final GlobalKey<FormState> _insertPistaForm = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  bool? estado;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    AppLogger.info("Abierto diálogo de creación de pista", tag: "PISTAS_ADMIN");
  }

  String? Function(String?) validatorRellenarCampo = (String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Añadir pista"),
      content: Form(
        key: _insertPistaForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            CustomFormField(
              labelText: "Nombre",
              controller: nombreCtrl,
              validator: validatorRellenarCampo,
            ),
            SwitchListTile(
              title: const Text("Activa / Inactiva"),
              value: estado ?? false,
              onChanged: (value) {
                setState(() {
                  estado = value;
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
                    AppLogger.info(
                      "Cancelada inserción de pista ${nombreCtrl.text}",
                      tag: "PISTAS_ADMIN",
                    );
                    Navigator.pop(this.context);
                  },
                ),
                CustomButton(
                  text: "Añadir pista",
                  isLoading: false,
                  primary: true,
                  onPressFunction: () {
                    AppLogger.info(
                      "Intento de inserción de pista ${nombreCtrl.text}",
                      tag: "PISTAS_ADMIN",
                    );

                    if (!_insertPistaForm.currentState!.validate()) {
                      AppLogger.warning(
                        "Formulario inválido al insertar pista ${nombreCtrl.text}",
                        tag: "PISTAS_ADMIN",
                      );
                      return;
                    }

                    if (estado == null) {
                      AppLogger.warning(
                        "Campos incompletos al insertar pista ${nombreCtrl.text}",
                        tag: "PISTAS_ADMIN",
                      );
                      setState(() {
                        errorMessage = "Completa todos los campos";
                      });
                      return;
                    }

                    AppLogger.info(
                      "Datos validados correctamente para pista ${nombreCtrl.text}",
                      tag: "PISTAS_ADMIN",
                    );

                    widget.onCreate(
                      nombreCtrl.text.trim(),
                      estado!,
                    );
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
