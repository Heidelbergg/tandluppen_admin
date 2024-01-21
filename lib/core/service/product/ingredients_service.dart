import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/model/ingredient.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';

class IngredientsService{

  Future<List<ToothpasteIngredient>> getAllIngredientsSorted() async {
    List<ToothpasteIngredient> ingredientsList = [];

    var toothpasteIngredientsCollection = await FirestoreConsts.firestoreToothpasteIngredients.get();

    for (var ingredient in toothpasteIngredientsCollection.docs){
      ingredientsList.add(ToothpasteIngredient.fromJson(ingredient.data()));
    }
    return ingredientsList;
  }

  Future<void> updateIngredient(ToothpasteIngredient toothpasteIngredient) async {
    await FirestoreConsts.firestoreToothpasteIngredients.doc(toothpasteIngredient.name).update(toothpasteIngredient.toJson());
  }

  Future<ToothpasteIngredient> getIngredient(ToothpasteIngredient toothpasteIngredient) async {
    var reference = await FirestoreConsts.firestoreToothpasteIngredients.doc(toothpasteIngredient.name).get();
    return ToothpasteIngredient.fromJson(reference.data()!);
  }

}