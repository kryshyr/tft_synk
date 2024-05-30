import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';

import '../utils/champion.dart';

class ChampionList extends StatefulWidget {
  final String searchQuery;
  final String synergyFilter;

  const ChampionList({
    Key? key,
    required this.searchQuery,
    required this.synergyFilter,
  }) : super(key: key);

  @override
  _ChampionListState createState() => _ChampionListState();
}

class _ChampionListState extends State<ChampionList> {
  late Map<int, List<Champion>> tieredChampions;

  @override
  void initState() {
    super.initState();
    _loadChampionsData();
  }

  Future<void> _loadChampionsData() async {
    try {
      tieredChampions = await parseChampionsFromJson();
    } catch (error) {
      print('Error loading champions data: $error');
      // Handle error loading champions data
    }
    setState(() {}); // Trigger a rebuild after loading champions data
  }

  @override
  Widget build(BuildContext context) {
    if (tieredChampions == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width, // Match maximum width
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var tier in tieredChampions.keys)
                      if (tieredChampions[tier]!.any((champion) =>
                          champion.name.toLowerCase().contains(
                              widget.searchQuery.toLowerCase().trim()) &&
                          (widget.synergyFilter == 'Any Synergy' ||
                              champion.traits.contains(widget.synergyFilter))))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              'Tier $tier',
                              style: AppTextStyles.headline3BeaufortforLOL,
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: [
                                for (var champion in tieredChampions[tier]!)
                                  if (champion.name.toLowerCase().contains(
                                          widget.searchQuery.toLowerCase()) &&
                                      (widget.synergyFilter == 'Any Synergy' ||
                                          champion.traits
                                              .contains(widget.synergyFilter)))
                                    LongPressDraggable<Champion>(
                                      delay: const Duration(milliseconds: 70),
                                      data: champion,
                                      feedback: Image.asset(
                                        'assets/champions/${champion.image}',
                                        width: 35,
                                        height: 35,
                                      ),
                                      child: Image.asset(
                                        'assets/champions/${champion.image}',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
