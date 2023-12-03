import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class ProductImageService{

  Future storeProductImageToStorage(Uint8List? image, String productId) async {
    UploadTask uploadTask;

    final path = 'toothpasteImages/$productId';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putData(image!);

    await uploadTask.whenComplete(() {
      print("Image uploaded");
    });
  }

  Future<String?> getImageUrl(String productId) async {
    final ref = FirebaseStorage.instance.ref('toothpasteImages/$productId');
    return await ref.getDownloadURL();
  }

  Future deletePicture(String productId) async {
    await FirebaseStorage.instance.ref().child('toothpasteImages/$productId').delete();
  }

}