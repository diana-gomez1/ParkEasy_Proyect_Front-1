import 'dart:async';

class SaldoController {
  // StreamController para emitir el saldo
  final _saldoStreamController = StreamController<double>();

  // Getter para el stream de saldo
  Stream<double> get saldoStream => _saldoStreamController.stream;

  // Método para actualizar el saldo y emitirlo al stream
  void actualizarSaldo(double nuevoSaldo) {
    _saldoStreamController.add(nuevoSaldo);
  }

  // Método para cerrar el StreamController
  void dispose() {
    _saldoStreamController.close();
  }
}
