import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/tipovehiculo.dart';
import 'package:memes/services/api_services_tipovehiculo.dart';

class TipoVehiculoDetailPage extends StatelessWidget {
  final int id;

  const TipoVehiculoDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de tipos de vehículos')),
      body: FutureBuilder<TipoVehiculo>(
        future: ApiServicetipovehiculo().getTipoVehiculos(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final tipoVehiculo = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${tipoVehiculo.nombre}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Valor por hora: \$${tipoVehiculo.valorHora}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Valor por día: \$${tipoVehiculo.valorDia}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Valor por mes: \$${tipoVehiculo.valorMes}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push('/edit/${tipoVehiculo.idVehiculo}');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Aquí puedes agregar la lógica para eliminar el tipo de vehículo
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
