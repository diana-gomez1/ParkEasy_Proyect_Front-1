// Clase de modelo IngresoVehiculos
class IngresoVehiculos {
  final String placaVehiculo;
  final String fechaIngreso;
  final String tipoVehiculo;
  final int idEspacio;
  final String fechaSalida;

  IngresoVehiculos({
    required this.placaVehiculo,
    required this.fechaIngreso,
    required this.tipoVehiculo,
    required this.idEspacio,
    required this.fechaSalida,
  });

  factory IngresoVehiculos.fromJson(Map<String, dynamic> json) {
    return IngresoVehiculos(
      placaVehiculo: json['placa_vehiculo'] ?? '',
      fechaIngreso: json['fecha_ingreso'] ?? '',
      tipoVehiculo: json['tipo_vehiculo'] ?? '',
      idEspacio: json['id_espacio'] ?? 0,
      fechaSalida: json['fecha_salida'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placa_vehiculo': placaVehiculo,
      'fecha_ingreso': fechaIngreso,
      'tipo_vehiculo': tipoVehiculo,
      'id_espacio': idEspacio,
      'fecha_salida': fechaSalida,
    };
  }
}
