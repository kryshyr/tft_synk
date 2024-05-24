import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

class SynergyList extends StatelessWidget{
  const SynergyList({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Container(
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
          );
  }
}

