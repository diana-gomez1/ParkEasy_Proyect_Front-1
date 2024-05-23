// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/caja.dart';
import 'package:memes/services/api_services_caja.dart';
import 'package:memes/config/theme/app_theme.dart';

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
    return Theme(
      data: AppTheme().getTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.caja == null ? 'Crear Caja' : 'Editar Caja'),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  child: Text(widget.caja == null ? 'Crear' : 'Actualizar'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    textStyle: GoogleFonts.montserratAlternates(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
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
