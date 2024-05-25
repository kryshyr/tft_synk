import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import './detailed_view.dart';
import './firestore/firebase_service.dart';
import './utils/device_id.dart';
import 'app_constants.dart';

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
            color: AppColors.primaryVariant,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: AppColors.primaryAccent, width: 2),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Color.fromRGBO(200, 155, 60, 1),
            height: 1.0,
          ),
        ),
        title: Row(
          children: [
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('MY COMPS',
                  style: AppTextStyles.headline1BeaufortforLOL),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: titles.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                child: VerticalCardPager(
                  textStyle: const TextStyle(
                    color: AppColors.primaryText,
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
