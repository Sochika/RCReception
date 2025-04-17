class Colombe {
  final int? id;
  final String firstName,
      middleName,
      lastName,
      keyNum,
      dob,
      office,
      gender;
  final int ab,
      gca;

  Colombe(
      {this.id,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.keyNum,
      required this.dob,
        required this.ab,
        required this.gca,
        required this.office,
        required this.gender
         });
  // int abID = int.parse(ab?);
  // int gcaID = int.parse(gca);
  // int tmoID = int.parse(tmoController.text);

  factory Colombe.fromJson(Map<String, dynamic> json) => Colombe(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'],
      keyNum: json['keyNum'].toString(),
      dob: json['dob'] ?? '',
    ab: json['ab_id'] ?? 0,
    gca: json['gca_id'] ?? 0,
      office: json['office'] ?? '',
      gender: json['gender'] ?? '',
    );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'middleName': middleName,
    'lastName': lastName,
    'keyNum': keyNum,
    'dob': dob,
    'ab_id': ab,
    'gca_id': gca,
    'office' : office,
    'gender' : gender,

  };

  
}
