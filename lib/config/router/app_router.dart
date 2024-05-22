import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memes/models/categoria.dart';
import 'package:memes/views/categoria/categoria_detail_page.dart';
import 'package:memes/views/categoria/categoria_form_page.dart';
import 'package:memes/views/categoria/categoria_list_view.dart';
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
    //*****RUTAS CATEGORIA*****
    GoRoute(
      path: '/categorias',
      builder: (context, state) => const CategoriaListView(),
    ),
    GoRoute(
      path: '/categoria/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CategoriaDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CategoriaFormPage(
          categoria: Categoria(id: id, nombre: '', descripcion: ''),
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Ruta no encontrada: ${state.error}')),
  ),
);
