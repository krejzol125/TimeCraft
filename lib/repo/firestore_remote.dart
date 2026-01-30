import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRemote {
  FirestoreRemote(this.fs);
  final FirebaseFirestore fs;

  CollectionReference<Map<String, dynamic>> patterns(String uid) =>
      fs.collection('users').doc(uid).collection('taskPatterns');

  CollectionReference<Map<String, dynamic>> overrides(String uid) =>
      fs.collection('users').doc(uid).collection('taskOverrides');

  Future<void> pushPattern(String uid, Map<String, dynamic> doc) async {
    final id = doc['id'] as String;
    await patterns(uid).doc(id).set({...doc}, SetOptions(merge: true));
  }

  Future<void> pushOverride(
    String uid,
    String overrideId,
    Map<String, dynamic> doc,
  ) async {
    await overrides(uid).doc(overrideId).set({...doc}, SetOptions(merge: true));
  }
}
