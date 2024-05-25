// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/ingreso_vehiculos.dart';
//import 'package:memes/models/tipo_vehiculo.dart'; // Importa el modelo TipoVehiculo
import 'package:memes/models/tipovehiculo.dart';
import 'package:memes/services/api_services_espacioestacionamiento.dart';
import 'package:memes/services/api_services_ingresovehiculos.dart';
import 'package:memes/services/api_services_tipovehiculo.dart';

class IngresoVehiculoFormPage extends StatefulWidget {
  const IngresoVehiculoFormPage({
    super.key,
  });

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

  List<TipoVehiculo> _tiposVehiculos =
      []; // Lista para almacenar los tipos de vehículos
  TipoVehiculo?
      _selectedTipoVehiculo; // Variable para almacenar el tipo de vehículo seleccionado

  @override
  void initState() {
    super.initState();
    _fechaIngresoController.text = DateTime.now().toString();
    _fetchEspaciosDisponibles();
    _fetchTiposVehiculos(); // Llama a la función para obtener los tipos de vehículos
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
        SnackBar(
          content: Text('Error al obtener espacios disponibles: $e'),
        ),
      );
    }
  }

  Future<void> _fetchTiposVehiculos() async {
    try {
      final tipos = await ApiServicetipovehiculo()
          .getTipoVehiculo(); // Reemplaza ApiServiceTipoVehiculo con tu servicio real
      setState(() {
        _tiposVehiculos = tipos;
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
          'Agregar Ingreso Vehículo',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 24, 99, 250),
              ),
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
              _buildTextField(
                controller: _fechaIngresoController,
                label: 'Fecha de Ingreso',
                enabled: false,
              ),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final nuevoIngreso = IngresoVehiculos(
                      placaVehiculo: _placaVehiculoController.text,
                      fechaIngreso: _fechaIngresoController.text,
                      tipoVehiculo: _selectedTipoVehiculo!
                          .nombre, // Usa el nombre del tipo de vehículo seleccionado
                      idEspacio: int.parse(_idEspacioController.text),
                      fechaSalida: null,
                    );

                    try {
                      await ApiServiceIngresoVehiculos()
                          .createIngresoVehiculo(nuevoIngreso);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Ingreso de vehículo agregado exitosamente'),
                        ),
                      );
                      context.go('/home');
                    } catch (e) {
                      if (kDebugMode) {
                        print('Error al agregar ingreso de vehículo: $e');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Error al agregar ingreso de vehículo: $e'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Agregar'),
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
        labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 18,
            ),
      ),
      value: value,
      items: items
          .map((item) => DropdownMenuItem<TipoVehiculo>(
                value: item,
                child: Text(
                  item.nombre, // Usa el nombre del tipo de vehículo como texto del elemento desplegable
                  style: const TextStyle(fontSize: 16),
                ),
              ))
          .toList(),
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
        labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              // Corregido el uso de `titleMedium` por `headline6`
              fontSize: 18,
            ),
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
        labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              // Corregido el uso de `titleMedium` por `headline6`
              fontSize: 18,
            ),
      ),
      value: value,
      items: items
          .map((item) => DropdownMenuItem<int>(
                value: item,
                child: Text(
                  item.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ))
          .toList(),
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
