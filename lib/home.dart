import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';

import './firestore/firebase_service.dart';
import './utils/champion.dart';
import './utils/device_id.dart';
import './utils/synergy_list.dart';
import 'utils/champion_list.dart';
import 'utils/hexagon_grid.dart';

class HexagonGridController {
  void placeChampion(
      int? dropTargetRow, int? dropTargetCol, Champion champion) {
    HexagonGrid.hexagonGridKey.currentState
        ?.placeChampion(dropTargetRow!, dropTargetCol!, champion);
  }

  void placeChampionInGrid(int row, int col, Champion champion) {
    // Place the champion in the specified row and column of the grid
    championsGrid[row][col] = champion;
  }

}

void clearHexagonGrid() {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 7; j++) {
      championsGrid[i][j] = null;
    }
  }

}

class SynergyListController {
  void Function(String) incrementTraitCount = (trait) {};
  void Function(String) decrementTraitCount = (trait) {};
  void Function() clearTraitCounts = () {};
}

class HomeTab extends StatefulWidget {
  final String? initialCompositionName;
  final GlobalKey<HomeTabState> key;

  const HomeTab({
    required this.key,
    this.initialCompositionName,
  }) : super(key: key);

  // Global key for accessing the state of HomeTab
  static final GlobalKey<HomeTabState> homeTabKey = GlobalKey<HomeTabState>();

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  final FirebaseService _firebaseService = FirebaseService();
  final HexagonGridController hexagonGridController = HexagonGridController();
  final SynergyListController synergyListController = SynergyListController();
  // final SynergyList synergyList = SynergyList(controller: SynergyListController());
  String searchQuery = ''; // To store the search query
  List<ChampionPosition> championsList = [];
  ChampionList championList =
      ChampionList(searchQuery: '', synergyFilter: 'Any Synergy');

  // Callback function to handle champion that is dropped onto the board
  void _handleChampionDropped(int? dropTargetRow, int? dropTargetCol,
      int? draggedFromRow, int? draggedFromCol, Champion champion) {
    bool isDraggedFromHexagon =
        (draggedFromCol != null && draggedFromRow != null);
    bool targetHexagonOccupied = championsList.any((element) =>
        element.row == dropTargetRow && element.col == dropTargetCol);
    bool isSameHexagon =
        (draggedFromRow == dropTargetRow && draggedFromCol == dropTargetCol);

    // Champion? previousChampion;
    String? previousChampionName;
    List<String>? previousChampionTraits;

    if (targetHexagonOccupied) {
      previousChampionName = championsList
          .firstWhere((element) =>
              element.row == dropTargetRow && element.col == dropTargetCol)
          .championName;
      previousChampionTraits = getTraitListByChampionName(previousChampionName);
    }

    // If the champion is dropped on the same hexagon
    if (isSameHexagon) {
      return;
    }

    // If dragged from a hexagon and the target has no champion
    if (isDraggedFromHexagon && !targetHexagonOccupied) {
      // Remove the champion from the previous position
      championsList.removeWhere((element) =>
          element.row == draggedFromRow && element.col == draggedFromCol);

      // if the champion is no longer in the list
      if (!championsList
          .any((element) => element.championName == previousChampionName)) {
        // decrement the trait count
        champion.traits.forEach((trait) {
          synergyListController.decrementTraitCount(trait);
        });
      }
    }

    // If not dragged from a hexagon and the target is occupied
    if (!isDraggedFromHexagon && targetHexagonOccupied) {
      // Remove the champion from the target position
      setState(() {
        championsList.removeWhere((element) =>
            element.row == dropTargetRow && element.col == dropTargetCol);

        // check if the champion is no longer in the list
        if (!championsList
            .any((element) => element.championName == previousChampionName)) {
          // decrement the trait count
          previousChampionTraits!.forEach((trait) {
            synergyListController.decrementTraitCount(trait);
          });
        }
      });
    }

    // If dragged from a hexagon and the target has a champion
    if (isDraggedFromHexagon && targetHexagonOccupied) {
      // Swap them
      setState(() {
        // Remove the champion from the previous position
        championsList.removeWhere((element) =>
            element.row == draggedFromRow && element.col == draggedFromCol);

        // Do not decrement trait if champion has duplicate
        if (!championsList
            .any((element) => element.championName == champion.name)) {
          champion.traits.forEach((trait) {
            synergyListController.decrementTraitCount(trait);
          });
        }

        // Remove the champion from the target position
        championsList.removeWhere((element) =>
            element.row == dropTargetRow && element.col == dropTargetCol);

        // Add the champion from the target position to the previous position
        championsList.add(ChampionPosition(
            previousChampionName!, draggedFromRow, draggedFromCol));
      });
    }

    // Do not increment trait if champion has duplicate
    if (!championsList
        .any((element) => element.championName == champion.name)) {
      champion.traits.forEach((trait) {
        synergyListController.incrementTraitCount(trait);
      });
    }

    // Add the champion to the list
    championsList
        .add(ChampionPosition(champion.name, dropTargetRow!, dropTargetCol!));

    // Debugging purposes
    print(
        'Champion ${champion.name} dropped at row: $dropTargetRow, col: $dropTargetCol');
    for (var champ in championsList) {
      print(
          'Champion: ${champ.championName}, row: ${champ.row}, col: ${champ.col}');
    }
    print('\n');
  }

