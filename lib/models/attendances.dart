

class Attendances {
  final int? id;
  final String keyNum;
  final String gender;
  final int eventID;


  Attendances(
      {this.id,
        required this.keyNum ,
        required this.gender,
        required this.eventID,

      });

  factory Attendances.fromJson(Map<String, dynamic> json) => Attendances(
      id: json['id'],
      keyNum : json['keyNum'],
      gender  : json['gender'],
      eventID : json['events_id'] ?? 0);

  Map<String, dynamic> toJson() => {
    'id': id,
    'keyNum': keyNum ,
    'gender': gender,
    'events_id': eventID,
    };

// int save() {
//   return 1;
// }
}
