// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/factura.dart';
import 'package:memes/services/api_services_caja.dart';
import 'package:memes/services/api_services_factura.dart';
import 'package:memes/config/theme/app_theme.dart';
import 'package:memes/views/home.dart';

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

  // Método para eliminar una factura y actualizar el saldo de la caja
  Future<void> _deleteFacturaAndRefreshSaldo(int idFactura) async {
    try {
      await ApiServiceFactura().deleteFactura(idFactura);
      // Después de eliminar la factura, actualiza el saldo
      await _fetchSaldoCaja();
      // Luego, actualiza la lista de facturas
      setState(() {
        futureFacturas = ApiServiceFactura().getFacturas();
      });
      Navigator.of(context).pop();
      context.go('/home');
    } catch (e) {
      if (kDebugMode) {
        print('Error al eliminar: $e');
      }
    }
  }

  // Método para obtener el saldo de la caja desde la API
  Future<void> _fetchSaldoCaja() async {
    try {
      final saldo = await ApiServiceCaja().getSaldoCaja(1); // ID de la caja
      // Actualiza el saldo usando el controller
      SaldoController().actualizarSaldo(saldo);
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener saldo de caja: $e');
      }
    }
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Placa Vehículo: ${factura.placaVehiculo}',
                        style: AppTheme().getTheme().textTheme.titleSmall,
                      ),
                      Text(
                        'Monto a Pagar: \$${factura.montoPagar}',
                        style: AppTheme().getTheme().textTheme.titleSmall,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push(
                            '/editfactura/${factura.idFactura}?placa=${factura.placaVehiculo}&monto=${factura.montoPagar}&fecha=${factura.fechaSalida?.toString() ?? ''}',
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever),
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
                                    // Llama al método para eliminar la factura y actualizar el saldo
                                    await _deleteFacturaAndRefreshSaldo(
                                        factura.idFactura);
                                  },
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/facturaagregar');
        },
        child: const Icon(Icons.add_box_sharp),
      ),
    );
  }
}
