import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tft_synk/app_constants.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore; // Add this getter

  Future<bool> isCompExist(
      String compName, DocumentReference deviceDocRef) async {
    bool compExists = await deviceDocRef
        .collection('compositions')
        .doc(compName)
        .get()
        .then((doc) => doc.exists);

    return compExists;
  }

  Future<void> attemptDeleteTeamComp(
      BuildContext context, String deviceId, String compName) async {
    // Reference to the collection
    CollectionReference teamComps = _firestore.collection('team_comps');
    //New document ID
    DocumentReference deviceDocRef = teamComps.doc(deviceId);

    // CheckIng if the team composition name already exists in the doc
    bool compExists = await isCompExist(compName, deviceDocRef);

    if (!compExists) {
      showFirebaseDialog(context, 'Team composition does not exist.');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Would you like to delete "$compName"?',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteTeamComp(compName, deviceDocRef);
                for (int i = 0; i < 3; i++) {
                  Navigator.of(context).pop();
                }
                showFirebaseDialog(
                    context, 'Team composition deleted successfully.');
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> attemptSaveTeamComp(BuildContext context, String deviceId,
      String compName, List<Map<String, String>> championPositions) async {
    // Reference to the collection
    CollectionReference teamComps = _firestore.collection('team_comps');
    //New document ID
    DocumentReference deviceDocRef = teamComps.doc(deviceId);

    // CheckIng if the team composition name already exists in the doc
    bool compExists = await isCompExist(compName, deviceDocRef);

    if (compExists) {
      // Debugging Purposes
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.primaryVariant,
            title: const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child:
                  Text('Warning', style: AppTextStyles.headline1BeaufortforLOL),
            ),
            content: Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                  'Team composition name already exists. Would you like to overwrite "$compName"?',
                  style: AppTextStyles.bodyText6Spiegel),
            ),
            actions: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 8, 40, 48),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: AppTextStyles.headline5BeaufortforLOL,
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 8, 40, 48),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                    onPressed: () {
                      updateTeampComp(
                          compName, championPositions, deviceDocRef);
                      Navigator.of(context).pop();
                      showFirebaseDialog(
                          context, 'Team composition saved successfully.');
                    },
                    child: const Text(
                      'Overwrite',
                      style: AppTextStyles.headline5BeaufortforLOL,
                    )),
              ),
            ],
          );
        },
      );
    } else {
      saveTeamComp(compName, championPositions, deviceDocRef);
      showFirebaseDialog(context, 'Team composition saved successfully.');
    }
  }

  Future<void> saveTeamComp(
      String compName,
      List<Map<String, String>> championPositions,
      DocumentReference deviceDocRef) async {
    // Save the team composition
    await deviceDocRef.collection('compositions').doc(compName).set({
      'championPositions': championPositions,
      'timestamp': FieldValue.serverTimestamp(), // timestamp
    });
  }

  Future<void> updateTeampComp(
      String compName,
      List<Map<String, String>> championPositions,
      DocumentReference deviceDocRef) async {
    // Update the team composition
    await deviceDocRef.collection('compositions').doc(compName).update({
      'championPositions': championPositions,
      'timestamp': FieldValue.serverTimestamp(), // timestamp
    });
  }

  Future<void> deleteTeamComp(
      String compName, DocumentReference deviceDocRef) async {
    // Delete the team composition
    await deviceDocRef.collection('compositions').doc(compName).delete();
  }

  void showFirebaseDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryVariant,
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child:
                Text('Success', style: AppTextStyles.headline1BeaufortforLOL),
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(message, style: AppTextStyles.bodyText6Spiegel),
          ),
          actions: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 8, 40, 48),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK',
                    style: AppTextStyles.headline5BeaufortforLOL),
              ),
            )
          ],
        );
      },
    );
  }
}
