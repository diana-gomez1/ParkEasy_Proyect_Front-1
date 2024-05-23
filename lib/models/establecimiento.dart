class Establecimiento {
  final int idEstablecimiento;
  final String nombreEstablecimiento;
  final String descripcion;
  final String direccion;
  final String nit;

  Establecimiento({
    required this.idEstablecimiento,
    required this.nombreEstablecimiento,
    required this.descripcion,
    required this.direccion,
    required this.nit,
  });

  factory Establecimiento.fromJson(Map<String, dynamic> json) {
    return Establecimiento(
      idEstablecimiento: json['id_establecimiento'],
      nombreEstablecimiento: json['nombre_establecimiento'], // Corregido
      descripcion: json['descripcion'],
      direccion: json['direccion'],
      nit: json['nit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_establecimiento': idEstablecimiento,
      'nombre': nombreEstablecimiento, // Corregido
      'descripcion': descripcion,
      'direccion': direccion,
      'nit': nit
    };
  }
}
