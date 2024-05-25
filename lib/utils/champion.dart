// champions.dart

import 'dart:convert';

import 'package:flutter/services.dart'; // Import Services library for reading JSON file

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
    List<Champion> champions = [];
    for (var champData in championList) {
      champions.add(Champion.fromJson(champData));
    }
    tieredChampions[tierNumber] = champions;
  });

  return tieredChampions;
}

// get trait list by champion name
List<String> getTraitListByChampionName(String championName) {
  for (var champion in champions) {
    if (champion.name == championName) {
      return champion.traits;
    }
  }
  return [];
}