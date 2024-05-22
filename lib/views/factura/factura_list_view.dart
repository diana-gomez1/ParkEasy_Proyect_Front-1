// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/factura.dart';
import 'package:memes/services/api_services_factura.dart';
import 'package:memes/config/theme/app_theme.dart';

class FacturaListView extends StatefulWidget {
  const FacturaListView({super.key});

  @override
  State<FacturaListView> createState() => _FacturaListViewState();
}

class _FacturaListViewState extends State<FacturaListView> {
  late Future<List<Factura>> futureFacturas;

  @override
  void initState() {
    super.initState();
    futureFacturas = ApiServiceFactura().getFacturas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facturas')),
      body: FutureBuilder<List<Factura>>(
        future: futureFacturas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final facturas = snapshot.data!;
            return ListView.builder(
              itemCount: facturas.length,
              itemBuilder: (context, index) {
                final factura = facturas[index];
                return ListTile(
                  title: Text(
                    'Factura #${factura.idFactura}',
                    style: AppTheme().getTheme().textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Placa del Vehículo: ${factura.placaVehiculo}',
                    style: AppTheme().getTheme().textTheme.titleSmall,
                  ),
                  onTap: () {
                    // Acción al hacer clic en la factura
                  },
                  trailing: IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmación'),
                          content: const Text(
                            '¿Estás seguro de que deseas eliminar esta factura?',
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
                                  await ApiServiceFactura()
                                      .deleteFactura(factura.idFactura);
                                  setState(() {
                                    futureFacturas =
                                        ApiServiceFactura().getFacturas();
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
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/facturasagregar');
        },
        child: const Icon(Icons.add_box_sharp),
      ),
    );
  }
}
