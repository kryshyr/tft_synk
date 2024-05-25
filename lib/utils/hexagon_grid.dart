import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:tft_synk/home.dart' show HexagonGridController;

import 'champion.dart';

typedef ChampionDroppedCallback = void Function(
    int? dropTargetRow,
    int? dropTargetCol,
    int? draggedFromRow,
    int? draggedFromCol,
    Champion champion);

typedef ChampionRemovedCallback = void Function(
    int? row, int? col, Champion champion);

class HexagonGrid extends StatefulWidget {
  final ChampionDroppedCallback onChampionDropped;
  final ChampionRemovedCallback onChampionRemoved;
  final HexagonGridController controller;

  const HexagonGrid(
      {Key? key,
      required this.onChampionDropped,
      required this.onChampionRemoved,
      required this.controller})
      : super(key: key);

  // Global key for accessing the state of HexagonGrid
  static final GlobalKey<_HexagonGridState> hexagonGridKey =
      GlobalKey<_HexagonGridState>();

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
                  Widget? dragTargetChild;

                  if (champion != null) {
                    // If a champion has been dropped
                    dragTargetChild = LongPressDraggable<Champion>(
                      delay: const Duration(milliseconds: 20),
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
                          if (draggedFromRow != null &&
                              draggedFromCol != null) {
                            Champion? championToRemove =
                                championsGrid[draggedFromRow!][draggedFromCol!];
                            championsGrid[draggedFromRow!][draggedFromCol!] =
                                null;

                            if (championToRemove != null) {
                              widget.onChampionRemoved(
                                  draggedFromRow,
                                  draggedFromCol,
                                  championToRemove); // Remove from list if destination is not valid
                            }
                          }
                          draggedFromCol = null;
                          draggedFromRow = null;
                        });
                      },
                      onDragCompleted: () {
                        // Clear the dragged image from the screen
                        setState(() {
                          draggedFromCol = null;
                          draggedFromRow = null;
                          dropTargetCol = null;
                          dropTargetRow = null;
                        });
                      },
                      child: Image.asset(
                        'assets/champions/${champion.image}',
                      ),
                    );
                  }
                  // If no champion has been dropped yet
                  return DragTarget<Champion>(
                    builder: (context, candidateData, rejectedData) {
                      return dragTargetChild ?? Container();
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
                      updateChampion(dropTargetRow, dropTargetCol,
                          draggedFromRow, draggedFromCol, champion);
                    },
                    onLeave: (_) {
                      // Clear the drop target position when the champion is dragged away
                      setState(() {
                        dropTargetCol = null;
                        dropTargetRow = null;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateChampion(int? dropTargetRow, int? dropTargetCol,
      int? draggedFromRow, int? draggedFromCol, Champion champion) {
    // Notify the parent widget (HomeTab) about the dropped champion
    widget.onChampionDropped(
        dropTargetRow, dropTargetCol, draggedFromRow, draggedFromCol, champion);

    setState(() {
      bool isDraggedFromHexagon =
          (draggedFromCol != null && draggedFromRow != null);

      // Store the champion from the target hexagon
      final championInTargetHexagon =
          championsGrid[dropTargetRow!][dropTargetCol!];

      // Update the champion's position to the target hexagon
      placeChampion(dropTargetRow!, dropTargetCol!, champion);

      // If there was a champion in the target hexagon and new champion not from hexagon, move it to the source hexagon
      if ((championInTargetHexagon != null) && isDraggedFromHexagon) {
        placeChampion(
            draggedFromRow!, draggedFromCol!, championInTargetHexagon);
      } else {
        // If there was no champion in the target hexagon, clear the source hexagon
        if (draggedFromRow != null && draggedFromCol != null) {
          championsGrid[draggedFromRow!][draggedFromCol!] = null;
        }
      }

      // Reset drag positions
      draggedFromCol = null;
      draggedFromRow = null;
      dropTargetCol = null;
      dropTargetRow = null;
    });
  }

  // Places a champion on a specific hexagon
  void placeChampion(
      int? dropTargetRow, int? dropTargetCol, Champion champion) {
    setState(() {
      championsGrid[dropTargetRow!][dropTargetCol!] = champion;
    });
  }

  // Method to clear the championsGrid list
  void resetChampionsGrid() {
    setState(() {
      // Clear the champions grid
      championsGrid = List.generate(
        4,
        (row) => List.generate(
          7,
          (col) => null,
        ),
      );

      // Reset position variables
      draggedFromCol = null;
      draggedFromRow = null;
      dropTargetCol = null;
      dropTargetRow = null;
    });
  }
}
