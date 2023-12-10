class ToothpasteProduct {
  final String id;
  final String brand;
  final String manufacturer;
  final String link;
  final String description;
  final String flouride;
  final String rda;
  final String effectDuration;
  final String effect;
  final String countryCode;
  final List<dynamic> usage;
  final List<dynamic> ingredients;

  ToothpasteProduct(
      {required this.id,
      required this.brand,
      required this.manufacturer,
      required this.link,
      required this.description,
      required this.flouride,
      required this.usage,
      required this.rda,
      required this.effect,
      required this.effectDuration,
      required this.ingredients,
      required this.countryCode});

  factory ToothpasteProduct.fromJson(Map<String, dynamic> json) {
    return ToothpasteProduct(
      id: json['id'] ?? 'Opdateres',
      brand: json['brand'] ?? 'Opdateres',
      manufacturer: json['manufacturer'] ?? 'Opdateres',
      link: json['link'] ?? 'Opdateres',
      description: json['description'] ?? 'Opdateres',
      flouride: json['flouride'] ?? 'Opdateres',
      usage: json['usage'] ?? [],
      rda: json['rda'] ?? 'Opdateres',
      effect: json['effect'] ?? 'Opdateres',
      effectDuration: json['effect_duration'] ?? 'Opdateres',
      ingredients: json['ingredients'] ?? [],
      countryCode: json['c_code'] ?? 'Opdateres',
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
      'rda': rda,
      'effect': effect,
      'effect_duration': effectDuration,
      'ingredients': ingredients,
      'c_code': countryCode
    };
    return json;
  }

  List<String> toCSV(){
    return [
      id,
      brand,
      manufacturer,
      link,
      description,
      flouride,
      usage.toString(),
      rda,
      effectDuration,
      effect,
      countryCode,
      ...ingredients.map((ingredient) => '$ingredient'),
    ];
  }
}
