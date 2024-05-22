import 'package:flutter/foundation.dart';
import 'package:memes/models/factura.dart'; // Asegúrate de que el modelo Factura está en esta ruta
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceFactura {
  // CASA
  //static const String baseUrl = 'http://192.168.18.243/memesapp/public/api/v1';
  // Red Docentes
  static const String baseUrl = 'http://192.168.12.216/memesapp/public/api/v1';

  Future<List<Factura>> getFacturas() async {
    final response = await http.get(Uri.parse('$baseUrl/facturaver'));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      final Map<String, dynamic> body = json.decode(response.body);
      if (body.containsKey('factura')) {
        // Verificar si la clave "factura" está presente
        List<dynamic> facturaJson = body[
            'factura']; // Acceder a la lista de facturas bajo la clave "factura"
        return facturaJson
            .map((dynamic item) => Factura.fromJson(item))
            .toList();
      } else {
        throw Exception('No facturas found in response');
      }
    } else {
      throw Exception('Failed to load facturas');
    }
  }

  Future<Factura> getFactura(int idFactura) async {
    final response =
        await http.get(Uri.parse('$baseUrl/facturaagregar/$idFactura'));
    if (response.statusCode == 200) {
      return Factura.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load factura');
    }
  }

  Future<void> createFactura(Factura factura) async {
    final response = await http.post(
      Uri.parse('$baseUrl/facturaagregar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(factura.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create factura');
    }
  }

  Future<void> updateFactura(Factura factura) async {
    final response = await http.post(
      Uri.parse('$baseUrl/facturaact'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(factura.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update factura');
    }
  }

  Future<void> deleteFactura(int idFactura) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/facturadestroy/$idFactura'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete factura');
    }
  }
}
