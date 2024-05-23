class Caja {
  final int idCaja;
  final String nombreCaja;
  final double saldo;
  final String nombreAdmin;

  Caja({
    required this.idCaja,
    required this.nombreCaja,
    required this.saldo,
    required this.nombreAdmin,
  });

  factory Caja.fromJson(Map<String, dynamic> json) {
    return Caja(
      idCaja: json['id_caja'],
      nombreCaja: json['nombre_caja'],
      saldo: double.parse(json['saldo'].toString()),
      nombreAdmin: json['nombre_admin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_caja': idCaja,
      'nombre_caja': nombreCaja,
      'saldo': saldo.toString(),
      'nombre_admin': nombreAdmin,
    };
  }
}
