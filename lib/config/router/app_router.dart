import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:memes/models/establecimiento.dart';
import 'package:memes/models/tipovehiculo.dart';
import 'package:memes/models/factura.dart';
import 'package:memes/models/caja.dart'; // Importar el modelo de Caja
import 'package:memes/services/api_services_espacioestacionamiento.dart';
import 'package:memes/views/caja/caja_list_view.dart';
import 'package:memes/views/caja/caja_form_page.dart'; // Importar la vista del formulario de Caja
import 'package:memes/views/espacioestacionamiento/espacioestacionamiento_form_page.dart';
import 'package:memes/views/espacioestacionamiento/espacioestacionamiento_list_view.dart';
// import 'package:memes/services/api-services_establecimiento.dart';
import 'package:memes/views/establecimiento/establecimiento_list_view.dart';
import 'package:memes/views/factura/factura_form_page.dart';
import 'package:memes/views/factura/factura_list_view.dart';
import 'package:memes/views/import_views.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const LoginPage(),
    // ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MyHomePage(),
    ),
    // Rutas establecimiento
    GoRoute(
      path: '/establecimientover',
      builder: (context, state) => const EstablecimientoListView(),
    ),
    // Rutas caja
    GoRoute(
      path: '/cajaver',
      builder: (context, state) => const CajaListView(),
    ),
    GoRoute(
      path: '/cajaagregar',
      builder: (context, state) => const CajaFormPage(),
    ),
    GoRoute(
      path: '/editcaja/:id_caja',
      builder: (context, state) {
        final idCaja = int.parse(state.pathParameters['id_caja']!);
        final nombreCaja = state.uri.queryParameters['nombreCaja'];
        final saldo = state.uri.queryParameters['saldo'];
        final nombreAdmin = state.uri.queryParameters['nombreAdmin'];

        return CajaFormPage(
          caja: Caja(
            idCaja: idCaja,
            nombreCaja: nombreCaja ?? '',
            saldo: saldo != null ? double.tryParse(saldo) ?? 0.0 : 0.0,
            nombreAdmin: nombreAdmin ?? '',
          ),
        );
      },
    ),
    // *****RUTAS TIPOVEHICULOS*****
    GoRoute(
      path: '/tipovehiculosver',
      builder: (context, state) => const TipoVehiculoListView(),
    ),
    GoRoute(
      path: '/delete/:id_vehiculo',
      builder: (context, state) {
        int.parse(state.pathParameters['id_vehiculo']!);
        // Lógica para eliminar el tipo de vehículo con la ID proporcionada
        // Navegar de vuelta a la lista de tipos de vehículos después de la eliminación
        Future.delayed(Duration.zero, () {
          GoRouterState.of('/tipovehiculosver' as BuildContext);
        });
        // Devolver un contenedor vacío
        return const SizedBox.shrink();
      },
    ),
    GoRoute(
      path: '/tipovehiculosagregar',
      builder: (context, state) => const TipoVehiculoFormPage(),
    ),
    GoRoute(
      path: '/edit/:id_vehiculo',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id_vehiculo']!);
        final nombre = state.uri.queryParameters['nombre'];
        return TipoVehiculoFormPage(
          tipoVehiculo: TipoVehiculo(
            idVehiculo: id,
            nombre: nombre ?? '',
            valorHora: 0,
            valorDia: 0,
            valorMes: 0,
          ),
        );
      },
    ),
    // *****RUTAS FACTURAS*****
    GoRoute(
      path: '/facturaver',
      builder: (context, state) => const FacturaListView(),
    ),
    GoRoute(
      path: '/facturaagregar',
      builder: (context, state) => const FacturaFormPage(),
    ),
    GoRoute(
      path: '/editfactura/:id_factura',
      builder: (context, state) {
        final idFactura = int.parse(state.pathParameters['id_factura']!);
        final placa = state.uri.queryParameters['placa'];
        final monto = state.uri.queryParameters['monto'];
        final fecha = state.uri.queryParameters['fecha'];

        return FacturaFormPage(
          factura: Factura(
            idFactura: idFactura,
            placaVehiculo: placa ?? '',
            montoPagar: monto != null ? double.tryParse(monto) ?? 0.0 : 0.0,
            fechaSalida: fecha != null ? DateTime.parse(fecha) : DateTime.now(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/deletefactura/:id_factura',
      builder: (context, state) {
        int.parse(state.pathParameters['id_factura']!);
        // Lógica para eliminar la factura con la ID proporcionada
        // Navegar de vuelta a la lista de facturas después de la eliminación
        Future.delayed(Duration.zero, () {
          GoRouterState.of('/facturaver' as BuildContext);
        });
        // Devolver un contenedor vacío
        return const SizedBox.shrink();
      },
    ),
    GoRoute(
      path: '/espacioestacionamientover',
      builder: (context, state) => const EspacioEstacionamientoListView(),
    ),
    GoRoute(
      path: '/espacioestacionamientoagregar',
      builder: (context, state) => const EspacioEstacionamientoFormPage(),
    ),
    GoRoute(
      path: '/espacioestacionamientoeliminar/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        // Llamar al método para eliminar el espacio de estacionamiento con el ID proporcionado
        ApiServiceEspacioEstacionamiento()
            .deleteEspacioEstacionamiento(int.parse(id!));
        // Redirigir de vuelta a la lista de espacios de estacionamiento
        context.go('/espacioestacionamientover');
        // Retornar un widget vacío ya que esta página no tiene contenido visible
        return Container();
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Ruta no encontrada: ${state.error}')),
  ),
);
