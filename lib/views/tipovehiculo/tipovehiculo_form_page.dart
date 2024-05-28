// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkeasy/models/tipovehiculo.dart';
import 'package:parkeasy/services/api_services_tipovehiculo.dart';

class TipoVehiculoFormPage extends StatefulWidget {
  final TipoVehiculo? tipoVehiculo;

  const TipoVehiculoFormPage({super.key, this.tipoVehiculo});

  @override
  State<TipoVehiculoFormPage> createState() => _TipoVehiculoFormPageState();
}

class _TipoVehiculoFormPageState extends State<TipoVehiculoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _nombreController;
  late TextEditingController _valorHoraController;
  late TextEditingController _valorDiaController;
  late TextEditingController _valorMesController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(
        text: widget.tipoVehiculo?.idVehiculo.toString() ?? '');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tipoVehiculo == null
              ? 'Crear Tipo de Vehículo'
              : 'Editar Tipo de Vehículo',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                  labelText: 'ID del Vehículo',
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
                    return 'Por favor ingrese la ID del vehículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
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
              TextFormField(
                controller: _valorHoraController,
                decoration: InputDecoration(
                  labelText: 'Valor por hora',
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
                decoration: InputDecoration(
                  labelText: 'Valor por día',
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
                decoration: InputDecoration(
                  labelText: 'Valor por mes',
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
                      idVehiculo: int.parse(_idController.text),
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
                  widget.tipoVehiculo == null ? 'Crear' : 'Actualizar',
                  style: GoogleFonts.montserratAlternates(
                    color: const Color(0xFF497FEB),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
