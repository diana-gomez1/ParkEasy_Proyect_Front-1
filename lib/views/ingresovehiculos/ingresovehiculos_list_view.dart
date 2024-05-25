// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/ingreso_vehiculos.dart';
import 'package:memes/services/api_services_ingresovehiculos.dart';

class IngresoVehiculoListView extends StatefulWidget {
  const IngresoVehiculoListView({super.key});

  @override
  _IngresoVehiculoListViewState createState() =>
      _IngresoVehiculoListViewState();
}

class _IngresoVehiculoListViewState extends State<IngresoVehiculoListView> {
  late Future<List<IngresoVehiculos>> futureIngresoVehiculos;

  @override
  void initState() {
    super.initState();
    futureIngresoVehiculos = ApiServiceIngresoVehiculos().getIngresoVehiculos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingresos de Vehículos',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 24, 99, 250),
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.add_box_sharp,
                color: Color.fromARGB(255, 24, 99, 250),
              ),
              onPressed: () {
                context.go('/ingresovehiculoagregar');
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<IngresoVehiculos>>(
        future: futureIngresoVehiculos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final ingresosVehiculos = snapshot.data!;
            return ListView.builder(
              itemCount: ingresosVehiculos.length,
              itemBuilder: (context, index) {
                final ingresoVehiculo = ingresosVehiculos[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildIngresoVehiculoCard(ingresoVehiculo),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildIngresoVehiculoCard(IngresoVehiculos ingresoVehiculo) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        title: Text(
          'Placa del Vehículo: ${ingresoVehiculo.placaVehiculo}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 18,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha de Ingreso: ${ingresoVehiculo.fechaIngreso}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                  ),
            ),
            Text(
              'Tipo de Vehículo: ${ingresoVehiculo.tipoVehiculo}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                  ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _showDeleteConfirmationDialog(ingresoVehiculo);
          },
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      IngresoVehiculos ingresoVehiculo) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar este ingreso de vehículo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ApiServiceIngresoVehiculos()
                    .deleteIngresoVehiculo(ingresoVehiculo.placaVehiculo);
                setState(() {
                  futureIngresoVehiculos =
                      ApiServiceIngresoVehiculos().getIngresoVehiculos();
                });
                Navigator.of(context).pop(true);
                context.go('/home');
              } catch (e) {
                if (kDebugMode) {
                  print('Error al eliminar: $e');
                }
                Navigator.of(context).pop(false);
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingreso de vehículo eliminado')),
      );
    }
  }
}