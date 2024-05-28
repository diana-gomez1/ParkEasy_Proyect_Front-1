// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkeasy/models/tipovehiculo.dart';
import 'package:parkeasy/services/api_services_tipovehiculo.dart';
//import 'package:parkeasy/config/theme/app_theme.dart';

class TipoVehiculoListView extends StatefulWidget {
  const TipoVehiculoListView({super.key});

  @override
  State<TipoVehiculoListView> createState() => _TipoVehiculoListViewState();
}

class _TipoVehiculoListViewState extends State<TipoVehiculoListView> {
  late Future<List<TipoVehiculo>> futureTipoVehiculos;

  @override
  void initState() {
    super.initState();
    futureTipoVehiculos = ApiServicetipovehiculo().getTipoVehiculo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                '          Tipos de Vehículos',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
            IconButton(
                onPressed: () {
                  context.go('/tipovehiculosagregar');
                },
                icon: const Icon(Icons.add_circle_outline_sharp),
                color: const Color.fromARGB(255, 56, 244, 18)),
          ],
        ),
        backgroundColor: const Color(0xFF497FEB),
      ),
      body: FutureBuilder<List<TipoVehiculo>>(
        future: futureTipoVehiculos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final tipoVehiculos = snapshot.data!;
            return ListView.builder(
              itemCount: tipoVehiculos.length,
              itemBuilder: (context, index) {
                final tipoVehiculo = tipoVehiculos[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            ' ${tipoVehiculo.nombre}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 73, 128, 237),
                                ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        _buildInfoRow(
                            'Valor por hora:', '\$${tipoVehiculo.valorHora}',
                            fontSizeLabel: 18.0,
                            fontSizeValue: 19.0,
                            fieldColor: Colors.black, // Color del campo
                            valueColor: const Color.fromARGB(255, 56, 244, 18)),
                        _buildInfoRow(
                            'Valor por día:', '\$${tipoVehiculo.valorDia}',
                            fontSizeLabel: 18.0,
                            fontSizeValue: 19.0,
                            fieldColor: Colors.black, // Color del campo
                            valueColor: const Color.fromARGB(255, 56, 244, 18)),
                        _buildInfoRow(
                            'Valor por mes:', '\$${tipoVehiculo.valorMes}',
                            fontSizeLabel: 18.0,
                            fontSizeValue: 19.0,
                            fieldColor: Colors.black, // Color del campo
                            valueColor: const Color.fromARGB(255, 56, 244, 18)),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirmación'),
                                      content: const Text(
                                        '¿Estás seguro de que deseas eliminar este tipo de vehículo?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await ApiServicetipovehiculo()
                                                  .deleteTipoVehiculo(
                                                tipoVehiculo.idVehiculo,
                                              );
                                              setState(() {
                                                futureTipoVehiculos =
                                                    ApiServicetipovehiculo()
                                                        .getTipoVehiculo();
                                              });
                                              Navigator.of(context).pop();
                                              context.go('/home');
                                            } catch (e) {
                                              if (kDebugMode) {
                                                print('Error al eliminar: $e');
                                              }
                                            }
                                          },
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete_forever_outlined),
                                color: const Color.fromARGB(255, 239, 44, 33)),
                            IconButton(
                                onPressed: () {
                                  context.go(
                                    '/edit/${tipoVehiculo.idVehiculo}?nombre=${Uri.encodeComponent(tipoVehiculo.nombre)}',
                                  );
                                },
                                icon: const Icon(Icons.edit_outlined),
                                color: const Color.fromARGB(255, 255, 227, 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? fieldColor,
    Color? valueColor,
    double fontSizeLabel = 20.0,
    double fontSizeValue = 20.0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.montserratAlternates(
              fontSize: fontSizeLabel,
              fontWeight: FontWeight.w700,
              color: fieldColor ??
                  Colors
                      .black, // Usar el color del campo si se proporciona, de lo contrario, usar negro
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: GoogleFonts.montserratAlternates(
              fontSize: fontSizeValue,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color.fromARGB(255, 73, 128, 237),
            ),
          ),
        ],
      ),
    );
  }
}
