import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/pista_model.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

class PistaEdit extends StatefulWidget {
  final PistaModel pista;
  final Future<String?> Function(PistaModel) onEdit;
  const PistaEdit({super.key, required this.pista, required this.onEdit});

  @override
  State<PistaEdit> createState() => _PistaEditState();
}

class _PistaEditState extends State<PistaEdit> {
  final GlobalKey<FormState> _updatePistaForm = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  bool? estado;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      "Abierto diálogo de edición para pista ${widget.pista.idPista}",
      tag: "PISTAS_ADMIN",
    );
    nombreCtrl.text = widget.pista.nombre;
    estado = widget.pista.estado;
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
      title: const Text("Editar pista"),
      content: Form(
        key: _updatePistaForm,
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
                      "Cancelada edición de pista ${widget.pista.idPista}",
                      tag: "PISTAS_ADMIN",
                    );
                    Navigator.pop(this.context);
                  },
                ),
                CustomButton(
                  text: "Editar",
                  isLoading: false,
                  primary: true,
                  onPressFunction: () async {
                    AppLogger.info(
                      "Intento de edición de pista ${widget.pista.idPista}",
                      tag: "PISTAS_ADMIN",
                    );

                    setState(() {
                      errorMessage = null;
                    });

                    if (!_updatePistaForm.currentState!.validate()) {
                      AppLogger.warning(
                        "Formulario inválido al editar pista ${widget.pista.idPista}",
                        tag: "PISTAS_ADMIN",
                      );
                      return;
                    }

                    if (estado == null) {
                      AppLogger.warning(
                        "Campos incompletos al editar pista ${widget.pista.idPista}",
                        tag: "PISTAS_ADMIN",
                      );
                      setState(() {
                        errorMessage = "Completa todos los campos";
                      });
                      return;
                    }

                    final updatedPista = PistaModel(
                      idPista: widget.pista.idPista,
                      nombre: nombreCtrl.text.trim(),
                      estado: estado!,
                    );

                    AppLogger.info(
                      "Datos validados correctamente para pista ${widget.pista.idPista}",
                      tag: "PISTAS_ADMIN",
                    );

                    final error = await widget.onEdit(updatedPista);

                    if (error != null) {
                      setState(() {
                        errorMessage = error;
                      });
                    }
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
