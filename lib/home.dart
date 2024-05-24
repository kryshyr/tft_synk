import 'package:flutter/material.dart';

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
}

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  // Global key for accessing the state of HomeTab
  static final GlobalKey<_HomeTabState> homeTabKey = GlobalKey<_HomeTabState>();

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirebaseService _firebaseService = FirebaseService();
  final HexagonGridController hexagonGridController = HexagonGridController();
  final SynergyList synergyList = SynergyList();
  String searchQuery = ''; // To store the search query
  List<ChampionPosition> championsList = [];

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

    // If the champion is dropped on the same hexagon
    if (isSameHexagon) {
      return;
    }

    // If dragged from a hexagon and the target has no champion
    if (isDraggedFromHexagon && !targetHexagonOccupied) {
      // Remove the champion from the previous position
      setState(() {
        championsList.removeWhere((element) =>
            element.row == draggedFromRow && element.col == draggedFromCol);
      });
    }

    // If not dragged from a hexagon and the target is occupied
    if (!isDraggedFromHexagon && targetHexagonOccupied) {
      // Remove the champion from the target position
      setState(() {
        championsList.removeWhere((element) =>
            element.row == dropTargetRow && element.col == dropTargetCol);
      });
    }

    // If dragged from a hexagon and the target has a champion
    if (isDraggedFromHexagon && targetHexagonOccupied) {
      // Swap them
      setState(() {
        // // Save name of the champion in the target position
        // previousChampion = championsList.firstWhere((element) =>
        //     element.row == dropTargetRow && element.col == dropTargetCol).championName;
        previousChampionName = championsList
            .firstWhere((element) =>
                element.row == dropTargetRow && element.col == dropTargetCol)
            .championName;

        // Remove the champion from the previous position
        championsList.removeWhere((element) =>
            element.row == draggedFromRow && element.col == draggedFromCol);

        // Remove the champion from the target position
        championsList.removeWhere((element) =>
            element.row == dropTargetRow && element.col == dropTargetCol);

        // Add the champion from the target position to the previous position
        championsList.add(ChampionPosition(
            previousChampionName!, draggedFromRow, draggedFromCol));
        // hexagonGridController.placeChampion(draggedFromRow, draggedFromCol, previousChampion!);
      });
    }

    // Add the champion to the list
    setState(() {
      championsList
          .add(ChampionPosition(champion.name, dropTargetRow!, dropTargetCol!));
    });

    // Debugging purposes
    print(
        'Champion ${champion.name} dropped at row: $dropTargetRow, col: $dropTargetCol');
    for (var champ in championsList) {
      print(
          'Champion: ${champ.championName}, row: ${champ.row}, col: ${champ.col}');
    }
    print('\n');
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

    // Reset the champions grid (NOT WORKING)
    HexagonGrid.hexagonGridKey.currentState?.resetChampionsGrid();
    resetState();
  }

  TextEditingController _compositionNameController = TextEditingController();

  // Define a variable to hold the current composition name
  String _compositionName = 'Name';

  // Function to show the dialog to edit the composition name
  Future<void> _showEditCompositionNameDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Team Comp Name"),
          content: TextField(
            controller: _compositionNameController,
            decoration: InputDecoration(hintText: "Enter new composition name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  _compositionName = _compositionNameController.text.isNotEmpty
                      ? _compositionNameController.text
                      : 'Name';
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _compositionNameController.dispose();
    super.dispose();
  }

  void resetState() {
    setState(() {
      // To clear the champions list and positions map
      championsList.clear();
      // championPositions.clear();
      // To reset the composition name
      _compositionName = 'Name';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(10, 20, 40, 1),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Color.fromRGBO(200, 155, 60, 1),
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
                style: const TextStyle(
                    fontSize: 16, color: Color.fromRGBO(200, 155, 60, 1)),
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
            color: Color.fromRGBO(10, 20, 40, 1),
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              child: HexagonGrid(
                onChampionDropped: _handleChampionDropped,
                controller: hexagonGridController,
              ),
            ),
          ),
          synergyList,
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
                    items: <String>[
                      'Any Synergy',
                      'Synergy 1',
                      'Synergy 2',
                      'Synergy 3',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                    hint: Text('Any Synergy'),
                  ),
                ],
              ),
            ),
          ),
          Container(child: ChampionList(searchQuery: searchQuery))
        ],
      ),
    );
  }
}
