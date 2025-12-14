import 'dart:convert';
import 'package:http/http.dart' as http;

class LinkVerifierService {
  static const String baseUrl = "https://phishing-app-uktc.onrender.com"; // IP DO SEU PC

  Future<bool> verifyLink(String url) async {
    final response = await http.post(
      Uri.parse("$baseUrl/verificar"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"url": url}),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao acessar servidor");
    }

    final data = json.decode(response.body);

    return data["seguro"]; // já vem do servidor
  }
}
