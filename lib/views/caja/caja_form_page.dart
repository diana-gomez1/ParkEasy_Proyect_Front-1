// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/caja.dart';
import 'package:memes/services/api_services_caja.dart';

class CajaFormPage extends StatefulWidget {
  final Caja? caja;

  const CajaFormPage({super.key, this.caja});

  @override
  State<CajaFormPage> createState() => _CajaFormPageState();
}

class _CajaFormPageState extends State<CajaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _nombreCajaController;
  late TextEditingController _saldoController;
  late TextEditingController _nombreAdminController;

  @override
  void initState() {
    super.initState();
    _idController =
        TextEditingController(text: widget.caja?.idCaja.toString() ?? '');
    _nombreCajaController =
        TextEditingController(text: widget.caja?.nombreCaja ?? '');
    _saldoController =
        TextEditingController(text: widget.caja?.saldo.toString() ?? '');
    _nombreAdminController =
        TextEditingController(text: widget.caja?.nombreAdmin ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.caja == null ? 'Crear Caja' : 'Editar Caja',
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
                  labelText: 'ID de Caja',
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
                    return 'Por favor ingrese la ID de la caja';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreCajaController,
                decoration: InputDecoration(
                  labelText: 'Nombre Caja',
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
                    return 'Por favor ingrese el nombre de la Caja';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _saldoController,
                decoration: InputDecoration(
                  labelText: 'Saldo',
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
                    return 'Por favor ingrese el saldo';
                  }
                  return null;
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreAdminController,
                decoration: InputDecoration(
                  labelText: 'Nombre Admin',
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
                    return 'Por favor ingrese el nombre de Admin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final caja = Caja(
                      idCaja: int.parse(_idController.text),
                      nombreCaja: _nombreCajaController.text,
                      saldo: double.parse(_saldoController.text),
                      nombreAdmin: _nombreAdminController.text,
                    );
                    if (widget.caja == null) {
                      await ApiServiceCaja().createCaja(caja);
                    } else {
                      await ApiServiceCaja().updateCaja(caja);
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
                  widget.caja == null ? 'Crear' : 'Actualizar',
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
