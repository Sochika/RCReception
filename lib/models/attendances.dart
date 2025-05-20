import '../constants.dart';

class Attendances {
  final int? id;
  final String keyNum;
  final String gender;
  final int office;
  final int eventID;
  // final DateTime? createdAt;

  Attendances({
    this.id,
    required this.keyNum,
    required this.gender,
    required this.office,
    required this.eventID,
    // this.createdAt,
  });

  factory Attendances.fromJson(Map<String, dynamic> json) => Attendances(
    id: json['id'] as int?,
    keyNum: json['keyNum'] as String,
    gender: json['gender'] as String,
    office: (json['attendance_office'] as num?)?.toInt() ?? 0,
    eventID: (json['events_id'] as num?)?.toInt() ?? 0,

  );

  factory Attendances.fromMap(Map<String, dynamic> map) => Attendances.fromJson(map);

  Map<String, dynamic> toJson() => {
    'id': id,
    'keyNum': keyNum,
    'gender': gender,
    'attendance_office': office,
    'events_id': eventID,
    // 'created_at': createdAt?.toIso8601String(),
  };

  Map<String, dynamic> toMap() => toJson();

  // Helper to get office name from the Office map
  String get officeName => Office[office] ?? 'Member';

  // Copy with method for immutability
  Attendances copyWith({
    int? id,
    String? keyNum,
    String? gender,
    int? office,
    int? eventID,
    // DateTime? createdAt,
  }) {
    return Attendances(
      id: id ?? this.id,
      keyNum: keyNum ?? this.keyNum,
      gender: gender ?? this.gender,
      office: office ?? this.office,
      eventID: eventID ?? this.eventID,
      // createdAt: createdAt ?? this.createdAt,
    );
  }}