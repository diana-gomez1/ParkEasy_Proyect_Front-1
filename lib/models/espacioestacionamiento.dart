class EspacioEstacionamiento {
  final int idEspacio;
  final String nombreEspacio;
  final String tipoVehiculo;
  final bool ocupado;

  EspacioEstacionamiento({
    required this.idEspacio,
    required this.nombreEspacio,
    required this.tipoVehiculo,
    required this.ocupado,
  });

  factory EspacioEstacionamiento.fromJson(Map<String, dynamic> json) {
    return EspacioEstacionamiento(
      idEspacio: json['id_espacio'],
      nombreEspacio: json['nombre_espacio'],
      tipoVehiculo: json['tipo_vehiculo'],
      ocupado: json['ocupado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_espacio': idEspacio,
      'nombre_espacio': nombreEspacio,
      'tipo_vehiculo': tipoVehiculo,
      'ocupado': ocupado,
    };
  }
}
