import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';
import 'package:tft_synk/utils/synergy_list.dart';
import 'package:tft_synk/home.dart' show SynergyListController;

class SynergyListMini extends StatelessWidget {
  final List<String> champions;

  const SynergyListMini({
    Key? key,
    required this.champions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      for (var champion in champions) {
        print(champion);
      }

      return Container();
  }
}