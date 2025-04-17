import 'package:attendance/models/MembersRecords.dart';
import 'package:attendance/models/colombe.dart';

class AttendancesRecords {
  final int? id;
  final String keyNum;
  final String firstName;
  final String lastName;
  final String gender;
  final int? colombeID;
  final int eventID;
  final Colombe? colombe;
  final Members? members;

  AttendancesRecords({
    this.id,
    required this.keyNum,
    required this.gender,
    required this.eventID,
    required this.firstName,
    required this.lastName,
    this.colombeID,
    this.colombe,
    this.members,
  });

  factory AttendancesRecords.fromJson(Map<String, dynamic> json) => AttendancesRecords(
    id: json['id'],
    keyNum: json['keyNum'] ?? '', // Added fallback for null keyNum
    gender: json['gender'] ?? 'Female', // Added default gender
    eventID: json['events_id'] ?? 0,
    firstName: json['first_name'] ?? '',
    lastName: json['last_name'] ?? '',
    colombeID: json['colombeID'],
    colombe: json['colombe'] != null
        ? Colombe.fromJson(json['colombe'])
        : null,
    members: json['members'] != null
        ? Members.fromJson(json['members'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'keyNum': keyNum,
    'gender': gender,
    'events_id': eventID,
    'first_name': firstName,
    'last_name': lastName,
    'colombeID': colombeID,
    if (colombe != null) 'colombe': colombe!.toJson(),
    if (members != null) 'members': members!.toJson(),
  };

  // Add a copyWith method for immutability patterns
  AttendancesRecords copyWith({
    int? id,
    String? keyNum,
    String? firstName,
    String? lastName,
    String? gender,
    int? eventID,
    int? colombeID,
    Colombe? colombe,
    Members? members,
  }) {
    return AttendancesRecords(
      id: id ?? this.id,
      keyNum: keyNum ?? this.keyNum,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      eventID: eventID ?? this.eventID,
      colombeID: colombeID ?? this.colombeID,
      colombe: colombe ?? this.colombe,
      members: members ?? this.members,
    );
  }

  // Add toString() for debugging
  @override
  String toString() {
    return 'Attendances(id: $id, keyNum: $keyNum, name: $firstName $lastName, eventID: $eventID)';
  }

  // Add equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttendancesRecords &&
        other.id == id &&
        other.keyNum == keyNum &&
        other.eventID == eventID;
  }

  @override
  int get hashCode => id.hashCode ^ keyNum.hashCode ^ eventID.hashCode;
}