import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/model/ingredient.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';

class IngredientsService {
  Future<List<ToothpasteIngredient>> getAllIngredientsSorted(BuildContext context) async {
    List<ToothpasteIngredient> ingredientsList = [];
    _compareProductIngredientsWithDb(context);
    List<ToothpasteIngredient> unusedIngredients = await _checkUnusedIngredientsInProducts(context);

    var toothpasteIngredientsCollection = await FirestoreConsts.firestoreToothpasteIngredients.get();

    for (var ingredient in toothpasteIngredientsCollection.docs) {
      ingredientsList.add(ToothpasteIngredient.fromJson(ingredient.data()));
    }

    ingredientsList.removeWhere((ingredient1) => unusedIngredients.any((ingredient2) => ingredient1.name == ingredient2.name));
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

  Future<void> _compareProductIngredientsWithDb(BuildContext context) async {
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
    List<ToothpasteIngredient> missingIngredients = [];

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
          ToothpasteIngredient ingredient = ToothpasteIngredient(name: productIngredient, description: "Opdateres");
          missingIngredients.add(ingredient);
        }
      }
    }
    List<ToothpasteIngredient> sortedList = missingIngredients.toSet().toList();
    _showSnackbar(context, sortedList, "nye ingredienser er registreret, og gemt i oversigten.");
    uploadMissingIngredients(sortedList);
  }

  Future<List<ToothpasteIngredient>> _checkUnusedIngredientsInProducts(BuildContext context) async {
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
    List<ToothpasteIngredient> missingIngredients = [];

    for (ToothpasteIngredient dbIngredient in dbIngredients) {
      if (products.every((product) => !product.ingredients.contains(dbIngredient.name))) {
        missingIngredients.add(dbIngredient);
      }
    }

    List<ToothpasteIngredient> sortedList = missingIngredients.toSet().toList();
    _showSnackbar(context, sortedList, "ingredienser i databasen er registereret ikke i brug af de eksisterende produkter. Ingredienserne er nu fjernet.");
    await  _deleteIngredients(sortedList);
    return sortedList;
  }

  Future<void> uploadMissingIngredients(List<ToothpasteIngredient> ingredientsList) async {
    for (var item in ingredientsList) {
      await FirestoreConsts.firestoreToothpasteIngredients
          .doc(item.name.replaceAll("/", ""))
          .set(item.toJson());
    }
  }

  Future<void> _deleteIngredients(
      List<ToothpasteIngredient> toothpasteList) async {
    for (ToothpasteIngredient ingredient in toothpasteList) {
      await FirestoreConsts.firestoreToothpasteIngredients
          .doc(ingredient.name)
          .delete();
    }
  }

  void _showSnackbar(BuildContext context, List<ToothpasteIngredient> sortedList, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "${sortedList.length.toString()} $text"),
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 5),
    ));
  }

}
