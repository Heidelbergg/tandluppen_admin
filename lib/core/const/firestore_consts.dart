import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConsts{
  static final CollectionReference<Map<String, dynamic>> firestoreToothpasteCollection = FirebaseFirestore.instance.collection('tandpasta');
  static final CollectionReference<Map<String, dynamic>> firestoreGuidesCollection = FirebaseFirestore.instance.collection('guides');
  static final CollectionReference<Map<String, dynamic>> firestoreToothpasteIngredients = FirebaseFirestore.instance.collection('toothpasteIngredients');

}