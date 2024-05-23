import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:memes/models/establecimiento.dart';

class ApiServiceEstablecimiento {
  static const String baseUrl = 'http://192.168.18.243/memesapp/public/api/v1';
  // Red Docentes
  //static const String baseUrl = 'http://192.168.12.216/memesapp/public/api/v1';

  Future<List<Establecimiento>> getEstablecimiento() async {
    final response = await http.get(Uri.parse('$baseUrl/establecimientover'));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      try {
        final body = json.decode(response.body);
        if (body['status'] == true) {
          List<dynamic> establecimientoJson = body['establecimiento'];
          return establecimientoJson
              .map((dynamic item) => Establecimiento.fromJson(item))
              .toList();
        } else {
          throw Exception('Invalid status in response');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error decoding JSON: $e');
        }
        throw Exception('Failed to decode JSON');
      }
    } else {
      if (kDebugMode) {
        print(
            'Failed to load establecimiento. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to load establecimiento');
    }
  }

  Future<Establecimiento> getEstablecimientos(int idEstablecimiento) async {
    final response = await http
        .get(Uri.parse('$baseUrl/estacionamientobuscar/$idEstablecimiento'));
    if (response.statusCode == 200) {
      return Establecimiento.fromJson(json.decode(response.body));
    } else {
      if (kDebugMode) {
        print(
            'Failed to load establecimiento. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to load establecimiento');
    }
  }

  Future<void> createEstablecimiento(Establecimiento establecimiento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/establecimientoagregar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(establecimiento.toJson()),
    );
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print(
            'Failed to create establecimiento. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to create establecimiento');
    }
  }

  Future<void> updateEstablecimiento(Establecimiento establecimiento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/establecimientoact'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(establecimiento.toJson()),
    );
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print(
            'Failed to update establecimiento. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to update establecimiento');
    }
  }

  Future<void> deleteEstablecimiento(int idEstablecimiento) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/establecimientodestroy/$idEstablecimiento'),
    );
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print(
            'Failed to delete establecimiento. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to delete establecimiento');
    }
  }
}
