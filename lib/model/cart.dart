class cardModel {
  final int id;
  final String name;
  final String type;
  final String desc;
  final String race;
  final String url;
  final int? level;
  final String? attribute;

  cardModel({
    required this.id,
    required this.name,
    required this.type,
    required this.desc,
    required this.race,
    required this.url,
    this.level,
    this.attribute,
  });

  factory cardModel.fromJson(Map<String, dynamic> json) {
    return cardModel(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        desc: json['desc'],
        race: json['race'],
        url: json['card_images'][0]['image_url'],
        attribute: json['attribute'],
        level: json['level']);
  }
}
