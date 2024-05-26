// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/factura.dart';
import 'package:memes/services/api_services_factura.dart';

class FacturaFormPage extends StatefulWidget {
  final Factura? factura;

  const FacturaFormPage({super.key, this.factura});

  @override
  _FacturaFormPageState createState() => _FacturaFormPageState();
}

class _FacturaFormPageState extends State<FacturaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _placaVehiculoController;
  late TextEditingController _montoPagarController;

  @override
  void initState() {
    super.initState();
    _idController =
        TextEditingController(text: widget.factura?.idFactura.toString() ?? '');
    _placaVehiculoController =
        TextEditingController(text: widget.factura?.placaVehiculo ?? '');
    _montoPagarController = TextEditingController(
        text: widget.factura?.montoPagar.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.factura == null ? 'Crear Factura' : 'Editar Factura',
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
                  labelText: 'ID de la Factura',
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
                    return 'Por favor ingrese el ID de la factura';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _placaVehiculoController,
                decoration: InputDecoration(
                  labelText: 'Placa del Vehículo',
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
                    return 'Por favor ingrese la placa del vehículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _montoPagarController,
                decoration: InputDecoration(
                  labelText: 'Monto a Pagar',
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
                    return 'Por favor ingrese el monto a pagar';
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
                    final factura = Factura(
                      idFactura: int.parse(_idController.text),
                      placaVehiculo: _placaVehiculoController.text,
                      montoPagar: double.parse(_montoPagarController.text),
                      fechaSalida:
                          DateTime.now(), // Asigna la fecha y hora actual
                    );
                    if (widget.factura == null) {
                      await ApiServiceFactura().createFactura(factura);
                    } else {
                      await ApiServiceFactura().updateFactura(factura);
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
                    color: Color(0xFF497FEB), // Color del contorno
                    width: 2.0, // Ancho del contorno
                  ),
                ),
                child: Text(
                  widget.factura == null ? 'Crear' : 'Actualizar',
                  style: GoogleFonts.montserratAlternates(
                    color: const Color(0xFF497FEB), // Color de la fuente
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
