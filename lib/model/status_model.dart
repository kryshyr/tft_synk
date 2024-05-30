import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/status_class.dart';

class StatusApi {
  static Future<List<Status>> getStatus(
      String summonerId, String apiKey) async {
    // Sending HTTP GET request to the API
    final response = await http.get(
      Uri.parse(
          'https://ph2.api.riotgames.com/tft/league/v1/entries/by-summoner/$summonerId?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // empty list to store the status
      List<Status> statusList = [];

      // iterating over each entry in the list
      data.forEach((entry) {
        // to check if the queueType field of the entry is 'RANKED_TFT'
        if (entry['queueType'] == 'RANKED_TFT') {
          statusList.add(Status.fromJson(entry));
        }
      });

      return statusList;
    } else {
      throw Exception('Failed to load status');
    }
  }
}
