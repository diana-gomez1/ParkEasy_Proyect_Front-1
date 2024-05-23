import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/caja.dart';
import 'package:memes/services/api_services_caja.dart';
import 'package:memes/config/theme/app_theme.dart';

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
      appBar: AppBar(title: const Text('Caja')),
      body: FutureBuilder<List<Caja>>(
        future: futureCaja,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final caja = snapshot.data!;
            return ListView.builder(
              itemCount: caja.length,
              itemBuilder: (context, index) {
                final caja_ = caja[index];
                return ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${caja_.idCaja}: ${caja_.nombreCaja}',
                              style:
                                  AppTheme().getTheme().textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
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
                                      await ApiServiceCaja().deleteCaja(
                                        caja_.idCaja,
                                      );
                                      setState(() {
                                        futureCaja = ApiServiceCaja().getCaja();
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
                      IconButton(
                        onPressed: () {
                          context.go(
                            '/edit/${caja_.idCaja}?nombreCaja=${Uri.encodeComponent(caja_.nombreCaja)}',
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          context.go(
                            '/edit/${caja_.idCaja}?nombreAdmin=${Uri.encodeComponent(caja_.nombreAdmin)}',
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Saldo : \$${caja_.saldo}',
                    style: AppTheme().getTheme().textTheme.titleSmall,
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/cajaAgregar');
        },
        child: const Icon(Icons.add_box_sharp),
      ),
    );
  }
}
