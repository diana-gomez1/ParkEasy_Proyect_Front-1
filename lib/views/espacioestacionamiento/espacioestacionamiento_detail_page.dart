import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/espacioestacionamiento.dart';
import 'package:memes/services/api_services_espacioestacionamiento.dart';

class EspacioEstacionamientoDetailPage extends StatelessWidget {
  final int id;

  const EspacioEstacionamientoDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Espacio de Estacionamiento')),
      body: FutureBuilder<EspacioEstacionamiento>(
        future: ApiServiceEspacioEstacionamiento().getEspacioEstacionamiento(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron datos'));
          } else {
            final espacio = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre del Espacio: ${espacio.nombreEspacio}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Tipo de Vehículo: ${espacio.tipoVehiculo}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Ocupado: ${espacio.ocupado ? "Sí" : "No"}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push('/edit/${espacio.idEspacio}');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: const Text('¿Estás seguro de que deseas eliminar este espacio de estacionamiento?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (shouldDelete == true) {
                            await ApiServiceEspacioEstacionamiento().deleteEspacioEstacionamiento(espacio.idEspacio);
                            context.pop();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
