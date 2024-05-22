import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/tipovehiculo.dart';
import 'package:memes/services/api_services_tipovehiculo.dart';
import 'package:memes/config/theme/app_theme.dart';

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
      appBar: AppBar(title: const Text('Tipos de Vehículos')),
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
                return ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${tipoVehiculo.idVehiculo}: ${tipoVehiculo.nombre}',
                              style:
                                  AppTheme().getTheme().textTheme.titleMedium,
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
                        icon: const Icon(Icons.delete_forever),
                      ),
                      IconButton(
                        onPressed: () {
                          context.go(
                            '/edit/${tipoVehiculo.idVehiculo}?nombre=${Uri.encodeComponent(tipoVehiculo.nombre)}',
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Valor por hora: \$${tipoVehiculo.valorHora}',
                    style: AppTheme().getTheme().textTheme.titleSmall,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Valor por día: \$${tipoVehiculo.valorDia}',
                            style: AppTheme().getTheme().textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Valor por mes: \$${tipoVehiculo.valorMes}',
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
          context.go('/tipovehiculosagregar');
        },
        child: const Icon(Icons.add_box_sharp),
      ),
    );
  }
}
