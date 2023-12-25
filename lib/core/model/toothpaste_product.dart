import 'package:tandluppen_web/core/model/toothpaste_product_link.dart';

class ToothpasteProduct {
  final String id;
  final String brand;
  final String manufacturer;
  final Link link;
  final String description;
  final String effectDuration;
  final String effect;
  final String countryCode;
  final int flouride;
  final int rda;
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
      link: Link.fromJson(json['link']),
      description: json['description'] ?? 'Opdateres',
      flouride: json['flouride'] ?? 0,
      usage: json['usage'] ?? [],
      rda: json['rda'] ?? 0,
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
      'link': link.toJson(),
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
      link.url,
      description,
      flouride.toString(),
      usage.toString(),
      rda.toString(),
      effectDuration,
      effect,
      countryCode,
      ...ingredients.map((ingredient) => '$ingredient'),
    ];
  }

  @override
  String toString() {
    return "$id\n$brand\n$manufacturer\n$link\n$description\n$flouride\n$usage\n$rda\n$effectDuration\n$effect\n$countryCode\n$ingredients";
  }
}
