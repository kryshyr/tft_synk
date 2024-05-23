import 'package:flutter/material.dart';

import './firestore/firebase_service.dart';
import './utils/champion.dart';
import './utils/device_id.dart';
import 'utils/champion_list.dart';
import 'utils/hexagon_grid.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  // Global key for accessing the state of HomeTab
  static final GlobalKey<_HomeTabState> homeTabKey = GlobalKey<_HomeTabState>();

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirebaseService _firebaseService = FirebaseService();
  String searchQuery = ''; // To store the search query
  // List<Champion> championsList = []; // List to store the champions
  // Map<String, ChampionPosition> championPositions = {};
  List<ChampionPosition> championsList = [];


  // Callback function to handle champion that is dropped onto the board
  void _handleChampionDropped(int row, int col, Champion champion) {
    // // To check if the champion already exists in the list
    // bool championExists = championsList
    //     .any((existingChampion) => existingChampion.name == champion.name);

    // setState(() {
    //   if (championExists) {
    //     // Update the position of the existing champion
    //     var existingChampionIndex = championsList.indexWhere(
    //         (existingChampion) => existingChampion.name == champion.name);
    //     championsList[existingChampionIndex] = champion;
    //   } else {
    //     // Add the dropped champion to the list
    //     championsList.add(champion);
    //   }

    //   // Store the position of the champion
    //   championPositions[champion.name] = ChampionPosition(row, col);
    // });

    // Add the champion to the list
    setState(() {
      championsList.add(ChampionPosition(champion.name, row, col));
    });

    // Debugging purposes
    print('Champion ${champion.name} dropped at row: $row, col: $col');
    for (var champ in championsList) {
      print('Champion: ${champ.championName}, row: ${champ.row}, col: ${champ.col}');
    }
    print('\n');
  }

  Future<void> saveTeamCompToFirestore() async {
    // // Gettin the names of the champions from the championsList
    // List<String> champions =
    //     championsList.map((champion) => champion.name).toList();

    // // Getting the positions of champions from the championPositions map
    // List<Map<String, int>> positions = [];
    // for (var champion in championsList) {
    //   ChampionPosition position = championPositions[champion.name]!;
    //   positions.add({'row': position.row, 'col': position.col});
    // }

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
              ),
            ),
          ),
          Container(
            color: Colors.deepPurple,
            height: 60,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < 15; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Image.asset(
                          'assets/traits/Trait_Icon_11_Sage.TFT_Set11.png',
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
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
