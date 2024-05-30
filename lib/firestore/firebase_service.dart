import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore; // Add this getter

  Future<void> attemptSaveTeamComp(BuildContext context, String deviceId,
      String compName, List<Map<String, String>> championPositions) async {
    // Reference to the collection
    CollectionReference teamComps = _firestore.collection('team_comps');
    //New document ID
    DocumentReference deviceDocRef = teamComps.doc(deviceId);

    // CheckIng if the team composition name already exists in the doc
    bool compExists = await deviceDocRef
        .collection('compositions')
        .doc(compName)
        .get()
        .then((doc) => doc.exists);

    if (compExists) {
      // Debugging Purposes
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Warning',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                'Team composition name already exists. Would you like to overwrite "$compName"?',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  updateTeampComp(compName, championPositions, deviceDocRef);
                  Navigator.of(context).pop();
                  showSuccessfulSaveDialog(context);
                },
                child: Text('Overwrite'),
              ),
            ],
          );
        },
      );
    } else {
      saveTeamComp(compName, championPositions, deviceDocRef);
      showSuccessfulSaveDialog(context);
    }
  }

  Future<void> saveTeamComp(
      String compName, 
      List<Map<String, String>> championPositions, 
      DocumentReference deviceDocRef
    ) async {
    
    // Save the team composition
    await deviceDocRef.collection('compositions').doc(compName).set({
      'championPositions': championPositions,
      'timestamp': FieldValue.serverTimestamp(), // timestamp
    });
  }

  Future<void> updateTeampComp(
      String compName, 
      List<Map<String, String>> championPositions, 
      DocumentReference deviceDocRef
    ) async {
    
    // Update the team composition
    await deviceDocRef.collection('compositions').doc(compName).update({
      'championPositions': championPositions,
      'timestamp': FieldValue.serverTimestamp(), // timestamp
    });
  }

  void showSuccessfulSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Success',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Team composition saved successfully.',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}