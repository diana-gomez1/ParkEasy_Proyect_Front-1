class TipoVehiculo {
  final int idVehiculo;
  final double valorHora;
  final double valorDia;
  final double valorMes;
  final String nombre;

  TipoVehiculo({
    required this.idVehiculo,
    required this.valorHora,
    required this.valorDia,
    required this.valorMes,
    required this.nombre,
  });

  factory TipoVehiculo.fromJson(Map<String, dynamic> json) {
    return TipoVehiculo(
      idVehiculo: json['id_vehiculo'],
      valorHora: double.parse(json['valor_hora'].toString()),
      valorDia: double.parse(json['valor_dia'].toString()),
      valorMes: double.parse(json['valor_mes'].toString()),
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_vehiculo': idVehiculo,
      'nombre': nombre,
      'valor_hora': valorHora.toString(),
      'valor_dia': valorDia.toString(),
      'valor_mes': valorMes.toString(),
    };
  }
}
