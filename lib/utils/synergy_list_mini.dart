import 'package:flutter/material.dart';
import 'package:tft_synk/utils/synergy_list.dart';
import 'package:tft_synk/utils/champion.dart';
import 'package:tft_synk/route_observer.dart';

class SynergyListMini extends StatefulWidget {
  final List<String> championsList;

  const SynergyListMini({
    Key? key,
    required this.championsList,
  }) : super(key: key);

  @override
  _SynergyListMiniState createState() => _SynergyListMiniState();
}

class _SynergyListMiniState extends State<SynergyListMini> with RouteAware {
  Map<String, int> traitList = {};

  @override
  void initState() {
    super.initState();
    _initializeTraitList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
    _initializeTraitList();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _initializeTraitList();
  }

  void _initializeTraitList() async {
    traitList = {};

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
    traitList = Map.fromEntries(traitList.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (String trait in traitList.keys) ...[
          buildSynergyIcon(trait),
          Text(traitList[trait]!.toString()),
        ],
      ],
    );
  }
}