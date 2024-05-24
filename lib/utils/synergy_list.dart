import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';

class SynergyList extends StatefulWidget {
  const SynergyList({Key? key}) : super(key: key);

  @override
  _SynergyListState createState() => _SynergyListState();
}

class _SynergyListState extends State<SynergyList> {
  Map<String, int> traitCounts = {};

  Map<String, List<int>> traitBonuses = {
    "Dragonlord": [2, 3, 4, 5],
    "Dryad": [2, 4, 6],
    "Fated": [3, 5, 7, 10],
    "Fortune": [3, 5, 7],
    "Ghostly": [2, 4, 6, 8],
    "Heavenly": [2, 3, 4, 5, 6, 7],
    "Inkshadow": [3, 5, 7],
    "Mythic": [3, 5, 7, 10],
    "Porcelain": [2, 4, 6],
    "Storyweaver": [3, 5, 7, 10],
    "Umbral": [2, 4, 6, 8],
    "Altruist": [2, 3, 4],
    "Arcanist": [2, 4, 6, 8],
    "Artist": [1],
    "Behemoth": [2, 4, 6],
    "Bruiser": [2, 4, 6, 8],
    "Duelist": [2, 4, 6, 8],
    "Exalted": [3, 5],
    "Great": [1],
    "Invoker": [2, 4, 6],
    "Lovers": [1],
    "Reaper": [2, 4],
    "Sage": [2, 3, 4, 5],
    "Sniper": [2, 4, 6],
    "Spiritwalker": [1],
    "Trickshot": [2, 4],
    "Warden": [2, 4, 6],
  };

  String getSynergyIcon(String trait) {
    return 'assets/traits/Trait_Icon_11_$trait.TFT_Set11.png';
  }

  String getFraction(String traitName, int count) {
    String numerator = count.toString();
    String denominator = "1";

    List<int> bonuses = traitBonuses[traitName]!;

    for (int i = 0; i < bonuses.length; i++) {
      if (count <= bonuses[i]) {
        denominator = bonuses[i].toString();
        break;
      }
    }

    return numerator + " / " + denominator;
  }

  void incrementTraitCount(String trait) {
    setState(() {
      traitCounts[trait] = (traitCounts[trait] ?? 0) + 1;
    });
  }

  void decrementTraitCount(String trait) {
    setState(() {
      traitCounts[trait] = (traitCounts[trait] ?? 0) - 1;
      if (traitCounts[trait] == 0) {
        traitCounts.remove(trait);
      }
    });
  }

  Widget buildSynergyIcon(String trait) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Image.asset(
        getSynergyIcon(trait),
      ),
    );
  }

  @override
  Widget build(context) {
    return Container(
      color: AppColors.secondaryAccent,
      height: 60,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // for every trait in traitCount, build a synergy icon
              for (var trait in traitCounts.keys)
                Column(
                  children: [
                    buildSynergyIcon(trait),
                    Text(
                      getFraction(trait, traitCounts[trait] ?? 0),
                      style: TextStyle(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
