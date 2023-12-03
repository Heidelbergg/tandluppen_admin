class ValidatorUtil{
  String? validateName(String? name){
    if (name == null || name.isEmpty || name == ""){
      return "Indsæt gyldig tekst";
    }
  }
}