import 'package:attendance/constants.dart';
import 'package:flutter/material.dart';
import 'package:attendance/models/events.dart';

import 'package:attendance/data/sqlite.dart';
// import 'file_info_card.dart';

class CloudStorageInfo {
  final String? svgSrc, title, date, time;
  final int? numOfMembers, percentage;
  final Color? color;
  final EventsDetails? eventDetail;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.date,
    this.time,
    this.numOfMembers,
    this.percentage,
    this.color,
    this.eventDetail,
  });
}

Future<List<CloudStorageInfo>> fetchEventInfo() async {
  final db = DatabaseHelper();
  List<EventsDetails> fetchedEvents = await db.getEvents();

  return fetchedEvents.map((event) => CloudStorageInfo(
    title: eventCats[event.event_typeID],
    numOfMembers: 0,
    svgSrc: "assets/icons/Documents.svg",
    date: event.date,
    time: event.time,
    color: primaryColor,
    percentage: 50,
    eventDetail: event
  )).toList();
}

Future<List<CloudStorageInfo>> events = fetchEventInfo();