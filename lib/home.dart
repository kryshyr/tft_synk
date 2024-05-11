import 'package:flutter/material.dart';

import './utils/champion.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key});

  @override
  Widget build(BuildContext context) {
    final List<List<Widget>> hexRows = [];

    // Generate the hexes in rows
    for (int i = 0; i < 4; i++) {
      final List<Widget> row = [];
      for (int j = 0; j < 7; j++) {
        row.add(
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 80),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Image.asset('../assets/icons/hex-icon.png',
                    fit: BoxFit.contain),
              ),
            ),
          ),
        );
      }
      hexRows.add(row);
    }

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
            const Text("TFT Planner",
                style: TextStyle(color: Color.fromRGBO(200, 155, 60, 1))),

            const SizedBox(width: 15),

            // EDIT BUTTON
            GestureDetector(
              onTap: () {
                print("Edit icon clicked");
              },
              child: Image.asset(
                '../assets/icons/edit-icon.png',
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
              '../assets/icons/expand-button.png',
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
              '../assets/icons/delete-icon.png',
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(width: 10),

          // SAVE BUTTON
          GestureDetector(
            onTap: () {
              print("Save icon clicked");
            },
            child: Image.asset(
              '../assets/icons/save-button.png',
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.green,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        for (int i = 0; i < hexRows.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (i % 2 == 0) SizedBox(width: 30),
                                ...hexRows[i],
                                if (i % 2 != 0) SizedBox(width: 30),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
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
                          '../assets/traits/Trait_Icon_11_Sage.TFT_Set11.png',
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
                      child: const TextField(
                        decoration: InputDecoration(
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Container(
                // color: Colors.orange,
                child: FutureBuilder<Map<int, List<Champion>>>(
                  future: parseChampionsFromJson(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      Map<int, List<Champion>> tieredChampions = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var tier in tieredChampions.keys)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    'Tier $tier', // Display the tier number
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                      height:
                                          5), // Space between tier number and champions
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      for (var champion
                                          in tieredChampions[tier]!)
                                        Image.asset(
                                          '../assets/champions/${champion.image}',
                                          width: 60,
                                          height: 60,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: 10), //Space between each tiers
                                ],
                              ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
