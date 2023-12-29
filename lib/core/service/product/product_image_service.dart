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

 /* Future<Uint8List?> getImageUrl(String productId) async {
    final ref = FirebaseStorage.instance.ref('toothpasteImages/$productId');

    try {
      final data = await ref.getData();

      if (data != null) {
        img.Image? decodedImage = img.decodeImage(data);

        if (decodedImage != null) {
          Uint8List pngBytes = Uint8List.fromList(img.encodePng(decodedImage));

          return pngBytes;
        }
      }
    } catch (e) {
      print('Error fetching or converting image: $e');
    }

    return null;
  }*/

  Future deletePicture(String productId) async {
    await FirebaseStorage.instance.ref().child('toothpasteImages/$productId').delete();
  }

}