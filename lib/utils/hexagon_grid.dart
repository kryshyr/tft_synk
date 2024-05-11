import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

import 'champion.dart';

class HexagonGrid extends StatefulWidget {
  @override
  _HexagonGridState createState() => _HexagonGridState();
}

class _HexagonGridState extends State<HexagonGrid> {
  // 2D array to keep track of the champions dropped on each hexagon
  List<List<Champion?>> championsGrid = List.generate(
    4, // rows
    (row) => List.generate(
      7, // columns
      (col) => null, // initially, no champion is dropped on any hexagon
    ),
  );

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
                buildTile: (col, row) => HexagonWidgetBuilder(
                  color: const Color.fromRGBO(10, 50, 60, 1),
                  elevation: 2,
                  padding: 2,
                ),
                buildChild: (col, row) {
                  Champion? champion = championsGrid[row][col];
                  if (champion != null) {
                    // If a champion has been dropped
                    return Image.asset(
                      '../assets/champions/${champion.image}',
                    );
                  } else {
                    // If no champion has been dropped yet
                    return DragTarget<Champion>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(); // empty container
                      },
                      onAcceptWithDetails: (details) {
                        final champion = details.data as Champion;
                        updateChampion(col, row, champion);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // To update the champion that is dropped on a specific hexagon
  void updateChampion(int col, int row, Champion champion) {
    setState(() {
      championsGrid[row][col] = champion;
    });
  }
}
