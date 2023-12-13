import 'package:validators/validators.dart';

class ValidatorUtil{
  String? validateName(String? name){
    if (name == null || name.isEmpty || name == ""){
      return "Indsæt gyldig tekst";
    }
  }

  String? validateUsageItems(List<dynamic>? items){
    if (items!.isEmpty){
      return "Vælg mindst én værdi fra listen";
    }
  }

  String? validateNumber(String? number){
    if (!isNumeric(number!)|| int.parse(number).isNegative || number.isEmpty || number == ""){
      return "Indsæt gyldigt tal";
    }
  }
}