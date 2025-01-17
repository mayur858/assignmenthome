import 'dart:convert';
import 'package:http/http.dart' as http;

class PostgresHelper {
  final String apiUrl = 'http://10.0.2.2:5000/functions';
  Future<List<String>> fetchFunctions() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item['name'].toString()).toList();
    } else {
      throw Exception('Failed to load functions');
    }
  }
}
