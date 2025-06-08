

class SettingsLoad {
  final int? id;
  final String userName;
  final int gcaID;
  final int abID;
  final int tts;
  final int ttsimple;




  SettingsLoad(
      {this.id,
        required this.userName ,
        required this.gcaID,
        required this.abID,
        required this.tts,
        required this.ttsimple,

      });

  factory SettingsLoad.fromJson(Map<String, dynamic> json) => SettingsLoad(
      id: json['id'],
      userName : json['userName'] ?? '',
      gcaID  : json['gca_id'],
      abID : json['ab_id'],
       tts : json['tts'],
      ttsimple: json['ttsimple'] ?? 0);

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'gca_id': gcaID,
    'ab_id': abID,
    'tts': tts,
    'ttsimple' : ttsimple
  };

// int save() {
//   return 1;
// }
}
