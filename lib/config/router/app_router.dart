import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:memes/models/categoria.dart';
import 'package:memes/models/tipovehiculo.dart';
//import 'package:memes/views/categoria/categoria_form_page.dart';
import 'package:memes/views/import_views.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/',
  // initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MyHomePage(),
    ),
    //*****RUTAS TIPOVEHICULOS*****
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
      path: '/tipovehiculo/:id_vehiculo',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id_vehiculo']!);
        return TipoVehiculoDetailPage(id: id);
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
        final nombre = state.uri.queryParameters[
            'nombre']; // Obtén el nombre del parámetro de consulta
        return TipoVehiculoFormPage(
          tipoVehiculo: TipoVehiculo(
            idVehiculo: id,
            nombre: nombre ??
                '', // Usa el nombre si está presente, de lo contrario usa una cadena vacía
            valorHora: 0,
            valorDia: 0,
            valorMes: 0,
          ),
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Ruta no encontrada: ${state.error}')),
  ),
);
