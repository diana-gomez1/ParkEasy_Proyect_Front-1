import 'package:flutter/foundation.dart';
import 'package:memes/models/caja.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceCaja {
  // CASA
  static const String baseUrl = 'http://192.168.18.243/memesapp/public/api/v1';
  // Red Docentes
  //static const String baseUrl = 'http://192.168.12.216/memesapp/public/api/v1';

  Future<List<Caja>> getCaja() async {
    final response = await http.get(Uri.parse('$baseUrl/cajaVer'));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      final Map<String, dynamic> body = json.decode(response.body);
      if (body.containsKey('caja')) {
        List<dynamic> cajaJson = body['caja'];
        return cajaJson.map((dynamic item) => Caja.fromJson(item)).toList();
      } else {
        throw Exception('No Caja found in response');
      }
    } else {
      throw Exception('Failed to load Caja');
    }
  }

  Future<Caja> getcaja(int idCaja) async {
    final response = await http.get(Uri.parse('$baseUrl/caja/$idCaja'));
    if (response.statusCode == 200) {
      return Caja.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load caja');
    }
  }

  Future<void> createCaja(Caja caja) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cajaAgregar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(caja.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create caja');
    }
  }

  Future<void> updateCaja(Caja caja) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CajaAct'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(caja.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update Caja');
    }
  }

  Future<void> deleteCaja(int idCaja) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cajaDestroy/$idCaja'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete Caja');
    }
  }
}
