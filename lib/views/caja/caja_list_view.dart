// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/caja.dart';
import 'package:memes/services/api_services_caja.dart';

class CajaListView extends StatefulWidget {
  const CajaListView({super.key});

  @override
  State<CajaListView> createState() => _CajaListViewState();
}

class _CajaListViewState extends State<CajaListView> {
  late Future<List<Caja>> futureCaja;

  @override
  void initState() {
    super.initState();
    futureCaja = ApiServiceCaja().getCaja();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                '                     Caja',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
            IconButton(
              onPressed: () {
                context.go('/cajaagregar');
              },
              icon: const Icon(Icons.add_circle_outline_sharp),
              color: const Color.fromARGB(255, 56, 244, 18),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF497FEB),
      ),
      body: FutureBuilder<List<Caja>>(
        future: futureCaja,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final cajaList = snapshot.data!;
            return ListView.builder(
              itemCount: cajaList.length,
              itemBuilder: (context, index) {
                final caja = cajaList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            caja.nombreCaja,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF497FEB),
                                ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        _buildInfoRow(
                          'Saldo:',
                          '\$${caja.saldo}',
                          'Administrador:',
                          caja.nombreAdmin,
                          fieldColor: Colors.black, // Color del campo
                          valueColor: const Color.fromARGB(
                              255, 56, 244, 18), // Color del valor
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmación'),
                                    content: const Text(
                                      '¿Estás seguro de que deseas eliminar esta caja?',
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
                                            await ApiServiceCaja()
                                                .deleteCaja(caja.idCaja);
                                            setState(() {
                                              futureCaja =
                                                  ApiServiceCaja().getCaja();
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
                              icon: const Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                context.go(
                                  '/editcaja/${caja.idCaja}?nombreCaja=${Uri.encodeComponent(caja.nombreCaja)}&saldo=${caja.saldo}&nombreAdmin=${Uri.encodeComponent(caja.nombreAdmin)}',
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Color.fromARGB(255, 255, 227, 12),
                              ),
                            ),
                          ],
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

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2,
      {Color? fieldColor, Color? valueColor}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label1,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: fieldColor ?? Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                value1,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? const Color.fromARGB(255, 73, 128, 237),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label2,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: fieldColor ?? Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                value2,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 73, 128, 237),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
