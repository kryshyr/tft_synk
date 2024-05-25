import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TraitModel {
  final String id;
  final String name;
  final String description;
  final String stats;

  TraitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.stats,
  });

  factory TraitModel.fromJson(Map<String, dynamic> json) {
    return TraitModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      stats: json['stats'] ?? '', // Handle null stats
    );
  }
}

class TraitsTab extends StatefulWidget {
  @override
  _TraitsTabState createState() => _TraitsTabState();
}

class _TraitsTabState extends State<TraitsTab> {
  late List<TraitModel> traits = [];

  @override
  void initState() {
    super.initState();
    loadTraits();
  }

  Future<void> loadTraits() async {
    final jsonString = await rootBundle.loadString('assets/data/traits.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      traits = jsonResponse.map((json) => TraitModel.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return traits.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            itemCount: traits.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 6),
            ),
            itemBuilder: (context, index) {
              final trait = traits[index];
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trait.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trait.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trait.stats,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
