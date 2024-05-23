import 'package:flutter/foundation.dart';
import 'package:memes/models/establecimiento.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceestablecimiento {
  // CASA
  static const String baseUrl = 'http://192.168.18.243/memesapp/public/api/v1';
  // Red Docentes
  //static const String baseUrl = 'http://192.168.12.216/memesapp/public/api/v1';

  Future<List<Establecimiento>> getEstablecimiento() async {
    final response = await http.get(Uri.parse('$baseUrl/establecimientosver'));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      final Map<String, dynamic> body = json.decode(response.body);
      if (body.containsKey('establecimientos')) {
        List<dynamic> establecimientoJson = body['establecimientos'];
        return establecimientoJson
            .map((dynamic item) => Establecimiento.fromJson(item))
            .toList();
      } else {
        throw Exception('No establecimientos found in response');
      }
    } else {
      throw Exception('Failed to load establecimiento');
    }
  }

  Future<Establecimiento> getEstablecimientos(int idEstablecimiento) async {
    final response =
        await http.get(Uri.parse('$baseUrl/establecimientos/$idEstablecimiento'));
    if (response.statusCode == 200) {
      return Establecimiento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load establecimiento');
    }
  }

  Future<void> createEstablecimiento(Establecimiento establecimiento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/establecimientosagregar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(establecimiento.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create establecimiento');
    }
  }

  Future<void> updateEstablecimiento(Establecimiento establecimiento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/establecimientosact'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(establecimiento.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update establecimiento');
    }
  }

  Future<void> deleteEstablecimiento(int idEstablecimiento) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/establecimientosdestroy/$idEstablecimiento'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete establecimiento');
    }
  }
}
