import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:tandluppen_web/core/model/toothpaste_guide.dart';

import '../../../core/service/toothpaste_guide/guide_image_service.dart';
import '../../../core/service/toothpaste_guide/guide_service.dart';
import '../../../core/util/validator/validator.dart';
import '../../styles/button_style.dart';
import '../../styles/text_styles.dart';
import '../../styles/textfield_styles.dart';

class EditToothpasteGuideScreen extends StatefulWidget {
  final ToothpasteGuide toothpasteGuide;
  const EditToothpasteGuideScreen({super.key, required this.toothpasteGuide});

  @override
  State<EditToothpasteGuideScreen> createState() => _EditToothpasteGuideScreenState();
}

class _EditToothpasteGuideScreenState extends State<EditToothpasteGuideScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final ValidatorUtil _validatorUtil = ValidatorUtil();

  final ToothpasteGuideService _toothpasteGuideService = ToothpasteGuideService();
  final GuideImageService _guideImageService = GuideImageService();

  Uint8List? _image;
  String? _savedImage;
  bool _hasImage = false;

  @override
  void initState() {
    _getGuide();
    super.initState();
  }

  _getGuide() async {
    ToothpasteGuide? toothpasteGuide = await _toothpasteGuideService.getGuide(widget.toothpasteGuide.id);
    String? image = await _guideImageService.getImageUrl(widget.toothpasteGuide.id);

    setState(() {
      if (toothpasteGuide != null){
        titleController.text = toothpasteGuide.title;
        contentController.text = toothpasteGuide.content;
      }
      if (image != null){
        _savedImage = image;
        _hasImage = true;
      }
    });
  }

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
        title: Text("Rediger guide", style: whiteHeaderTextStyle),
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
            const SizedBox(height: 10,),
            _hasImage
                ? SizedBox(
              height: 250,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _image = null;
                    _hasImage = false;
                    _savedImage = null;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _savedImage != null
                          ? Image.network(_savedImage!)
                          : Image.memory(_image!),
                    ),
                    Positioned(
                      top: 30,
                      right: 2.5,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                            _savedImage = null;
                            _hasImage = false;
                          });
                        },
                        icon: const Icon(Icons.delete_forever_outlined,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                  onTap: getImage,
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.withOpacity(0.1)),
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
            child: const Text('Gem redigering', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),),
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

    ToothpasteGuide toothpasteGuide = ToothpasteGuide(id: widget.toothpasteGuide.id, title: title, content: content, order: widget.toothpasteGuide.order);

    await _toothpasteGuideService.updateGuide(toothpasteGuide);
    if (_image != null) {
      await _guideImageService.storeGuideImageToStorage(_image, widget.toothpasteGuide.id);
    }
    Navigator.pop(context);
    Navigator.pop(context, toothpasteGuide.id);
  }
}
