import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

Widget buildHorizontalGrid() {
  return Center(
    child: Container(
      // color: Colors.green,
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
                return Text('$col, $row');
              },
            ),
          ),
        ],
      ),
    ),
  );
}
