import 'package:flutter/material.dart';

import '../utils/champion.dart';

class ChampionList extends StatelessWidget {
  const ChampionList({Key? key}) : super(key: key);

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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'Tier $tier', // Display the tier number
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    5), // Space between tier number and champions
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: [
                                for (var champion in tieredChampions[tier]!)
                                  LongPressDraggable<Champion>(
                                    data: champion,
                                    feedback: Image.asset(
                                      '../assets/champions/${champion.image}',
                                      width: 60,
                                      height: 60,
                                    ),
                                    child: Image.asset(
                                      '../assets/champions/${champion.image}',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(
                                height: 10), //Space between each tiers
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
