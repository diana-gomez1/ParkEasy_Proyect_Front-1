class Factura {
  final int idFactura;
  final String placaVehiculo;
  final double montoPagar;
  final DateTime fechaSalida;

  Factura({
    required this.idFactura,
    required this.placaVehiculo,
    required this.montoPagar,
    required this.fechaSalida,
  });

  factory Factura.fromJson(Map<String, dynamic> json) {
    return Factura(
      idFactura: json['id_factura'],
      placaVehiculo: json['placa_vehiculo'],
      montoPagar: double.parse(json['monto_pagar'].toString()),
      fechaSalida: DateTime.parse(json['fecha_salida']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_factura': idFactura,
      'placa_vehiculo': placaVehiculo,
      'monto_pagar': montoPagar.toString(),
      'fecha_salida': fechaSalida.toIso8601String(),
    };
  }
}
