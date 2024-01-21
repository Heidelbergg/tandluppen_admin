class ToothpasteIngredient{
  final String name;
  final String description;

  ToothpasteIngredient({required this.name, required this.description});

  factory ToothpasteIngredient.fromJson(Map<String, dynamic> json){
    return ToothpasteIngredient(
        name: json['name'],
        description: json['description']
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'name' : name,
      'description': description,
    };
    return json;
  }

}