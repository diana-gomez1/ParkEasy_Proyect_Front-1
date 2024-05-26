// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/espacioestacionamiento.dart';
import 'package:memes/services/api_services_espacioestacionamiento.dart';
import 'package:memes/services/api_services_tipovehiculo.dart';
import 'package:memes/models/tipovehiculo.dart';

class EspacioEstacionamientoFormPage extends StatefulWidget {
  final EspacioEstacionamiento? espacioEstacionamiento;

  const EspacioEstacionamientoFormPage(
      {super.key, this.espacioEstacionamiento});

  @override
  State<EspacioEstacionamientoFormPage> createState() =>
      _EspacioEstacionamientoFormPageState();
}

class _EspacioEstacionamientoFormPageState
    extends State<EspacioEstacionamientoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _nombreController;
  late TextEditingController _tipoVehiculoController;
  late TextEditingController _ocupadoController;

  List<TipoVehiculo> _tiposVehiculos = [];
  TipoVehiculo? _selectedTipoVehiculo;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(
        text: widget.espacioEstacionamiento?.idEspacio.toString() ?? '');
    _nombreController = TextEditingController(
        text: widget.espacioEstacionamiento?.nombreEspacio ?? '');
    _tipoVehiculoController = TextEditingController(
        text: widget.espacioEstacionamiento?.tipoVehiculo ?? '');
    _ocupadoController = TextEditingController(
        text: widget.espacioEstacionamiento?.ocupado.toString() ?? '');

    // Llama a la función para obtener los tipos de vehículos existentes
    _fetchTiposVehiculos();
  }

  Future<void> _fetchTiposVehiculos() async {
    try {
      final tiposVehiculos = await ApiServicetipovehiculo().getTipoVehiculo();
      setState(() {
        _tiposVehiculos = tiposVehiculos;
      });
    } catch (e) {
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.espacioEstacionamiento == null
              ? 'Crear Espacio de Estacionamiento'
              : 'Editar Espacio de Estacionamiento',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: const Color(0xFF497FEB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: const Color.fromARGB(255, 56, 244, 18),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID del Espacio',
                  border: const OutlineInputBorder(),
                  labelStyle: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                style: GoogleFonts.montserratAlternates(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 73, 128, 237),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la ID del espacio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Espacio',
                  border: const OutlineInputBorder(),
                  labelStyle: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                style: GoogleFonts.montserratAlternates(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 73, 128, 237),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TipoVehiculo>(
                value: _selectedTipoVehiculo,
                decoration: InputDecoration(
                  labelText: 'Tipo de Vehículo',
                  border: const OutlineInputBorder(),
                  labelStyle: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                items: _tiposVehiculos
                    .map((tipo) => DropdownMenuItem<TipoVehiculo>(
                          value: tipo,
                          child: Text(
                            tipo.nombre,
                            style: const TextStyle(
                              fontSize:
                                  16, // Ajusta aquí el tamaño de la fuente
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTipoVehiculo = value;
                    _tipoVehiculoController.text = value!.nombre;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un tipo de vehículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<bool>(
                value: widget.espacioEstacionamiento?.ocupado ?? false,
                decoration: InputDecoration(
                  labelText: 'Ocupado',
                  border: const OutlineInputBorder(),
                  labelStyle: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: true,
                    child: Text(
                      'Sí',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text(
                      'No',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
                onChanged: (value) {
                  _ocupadoController.text = value.toString();
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione si está ocupado';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final espacioEstacionamiento = EspacioEstacionamiento(
                      idEspacio: int.parse(_idController.text),
                      nombreEspacio: _nombreController.text,
                      tipoVehiculo: _tipoVehiculoController.text,
                      ocupado: _ocupadoController.text.toLowerCase() == 'true',
                    );
                    if (widget.espacioEstacionamiento == null) {
                      await ApiServiceEspacioEstacionamiento()
                          .createEspacioEstacionamiento(espacioEstacionamiento);
                    } else {
                      await ApiServiceEspacioEstacionamiento()
                          .updateEspacioEstacionamiento(espacioEstacionamiento);
                    }
                    context.go('/home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  textStyle: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF497FEB),
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF497FEB),
                    width: 2.0,
                  ),
                ),
                child: Text(
                  widget.espacioEstacionamiento == null
                      ? 'Crear'
                      : 'Actualizar',
                  style: GoogleFonts.montserratAlternates(
                    color: const Color(0xFF497FEB),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
