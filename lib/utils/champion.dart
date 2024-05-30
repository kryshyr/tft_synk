// champions.dart

import 'dart:convert';

import 'package:flutter/services.dart';

List<Champion> champions = [];
Map<int, List<Champion>> tieredChampions = {};

class Champion {
  final String id;
  final String name;
  final int tier;
  final String image;
  final List<String> traits;
  final String description;

  Champion({
    required this.id,
    required this.name,
    required this.tier,
    required this.image,
    required this.traits,
    required this.description,
  });

  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      id: json['id'],
      name: json['name'],
      tier: json['tier'] as int, // Ensure tier is parsed as an integer
      image: json['image'],
      traits: List<String>.from(json['traits']),
      description: json['description'],
    );
  }
}

class ChampionPosition {
  final String championName;
  final int row;
  final int col;

  ChampionPosition(this.championName, this.row, this.col);
}

Future<Map<int, List<Champion>>> parseChampionsFromJson() async {
  String jsonData = await rootBundle.loadString('assets/data/champions.json');
  final Map<String, dynamic> data = json.decode(jsonData);

  data.forEach((tier, championList) {
    int tierNumber =
        int.tryParse(tier) ?? 0; // Parse tier number or default to 0
    champions = [];
    for (var champData in championList) {
      champions.add(Champion.fromJson(champData));
    }
    tieredChampions[tierNumber] = champions;
  });

  return tieredChampions;
}

// get trait list by champion name
List<String> getChampionTraitList(String championName) {
  for (var champion in champions) {
    if (champion.name == championName) {
      return champion.traits;
    }
  }
  print('Champion not found: $championName');
  return [];
}

Future<List<String>> getTraitListFromJson(String championName) async {
  String jsonData = await rootBundle.loadString('assets/data/champions.json');
  final Map<String, dynamic> data = json.decode(jsonData);

  // Iterate through each tier in the data
  for (var tier in data.values) {
    // Iterate through each champion in the tier
    for (var champion in tier) {
      // Check if the champion's name matches the given name
      if (champion['name'] == championName) {
        // Return the traits of the champion
        return List<String>.from(champion['traits']);
      }
    }
  }
  // return null if the champion is not found
  return [];
}

// get champion by name, from json
Future<Champion> getChampionByName(String championName) async {
  String jsonData = await rootBundle.loadString('assets/data/champions.json');
  final Map<String, dynamic> data = json.decode(jsonData);

  for (var tier in data.values) {
    for (var champData in tier) {
      if (champData['name'] == championName) {
        // print('id: ${champData['id']}');
        // print('name: ${champData['name']}');
        // print('tier: ${champData['tier']}');
        // print('image: ${champData['image']}');
        // print('traits: ${champData['traits']}');
        // print('description: ${champData['description']}');
        return Champion.fromJson(champData);
      }
    }
  }

  // Return null if the champion is not found
  print('Champion not found: $championName');

  return Champion(
    id: '',
    name: '',
    tier: 0,
    image: '',
    traits: [],
    description: '',
  );
}
