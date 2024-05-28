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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '     Espacios Parking Lot',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: IconButton(
              // ignore: prefer_const_constructors
              icon: Icon(
                Icons.add_circle_outline_sharp,
                color: const Color.fromARGB(255, 56, 244, 18),
              ),
              onPressed: () {
                context.go('/espacioestacionamientoagregar');
              },
            ),
          ),
        ],
        backgroundColor: const Color(0xFF497FEB),
      ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          espaciosEstacionamiento.map((espacioEstacionamiento) {
                        final bool ocupado = espacioEstacionamiento.ocupado;
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child:
                              _buildStatusBox(espacioEstacionamiento, ocupado),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildStatusBox(
      EspacioEstacionamiento espacioEstacionamiento, bool ocupado) {
    return Column(
      children: [
        Container(
          width: 23,
          height: 23,
          color: ocupado
              ? const Color.fromARGB(255, 239, 44, 33)
              : const Color.fromARGB(255, 102, 243, 109),
          margin: const EdgeInsets.only(bottom: 4),
        ),
        Text(
          espacioEstacionamiento.nombreEspacio,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: ocupado
                    ? const Color.fromARGB(255, 239, 44, 33)
                    : const Color.fromARGB(255, 56, 244, 18),
                fontSize: 14,
              ),
        ),
      ],
    );
  }

  Widget _buildEspacioEstacionamientoCard(
    EspacioEstacionamiento espacioEstacionamiento,
  ) {
    final bool ocupado = espacioEstacionamiento.ocupado;
    final Color borderColor = ocupado
        ? const Color.fromARGB(255, 239, 44, 33)
        : const Color.fromARGB(255, 56, 244, 18);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Nombre del lugar : ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        color: Colors.black, // Color del campo
                      ),
                ),
                TextSpan(
                  text: espacioEstacionamiento.nombreEspacio,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 22,
                        color: ocupado
                            ? const Color.fromARGB(255, 239, 44, 33)
                            : const Color.fromARGB(255, 56, 244, 18),
                      ),
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Tipo de vehículo: ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                            color: Colors.black, // Color del campo
                          ),
                    ),
                    TextSpan(
                      text: espacioEstacionamiento.tipoVehiculo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 22,
                            color: ocupado
                                ? const Color.fromARGB(255, 239, 44, 33)
                                : const Color.fromARGB(255, 56, 244, 18),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              _showDeleteConfirmationDialog(espacioEstacionamiento);
            },
            icon: const Icon(Icons.delete_forever_outlined),
            color: const Color.fromARGB(255, 239, 44, 33),
          ),
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
