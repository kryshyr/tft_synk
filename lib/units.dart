import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';

import './utils/champion.dart'; // Import the Champion class and parseChampionsFromJson function

class UnitTab extends StatefulWidget {
  const UnitTab({super.key});

  @override
  _UnitTabState createState() => _UnitTabState();
}

class _UnitTabState extends State<UnitTab> {
  String searchQuery = '';
  String selectedFilter = 'All';
  List<Champion> allChampions = [];
  Map<int, List<Champion>> filteredChampions = {};
  List<String> traits = [];

  @override
  void initState() {
    super.initState();
    _loadChampions();
  }

  Future<void> _loadChampions() async {
    Map<int, List<Champion>> data = await parseChampionsFromJson();
    setState(() {
      allChampions = data.values.expand((e) => e).toList();
      filteredChampions = _filterChampions();
      traits = _getUniqueTraits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search champions',
                    hintStyle: TextStyle(
                        color: AppColors.hintText,
                        fontFamily: 'Spiegel',
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.tertiaryAccent),
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.secondary),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  ),
                  style: const TextStyle(
                    color: AppColors.hintText,
                    fontFamily: 'Spiegel',
                    fontWeight: FontWeight.normal,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      filteredChampions = _filterChampions();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: selectedFilter,
                dropdownColor: AppColors.primaryVariant,
                style: const TextStyle(color: AppColors.hintText),
                iconEnabledColor: AppColors.secondary,
                items: ['All', ...traits].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                    filteredChampions = _filterChampions();
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredChampions.length,
            itemBuilder: (context, tierIndex) {
              int tier = filteredChampions.keys.elementAt(tierIndex);
              List<Champion> championsInTier = filteredChampions[tier]!;
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
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: championsInTier.length,
                    itemBuilder: (context, championIndex) {
                      Champion champion = championsInTier[championIndex];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.secondary,
                            width: 2,
                          ),
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
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.black.withOpacity(0.4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (var trait in champion.traits)
                                              Text(
                                                trait,
                                                style: const TextStyle(
                                                  color: AppColors.primaryText,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Spiegel',
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
          ),
        ),
      ],
    );
  }

  Map<int, List<Champion>> _filterChampions() {
    List<Champion> filteredList = allChampions.where((champion) {
      bool matchesQuery =
          champion.name.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesFilter =
          selectedFilter == 'All' || champion.traits.contains(selectedFilter);
      return matchesQuery && matchesFilter;
    }).toList();

    Map<int, List<Champion>> tieredMap = {};
    for (var champion in filteredList) {
      if (!tieredMap.containsKey(champion.tier)) {
        tieredMap[champion.tier] = [];
      }
      tieredMap[champion.tier]!.add(champion);
    }
    return tieredMap;
  }

  List<String> _getUniqueTraits() {
    Set<String> uniqueTraits = {};
    for (var champion in allChampions) {
      uniqueTraits.addAll(champion.traits);
    }
    return uniqueTraits.toList();
  }
}
