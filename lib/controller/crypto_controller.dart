import 'dart:convert';
import 'package:crypto_exercice/model/crypto_model.dart';
import 'package:crypto_exercice/utils/app_constant.dart';
import 'package:http/http.dart' as http;

class CryptoController {
  Future<List<CryptoModel>> fetchCryptos() async {
    final response = await http.get(Uri.parse(AppConstant().apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<CryptoModel> cryptos = body.map((dynamic item) => CryptoModel.fromJson(item)).toList();
      return cryptos;
    } else {
      throw Exception('Failed to load cryptos');
    }
  }
}
