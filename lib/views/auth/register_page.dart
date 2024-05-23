import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future<void> _register() async {
    const String apiUrl =
        'http://192.168.18.243/memesapp/public/api/v1/register';
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
          _message = 'Registro exitoso!';
        });
      } else {
        setState(() {
          _message = 'Error en el registro. Por favor, inténtalo de nuevo.';
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
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: GoogleFonts.montserratAlternates(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.montserratAlternates(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.montserratAlternates(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                textStyle: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 10.0),
            Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                textStyle: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Ir al Homepage'),
            ),
          ],
        ),
      ),
    );
  }
}
