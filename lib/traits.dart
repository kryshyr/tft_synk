import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tft_synk/app_constants.dart';

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
      stats: json['stats'] ?? '',
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

// Function to load traits data from JSON
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 3.0,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, index) {
              // Get the trait at the current index
              final trait = traits[index];
              return SizedBox(
                height: 150,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVariant,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/traits/Trait_Icon_11_${trait.name}.TFT_Set11.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(trait.name,
                                style: AppTextStyles.headline4BeaufortforLOL),
                          ],
                        ),
                        const Divider(color: AppColors.secondary),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            trait.description,
                            style: AppTextStyles.bodyText3Spiegel,
                            maxLines: 6,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          trait.stats,
                          style: AppTextStyles.bodyText4Spiegel,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
