// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> login() async {
    const String apiUrl = 'http://192.168.12.216/memesapp/public/api/v1/login';

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      // Después de la sección que establece _message en caso de un registro exitoso o un error
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userData', json.encode(responseData));
        GoRouter.of(context).go('/home');

        // Esperar 2 segundos antes de limpiar el mensaje
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            // Verificar si el widget está montado
            setState(() {
              _message = '';
            });
          }
        });
      } else {
        setState(() {
          _message =
              '           Error al iniciar sesión.\nPor favor, verifica tus credenciales.';
        });

        // Esperar 2 segundos antes de limpiar el mensaje de error
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            // Verificar si el widget está montado
            setState(() {
              _message = '';
            });
          }
        });
      }
    } catch (error) {
      setState(() {
        _message = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '    Login ParkEasyApp',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor:
            const Color(0xFF497FEB), // Color de la barra de navegación
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              width: 185, // Ajusta el ancho de la imagen según sea necesario
              height: 185, // Ajusta la altura de la imagen según sea necesario
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF497FEB),
                    ),
              ),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 2.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF497FEB),
                    ),
              ),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6.0),
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.red, // Cambia el color de la fuente a rojo
                        ),
                    backgroundColor: const Color.fromARGB(
                        255, 255, 255, 255), // Color del botón
                    side: const BorderSide(
                      color: Color(0xFF497FEB), // Color del contorno
                      width: 2.0, // Ancho del contorno
                    ),
                  ),
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).go('/register'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6.0),
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.red, // Cambia el color de la fuente a rojo
                        ),
                    backgroundColor: const Color.fromARGB(
                        255, 255, 255, 255), // Color del botón
                    side: const BorderSide(
                      color: Color(0xFF497FEB), // Color del contorno
                      width: 2.0, // Ancho del contorno
                    ),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Text(
              _message,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
