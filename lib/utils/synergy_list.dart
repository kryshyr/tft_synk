import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';
import 'package:tft_synk/home.dart' show SynergyListController;

Map<String, List<int>> traitBonuses = {
  "Any Synergy": [],
  "Altruist": [2, 3, 4],
  "Arcanist": [2, 4, 6, 8],
  "Artist": [1],
  "Behemoth": [2, 4, 6],
  "Bruiser": [2, 4, 6, 8],
  "Dragonlord": [2, 3, 4, 5],
  "Dryad": [2, 4, 6],
  "Duelist": [2, 4, 6, 8],
  "Exalted": [3, 5],
  "Fated": [3, 5, 7, 10],
  "Fortune": [3, 5, 7],
  "Ghostly": [2, 4, 6, 8],
  "Great": [1],
  "Heavenly": [2, 3, 4, 5, 6, 7],
  "Inkshadow": [3, 5, 7],
  "Invoker": [2, 4, 6],
  "Lovers": [1],
  "Mythic": [3, 5, 7, 10],
  "Porcelain": [2, 4, 6],
  "Reaper": [2, 4],
  "Sage": [2, 3, 4, 5],
  "Sniper": [2, 4, 6],
  "Spirit Walker": [1],
  "Storyweaver": [3, 5, 7, 10],
  "Trickshot": [2, 4],
  "Umbral": [2, 4, 6, 8],
  "Warden": [2, 4, 6],
};

class SynergyList extends StatefulWidget {
  final SynergyListController controller;

  const SynergyList({
    Key? key,
    required this.controller,
  }) : super(key: key);

  // Global key for accessing the state of HexagonGrid
  static final GlobalKey<_SynergyListState> synergyListKey =
      GlobalKey<_SynergyListState>();

  @override
  _SynergyListState createState() => _SynergyListState(controller);
}

class _SynergyListState extends State<SynergyList> {
  Map<String, int> traitCounts = {};

  _SynergyListState(SynergyListController controller) {
    controller.incrementTraitCount = incrementTraitCount;
    controller.decrementTraitCount = decrementTraitCount;
    controller.clearTraitCounts = clearTraitCounts;
  }

  String getSynergyIcon(String trait) {
    if (trait == "Inkshadow") {
      trait = "Ink Shadow";
    }

    return 'assets/traits/Trait_Icon_11_$trait.TFT_Set11.png';
  }

  String getFraction(String traitName, int count) {
    String numerator = count.toString();
    String denominator = count.toString();

    List<int> bonuses = traitBonuses[traitName]!;

    for (int i = 0; i < bonuses.length; i++) {
      if (count <= bonuses[i]) {
        denominator = bonuses[i].toString();
        break;
      }
    }

    return numerator + " / " + denominator;
  }

  void clearTraitCounts() {
    setState(() {
      traitCounts = {};
    });
  }

  void incrementTraitCount(String trait) {
    setState(() {
      traitCounts[trait] = (traitCounts[trait] ?? 0) + 1;
    });

    // for debugging
    for (var trait in traitCounts.keys) {
      print(trait + ": " + traitCounts[trait].toString());
    }
  }

  void decrementTraitCount(String trait) {
    setState(() {
      traitCounts[trait] = (traitCounts[trait] ?? 0) - 1;
      if (traitCounts[trait] == 0) {
        traitCounts.remove(trait);
      }
    });

    // for debugging
    for (var trait in traitCounts.keys) {
      print(trait + ": " + traitCounts[trait].toString());
    }
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
    traitCounts = Map.fromEntries(traitCounts.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

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
