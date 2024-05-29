import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
  Color _messageColor = Colors.black;

  Future<void> _register() async {
    const String apiUrl =
        'http://192.168.12.216/memesapp/public/api/v1/register';
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = '  ¡Registro exitoso!';
          _messageColor = const Color.fromARGB(
              255, 56, 244, 18); // Color rojo para mensaje de error
        });
        // Esperar 5 segundos antes de redirigir al usuario
        Timer(const Duration(seconds: 3), () {
          GoRouter.of(context).go('/');
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              // Verificar si el widget está montado
              setState(() {
                _message = '';
                _messageColor = const Color.fromARGB(
                    255, 56, 244, 18); // Color rojo para mensaje de error
              });
            }
          });
        });
      } else {
        setState(() {
          _message =
              '             Error en el registro. \n Por favor, inténtalo de nuevo.';
          _messageColor = Colors.red; // Color rojo para mensaje de error
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
          '                  Register',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: const Color(0xFF497FEB),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              GoRouter.of(context).go('/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              width: 100, // Ajusta el ancho de la imagen según sea necesario
              height: 100, // Ajusta la altura de la imagen según sea necesario
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF497FEB),
                    ),
              ),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF497FEB),
                    ),
              ),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
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
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2.0),
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(0xFF497FEB),
                  width: 2.0,
                ),
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 5.0),
            Text(
              _message,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _messageColor,
                  ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
