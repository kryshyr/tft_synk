import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:tft_synk/home.dart';

import './utils/device_id.dart';
import 'app_constants.dart';

class DetailedViewPage extends StatelessWidget {
  final String title;
  // final GlobalKey<HomeTabState> homeTabKey = ;

  const DetailedViewPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getDeviceID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is loading, show a loading indicator
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // If there's an error, show an error message
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          // Once the future has resolved, use the device ID to fetch data from Firestore
          String deviceID = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
                backgroundColor: AppColors.primary,
                title: Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 15),

                    // EDIT BUTTON
                    GestureDetector(
                      onTap: () {
                        print("Edit icon clicked");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeTab(
                                key: GlobalKey<HomeTabState>(),
                                initialCompositionName: title),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/icons/edit-icon.png',
                        height: 20,
                      ),
                    ),
                  ],
                )),
            body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('team_comps')
                  .doc(deviceID)
                  .collection('compositions')
                  .doc(title)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: Text('No data found.'),
                  );
                } else {
                  var data = snapshot.data!.data();
                  if (data != null &&
                      (data as Map<String, dynamic>)['championPositions'] !=
                          null) {
                    var championPositions =
                        data['championPositions'] as List<dynamic>;
                    return HexagonGridView(
                      championPositions: championPositions,
                    );
                  } else {
                    return Center(
                      child: Text('No champion positions data found.'),
                    );
                  }
                }
              },
            ),
          );
        }
      },
    );
  }
}

class HexagonGridView extends StatelessWidget {
  final List<dynamic> championPositions;

  const HexagonGridView({Key? key, required this.championPositions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: HexagonOffsetGrid.oddPointy(
                columns: 7,
                rows: 4,
                buildTile: (col, row) {
                  // To find the champion for the current row and column
                  var champion = championPositions.firstWhere(
                    (champion) =>
                        champion['row'] == row.toString() &&
                        champion['col'] == col.toString(),
                    orElse: () => null,
                  );
                  return HexagonWidgetBuilder(
                    color: const Color.fromRGBO(10, 50, 60, 1),
                    elevation: 2,
                    padding: 2,
                    child: champion != null
                        ? Image.asset(
                            'assets/champions/${champion['championName']}.png',
                            width: 60,
                            height: 60,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
