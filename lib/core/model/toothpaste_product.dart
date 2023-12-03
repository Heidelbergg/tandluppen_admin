class ToothpasteProduct {
  final String id;
  final String brand;
  final String manufacturer;
  final String link;
  final String description;
  final String flouride;
  final String usage;
  final bool sls;
  final String rda;
  final String effectDuration;
  final String effect;
  final String countryCode;
  final List<dynamic> ingredients;

  ToothpasteProduct(
      {required this.id,
      required this.brand,
      required this.manufacturer,
      required this.link,
      required this.description,
      required this.flouride,
      required this.usage,
      required this.sls,
      required this.rda,
      required this.effect,
      required this.effectDuration,
      required this.ingredients,
      required this.countryCode});

  factory ToothpasteProduct.fromJson(Map<String, dynamic> json) {
    return ToothpasteProduct(
      id: json['id'] ?? 'opdateres',
      brand: json['brand'] ?? 'opdateres',
      manufacturer: json['manufacturer'] ?? 'opdateres',
      link: json['link'] ?? 'opdateres',
      description: json['description'] ?? 'opdateres',
      flouride: json['flouride'] ?? 'opdateres',
      usage: json['usage'] ?? 'opdateres',
      sls: json['sls'] == "JA",
      rda: json['rda'] ?? 'opdateres',
      effect: json['effect'] ?? 'opdateres',
      effectDuration: json['effect_duration'] ?? 'opdateres',
      ingredients: json['ingredients'] ?? [],
      countryCode: json['c_code'] ?? 'opdateres',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'brand': brand,
      'manufacturer': manufacturer,
      'link': link,
      'description': description,
      'flouride': flouride,
      'usage': usage,
      'sls': sls,
      'rda': rda,
      'effect': effect,
      'effect_duration': effectDuration,
      'ingredients': ingredients,
      'c_code': countryCode
    };
    return json;
  }
}
