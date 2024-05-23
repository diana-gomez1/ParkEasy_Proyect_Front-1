import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/tipovehiculo.dart';
import 'package:memes/services/api_services_tipovehiculo.dart';
import 'package:memes/config/theme/app_theme.dart';

class TipoVehiculoFormPage extends StatefulWidget {
  final TipoVehiculo? tipoVehiculo;

  const TipoVehiculoFormPage({Key? key, this.tipoVehiculo}) : super(key: key);

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
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'ID del Vehículo',
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
                  controller: _valorHoraController,
                  decoration: InputDecoration(
                    labelText: 'Valor por hora',
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  child: Text(
                      widget.tipoVehiculo == null ? 'Crear' : 'Actualizar'),
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
