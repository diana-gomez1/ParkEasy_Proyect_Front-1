import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/establecimiento.dart';
import 'package:memes/services/api-services_establecimiento.dart';

class EstablecimientoDetailPage extends StatelessWidget {
  final int id;

  const EstablecimientoDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de establecimientos')),
      body: FutureBuilder<Establecimiento>(
        future: ApiServiceEstablecimiento().getEstablecimientos(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final establecimiento = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: \$${establecimiento.nombreEstablecimiento}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Descripcion: \$${establecimiento.descripcion}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Direccion: \$${establecimiento.direccion}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('NIT: \$${establecimiento.nit}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push(
                              '/edit/${establecimiento.idEstablecimiento}');
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
