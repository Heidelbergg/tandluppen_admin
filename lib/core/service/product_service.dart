import 'package:flutter/src/widgets/editable_text.dart';
import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';
import 'package:tandluppen_web/core/service/product_image_service.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Future<void> storeProductToFirestore(
      ToothpasteProduct toothpasteProduct) async {
    FirestoreConsts.firestoreToothpasteCollection
        .doc()
        .set(toothpasteProduct.toJson());
  }

  Future<List<ToothpasteProduct>> getToothpasteProductList() async {
    List<ToothpasteProduct> list = [];
    var collection = await FirestoreConsts.firestoreToothpasteCollection.get();
    for (var product in collection.docs) {
      list.add(ToothpasteProduct.fromJson(product.data()));

      /// Parse ingredients to list in firebase after import
      /*String ingredients = product.data()['ingredients'];
      List ingredientsList = ingredients.split(",");
      FirestoreConsts.firestoreToothpasteCollection.doc(product.id).update({
        'ingredients': ingredientsList
      });*/

      /// Insert uuid for each product
      /*var uuid = const Uuid().v4();
      FirestoreConsts.firestoreToothpasteCollection.doc(product.id).update({'id':uuid});*/
    }
    return list;
  }

  Future<ToothpasteProduct?> findToothpasteProduct(String productId) async {
    var collection = await FirestoreConsts.firestoreToothpasteCollection.get();
    for (var doc in collection.docs) {
      if (doc.data()['id'] == productId) {
        return ToothpasteProduct.fromJson(doc.data());
      }
    }
    return null;
  }

  Future<ToothpasteProduct?> populateTextFields(
      String productId,
      TextEditingController brandController,
      TextEditingController manufacturerController,
      TextEditingController linkController,
      TextEditingController descriptionController,
      TextEditingController flourContentController,
      TextEditingController rdaController,
      TextEditingController effectController,
      TextEditingController resultController,
      TextEditingController ingredientsController,
      TextEditingController countryCodeController) async {
    ToothpasteProduct? toothpasteProduct =
        await findToothpasteProduct(productId);

    if (toothpasteProduct != null) {
      brandController.text = toothpasteProduct.brand;
      manufacturerController.text = toothpasteProduct.manufacturer;
      linkController.text = toothpasteProduct.link;
      descriptionController.text = toothpasteProduct.description;
      flourContentController.text = toothpasteProduct.flouride.toString();
      rdaController.text = toothpasteProduct.rda;
      effectController.text = toothpasteProduct.effect;
      resultController.text = toothpasteProduct.effectDuration;
      countryCodeController.text = toothpasteProduct.countryCode;

      List<dynamic> ingredients = toothpasteProduct.ingredients;
      String formattedIngredients = ingredients.map((ingredient) => ingredient.trim()).join(',');
      ingredientsController.text = formattedIngredients;

      return toothpasteProduct;
    }
    return null;
  }

  Future<void> updateFirestoreProduct(
      ToothpasteProduct toothpasteProduct) async {
    var collection = await FirestoreConsts.firestoreToothpasteCollection.get();
    for (var doc in collection.docs) {
      if (doc.data()['id'] == toothpasteProduct.id) {
        await FirestoreConsts.firestoreToothpasteCollection
            .doc(doc.id)
            .update(toothpasteProduct.toJson());
      }
    }
  }

  Future<void> deleteFirestoreProduct(
      ToothpasteProduct toothpasteProduct, String? savedImage) async {
    var collection = await FirestoreConsts.firestoreToothpasteCollection.get();
    for (var doc in collection.docs) {
      if (doc.data()['id'] == toothpasteProduct.id) {
        await FirestoreConsts.firestoreToothpasteCollection
            .doc(doc.id)
            .delete();
      }
    }
    if (savedImage != null) {
      await ProductImageService().deletePicture(toothpasteProduct.id);
    }
  }
}
