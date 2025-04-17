import 'package:intl/intl.dart';

class Members {
  final int? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String keyNum;
  final String? email;
  final String? phoneNum;
  final int ab;
  final int gca;
  final String office;
  final String degree;
  final String gender;
  final int tmo;
  final int colombe;
  final String? dateOfBirth;

  Members({
    this.id,
    required this.firstName,
    this.middleName = '',
    required this.lastName,
    required this.keyNum,
    this.email,
    this.phoneNum,
    required this.ab,
    required this.gca,
    this.office = '',
    this.degree = '',
    this.tmo = 0,
    this.colombe = 0,
    required this.gender,
    this.dateOfBirth,
  }) {
    // Validate required fields
    if (firstName.isEmpty) throw ArgumentError('First name cannot be empty');
    if (lastName.isEmpty) throw ArgumentError('Last name cannot be empty');
    if (keyNum.isEmpty) throw ArgumentError('Key number cannot be empty');
    if (gender.isEmpty) throw ArgumentError('Gender cannot be empty');
  }

  factory Members.fromJson(Map<String, dynamic> json) => Members(
    id: json['id'] as int?,
    firstName: json['firstName'] as String,
    middleName: json['middleName'] as String? ?? '',
    lastName: json['lastName'] as String,
    keyNum: json['keyNum'] as String,
    email: json['email'] as String?,
    phoneNum: json['phoneNumber'] as String?,
    ab: (json['ab_id'] as int?) ?? 0,
    gca: (json['gca_id'] as int?) ?? 0,
    office: json['office'] as String? ?? '',
    degree: json['degree'] as String? ?? '',
    tmo: (json['tmo'] as int?) ?? 0,
    colombe: (json['colombe'] as int?) ?? 0,
    gender: json['gender'] as String? ?? '',
    dateOfBirth:json['dob'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'middleName': middleName,
    'lastName': lastName,
    'keyNum': keyNum,
    'email': email,
    'phoneNumber': phoneNum,
    'ab_id': ab,
    'gca_id': gca,
    'office': office,
    'degree': degree,
    'tmo': tmo,
    'colombe': colombe,
    'gender': gender,
    'dob': dateOfBirth,
  };

  // Helper getter for formatted date
  // String get formattedDateOfBirth {
  //   return dateOfBirth != null
  //       ? DateFormat('yyyy-MM-dd').format(dateOfBirth!)
  //       : '';
  // }

  // Copy with method for immutability
  Members copyWith({
    int? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? keyNum,
    String? email,
    String? phoneNum,
    int? ab,
    int? gca,
    String? office,
    String? degree,
    int? tmo,
    int? colombe,
    String? gender,
    String? dateOfBirth,
  }) {
    return Members(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      keyNum: keyNum ?? this.keyNum,
      email: email ?? this.email,
      phoneNum: phoneNum ?? this.phoneNum,
      ab: ab ?? this.ab,
      gca: gca ?? this.gca,
      office: office ?? this.office,
      degree: degree ?? this.degree,
      tmo: tmo ?? this.tmo,
      colombe: colombe ?? this.colombe,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}