import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/models/establecimiento.dart';
import 'package:memes/services/api_services_establecimiento.dart';

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
      appBar: AppBar(title: const Text('Info establecimiento')),
      body: FutureBuilder<List<Establecimiento>>(
        future: futureEstablecimientos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No se encontraron establecimientos'));
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
                      fontSizeLabel: 22,
                      fontWeightLabel: FontWeight.bold,
                      fontSizeValue: 20,
                      fontWeightValue: FontWeight.normal,
                    ),
                    _buildInfoRow(
                      'Dirección:',
                      establecimiento.direccion,
                      fontSizeLabel: 22,
                      fontWeightLabel: FontWeight.bold,
                      fontSizeValue: 20,
                      fontWeightValue: FontWeight.normal,
                    ),
                    _buildInfoRow(
                      'NIT:',
                      establecimiento.nit,
                      fontSizeLabel: 22,
                      fontWeightLabel: FontWeight.bold,
                      fontSizeValue: 20,
                      fontWeightValue: FontWeight.normal,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Descripción',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        establecimiento.descripcion,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
                        ),
                      ),
                      subtitle: Text(
                        'Descripcion${establecimiento.descripcion}',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
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
    double fontSizeLabel = 20,
    FontWeight fontWeightLabel = FontWeight.normal,
    double fontSizeValue = 18,
    FontWeight fontWeightValue = FontWeight.normal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: GoogleFonts.montserratAlternates(
                fontWeight: fontWeightLabel,
                fontSize: fontSizeLabel,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserratAlternates(
                fontWeight: fontWeightValue,
                fontSize: fontSizeValue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
