import 'package:tandluppen_web/core/model/toothpaste_guide.dart';

import '../../const/firestore_consts.dart';

class ToothpasteGuideService{

  Future<void> deleteGuide(ToothpasteGuide toothpasteGuide) async {
    var collection = await FirestoreConsts.firestoreGuidesCollection.where('id', isEqualTo: toothpasteGuide.id).get();
    for (var doc in collection.docs) {
      if (doc.data()['id'] == toothpasteGuide.id) {
        await FirestoreConsts.firestoreGuidesCollection
            .doc(doc.id)
            .delete();
      }
    }
  }

  Future<void> storeGuide(ToothpasteGuide toothpasteGuide) async {
    FirestoreConsts.firestoreGuidesCollection
        .doc(toothpasteGuide.id)
        .set(toothpasteGuide.toJson());
  }

  Future<void> updateGuide(ToothpasteGuide toothpasteGuide) async {
    var collection = await FirestoreConsts.firestoreGuidesCollection.where('id', isEqualTo: toothpasteGuide.id).get();
    for (var doc in collection.docs) {
      if (doc.data()['id'] == toothpasteGuide.id) {
        await FirestoreConsts.firestoreGuidesCollection
            .doc(doc.id)
            .update(toothpasteGuide.toJson());
      }
    }
  }

  Future<ToothpasteGuide?> getGuide(String guideId) async {
    var collection = await FirestoreConsts.firestoreGuidesCollection.where('id', isEqualTo: guideId).get();
    for (var doc in collection.docs) {
      if (doc.data()['id'] == guideId) {
        return ToothpasteGuide.fromJson(doc.data());
      }
    }
    return null;
  }

  Future<void> updateOrder(int newOrder, String guideId) async {
    await FirestoreConsts.firestoreGuidesCollection.doc(guideId).update({'order': newOrder});
  }

}