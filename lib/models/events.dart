
class EventsDetails {
  late int? id;
  final String speaker;
  final int event_typeID;
  final String time,
      date;

  EventsDetails(
      {this.id,
      required this.speaker,
      required this.event_typeID,
      required this.time,
      required this.date,
     });

  factory EventsDetails.fromJson(Map<String, dynamic> json) => EventsDetails(
      id: json['id'],
      speaker: json['speaker'],
      event_typeID: json['event_types_id'],
      time: json['time'],
      date: json['date']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'speaker': speaker,
    'event_types_id': event_typeID,
    'time': time,
    'date': date,
  };

  // int save() {
  //   return 1;
  // }
}
