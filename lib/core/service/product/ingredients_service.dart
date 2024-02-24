import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/model/ingredient.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';

class IngredientsService {
  Future<List<ToothpasteIngredient>> getAllIngredientsSorted() async {
    List<ToothpasteIngredient> ingredientsList = [];

    var toothpasteIngredientsCollection =
        await FirestoreConsts.firestoreToothpasteIngredients.get();

    for (var ingredient in toothpasteIngredientsCollection.docs) {
      ingredientsList.add(ToothpasteIngredient.fromJson(ingredient.data()));
    }
    return ingredientsList;
  }

  Future<void> updateIngredient(
      ToothpasteIngredient toothpasteIngredient) async {
    await FirestoreConsts.firestoreToothpasteIngredients
        .doc(toothpasteIngredient.name)
        .update(toothpasteIngredient.toJson());
  }

  Future<ToothpasteIngredient> getIngredient(
      ToothpasteIngredient toothpasteIngredient) async {
    var reference = await FirestoreConsts.firestoreToothpasteIngredients
        .doc(toothpasteIngredient.name)
        .get();
    return ToothpasteIngredient.fromJson(reference.data()!);
  }

  Future<void> compareProductIngredientsWithDb() async {
    var toothpasteIngredientsCollection =
        await FirestoreConsts.firestoreToothpasteIngredients.get();
    var toothpasteProductsCollection =
        await FirestoreConsts.firestoreToothpasteCollection.get();

    List<ToothpasteProduct> products = toothpasteProductsCollection.docs
        .map((e) => ToothpasteProduct.fromJson(e.data()))
        .toList();
    List<ToothpasteIngredient> dbIngredients = toothpasteIngredientsCollection
        .docs
        .map((e) => ToothpasteIngredient.fromJson(e.data()))
        .toList();
    List<String> missingIngredients = [];

    for (ToothpasteProduct product in products) {
      for (String productIngredient in product.ingredients) {
        bool ingredientFound = false;
        for (ToothpasteIngredient dbIngredient in dbIngredients) {
          if (dbIngredient.name == productIngredient) {
            ingredientFound = true;
            break;
          }
        }

        if (!ingredientFound) {
          missingIngredients.add(productIngredient);
        }
      }
    }
    List<String> sortedList = missingIngredients.toSet().toList();
    debugPrint("NON-USED INGREDIENTES: $sortedList");
    //uploadMissingIngredients(sortedList);
  }

  Future<void> checkUnusedIngredientsInProducts(BuildContext context) async {
    var toothpasteIngredientsCollection =
        await FirestoreConsts.firestoreToothpasteIngredients.get();
    var toothpasteProductsCollection =
        await FirestoreConsts.firestoreToothpasteCollection.get();

    List<ToothpasteProduct> products = toothpasteProductsCollection.docs
        .map((e) => ToothpasteProduct.fromJson(e.data()))
        .toList();
    List<ToothpasteIngredient> dbIngredients = toothpasteIngredientsCollection
        .docs
        .map((e) => ToothpasteIngredient.fromJson(e.data()))
        .toList();
    List<String> missingIngredients = [];

    for (ToothpasteIngredient dbIngredient in dbIngredients) {
      for (ToothpasteProduct product in products) {
        if (!product.ingredients.contains(dbIngredient)) {
          missingIngredients.add(dbIngredient.name);
        }
      }
    }
    List<String> sortedList = missingIngredients.toSet().toList();
    _showSnackbar(context, sortedList);
    debugPrint("NON-USED INGREDIENTES: $sortedList");
    //deleteIngredients();
  }

  Future<void> uploadMissingIngredients(List<String> ingredientsList) async {
    for (var item in ingredientsList) {
      await FirestoreConsts.firestoreToothpasteIngredients
          .doc(item)
          .set({'name': item, 'description': 'Opdateres'});
    }
  }

  Future<void> deleteIngredients(
      List<ToothpasteIngredient> toothpasteList) async {
    for (ToothpasteIngredient ingredient in toothpasteList) {
      await FirestoreConsts.firestoreToothpasteIngredients
          .doc(ingredient.name)
          .delete();
    }
  }

  void _showSnackbar(BuildContext context, List<String> sortedList) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "${sortedList.length.toString()} ingredienser er registereret ikke i brug, af eksisterende produkter i databasen."),
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 10),
    ));
  }

}
