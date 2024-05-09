import 'dart:async';

import 'package:http/http.dart' as http;

class ChampionApi {
  static Future<http.Response> getCharacters() {
    // Convert the URL string to a Uri object
    final Uri uri = Uri.parse(
        "https://ddragon.leagueoflegends.com/cdn/14.9.1/data/en_US/tft-champion.json");
    return http.get(uri);
  }
}
