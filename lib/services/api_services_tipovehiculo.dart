import 'package:flutter/foundation.dart';
import 'package:memes/models/tipovehiculo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServicetipovehiculo {
  // CASA
  static const String baseUrl = 'http://192.168.18.243/memesapp/public/api/v1';
  // Red Docentes
  //static const String baseUrl = 'http://192.168.12.216/memesapp/public/api/v1';

  Future<List<TipoVehiculo>> getTipoVehiculo() async {
    final response = await http.get(Uri.parse('$baseUrl/tipovehiculosver'));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      final Map<String, dynamic> body = json.decode(response.body);
      if (body.containsKey('tipovehiculos')) {
        List<dynamic> tipovehiculoJson = body['tipovehiculos'];
        return tipovehiculoJson
            .map((dynamic item) => TipoVehiculo.fromJson(item))
            .toList();
      } else {
        throw Exception('No tipovehiculos found in response');
      }
    } else {
      throw Exception('Failed to load tipovehiculo');
    }
  }

  Future<TipoVehiculo> getTipoVehiculos(int idVehiculo) async {
    final response =
        await http.get(Uri.parse('$baseUrl/tipovehiculos/$idVehiculo'));
    if (response.statusCode == 200) {
      return TipoVehiculo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tipovehiculo');
    }
  }

  Future<void> createTipoVehiculo(TipoVehiculo tipovehiculo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tipovehiculosagregar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tipovehiculo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create tipovehiculo');
    }
  }

  Future<void> updateTipoVehiculo(TipoVehiculo tipovehiculo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tipovehiculosact'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tipovehiculo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update tipovehiculo');
    }
  }

  Future<void> deleteTipoVehiculo(int idVehiculo) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tipovehiculosdestroy/$idVehiculo'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete tipovehiculo');
    }
  }
}
