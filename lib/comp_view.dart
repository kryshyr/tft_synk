import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import './detailed_view.dart';
import './firestore/firebase_service.dart';
import './utils/device_id.dart';

class CompViewTab extends StatefulWidget {
  @override
  _CompViewTabState createState() => _CompViewTabState();
}

class _CompViewTabState extends State<CompViewTab> {
  final FirebaseService _firebaseService = FirebaseService();
  List<String> titles = [];
  List<Widget> images = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamComps();
  }

  Future<void> _fetchTeamComps() async {
    String deviceId = await getDeviceID();
    CollectionReference compositionsRef = _firebaseService.firestore
        .collection('team_comps')
        .doc(deviceId)
        .collection('compositions');

    QuerySnapshot snapshot = await compositionsRef.get();

    setState(() {
      titles = snapshot.docs.map((doc) => doc.id).toList();
      images = List<Widget>.generate(
        snapshot.docs.length,
        (index) => Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'MY COMPS',
                style: const TextStyle(
                    fontSize: 16, color: Color.fromRGBO(200, 155, 60, 1)),
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
      body: SafeArea(
        child: titles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: VerticalCardPager(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  titles: titles,
                  images: images,
                  onPageChanged: (page) {},
                  align: ALIGN.CENTER,
                  onSelectedItem: (index) {
                    print("Selected: ${titles[index]}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailedViewPage(title: titles[index]),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
