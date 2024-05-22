import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return json.decode(userDataString);
    } else {
      throw 'No se encontraron datos del usuario en el almacenamiento local.';
    }
  }
}
