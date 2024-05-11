// champions.dart

import 'dart:convert';

import 'package:flutter/services.dart'; // Import Services library for reading JSON file

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

Future<Map<int, List<Champion>>> parseChampionsFromJson() async {
  String jsonData = await rootBundle.loadString('../../data/champions.json');
  final Map<String, dynamic> data = json.decode(jsonData);
  Map<int, List<Champion>> tieredChampions = {};

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
