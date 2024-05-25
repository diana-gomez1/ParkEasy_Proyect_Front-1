import 'package:flutter/foundation.dart';
import 'package:memes/models/espacioestacionamiento.dart';
import 'package:memes/models/ingreso_vehiculos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServiceIngresoVehiculos {
  static const String baseUrl = 'http://192.168.18.243/memesapp/public/api/v1';

  Future<List<IngresoVehiculos>> getIngresoVehiculos() async {
    final response = await http.get(Uri.parse('$baseUrl/ingresovehiculosver'));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('ingresovehiculos')) {
        List<dynamic> ingresosJson = responseBody['ingresovehiculos'];
        return ingresosJson
            .map((dynamic item) => IngresoVehiculos.fromJson(item))
            .toList();
      } else {
        throw Exception('No ingresovehiculos found in response');
      }
    } else {
      throw Exception('Failed to load ingresos vehiculos');
    }
  }

  Future<IngresoVehiculos> getIngresoVehiculo(String placaVehiculo) async {
    final response = await http
        .get(Uri.parse('$baseUrl/ingresovehiculosbuscar/$placaVehiculo'));
    if (response.statusCode == 200) {
      return IngresoVehiculos.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load ingreso vehiculo');
    }
  }

  Future<void> createIngresoVehiculo(IngresoVehiculos ingresoVehiculo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ingresovehiculosagregar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ingresoVehiculo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create ingreso vehiculo');
    }
  }

  Future<void> updateIngresoVehiculo(IngresoVehiculos ingresoVehiculo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ingresovehiculosact'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ingresoVehiculo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update ingreso vehiculo');
    }
  }

  Future<void> deleteIngresoVehiculo(String placaVehiculo) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ingresovehiculosdestroy/$placaVehiculo'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete ingreso vehiculo');
    }
  }

  Future<EspacioEstacionamiento> getEspacioEstacionamientoById(
      int idEspacio) async {
    final response = await http
        .get(Uri.parse('$baseUrl/espacioestacionamientobuscar/$idEspacio'));
    if (response.statusCode == 200) {
      return EspacioEstacionamiento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load espacio estacionamiento');
    }
  }

  Future<String> getNombreEspacioEstacionamientoById(int idEspacio) async {
    final response =
        await http.get(Uri.parse('$baseUrl/espacioestacionamiento/$idEspacio'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return responseBody['nombreEspacio'];
    } else {
      throw Exception('Failed to load espacio estacionamiento');
    }
  }
}
