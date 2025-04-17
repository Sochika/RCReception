class EventTypes {
  final int? id;
  final String name;

  EventTypes(
      {this.id,
        required this.name,

      });

  factory EventTypes.fromJson(Map<String, dynamic> json) => EventTypes(
      id: json['id'],
      name: json['name']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,

  };

// int save() {
//   return 1;
// }
}
