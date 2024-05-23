// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/establecimiento.dart';
import 'package:memes/services/api-services_establecimiento.dart';
import 'package:memes/config/theme/app_theme.dart';

class EstablecimientoListView extends StatefulWidget {
  const EstablecimientoListView({super.key});

  @override
  State<EstablecimientoListView> createState() =>
      _EstablecimientoListViewState();
}

class _EstablecimientoListViewState extends State<EstablecimientoListView> {
  late Future<List<Establecimiento>> futureEstablecimientos;

  @override
  void initState() {
    super.initState();
    futureEstablecimientos = ApiServiceEstablecimiento().getEstablecimiento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Establecimientos')),
      body: FutureBuilder<List<Establecimiento>>(
        future: futureEstablecimientos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final establecimientos = snapshot.data!;
            return ListView.builder(
              itemCount: establecimientos.length,
              itemBuilder: (context, index) {
                final establecimiento = establecimientos[index];
                return ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${establecimiento.idEstablecimiento}: ${establecimiento.nombreEstablecimiento}',
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
                                '¿Estás seguro de que deseas eliminar este establecimiento?',
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
                                      await ApiServiceEstablecimiento()
                                          .deleteEstablecimiento(
                                        establecimiento.idEstablecimiento,
                                      );
                                      setState(() {
                                        futureEstablecimientos =
                                            ApiServiceEstablecimiento()
                                                .getEstablecimiento();
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
                            '/edit/${establecimiento.idEstablecimiento}?nombre=${Uri.encodeComponent(establecimiento.nombreEstablecimiento)}',
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Descripcion: \$${establecimiento.descripcion}',
                    style: AppTheme().getTheme().textTheme.titleSmall,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Direccion: \$${establecimiento.direccion}',
                            style: AppTheme().getTheme().textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NIT: \$${establecimiento.nit}',
                            style: AppTheme().getTheme().textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/establecimientoagregar');
        },
        child: const Icon(Icons.add_box_sharp),
      ),
    );
  }
}
