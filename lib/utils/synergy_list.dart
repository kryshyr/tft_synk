import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:tft_synk/app_constants.dart';

class SynergyList extends StatefulWidget{
  const SynergyList({Key? key}) : super(key: key);

  @override
  _SynergyListState createState() => _SynergyListState();
}

class _SynergyListState extends State<SynergyList>{
  Map<String, int> traitCounts = {
    "Artist" : 1,
    "Ghostly" : 3,
    "Behemoth" : 5,
    "Dragonlord" : 3,
    "Sage" : 2,
    "Mythic" : 1,
    "Warden" : 4,
    "Fated" : 10,
    "Reaper" : 9,
    "Lovers" : 3
  };

  Map<String, List<int>> traitBonuses = {
    "Artist" : [1, 2, 3],
    "Ghostly" : [2, 4, 6],
    "Behemoth" : [2, 4, 6],
    "Dragonlord" : [1, 2, 3],
    "Sage" : [1, 2],
    "Mythic" : [1],
    "Warden" : [2, 4],
    "Fated" : [3, 6, 9, 13],
    "Reaper" : [3, 6, 9],
    "Lovers" : [2, 4, 6]
  };
  
  
  String getSynergyIcon(String trait){
    return 'assets/traits/Trait_Icon_11_$trait.TFT_Set11.png';
  }


  String getFraction(String traitName, int count){
    String numerator = count.toString();
    String denominator = "1";

    List<int> bonuses = traitBonuses[traitName]!;

    for (int i = 0; i < bonuses.length; i++){
      if(count <= bonuses[i]){
        denominator = bonuses[i].toString();
        break;
      }
    }
    
    return numerator + " / " + denominator;
  }

  void incrementTraitCount(String trait){
    setState(() {
      traitCounts[trait] = (traitCounts[trait] ?? 0) + 1;
    });
  }

  void decrementTraitCount(String trait){
    setState(() {
      traitCounts[trait] = (traitCounts[trait] ?? 0) - 1;
      if(traitCounts[trait] == 0){
        traitCounts.remove(trait);
      }
    });
  }

  Widget buildSynergyIcon(String trait){
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