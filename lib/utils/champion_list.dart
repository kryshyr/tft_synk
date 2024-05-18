import 'package:flutter/material.dart';

import '../utils/champion.dart';

class ChampionList extends StatelessWidget {
  final String searchQuery;

  const ChampionList({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Container(
          child: FutureBuilder<Map<int, List<Champion>>>(
            future: parseChampionsFromJson(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                Map<int, List<Champion>> tieredChampions = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var tier in tieredChampions.keys)
                        if (tieredChampions[tier]!.any((champion) => champion
                            .name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase())))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                'Tier $tier',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  for (var champion in tieredChampions[tier]!)
                                    if (champion.name
                                        .toLowerCase()
                                        .contains(searchQuery))
                                      LongPressDraggable<Champion>(
                                        data: champion,
                                        feedback: Image.asset(
                                          'assets/champions/${champion.image}',
                                          width: 60,
                                          height: 60,
                                        ),
                                        child: Image.asset(
                                          'assets/champions/${champion.image}',
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
