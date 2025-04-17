

class SettingsLoad {
  final int? id;
  final String userName;
  final int gcaID;
  final int abID;



  SettingsLoad(
      {this.id,
        required this.userName ,
        required this.gcaID,
        required this.abID,

      });

  factory SettingsLoad.fromJson(Map<String, dynamic> json) => SettingsLoad(
      id: json['id'],
      userName : json['userName'] ?? '',
      gcaID  : json['gca_id'],
      abID : json['ab_id']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName ,
    'gca_id': gcaID,
    'ab_id': abID,
  };

// int save() {
//   return 1;
// }
}
