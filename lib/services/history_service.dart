import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryItem {
  final String url;
  final bool seguro;
  final String data;

  HistoryItem({
    required this.url,
    required this.seguro,
    required this.data,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      url: json['url'],
      seguro: json['is_safe'], // <- nome correto do backend
      data: json['data'],
    );
  }
}

class HistoryService {
  static const String baseUrl = "http://192.168.1.6:5000";

  static Future<List<HistoryItem>> buscarHistorico() async {
    final response = await http.get(Uri.parse("$baseUrl/historico"));

    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar histórico");
    }

    List data = jsonDecode(response.body);

    return data.map((json) => HistoryItem.fromJson(json)).toList();
  }
}
