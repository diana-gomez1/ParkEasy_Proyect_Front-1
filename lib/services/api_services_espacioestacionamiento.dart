import 'package:flutter/foundation.dart';
import 'package:memes/models/espacioestacionamiento.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceEspacioEstacionamiento {
  // CASA
  static const String baseUrl = 'http://192.168.18.243/memesapp/public/api/v1';
  // Red Docentes
  //static const String baseUrl = 'http://192.168.12.216/memesapp/public/api/v1';

  Future<List<EspacioEstacionamiento>> getEspaciosEstacionamiento() async {
    final response = await http.get(Uri.parse('$baseUrl/espaciosestacionamientover'));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      final Map<String, dynamic> body = json.decode(response.body);
      if (body.containsKey('espacios_estacionamiento')) {
        List<dynamic> espaciosJson = body['espacios_estacionamiento'];
        return espaciosJson
            .map((dynamic item) => EspacioEstacionamiento.fromJson(item))
            .toList();
      } else {
        throw Exception('No espacios_estacionamiento found in response');
      }
    } else {
      throw Exception('Failed to load espacios_estacionamiento');
    }
  }

  Future<EspacioEstacionamiento> getEspacioEstacionamiento(int idEspacio) async {
    final response = await http.get(Uri.parse('$baseUrl/espaciosestacionamiento/$idEspacio'));
    if (response.statusCode == 200) {
      return EspacioEstacionamiento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load espacio_estacionamiento');
    }
  }

  Future<void> createEspacioEstacionamiento(EspacioEstacionamiento espacio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/espaciosestacionamientoagregar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(espacio.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create espacio_estacionamiento');
    }
  }

  Future<void> updateEspacioEstacionamiento(EspacioEstacionamiento espacio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/espaciosestacionamientoact'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(espacio.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update espacio_estacionamiento');
    }
  }

  Future<void> deleteEspacioEstacionamiento(int idEspacio) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/espaciosestacionamientodestroy/$idEspacio'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete espacio_estacionamiento');
    }
  }
}
