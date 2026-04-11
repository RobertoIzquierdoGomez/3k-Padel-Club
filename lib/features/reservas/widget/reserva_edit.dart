import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/pista_model.dart';
import 'package:app_3k_padel/model/reservas_model.dart';
import 'package:app_3k_padel/widgets/custom_badge.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ReservaEdit extends StatefulWidget {
  final ReservasModel reserva;
  final List<PistaModel> pistas;
  final Future<String?> Function(ReservasModel) onEdit;
  final Function(String idReserva, String idUsuario) onDeleteParticipacion;

  const ReservaEdit({
    super.key,
    required this.reserva,
    required this.pistas,
    required this.onEdit,
    required this.onDeleteParticipacion,
  });

  @override
  State<ReservaEdit> createState() => _ReservaEditState();
}

class _ReservaEditState extends State<ReservaEdit> {
  final GlobalKey<FormState> _editReservaForm = GlobalKey<FormState>();
  String? selectedPistaId;
  DateTime? selectedFecha;
  String? horaInicio;
  String? horaFin;
  bool editarCapacidad = false;
  int? capacidadMaxima;
  bool mostrarUsuarios = false;
  String? errorMessage;
  late TextEditingController controllerFecha;
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
      "Abierto diálogo de edición de reserva",
      tag: "RESERVAS_ADMIN",
    );
    selectedPistaId = widget.reserva.idPista;
    selectedFecha = widget.reserva.fecha;
    horaInicio = widget.reserva.horaInicio;
    horaFin = widget.reserva.horaFin;
    capacidadMaxima = widget.reserva.capacidadMaxima;
    controllerFecha = TextEditingController(
      text: selectedFecha != null
          ? "${selectedFecha!.day.toString().padLeft(2, '0')}/"
                "${selectedFecha!.month.toString().padLeft(2, '0')}/"
                "${selectedFecha!.year}"
          : "",
    );
  }

  @override
  void dispose() {
    controllerFecha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar reserva"),
      content: Form(
        key: _editReservaForm,
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
              controller: controllerFecha,
              onTap: () async {
                final now = DateTime.now();

                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedFecha ?? now,
                  firstDate:
                      selectedFecha != null && selectedFecha!.isBefore(now)
                      ? selectedFecha!
                      : now,
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() {
                    selectedFecha = picked;

                    controllerFecha.text =
                        "${picked.day.toString().padLeft(2, '0')}/"
                        "${picked.month.toString().padLeft(2, '0')}/"
                        "${picked.year}";
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
            SwitchListTile(
              title: const Text("Editar capacidad máxima"),
              value: editarCapacidad,
              onChanged: (value) {
                setState(() {
                  editarCapacidad = value;

                  if (!value) {
                    capacidadMaxima = null;
                  }
                });
              },
            ),
            if (editarCapacidad)
              DropdownButtonFormField<int>(
                initialValue: capacidadMaxima,
                hint: const Text("Capacidad máxima"),
                items: List.generate(16, (index) {
                  final value = index + 1;
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.toString()),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    capacidadMaxima = value;
                  });
                },
                validator: (value) {
                  if (editarCapacidad && value == null) {
                    return 'Selecciona capacidad máxima';
                  }
                  return null;
                },
              ),
            CustomButton(
              text: "Ver usuarios",
              isLoading: false,
              primary: false,
              onPressFunction: () {
                _mostrarUsuariosDialog();
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
                      "Cancelada edición de reserva $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                      tag: "RESERVAS_ADMIN",
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
                      "Intento de edición de reserva $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                      tag: "RESERVAS_ADMIN",
                    );

                    setState(() {
                      errorMessage = null;
                    });

                    if (!_editReservaForm.currentState!.validate()) {
                      AppLogger.warning(
                        "Formulario inválido al editar reserva $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                        tag: "RESERVAS_ADMIN",
                      );
                      return;
                    }

                    AppLogger.info(
                      "Datos validados correctamente para reserva $selectedFecha para $selectedPistaId de $horaInicio a $horaFin",
                      tag: "RESERVAS_ADMIN",
                    );

                    final updatedReserva = ReservasModel(
                      idReserva: widget.reserva.idReserva,
                      idPista: selectedPistaId!,
                      pista: widget.reserva.pista,
                      fecha: selectedFecha!,
                      horaInicio: horaInicio!,
                      horaFin: horaFin!,
                      estado: widget.reserva.estado,
                      usuarios: widget.reserva.usuarios,
                      capacidadMaxima: editarCapacidad
                          ? capacidadMaxima ?? widget.reserva.capacidadMaxima
                          : widget.reserva.capacidadMaxima,
                    );

                    // 🔥 CLAVE
                    final error = await widget.onEdit(updatedReserva);

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

  void _mostrarUsuariosDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Usuarios en la reserva"),
          content: SizedBox(
            width: 400,
            height: 300, // puedes ajustar
            child: widget.reserva.usuarios.isEmpty
                ? const Center(child: Text("No hay usuarios"))
                : ListView.builder(
                    itemCount: widget.reserva.usuarios.length,
                    itemBuilder: (context, i) {
                      final usuario = widget.reserva.usuarios[i];
                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color.fromARGB(255, 217, 221, 63),
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        title: Text("${usuario.apellidos}, ${usuario.nombre}"),
                        subtitle: Row(
                          spacing: 10,
                          children: [
                            Text("Nivel:"),
                            CustomBadge(text: usuario.nivel.toString()),
                          ],
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            _confirmDeleteParticipacion(
                              widget.reserva.idReserva,
                              usuario.idUsuario,
                              usuario.nombre,
                              usuario.apellidos,
                            );
                          },
                          child: const Text("Eliminar"),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            CustomButton(
              text: "Cerrar",
              isLoading: false,
              primary: false,
              onPressFunction: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteParticipacion(
    String idReserva,
    String idUsuario,
    String nombre,
    String apellidos,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar participación"),
          content: Text("¿Seguro que quieres eliminar a $nombre $apellidos?"),
          actions: [
            CustomButton(
              text: "Cancelar",
              isLoading: false,
              primary: true,
              onPressFunction: () => Navigator.pop(context, false),
            ),
            CustomButton(
              text: "Eliminar",
              isLoading: false,
              primary: false,
              onPressFunction: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      widget.onDeleteParticipacion(idReserva, idUsuario);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
