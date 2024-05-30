import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';
import 'package:tft_synk/utils/synergy_list.dart';
import 'package:tft_synk/utils/champion.dart';

class SynergyListMini extends StatefulWidget {
  final List<String> championsList;

  const SynergyListMini({
    Key? key,
    required this.championsList,
  }) : super(key: key);

  @override
  _SynergyListMiniState createState() => _SynergyListMiniState();
}

class _SynergyListMiniState extends State<SynergyListMini> {
  Map<String, int> traitList = {};

  @override
  void initState() {
    super.initState();
    _initializeTraitList();
  }

  void _initializeTraitList() async {
    for (String champion in widget.championsList) {
      List<String> traits = await getTraitListFromJson(champion);
      setState(() {
        for (String trait in traits) {
          if (traitList.containsKey(trait)) {
            traitList[trait] = traitList[trait]! + 1;
          } else {
            traitList[trait] = 1;
          }
        }
      });
    }

    // alphabetize traitlist by key
    traitList = Map.fromEntries(
        traitList.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (String trait in traitList.keys) ...[
          Column(
            children: [
              buildSynergyIcon(trait),
              Text(
                traitList[trait]!.toString(),
                style: AppTextStyles.bodyText6Spiegel,
              ),
            ],
          )
        ],
      ],
    );
  }
}
