// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/espacioestacionamiento.dart';
import 'package:memes/services/api_services_espacioestacionamiento.dart';

class EspacioEstacionamientoListView extends StatefulWidget {
  const EspacioEstacionamientoListView({super.key});

  @override
  _EspacioEstacionamientoListViewState createState() =>
      _EspacioEstacionamientoListViewState();
}

class _EspacioEstacionamientoListViewState
    extends State<EspacioEstacionamientoListView> {
  late Future<List<EspacioEstacionamiento>> futureEspaciosEstacionamiento;

  @override
  void initState() {
    super.initState();
    futureEspaciosEstacionamiento =
        ApiServiceEspacioEstacionamiento().getEspaciosEstacionamiento();
  }

  @override
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila de cuadros super pequeños para mostrar el estado
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children:
                        espaciosEstacionamiento.map((espacioEstacionamiento) {
                      final bool ocupado = espacioEstacionamiento.ocupado;
                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: _buildStatusBox(espacioEstacionamiento, ocupado),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // Lista de tarjetas de espacio de estacionamiento
                Expanded(
                  child: ListView.builder(
                    itemCount: espaciosEstacionamiento.length,
                    itemBuilder: (context, index) {
                      final espacioEstacionamiento =
                          espaciosEstacionamiento[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildEspacioEstacionamientoCard(
                            espacioEstacionamiento),
                      );
                    },
                  ),
                ),
              ],
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

  Widget _buildStatusBox(
      EspacioEstacionamiento espacioEstacionamiento, bool ocupado) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          color: ocupado
              ? const Color.fromARGB(234, 224, 84, 76)
              : const Color.fromARGB(255, 110, 226, 126),
          margin: const EdgeInsets.only(bottom: 4),
        ),
        Text(
          espacioEstacionamiento.nombreEspacio,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEspacioEstacionamientoCard(
    EspacioEstacionamiento espacioEstacionamiento,
  ) {
    final bool ocupado = espacioEstacionamiento.ocupado;
    final Color color = ocupado
        ? const Color.fromARGB(234, 224, 84, 76)
        : const Color.fromARGB(255, 110, 226, 126);

    return Card(
      color: color,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        title: Text(
          'Nombre del lugar --> ${espacioEstacionamiento.nombreEspacio}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18, // Tamaño de fuente ajustado
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estado? --> ${ocupado ? "Ocupado" : "Libre"}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18, // Tamaño de fuente ajustado
                  ),
            ),
            Text(
              'Tipo de vehículo --> ${espacioEstacionamiento.tipoVehiculo}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18, // Tamaño de fuente ajustado
                  ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _showDeleteConfirmationDialog(espacioEstacionamiento);
          },
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      EspacioEstacionamiento espacioEstacionamiento) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar este espacio de estacionamiento?'),
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
                await ApiServiceEspacioEstacionamiento()
                    .deleteEspacioEstacionamiento(
                        espacioEstacionamiento.idEspacio);
                setState(() {
                  futureEspaciosEstacionamiento =
                      ApiServiceEspacioEstacionamiento()
                          .getEspaciosEstacionamiento();
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
        const SnackBar(content: Text('Espacio de estacionamiento eliminado')),
      );
    }
  }
}
