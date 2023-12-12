class ValidatorUtil{
  String? validateName(String? name){
    if (name == null || name.isEmpty || name == ""){
      return "Indsæt gyldig tekst";
    }
  }

  String? validateUsageItems(List<String>? items){
    if (items!.isEmpty){
      return "Vælg mindst én værdi fra listen";
    }
  }
}