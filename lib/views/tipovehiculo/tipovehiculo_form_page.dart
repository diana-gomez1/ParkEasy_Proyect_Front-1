// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/tipovehiculo.dart';
import 'package:memes/services/api_services_tipovehiculo.dart';
import 'package:memes/config/theme/app_theme.dart';

class TipoVehiculoFormPage extends StatefulWidget {
  final TipoVehiculo? tipoVehiculo;

  const TipoVehiculoFormPage({super.key, this.tipoVehiculo});

  @override
  State<TipoVehiculoFormPage> createState() => _TipoVehiculoFormPageState();
}

class _TipoVehiculoFormPageState extends State<TipoVehiculoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController; // Nuevo controlador para la ID
  late TextEditingController _nombreController;
  late TextEditingController _valorHoraController;
  late TextEditingController _valorDiaController;
  late TextEditingController _valorMesController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(
        text: widget.tipoVehiculo?.idVehiculo.toString() ??
            ''); // Inicializa con el valor de la ID si existe
    _nombreController =
        TextEditingController(text: widget.tipoVehiculo?.nombre ?? '');
    _valorHoraController = TextEditingController(
        text: widget.tipoVehiculo?.valorHora.toString() ?? '');
    _valorDiaController = TextEditingController(
        text: widget.tipoVehiculo?.valorDia.toString() ?? '');
    _valorMesController = TextEditingController(
        text: widget.tipoVehiculo?.valorMes.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme().getTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.tipoVehiculo == null
              ? 'Crear Tipo de Vehículo'
              : 'Editar Tipo de Vehículo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Nuevo campo para ingresar la ID
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'ID del Vehículo',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la ID del vehículo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorHoraController,
                  decoration: const InputDecoration(
                    labelText: 'Valor por hora',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorDiaController,
                  decoration: const InputDecoration(
                    labelText: 'Valor por día',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorMesController,
                  decoration: const InputDecoration(
                    labelText: 'Valor por mes',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final tipoVehiculo = TipoVehiculo(
                        idVehiculo: int.parse(
                            _idController.text), // Obtén la ID del controlador
                        nombre: _nombreController.text,
                        valorHora: double.parse(_valorHoraController.text),
                        valorDia: double.parse(_valorDiaController.text),
                        valorMes: double.parse(_valorMesController.text),
                      );
                      if (widget.tipoVehiculo == null) {
                        await ApiServicetipovehiculo()
                            .createTipoVehiculo(tipoVehiculo);
                      } else {
                        await ApiServicetipovehiculo()
                            .updateTipoVehiculo(tipoVehiculo);
                      }
                      // Navegar a la lista de tipos de vehículos
                      context.go('/home');
                    }
                  },
                  child: Text(
                      widget.tipoVehiculo == null ? 'Crear' : 'Actualizar'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navegar al homepage
                    context.go('/home');
                  },
                  child: const Text('Ir al Homepage'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
