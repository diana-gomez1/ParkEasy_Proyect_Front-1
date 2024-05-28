// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Asegúrate de importar este paquete
import 'package:parkeasy/models/factura.dart';
import 'package:parkeasy/services/api_services_caja.dart';
import 'package:parkeasy/services/api_services_factura.dart';
//import 'package:parkeasy/config/theme/app_theme.dart';
import 'package:parkeasy/views/home.dart';

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

  Future<void> _deleteFacturaAndRefreshSaldo(int idFactura) async {
    try {
      await ApiServiceFactura().deleteFactura(idFactura);
      await _fetchSaldoCaja();
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

  Future<void> _fetchSaldoCaja() async {
    try {
      final saldo = await ApiServiceCaja().getSaldoCaja(1);
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
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                '                  Facturas',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
            IconButton(
              onPressed: () {
                context.go('/facturaagregar');
              },
              icon: const Icon(Icons.add_circle_outline_sharp),
              color: const Color.fromARGB(255, 56, 244, 18),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF497FEB),
      ),
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
                // Formatear la fecha de salida, manejar el caso null
                final formattedFechaSalida = factura.fechaSalida != null
                    ? DateFormat('dd/MM/yyyy HH:mm')
                        .format(factura.fechaSalida!)
                    : 'Fecha no disponible';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      '              Factura #${factura.idFactura}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(255, 73, 128, 237),
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Placa Vehículo:',
                          factura.placaVehiculo,
                          fieldColor: Colors.black, // Color del campo
                          valueColor: const Color.fromARGB(255, 255, 227, 12),
                        ),
                        _buildInfoRow(
                          'Monto a Pagar:',
                          '\$${factura.montoPagar}',
                          fieldColor: Colors.black, // Color del campo
                          valueColor: const Color.fromARGB(255, 56, 244, 18),
                        ),
                        _buildInfoRow('Fecha Salida:', formattedFechaSalida,
                            fieldColor: Colors.black, // Color del campo
                            valueColor: const Color(0xFF497FEB)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
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
                                      await _deleteFacturaAndRefreshSaldo(
                                          factura.idFactura);
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          color: const Color.fromARGB(255, 239, 44, 33),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color? fieldColor, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserratAlternates(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: fieldColor ??
                  Colors
                      .black, // Usar el color del campo si se proporciona, de lo contrario, usar negro
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: GoogleFonts.montserratAlternates(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: valueColor ?? const Color.fromARGB(255, 73, 128, 237),
            ),
          ),
        ],
      ),
    );
  }
}
