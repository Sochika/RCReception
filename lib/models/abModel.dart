
class AB {
  final int? id;
  final int gca_id;
  final String name;

  AB(
      {this.id,
        required this.gca_id,
        required this.name,

      });

  factory AB.fromJson(Map<String, dynamic> json) => AB(
      id: json['id'],
      gca_id : json['gca_id'],
      name : json['name']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'gca_id': gca_id ,
    'name ': name ,

  };


}
