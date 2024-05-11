import 'package:flutter/material.dart';

import './utils/champion.dart'; // Import the Champion class and parseChampionsFromJson function

class DatabaseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, List<Champion>>>(
      future: parseChampionsFromJson(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<int, List<Champion>> tieredChampions = snapshot.data!;
          return ListView.builder(
            itemCount: tieredChampions.length,
            itemBuilder: (context, tierIndex) {
              int tier = tieredChampions.keys.elementAt(tierIndex);
              List<Champion> championsInTier = tieredChampions[tier]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Tier $tier',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: championsInTier.length,
                    itemBuilder: (context, championIndex) {
                      Champion champion = championsInTier[championIndex];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.asset(
                              '../assets/champions/${champion.image}'),
                          title: Text(champion.name),
                          subtitle: Text(champion.description),
                          trailing: Text('Tier: $tier'),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
