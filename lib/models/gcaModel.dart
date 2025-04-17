
class GCA {
  final int? id;
  final String name;


  GCA(
      {this.id,
        required this.name ,
      });

  factory GCA.fromJson(Map<String, dynamic> json) => GCA(
      id: json['id'],
      name : json['name']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,

  };

// int save() {
//   return 1;
// }
}
