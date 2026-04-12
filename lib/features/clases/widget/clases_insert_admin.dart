import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ClasesInsertAdmin extends StatefulWidget {
  final Future<String?> Function(
    int diaSemana,
    String horaInicio,
    String horaFin,
  )
  onCreate;

  const ClasesInsertAdmin({super.key, required this.onCreate});

  @override
  State<ClasesInsertAdmin> createState() => _ClasesInsertAdminState();
}

class _ClasesInsertAdminState extends State<ClasesInsertAdmin> {
  final GlobalKey<FormState> _insertClaseForm = GlobalKey<FormState>();

  int? selectedDiaSemana;
  String? horaInicio;
  String? horaFin;
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
    AppLogger.info("Abierto diálogo de creación de clase", tag: "CLASES_ADMIN");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Añadir clase"),
      content: Form(
        key: _insertClaseForm,
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
                    (hora) => DropdownMenuItem(value: hora, child: Text(hora)),
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
                      "Cancelada inserción de clase para $selectedDiaSemana de $horaInicio a $horaFin",
                      tag: "CLASES_ADMIN",
                    );
                    Navigator.pop(this.context);
                  },
                ),
                CustomButton(
                  text: "Añadir clase",
                  isLoading: false,
                  primary: true,
                  onPressFunction: () async {
                    AppLogger.info(
                      "Intento de inserción de clase para $selectedDiaSemana de $horaInicio a $horaFin",
                      tag: "CLASES_ADMIN",
                    );

                    setState(() {
                      errorMessage = null;
                    });

                    if (!_insertClaseForm.currentState!.validate()) {
                      AppLogger.warning(
                        "Formulario inválido al insertar clase para $selectedDiaSemana de $horaInicio a $horaFin",
                        tag: "CLASES_ADMIN",
                      );
                      return;
                    }

                    AppLogger.info(
                      "Datos validados correctamente para clase para $diasSemana de $horaInicio a $horaFin",
                      tag: "CLASES_ADMIN",
                    );

                    final error = await widget.onCreate(
                      selectedDiaSemana!,
                      horaInicio!,
                      horaFin!,
                    );

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
