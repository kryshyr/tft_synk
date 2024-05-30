import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/id_class.dart'; // Import SummonerId class

class SummonerIdApi {
  // fetch the summoner id
  static Future<SummonerId> getSummonerId(String puuid, String apiKey) async {
    final response = await http.get(
      Uri.parse(
          'https://ph2.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/$puuid?api_key=$apiKey'),
    );

    // if the response is successful, parse the JSON
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // return the summoner id
      return SummonerId(
        id: data['id'],
      );
    } else {
      throw Exception('Failed to load summoner ID');
    }
  }
}
