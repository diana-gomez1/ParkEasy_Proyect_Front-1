class Factura {
  final int idFactura;
  final String placaVehiculo;
  final double montoPagar;
  final DateTime? fechaSalida; // Cambio: hacer fechaSalida opcional

  Factura({
    required this.idFactura,
    required this.placaVehiculo,
    required this.montoPagar,
    this.fechaSalida, // Cambio: fechaSalida puede ser null
  });

  factory Factura.fromJson(Map<String, dynamic> json) {
    return Factura(
      idFactura: json['id_factura'],
      placaVehiculo: json['placa_vehiculo'],
      montoPagar: double.parse(json['monto_pagar'].toString()),
      fechaSalida: json['fecha_salida'] != null
          ? DateTime.parse(json['fecha_salida'])
          : null, // Cambio: manejar fechaSalida opcional
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_factura': idFactura,
      'placa_vehiculo': placaVehiculo,
      'monto_pagar': montoPagar.toString(),
      'fecha_salida': fechaSalida
          ?.toIso8601String(), // Cambio: manejar fechaSalida opcional
    };
  }
}
