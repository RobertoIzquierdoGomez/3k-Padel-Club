import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/pista_model.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class InsertReservaAdmin extends StatefulWidget {
  final List<PistaModel> pistas;
  final Function(
    String idPista,
    DateTime fecha,
    String horaInicio,
    String horaFin, {
    int? capacidadMaxima,
  })
  onCreate;
  const InsertReservaAdmin({
    super.key,
    required this.pistas,
    required this.onCreate,
  });

  @override
  State<InsertReservaAdmin> createState() => _InsertReservaAdminState();
}

class _InsertReservaAdminState extends State<InsertReservaAdmin> {
  final GlobalKey<FormState> _inserReservaForm = GlobalKey<FormState>();
  String? selectedPistaId;
  DateTime? selectedFecha;
  String? horaInicio;
  String? horaFin;
  String? errorMessage;
  final List<String> horas = [
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00",
    "20:30",
    "21:00",
  ];

  int _toMinutes(String hora) {
    final parts = hora.split(":");
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      "Abierto diálogo de creación de reserva",
      tag: "RESERVAS_ADMIN",
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Añadir reserva"),
      content: Form(
        key: _inserReservaForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedPistaId,
              hint: const Text("Selecciona una pista"),
              items: widget.pistas.map((pista) {
                return DropdownMenuItem<String>(
                  value: pista.idPista,
                  child: Text(pista.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPistaId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecciona una pista';
                }
                return null;
              },
            ),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Fecha",
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: selectedFecha != null
                    ? "${selectedFecha!.day.toString().padLeft(2, '0')}/"
                          "${selectedFecha!.month.toString().padLeft(2, '0')}/"
                          "${selectedFecha!.year}"
                    : "",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() {
                    selectedFecha = picked;
                  });
                }
              },
              validator: (value) {
                if (selectedFecha == null) {
                  return 'Selecciona una fecha';
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
                      "Cancelada inserción de reserva $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                      tag: "RESERVAS_ADMIN",
                    );
                    Navigator.pop(this.context);
                  },
                ),
                CustomButton(
                  text: "Añadir reserva",
                  isLoading: false,
                  primary: true,
                  onPressFunction: () {
                    AppLogger.info(
                      "Intento de inserción de reserva $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                      tag: "RESERVAS_ADMIN",
                    );
                    setState(() {
                      errorMessage = null;
                    });
                    if (!_inserReservaForm.currentState!.validate()) {
                      AppLogger.warning(
                        "Formulario inválido al insertar reserva $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                        tag: "RESERVAS_ADMIN",
                      );
                      return;
                    }

                    if (horaInicio != null && horaFin != null) {
                      if (_toMinutes(horaInicio!) >= _toMinutes(horaFin!)) {
                        AppLogger.warning(
                          "Hora fin menor o igual que hora inicio $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                          tag: "RESERVAS_ADMIN",
                        );
                        setState(() {
                          errorMessage =
                              "La hora final no puede ser anterior que la hora inicial";
                        });
                        return;
                      }
                    }

                    AppLogger.info(
                      "Datos validados correctamente para reserva $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                      tag: "RESERVAS_ADMIN",
                    );

                    widget.onCreate(
                      selectedPistaId!,
                      selectedFecha!,
                      horaInicio!,
                      horaFin!,
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
