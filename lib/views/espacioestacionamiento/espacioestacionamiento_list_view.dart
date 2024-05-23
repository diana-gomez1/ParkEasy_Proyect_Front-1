// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/espacioestacionamiento.dart';
import 'package:memes/config/theme/app_theme.dart';
import 'package:memes/services/api_services_espacioestacionamiento.dart';

class EspacioEstacionamientoListView extends StatefulWidget {
  const EspacioEstacionamientoListView({super.key});

  @override
  State<EspacioEstacionamientoListView> createState() => _EspacioEstacionamientoListViewState();
}

class _EspacioEstacionamientoListViewState extends State<EspacioEstacionamientoListView> {
  late Future<List<EspacioEstacionamiento>> futureEspaciosEstacionamiento;

  @override
  void initState() {
    super.initState();
    futureEspaciosEstacionamiento = ApiServiceEspacioEstacionamiento().getEspaciosEstacionamiento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Espacios de Estacionamiento')),
      body: FutureBuilder<List<EspacioEstacionamiento>>(
        future: futureEspaciosEstacionamiento,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final espaciosEstacionamiento = snapshot.data!;
            return ListView.builder(
              itemCount: espaciosEstacionamiento.length,
              itemBuilder: (context, index) {
                final espacioEstacionamiento = espaciosEstacionamiento[index];
                return ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${espacioEstacionamiento.idEspacio}: ${espacioEstacionamiento.nombreEspacio}',
                              style: AppTheme().getTheme().textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmación'),
                              content: const Text(
                                '¿Estás seguro de que deseas eliminar este espacio de estacionamiento?',
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
                                      await ApiServiceEspacioEstacionamiento()
                                          .deleteEspacioEstacionamiento(
                                        espacioEstacionamiento.idEspacio,
                                      );
                                      setState(() {
                                        futureEspaciosEstacionamiento =
                                            ApiServiceEspacioEstacionamiento()
                                                .getEspaciosEstacionamiento();
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
                        icon: const Icon(Icons.delete_forever),
                      ),
                      IconButton(
                        onPressed: () {
                          context.go(
                            '/edit/${espacioEstacionamiento.idEspacio}?nombre=${Uri.encodeComponent(espacioEstacionamiento.nombreEspacio)}',
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Tipo de Vehículo: ${espacioEstacionamiento.tipoVehiculo}',
                    style: AppTheme().getTheme().textTheme.titleSmall,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Ocupado: ${espacioEstacionamiento.ocupado ? "Sí" : "No"}',
                            style: AppTheme().getTheme().textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/espacioestacionamientoagregar');
        },
        child: const Icon(Icons.add_box_sharp),
      ),
    );
  }
}
