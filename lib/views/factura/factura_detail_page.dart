import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/factura.dart'; // Asegúrate de que el modelo Factura esté en esta ruta
import 'package:memes/services/api_services_factura.dart'; // Asegúrate de que el servicio ApiServiceFactura esté en esta ruta

class FacturaDetailPage extends StatelessWidget {
  final int id;

  const FacturaDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la factura')),
      body: FutureBuilder<Factura>(
        future: ApiServiceFactura().getFactura(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final factura = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID Factura: ${factura.idFactura}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Placa del vehículo: ${factura.placaVehiculo}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Monto a pagar: \$${factura.montoPagar}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Fecha de salida: ${factura.fechaSalida}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.go('/edit/${factura.idFactura}');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Aquí puedes agregar la lógica para eliminar la factura
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
