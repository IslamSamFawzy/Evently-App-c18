import 'package:flutter/material.dart';

class EventData {
  static const String collectionPath = 'events_collection';

  String? eventID;
  String? userId;
  int? notificationId;
  final String eventTitle;
  final String eventDescription;
  final DateTime eventDate;
  final TimeOfDay eventTime;
  final bool isFavourite;
  final String eventCategory;
  final String eventCategoryImage;

  EventData({
    this.eventID,
    this.userId,
    this.notificationId,
    required this.eventTitle,
    required this.eventDescription,
    required this.eventDate,
    required this.eventTime,
    this.isFavourite = false,
    required this.eventCategory,
    required this.eventCategoryImage,
  });

  factory EventData.fromFirestore(Map<String, dynamic> json, String id) {
    final int totalMinutes = (json['event_time'] as int?) ?? 0;

    return EventData(
      eventID: id,
      userId: json['user_id'] as String?,
      notificationId: json['notification_id'] as int?,
      eventTitle: (json['event_title'] as String?) ?? '',
      eventDescription: (json['event_description'] as String?) ?? '',
      eventDate: DateTime.fromMillisecondsSinceEpoch(
        (json['event_date'] as int?) ?? 0,
      ),
      eventTime: TimeOfDay(
        hour: totalMinutes ~/ 60,
        minute: totalMinutes % 60,
      ),
      eventCategory: (json['event_category'] as String?) ?? '',
      eventCategoryImage: (json['event_category_image'] as String?) ?? '',
      isFavourite: (json['is_favourite'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'event_id': eventID,
      'notification_id': notificationId,
      'event_title': eventTitle,
      'event_description': eventDescription,
      'event_date': eventDate.millisecondsSinceEpoch,
      'event_time': eventTime.hour * 60 + eventTime.minute,
      'is_favourite': isFavourite,
      'event_category': eventCategory,
      'event_category_image': eventCategoryImage,
    };
  }
}