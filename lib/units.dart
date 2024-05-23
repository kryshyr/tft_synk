import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';

import './utils/champion.dart'; // Import the Champion class and parseChampionsFromJson function

class UnitTab extends StatelessWidget {
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
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Tier $tier',
                      style: AppTextStyles.headline2Spiegel,
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.5,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1.25, // Adjust as needed
                    ),
                    itemCount: championsInTier.length,
                    itemBuilder: (context, championIndex) {
                      Champion champion = championsInTier[championIndex];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.secondary,
                              width: 2), // Gold outline
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Card(
                          color: AppColors.primaryVariant,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(6)),
                                      child: Image.asset(
                                        'assets/unit_champions/TFT11_${champion.name}.TFT_Set11.png',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 28,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.black.withOpacity(0.5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (var trait in champion
                                                .traits) // Display each trait
                                              Text(
                                                trait,
                                                style: const TextStyle(
                                                  color: AppColors.primaryText,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 2.0,
                                                      color: Colors.black,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  champion.name,
                                  style: AppTextStyles.bodyText2Spiegel,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
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
