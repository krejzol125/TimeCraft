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
    for (final e in doc.entries) {
      print('${e.key}: ${e.value.runtimeType} => ${e.value}');
    }
    await patterns(uid).doc(id).set({...doc}, SetOptions(merge: true));
  }

  Future<void> pushOverride(
    String uid,
    String overrideId,
    Map<String, dynamic> doc,
  ) async {
    for (final e in doc.entries) {
      print('${e.key}: ${e.value.runtimeType} => ${e.value}');
    }
    await overrides(uid).doc(overrideId).set({...doc}, SetOptions(merge: true));
  }
}
