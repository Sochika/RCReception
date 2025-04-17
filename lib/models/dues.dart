import 'package:attendance/models/MembersRecords.dart';

class Dues {
  final int? id;
  final Members keyNum;
  final String affiliatedNum,
      affiliatedDate,
      localDues,
      glDues;

  Dues(
      {this.id,
      required this.keyNum ,
      required this.affiliatedNum,
      required this.affiliatedDate,
      required this.localDues,
      required this.glDues,
     });

  factory Dues.fromJson(Map<String, dynamic> json) => Dues(
      id: json['id'],
      keyNum : json['keyNum '],
      affiliatedNum : json['affiliatedNum'],
      affiliatedDate: json['affiliatedDate'],
      localDues: json['localDues'],
      glDues: json['glDues']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'keyNum': keyNum ,
    'affiliatedNum ': affiliatedNum ,
    'affiliatedDate': affiliatedDate,
    'localDues ': localDues ,
    'glDues ': glDues,

  };

  // int save() {
  //   return 1;
  // }
}
