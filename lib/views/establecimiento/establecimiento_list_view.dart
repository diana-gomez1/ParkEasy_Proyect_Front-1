import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/establecimiento.dart';
import 'package:memes/services/api_services_establecimiento.dart';

class EstablecimientoListView extends StatefulWidget {
  const EstablecimientoListView({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: Text(
          '    Info establecimiento',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 73, 128, 237),
              ),
        ),
      ),
      body: FutureBuilder<List<Establecimiento>>(
        future: futureEstablecimientos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No se encontraron establecimientos'),
            );
          } else {
            final establecimientos = snapshot.data!;
            if (establecimientos.length == 1) {
              final establecimiento = establecimientos[0];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildInfoRow(
                      'Nombre:',
                      establecimiento.nombreEstablecimiento,
                      fontWeightLabel: FontWeight.w900,
                      fontWeightValue: FontWeight.w600,
                    ),
                    _buildInfoRow(
                      'Dirección:',
                      establecimiento.direccion,
                      fontWeightLabel: FontWeight.w900,
                      fontWeightValue: FontWeight.w600,
                    ),
                    _buildInfoRow(
                      'NIT:',
                      establecimiento.nit,
                      fontWeightLabel: FontWeight.w900,
                      fontWeightValue: FontWeight.w600,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Descripción',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 73, 128, 237),
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        establecimiento.descripcion,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: establecimientos.length,
                itemBuilder: (context, index) {
                  final establecimiento = establecimientos[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${establecimiento.idEstablecimiento}: ${establecimiento.nombreEstablecimiento}',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    FontWeight fontWeightLabel = FontWeight.bold,
    FontWeight fontWeightValue = FontWeight.bold,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 73, 128, 237),
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: fontWeightValue,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
