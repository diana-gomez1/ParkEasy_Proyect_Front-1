import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:memes/views/caja/caja_list_view.dart';
import 'package:memes/views/espacioestacionamiento/espacioestacionamiento_list_view.dart';
import 'package:memes/views/establecimiento/establecimiento_list_view.dart';
import 'package:memes/views/factura/factura_list_view.dart';
import 'package:memes/views/ingresovehiculos/ingresovehiculos_list_view.dart';
import 'package:memes/views/tipovehiculo/tipovehiculo_list_view.dart';
import 'package:memes/services/api_services_caja.dart';

// Clase para controlar el saldo
class SaldoController {
  late StreamController<double> _saldoController;
  double _saldo = 0.0;

  SaldoController() {
    _saldoController = StreamController<double>.broadcast();
  }

  Stream<double> get saldoStream => _saldoController.stream;

  // Método para actualizar el saldo
  void actualizarSaldo(double nuevoSaldo) {
    _saldo = nuevoSaldo;
    _saldoController.add(_saldo); // Agregar el nuevo saldo al stream
  }

  // Cerrar el stream controller
  void dispose() {
    _saldoController.close();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  late SaldoController saldoController =
      SaldoController(); // Crear instancia de SaldoController

  // Método para obtener el saldo de la caja desde la API
  // Método para obtener el saldo de la caja desde la API
  Future<void> _fetchSaldoCaja() async {
    try {
      final saldo = await ApiServiceCaja().getSaldoCaja(1); // ID de la caja
      setState(() {
        saldoController
            .actualizarSaldo(saldo); // Actualiza el saldo usando el controller
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener saldo de caja: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSaldoCaja(); // Llama al método para obtener el saldo de la caja al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkEasy APP'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.attach_money),
                const SizedBox(width: 4),
                StreamBuilder<double>(
                  stream: saldoController
                      .saldoStream, // Acceder a saldoStream a través de la instancia de SaldoController
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'Saldo: \$${snapshot.data!.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      );
                    } else {
                      return const Text(
                        'Saldo: \$0.00',
                        style: TextStyle(fontSize: 16),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 73, 128, 237),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.car_crash_outlined),
            icon: Icon(Icons.car_crash),
            label: 'Ingreso',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Espacios',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.receipt_long),
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Factura',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Vehiculos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.attach_money),
            icon: Icon(Icons.attach_money_outlined),
            label: 'Caja',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_parking),
            icon: Icon(Icons.local_parking_rounded),
            label: 'Info',
          ),
        ],
      ),
      body: <Widget>[
        const IngresoVehiculoListView(),
        const EspacioEstacionamientoListView(),
        const FacturaListView(),
        const TipoVehiculoListView(),
        const CajaListView(),
        const EstablecimientoListView(),
      ][currentPageIndex],
    );
  }

  @override
  void dispose() {
    // Dispose del SaldoController al salir de la pantalla
    saldoController.dispose();
    super.dispose();
  }
}
