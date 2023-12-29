import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/model/toothpaste_guide.dart';
import 'package:uuid/uuid.dart';

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
            const SizedBox(height: 10,),
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
    Navigator.pop(context);
    Navigator.pop(context, uuid);
  }
}
