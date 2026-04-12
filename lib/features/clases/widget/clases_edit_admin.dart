import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/clases_model.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ClasesEditAdmin extends StatefulWidget {
  final ClasesModel clase;
  final List<UserModel> usuarios;
  final Future<String?> Function(ClasesModel) onEdit;

  const ClasesEditAdmin({
    super.key,
    required this.clase,
    required this.usuarios,
    required this.onEdit,
  });

  @override
  State<ClasesEditAdmin> createState() => _ClasesEditAdminState();
}

class _ClasesEditAdminState extends State<ClasesEditAdmin> {
  final GlobalKey<FormState> _editClaseForm = GlobalKey<FormState>();

  int? selectedDiaSemana;
  String? horaInicio;
  String? horaFin;
  bool? estadoClase;
  String? errorMessage;

  final List<String> horas = [
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
  ];

  final Map<int, String> diasSemana = {
    1: "Lunes",
    2: "Martes",
    3: "Miércoles",
    4: "Jueves",
    5: "Viernes",
  };

  int _toMinutes(String hora) {
    final parts = hora.split(":");
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  @override
  void initState() {
    super.initState();
    AppLogger.info("Abierto diálogo de edición de clase", tag: "CLASES_ADMIN");
    selectedDiaSemana = widget.clase.diaSemana;
    horaInicio = widget.clase.horaInicio;
    horaFin = widget.clase.horaFin;
    estadoClase = widget.clase.estadoClase;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar clase"),
      content: Form(
        key: _editClaseForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            DropdownButtonFormField<int>(
              initialValue: selectedDiaSemana,
              decoration: const InputDecoration(
                labelText: "Día de la semana",
                border: OutlineInputBorder(),
              ),
              items: diasSemana.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDiaSemana = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Selecciona un día";
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: horaInicio,
              hint: const Text("Hora inicio"),
              items: horas.map((hora) {
                return DropdownMenuItem(value: hora, child: Text(hora));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  horaInicio = value;
                  horaFin = null;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona hora de inicio';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: horaFin,
              hint: const Text("Hora fin"),
              items: horas
                  .where((hora) {
                    if (horaInicio == null) return true;
                    return _toMinutes(hora) > _toMinutes(horaInicio!);
                  })
                  .map(
                    (hora) =>
                        DropdownMenuItem(value: hora, child: Text(hora)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  horaFin = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona hora de fin';
                }
                return null;
              },
            ),
            SwitchListTile(
              title: const Text("Activa"),
              value: estadoClase ?? false,
              onChanged: (value) {
                setState(() {
                  estadoClase = value;
                });
              },
            ),
            if (errorMessage != null && errorMessage!.isNotEmpty)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
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
                      "Cancelada edición de clase $selectedDiaSemana de $horaInicio a $horaFin",
                      tag: "CLASES_ADMIN",
                    );
                    Navigator.pop(context);
                  },
                ),
                CustomButton(
                  text: "Editar clase",
                  isLoading: false,
                  primary: true,
                  onPressFunction: () async {
                    AppLogger.info(
                      "Intento de edición de clase $selectedDiaSemana de $horaInicio a $horaFin",
                      tag: "CLASES_ADMIN",
                    );

                    setState(() {
                      errorMessage = null;
                    });

                    if (!_editClaseForm.currentState!.validate()) {
                      AppLogger.warning(
                        "Formulario inválido al editar clase $selectedDiaSemana de $horaInicio a $horaFin",
                        tag: "CLASES_ADMIN",
                      );
                      return;
                    }

                    final updatedClase = ClasesModel(
                      idClase: widget.clase.idClase,
                      diaSemana: selectedDiaSemana!,
                      horaInicio: horaInicio!,
                      horaFin: horaFin!,
                      estadoClase: estadoClase!,
                      usuarios: widget.clase.usuarios,
                    );

                    final error = await widget.onEdit(updatedClase);

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