  void _handleChampionRemoved(
      int? draggedFromRow, int? draggedFromCol, Champion champion) {
    // Remove the champion from the list
    championsList.removeWhere((element) =>
        element.row == draggedFromRow && element.col == draggedFromCol);

    // decrement the trait count if the champion is no longer in the list
    if (!championsList
        .any((element) => element.championName == champion.name)) {
      champion.traits.forEach((trait) {
        synergyListController.decrementTraitCount(trait);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialCompositionName != null) {
      _fetchTeamComps();
      initCompositionName();
    }

    clearHexagonGrid();
  }

  Future<void> _fetchTeamComps() async {
    String deviceId = await getDeviceID();
    DocumentReference documentReference = _firebaseService.firestore
        .collection('team_comps')
        .doc(deviceId)
        .collection('compositions')
        .doc(widget.initialCompositionName);
    try {
      // Fetch the document snapshot
      DocumentSnapshot compositionDocSnapshot = await documentReference.get();

      if (compositionDocSnapshot.exists) {
        // The document data as a Map
        Map<String, dynamic>? compositionData =
            compositionDocSnapshot.data() as Map<String, dynamic>?;

        if (compositionData != null) {
          // Do something with the composition data
          print('Composition Data: $compositionData');
          // championsList = compositionData['championPositions'];
          List<dynamic> championPositions =
              compositionData['championPositions'];
          List<String> championTraits = [];
          Champion? championToAdd;

          for (var champion in championPositions) {
            // update trait count
            print('Champion: ${champion['championName']}');
            print(
                'Trait list: ${await getTraitListFromJson(champion['championName'])}');

            championTraits =
                await getTraitListFromJson(champion['championName']);

            championTraits.forEach((trait) {
              if (!championsList.any((element) =>
                  element.championName == champion['championName'])) {
                synergyListController.incrementTraitCount(trait);
              }
            });

            // Add the champion to the list
            championsList.add(ChampionPosition(champion['championName'],
                int.parse(champion['row']), int.parse(champion['col'])));

            // championToAdd = champions.firstWhere(
            //     (element) => element.name == champion['championName']);

            championToAdd = await getChampionByName(champion['championName']);
            print('name: ${championToAdd.name}');
            print('tier: ${championToAdd.tier}');
            print('image: ${championToAdd.image}');
            print('traits: ${championToAdd.traits}');
            print('description: ${championToAdd.description}');

            // TO-DO: place the champion in the championsGrid
            setState(() {
              hexagonGridController.placeChampionInGrid(
                  int.parse(champion['row']),
                  int.parse(champion['col']),
                  championToAdd!);
            });

            print(
                'Champion ${championToAdd.name} placed at row: ${champion['row']}, col: ${champion['col']})');
          }

          // Debugging purposes
          for (var champ in championsList) {
            print(
                'Champion: ${champ.championName}, row: ${champ.row}, col: ${champ.col}');
          }
          // print('Trais: ${synergyList.traitCounts}');

          // print(synergylist.trait)
        } else {
          print('No data found in the document');
        }
      } else {
        print('Composition document does not exist');
      }
    } catch (e) {
      print('Error getting composition document: $e');
    }
  }

  Future<void> saveTeamCompToFirestore() async {
    List<Map<String, String>> championPositions = [];

    // Get the names and positions in championsList
    for (var position in championsList) {
      championPositions.add({
        'championName': position.championName,
        'row': position.row.toString(),
        'col': position.col.toString(),
      });
    }

    // GET DEVICE ID
    String deviceId = await getDeviceID();

    // SAVE TEAM COMP
    await _firebaseService.saveTeamComp(
        context, deviceId, _compositionName, championPositions);

    print('Team composition saved!');
    resetPage();
  }

  TextEditingController _compositionNameController = TextEditingController();

  // Define a variable to hold the current composition name
  String _compositionName = 'Name';

  void initCompositionName() {
    _compositionName = widget.initialCompositionName ?? 'Name';
  }

  // Function to show the dialog to edit the composition name
  Future<void> _showEditCompositionNameDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryVariant,
          title: const Text(
            "Team Comp Name",
            style: AppTextStyles.headline1BeaufortforLOL,
          ),
          content: TextField(
            controller: _compositionNameController,
            decoration: const InputDecoration(
              hintText: "Enter composition name",
              hintStyle: AppTextStyles.bodyText6Spiegel,
            ),
          ),
          actions: <Widget>[
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 8, 40, 48),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton(
                child: const Text(
                  "Save",
                  style: AppTextStyles.headline5BeaufortforLOL,
                ),
                onPressed: () {
                  setState(() {
                    _compositionName =
                        _compositionNameController.text.isNotEmpty
                            ? _compositionNameController.text
                            : 'Name';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(width: 2),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 8, 40, 48),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextButton(
                child: const Text(
                  "Cancel",
                  style: AppTextStyles.headline5BeaufortforLOL,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  UniqueKey hexagonGridKey = UniqueKey();

  String? synergyFilter = 'Any Synergy';

  @override
  void dispose() {
    _compositionNameController.dispose();
    super.dispose();
  }

  void resetPage() {  
    setState(() {
      championsList.clear();
      synergyFilter = 'Any Synergy';
      _compositionName = 'Name';
      _compositionNameController.clear();
      synergyListController.clearTraitCounts();
      hexagonGridKey = UniqueKey(); // Update the key to rebuild HexagonGrid
      clearHexagonGrid();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Composition name: $_compositionName');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 20, 40, 1),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: const Color.fromRGBO(200, 155, 60, 1),
            height: 1.0,
          ),
        ),
        title: Row(
          children: [
            // TITLE

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _compositionName,
                style: AppTextStyles.headline3BeaufortforLOL,
              ),
            ),

            const SizedBox(width: 15),

            // EDIT BUTTON
            GestureDetector(
              onTap: () {
                print("Edit icon clicked");
                _showEditCompositionNameDialog();
              },
              child: Image.asset(
                'assets/icons/edit-icon.png',
                height: 20,
              ),
            ),
          ],
        ),
        actions: [
          // EXPAND BUTTON
          GestureDetector(
            onTap: () {
              print("Expand icon clicked");
            },
            child: Image.asset(
              'assets/icons/expand-button.png',
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(width: 10),

          // DELETE BUTTON
          GestureDetector(
            onTap: () {
              print("Delete icon clicked");
              resetPage();
            },
            child: Image.asset(
              'assets/icons/delete-icon.png',
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(width: 10),

          // SAVE BUTTON
          GestureDetector(
            onTap: () {
              print("Save icon clicked");
              saveTeamCompToFirestore();
            },
            child: Image.asset(
              'assets/icons/save-button.png',
              height: 30,
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromRGBO(10, 20, 40, 1),
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              child: HexagonGrid(
                key: hexagonGridKey,
                onChampionDropped: _handleChampionDropped,
                controller: hexagonGridController,
                // Remove the champion from the list
                onChampionRemoved: _handleChampionRemoved,
              ),
            ),
          ),
          SynergyList(controller: synergyListController),
          Container(
            color: const Color.fromARGB(255, 9, 137, 143),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        onChanged: (value) {
                          // Update the search query
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search...',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    value: synergyFilter,
                    items: traitBonuses.keys.toList().map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        synergyFilter = newValue!;
                      });
                    },
                    hint: const Text('Any Synergy'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
                child: championList = ChampionList(
              searchQuery: searchQuery,
              synergyFilter: synergyFilter!,
            )),
          ),
        ],
      ),
    );
  }
}
