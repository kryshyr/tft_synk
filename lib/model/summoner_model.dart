import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/summoner_class.dart';

class SummonerApi {
  static Future<Summoner> getSummoner(
      String gameName, String tagLine, String apiKey) async {
    // sending HTTP GET request to the API to fetch summoner
    final response = await http.get(
      Uri.parse(
          'https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$gameName/$tagLine?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Summoner(
        // extract the 'puuid' field from the JSON data
        puuid: data['puuid'],
      );
    } else {
      throw Exception('Failed to load summoner');
    }
  }
}
