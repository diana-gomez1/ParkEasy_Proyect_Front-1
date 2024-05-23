// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/establecimiento.dart';
import 'package:memes/services/api-services_establecimiento.dart';
import 'package:memes/config/theme/app_theme.dart';

class EstablecimientoFormPage extends StatefulWidget {
  final Establecimiento? establecimiento;

  const EstablecimientoFormPage({super.key, this.establecimiento});

  @override
  State<EstablecimientoFormPage> createState() => _EstablecimientoFormPageState();
}

class _EstablecimientoFormPageState extends State<EstablecimientoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idEstablecimientoController;
  late TextEditingController _nombreEstablecimientoController;
  late TextEditingController _descripcionController;
  late TextEditingController _direccionController;
  late TextEditingController _nitController;

  @override
  void initState() {
    super.initState();
    _idEstablecimientoController = TextEditingController(
        text: widget.establecimiento?.idEstablecimiento.toString() ?? '');
    _nombreEstablecimientoController =
        TextEditingController(text: widget.establecimiento?.nombreEstablecimiento ?? '');
    _descripcionController = 
        TextEditingController(text: widget.establecimiento?.descripcion ?? '');
    _direccionController = 
        TextEditingController(text: widget.establecimiento?.direccion ?? '');
    _nitController = 
        TextEditingController(text: widget.establecimiento?.nit ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme().getTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.establecimiento == null
              ? 'Crear Establecimiento'
              : 'Editar Establecimiento'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _idEstablecimientoController,
                  decoration: InputDecoration(
                    labelText: 'ID del Establecimiento',
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
                      return 'Por favor ingrese la ID del establecimiento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nombreEstablecimientoController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del establecimiento',
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
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripcion',
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
                      return 'Por favor ingrese una descripcion';
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _direccionController,
                  decoration: InputDecoration(
                    labelText: 'Direccion',
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
                      return 'Por favor ingrese una descripcion';
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nitController,
                  decoration: InputDecoration(
                    labelText: 'NIT',
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
                      return 'Por favor ingrese un número de identificación tributaria';
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
                      final establecimiento = Establecimiento(
                        idEstablecimiento: int.parse(_idEstablecimientoController.text),
                        nombreEstablecimiento: _nombreEstablecimientoController.text,
                        descripcion: _descripcionController.text,
                        direccion: _direccionController.text,
                        nit: _nitController.text,
                      );
                      if (widget.establecimiento == null) {
                        await ApiServiceestablecimiento()
                            .createEstablecimiento(establecimiento);
                      } else {
                        await ApiServiceestablecimiento()
                            .updateEstablecimiento(establecimiento);
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
                  child: Text(
                      widget.establecimiento == null ? 'Crear' : 'Actualizar'),
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
