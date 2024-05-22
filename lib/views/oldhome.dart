import 'package:flutter/material.dart';
import 'package:memes/storage/user_data_service.dart';

class Home extends StatelessWidget {
  final UserDataService userDataService = UserDataService();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: DrawerPage,

      appBar: AppBar(
        title: const Text('Home 1'),
      ),
      body: FutureBuilder(
        future: userDataService.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final userData = snapshot.data as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos del usuario:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Text('ID: ${userData['user']['id']}'),
                    Text('Nombre: ${userData['user']['name']}'),
                    Text('Email: ${userData['user']['email']}'),
                    Text('Token: ${userData['token']}'),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('No se encontraron datos del usuario.'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
