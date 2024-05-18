import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  //get collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('note');

  //create
  Future<void> insertNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //read
  Stream<QuerySnapshot> getNotes() {
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();
    return noteStream;
  }
}
