import '../constants.dart';
import 'MembersRecords.dart';
import 'attendances.dart';

class MemberAttendance {
  final Members member;
  final Attendances attendance;

  MemberAttendance({
    required this.member,
    required this.attendance,
  });

  factory MemberAttendance.fromMap(Map<String, dynamic> map) {
    try {
      return MemberAttendance(
        member: Members.fromJson(map),
        attendance: Attendances(
          id: map['attendance_id'] as int?,
          keyNum: map['keyNum'] as String,
          gender: map['gender'] as String,
          office: _parseOffice(map['attendance_office']),
          eventID: map['events_id'] as int,

        ),
      );
    } catch (e) {
      throw FormatException('Failed to parse MemberAttendance: $e');
    }
  }

  static int _parseOffice(dynamic office) {
    if (office == null) return 0;
    if (office is int) return office;
    if (office is String) return int.tryParse(office) ?? 0;
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      ...member.toJson(),
      'attendance_id': attendance.id,
      'attendance_office': attendance.office,
      'events_id': attendance.eventID,

    };
  }

  String get fullName => '${member.firstName} ${member.lastName}';

  String get officeName => Office[attendance.office] ?? 'Member';

  @override
  String toString() {
    return 'MemberAttendance($fullName - $officeName)';
  }

  MemberAttendance copyWith({
    Members? member,
    Attendances? attendance,
  }) {
    return MemberAttendance(
      member: member ?? this.member,
      attendance: attendance ?? this.attendance,
    );
  }

  static fromJson(Map<String, Object?> map) {}
}