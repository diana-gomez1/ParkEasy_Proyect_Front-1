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
    //const String apiUrl = 'http://192.168.18.243/memesapp/public/api/v1/login';
    // Red Docentes
    const String apiUrl = 'http://10.10.17.154/memesapp/public/api/v1/login';

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

      if (response.statusCode == 200) {
        // El inicio de sesión fue exitoso
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Guardar los datos del usuario y el token en Shared Preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'userData',
            json.encode(
                responseData)); // Guarda los datos del usuario y el token como JSON
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/home');
      } else {
        // El servidor devolvió un error
        setState(() {
          _message =
              'Error al iniciar sesión. Por favor, verifica tus credenciales.';
        });
      }
    } catch (error) {
      // Se produjo un error durante la solicitud
      setState(() {
        _message = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login storage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            ElevatedButton(
              // onPressed: () {
              //   Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const RegisterPage(),
              //   ));
              // },
              onPressed: () => context.push('/register'),
              child: const Text('register'),
            ),
            const SizedBox(height: 10.0),
            Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
