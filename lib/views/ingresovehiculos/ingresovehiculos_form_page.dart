// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/ingreso_vehiculos.dart';
import 'package:memes/models/tipovehiculo.dart';
import 'package:memes/services/api_services_espacioestacionamiento.dart';
import 'package:memes/services/api_services_ingresovehiculos.dart';
import 'package:memes/services/api_services_tipovehiculo.dart';

class IngresoVehiculoFormPage extends StatefulWidget {
  const IngresoVehiculoFormPage({super.key});

  @override
  _IngresoVehiculoFormPageState createState() =>
      _IngresoVehiculoFormPageState();
}

class _IngresoVehiculoFormPageState extends State<IngresoVehiculoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _placaVehiculoController =
      TextEditingController();
  final TextEditingController _fechaIngresoController = TextEditingController();
  final TextEditingController _tipoVehiculoController = TextEditingController();
  final TextEditingController _idEspacioController = TextEditingController();

  List<int> _espaciosDisponibles = [];
  List<TipoVehiculo> _tiposVehiculos = [];
  TipoVehiculo? _selectedTipoVehiculo;

  @override
  void initState() {
    super.initState();
    _fechaIngresoController.text = DateTime.now().toString();
    _fetchEspaciosDisponibles();
    _fetchTiposVehiculos();
  }

  Future<void> _fetchEspaciosDisponibles() async {
    try {
      final espacios =
          await ApiServiceEspacioEstacionamiento().getEspaciosEstacionamiento();
      setState(() {
        _espaciosDisponibles = espacios
            .where((espacio) => !espacio.ocupado)
            .map((espacio) => espacio.idEspacio)
            .toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener espacios disponibles: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener espacios disponibles: $e')),
      );
    }
  }

  Future<void> _fetchTiposVehiculos() async {
    try {
      final tipos = await ApiServicetipovehiculo().getTipoVehiculo();
      setState(() {
        _tiposVehiculos = tipos;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener tipos de vehículos: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener tipos de vehículos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agregar Ingreso Vehículo',
          style: GoogleFonts.montserratAlternates(
            fontWeight: FontWeight.w500,
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
          child: ListView(
            children: [
              _buildTextField(
                controller: _placaVehiculoController,
                label: 'Placa del Vehículo',
              ),
              const SizedBox(height: 16), // Espacio vertical
              _buildTextField(
                controller: _fechaIngresoController,
                label: 'Fecha de Ingreso',
                enabled: false,
              ),
              const SizedBox(height: 16), // Espacio vertical
              _buildTipoVehiculoDropdown(
                label: 'Tipo de Vehículo',
                value: _selectedTipoVehiculo,
                items: _tiposVehiculos,
                onChanged: (value) {
                  setState(() {
                    _selectedTipoVehiculo = value;
                  });
                },
              ),
              const SizedBox(height: 16), // Espacio vertical
              _buildDropdownField(
                label: 'ID de Espacio',
                value: _idEspacioController.text.isEmpty
                    ? null
                    : int.tryParse(_idEspacioController.text),
                items: _espaciosDisponibles,
                onChanged: (value) {
                  setState(() {
                    _idEspacioController.text = value.toString();
                  });
                },
              ),
              const SizedBox(height: 20), // Espacio vertical
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final nuevoIngreso = IngresoVehiculos(
                      placaVehiculo: _placaVehiculoController.text,
                      fechaIngreso: _fechaIngresoController.text,
                      tipoVehiculo: _selectedTipoVehiculo!.nombre,
                      idEspacio: int.parse(_idEspacioController.text),
                      fechaSalida: null,
                    );

                    try {
                      await ApiServiceIngresoVehiculos()
                          .createIngresoVehiculo(nuevoIngreso);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Ingreso de vehículo agregado exitosamente')),
                      );
                      context.go('/home');
                    } catch (e) {
                      if (kDebugMode) {
                        print('Error al agregar ingreso de vehículo: $e');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Error al agregar ingreso de vehículo: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  textStyle: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF497FEB),
                    width: 2.0,
                  ),
                ),
                child: Text(
                  'Agregar',
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

  Widget _buildTipoVehiculoDropdown({
    required String label,
    required TipoVehiculo? value,
    required List<TipoVehiculo> items,
    required ValueChanged<TipoVehiculo?> onChanged,
  }) {
    return DropdownButtonFormField<TipoVehiculo>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserratAlternates(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<TipoVehiculo>(
          value: item,
          child: Text(
            item.nombre,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor seleccione un $label';
        }
        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserratAlternates(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        border: const OutlineInputBorder(),
      ),
      style: GoogleFonts.montserratAlternates(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 73, 128, 237),
      ),
      keyboardType: keyboardType,
      enabled: enabled,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required int? value,
    required List<int> items,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserratAlternates(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<int>(
          value: item,
          child: Text(
            item.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor seleccione un $label';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _placaVehiculoController.dispose();
    _fechaIngresoController.dispose();
    _tipoVehiculoController.dispose();
    _idEspacioController.dispose();
    super.dispose();
  }
}
