import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class GuideImageService{

  Future storeGuideImageToStorage(Uint8List? image, String guideId) async {
    UploadTask uploadTask;

    final path = 'toothpasteGuides/$guideId';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putData(image!);

    await uploadTask.whenComplete(() {
      print("Image uploaded");
    });
  }

  Future<String?> getImageUrl(String guideId) async {
    final ref = FirebaseStorage.instance.ref('toothpasteGuides/$guideId');
    try {
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

}