import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/model/toothpaste_guide.dart';
import 'package:uuid/uuid.dart';

import '../../../core/service/toothpaste_guide/guide_image_service.dart';
import '../../../core/service/toothpaste_guide/guide_service.dart';
import '../../../core/util/validator/validator.dart';
import '../../styles/button_style.dart';
import '../../styles/text_styles.dart';
import '../../styles/textfield_styles.dart';

class AddToothpasteGuideScreen extends StatefulWidget {
  const AddToothpasteGuideScreen({super.key});

  @override
  State<AddToothpasteGuideScreen> createState() => _AddToothpasteGuideScreenState();
}

class _AddToothpasteGuideScreenState extends State<AddToothpasteGuideScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final ValidatorUtil _validatorUtil = ValidatorUtil();

  Uint8List? _image;
  bool _hasImage = false;
  bool _isHovered = false;

  Future getImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    if (image != null){
      setState(() {
        _image = image;
        _hasImage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.15),
      appBar: AppBar(
        title: Text("Opret guide", style: whiteHeaderTextStyle),
        elevation: 3,
        backgroundColor: const Color(0xFFFF6624),
        leading: const BackButton(color: Colors.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(left: 150, right: 150),
        child: Form(
          key: _key,
          child: ListView(
            shrinkWrap: true,
            children: _buildForm(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildForm() {
    return [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white
        ),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.all(8), child: Text("Guide indhold", style: largeBlackTextStyle,),)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: titleController,
                decoration: textFieldInputDecoration("Titel"),
                validator: _validatorUtil.validateName,
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: contentController,
                decoration: textFieldInputDecoration("Beskrivelse"),
                validator: _validatorUtil.validateName,
                maxLines: 10,
              ),
            ),
            _hasImage ? SizedBox(
              height: 250,
              //width: 150,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _image = null;
                    _hasImage = false;
                  });
                },
                onHover: (value) {
                  setState(() {
                    _isHovered = value;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_hasImage)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(_image!),
                      ),
                    if (_isHovered && _hasImage)
                      Positioned(
                        top: 30,
                        right: 2.5,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                              _hasImage = false;
                            });
                          },
                          icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ) :
            Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                  onTap: getImage,
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.withOpacity(0.1)
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_search_rounded),
                          Text("Klik for at uploade et billede")
                        ],
                      ),
                    ),

                  )),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 40,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (_key.currentState!.validate()) {
                _submitForm(
                    titleController.text,
                    contentController.text
                );
              }
            },
            style: greenButtonStyle,
            child: const Text('Opret guide', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
    ];
  }

  void _submitForm(
      String title,
      String content,
      ) async {

    showDialog(context: context, builder: (BuildContext context){
      return const AlertDialog(
        content: LinearProgressIndicator(),
      );
    });

    var uuid = const Uuid().v4();
    var  guidesDocs = await FirestoreConsts.firestoreGuidesCollection.get();
    int currentGuidesLength = guidesDocs.size;

    ToothpasteGuide toothpasteGuide = ToothpasteGuide(id: uuid, title: title, content: content, order: currentGuidesLength + 1);

    await ToothpasteGuideService().storeGuide(toothpasteGuide);
    if (_image != null){
      await GuideImageService().storeGuideImageToStorage(_image, uuid);
    }
    Navigator.pop(context);
    Navigator.pop(context, uuid);
  }
}
