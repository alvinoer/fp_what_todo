import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference activities = FirebaseFirestore.instance.collection('activities');

  /// CREATE: Membuat aktivitas baru
  Future<void> createActivity(
     String title,
     String location,
     String description,
     String notes,
     DateTime dateTime
    ) async {
      await activities.add({
        'title': title,
        'location': location,
        'description': description,
        'notes': notes,
        'dateTime': dateTime,
        'completed': false,
        'flagged': false,
        'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// READ: Mendapatkan daftar aktivitas dalam bentuk real-time stream
  Stream<QuerySnapshot> getActivities() {
    return activities.orderBy('dateTime', descending: false).snapshots();
  }

  /// UPDATE: Memperbarui data aktivitas berdasarkan ID
  Future<void> updateActivity(
    String id,
    String title,
    String location,
    String description,
    String notes
    ) async {
    await activities.doc(id).update({
      'title': title,
      'location': location,
      'description': description,
      'notes': notes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateActivityStatus(String id, bool status) async {
    await activities.doc(id).update({
      'completed': status,
    });
  }

  Future<void> updateActivityFlag(String id, bool flag) async {
    await activities.doc(id).update({
      'flagged': flag,
    });
  }

  /// DELETE: Menghapus aktivitas berdasarkan ID
  Future<void> deleteActivity(String id) async {
    await activities.doc(id).delete();
  }
}
