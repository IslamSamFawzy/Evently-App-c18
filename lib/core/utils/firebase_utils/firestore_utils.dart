import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:evenrly/models/event_data.dart';

class FirestoreUtils {
  FirestoreUtils._();

  static FirebaseAuth get _auth => FirebaseAuth.instance;

  static String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }
    return user.uid;
  }

  static CollectionReference<EventData> getEventsCollection() {
    return FirebaseFirestore.instance
        .collection(EventData.collectionPath)
        .withConverter<EventData>(
      fromFirestore: (snapshot, _) {
        final data = snapshot.data();
        if (data == null) {
          throw StateError('Event document ${snapshot.id} has no data.');
        }
        return EventData.fromFirestore(data, snapshot.id);
      },
      toFirestore: (value, _) => value.toFirestore(),
    );
  }

  static Future<void> addEvent(EventData eventData) async {
    try {
      final collectionRef = getEventsCollection();
      final docRef = collectionRef.doc();

      eventData.eventID = docRef.id;
      eventData.userId = currentUserId;

      await docRef.set(eventData);
    } catch (e) {
      debugPrint('Error adding event: $e');
      rethrow;
    }
  }

  static Stream<QuerySnapshot<EventData>> getEventsStream({String? category}) {
    Query<EventData> query =
    getEventsCollection().where('user_id', isEqualTo: currentUserId);

    if (category != null && category.trim().isNotEmpty) {
      query = query.where('event_category', isEqualTo: category);
    }

    return query.orderBy('event_date').snapshots();
  }

  static Future<List<EventData>> getEventsPaginated({
    int limit = 10,
    DocumentSnapshot<EventData>? lastDoc,
    String? category,
  }) async {
    try {
      Query<EventData> query =
      getEventsCollection().where('user_id', isEqualTo: currentUserId);

      if (category != null && category.trim().isNotEmpty) {
        query = query.where('event_category', isEqualTo: category);
      }

      query = query.orderBy('event_date').limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      debugPrint('Pagination error: $e');
      rethrow;
    }
  }

  static Future<void> updateEvent(EventData eventData) async {
    try {
      final docRef = getEventsCollection().doc(eventData.eventID);
      await docRef.update(eventData.toFirestore());
    } catch (e) {
      debugPrint('Update error: $e');
      rethrow;
    }
  }

  static Future<void> deleteEvent(EventData eventData) async {
    try {
      final docRef = getEventsCollection().doc(eventData.eventID);
      await docRef.delete();
    } catch (e) {
      debugPrint('Delete error: $e');
      rethrow;
    }
  }

  static CollectionReference<EventData> getFavouriteCollection() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('favourites')
        .withConverter<EventData>(
      fromFirestore: (snapshot, _) {
        final data = snapshot.data();
        if (data == null) {
          throw StateError(
            'Favourite document ${snapshot.id} has no data.',
          );
        }
        return EventData.fromFirestore(data, snapshot.id);
      },
      toFirestore: (value, _) => value.toFirestore(),
    );
  }

  static Future<void> addToFavourite(EventData eventData) async {
    try {
      final docRef = getFavouriteCollection().doc(eventData.eventID);
      await docRef.set(eventData);
    } catch (e) {
      debugPrint('Add to favourite error: $e');
      rethrow;
    }
  }

  static Future<void> removeFromFavourite(String eventId) async {
    try {
      final docRef = getFavouriteCollection().doc(eventId);
      await docRef.delete();
    } catch (e) {
      debugPrint('Remove favourite error: $e');
      rethrow;
    }
  }

  static Stream<QuerySnapshot<EventData>> getFavouriteStream() {
    return getFavouriteCollection().snapshots();
  }

  static Future<bool> isFavourite(String eventId) async {
    try {
      final doc = await getFavouriteCollection().doc(eventId).get();
      return doc.exists;
    } catch (e) {
      debugPrint('Check favourite error: $e');
      return false;
    }
  }

  static Future<void> toggleFavourite(EventData eventData) async {
    try {
      final docRef = getFavouriteCollection().doc(eventData.eventID);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.delete();
      } else {
        await docRef.set(eventData);
      }
    } catch (e) {
      debugPrint('Toggle favourite error: $e');
      rethrow;
    }
  }

  static Stream<Set<String>> getFavouriteIdsStream() {
    return getFavouriteCollection().snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toSet(),
    );
  }


  static Stream<EventData> getEventById(String id) {
    return FirebaseFirestore.instance
        .collection(EventData.collectionPath)
        .doc(id)
        .snapshots()
        .map((doc) => EventData.fromFirestore(doc.data()!, doc.id));
  }
}