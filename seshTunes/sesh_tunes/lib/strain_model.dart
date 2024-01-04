class Strain {
  final String name;
  final String imgUrl;
  final String type;
  final String thcLevel;
  final String mostCommonTerpene;
  final String description;
  final Map<String, String> effects;

  Strain({
    required this.name,
    required this.imgUrl,
    required this.type,
    required this.thcLevel,
    required this.mostCommonTerpene,
    required this.description,
    required this.effects,
  });

  factory Strain.fromJson(Map<String, dynamic> json) {
    return Strain(
      name: json['name'],
      imgUrl: json['img_url'],
      type: json['type'],
      thcLevel: json['thc_level'],
      mostCommonTerpene: json['most_common_terpene'],
      description: json['description'],
      effects: Map<String, String>.from(json['effects']),
    );
  }
}
