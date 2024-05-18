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

  // Variables to store the position of the dragged champion
  int? draggedFromCol;
  int? draggedFromRow;
  int? dropTargetCol;
  int? dropTargetRow;

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
                  color: (col == dropTargetCol && row == dropTargetRow)
                      ? Color.fromARGB(255, 27, 158, 149).withOpacity(0.5)
                      : const Color.fromRGBO(10, 50, 60, 1),
                  elevation: 2,
                  padding: 2,
                ),
                buildChild: (col, row) {
                  Champion? champion = championsGrid[row][col];
                  if (champion != null) {
                    // If a champion has been dropped
                    return LongPressDraggable<Champion>(
                      data: champion,
                      feedback: Image.asset(
                        'assets/champions/${champion.image}',
                        width: 40, // Adjust size as needed
                        height: 40,
                      ),
                      childWhenDragging:
                          Container(), // Empty container when dragging
                      onDragStarted: () {
                        // Store the position from which the champion is dragged
                        setState(() {
                          draggedFromCol = col;
                          draggedFromRow = row;
                        });
                      },
                      onDraggableCanceled: (_, __) {
                        // Clear the dragged from position if dragging is canceled
                        setState(() {
                          draggedFromCol = null;
                          draggedFromRow = null;
                        });
                      },
                      child: Image.asset(
                        'assets/champions/${champion.image}',
                      ),
                    );
                  } else {
                    // If no champion has been dropped yet
                    return DragTarget<Champion>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(); // Empty container
                      },
                      onWillAcceptWithDetails: (champion) {
                        // Store the position where the champion will be dropped
                        setState(() {
                          dropTargetCol = col;
                          dropTargetRow = row;
                        });
                        return true;
                      },
                      onAcceptWithDetails: (details) {
                        final champion = details.data as Champion;
                        updateChampion(col, row, champion);
                      },
                      onLeave: (_) {
                        // Clear the drop target position when the champion is dragged away
                        setState(() {
                          dropTargetCol = null;
                          dropTargetRow = null;
                        });
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
      // Remove the champion from its previous position
      if (draggedFromCol != null && draggedFromRow != null) {
        championsGrid[draggedFromRow!][draggedFromCol!] = null;
      }
      // Update the champion's position to the new hexagon
      championsGrid[row][col] = champion;
      // Clear the dragged from position
      draggedFromCol = null;
      draggedFromRow = null;
      // Clear the drop target position
      dropTargetCol = null;
      dropTargetRow = null;
    });
  }
}
