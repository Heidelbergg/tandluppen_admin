import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/model/ingredient.dart';
import 'package:tandluppen_web/core/service/product/ingredients_service.dart';

import '../../../core/util/validator/validator.dart';
import '../styles/button_style.dart';
import '../styles/text_styles.dart';
import '../styles/textfield_styles.dart';

class EditIngredientScreen extends StatefulWidget {
  final ToothpasteIngredient toothpasteIngredient;
  const EditIngredientScreen({super.key, required this.toothpasteIngredient});

  @override
  State<EditIngredientScreen> createState() => _EditToothpasteGuideScreenState();
}

class _EditToothpasteGuideScreenState extends State<EditIngredientScreen> {

  TextEditingController descriptionCtr = TextEditingController();

  final IngredientsService _ingredientsService = IngredientsService();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final ValidatorUtil _validatorUtil = ValidatorUtil();

  @override
  void initState() {
    _getIngredient();
    super.initState();
  }

  void _getIngredient() async {
    ToothpasteIngredient toothpasteIngredient = await _ingredientsService.getIngredient(widget.toothpasteIngredient);
    setState(() {
      descriptionCtr.text = toothpasteIngredient.description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.15),
      appBar: AppBar(
        title: Text(widget.toothpasteIngredient.name, style: whiteHeaderTextStyle),
        elevation: 3,
        backgroundColor: const Color(0xFFFF6624),
        leading: const BackButton(color: Colors.white,),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(left: 150, right: 150),
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
            Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.all(8), child: Text("Ingrediens indhold", style: largeBlackTextStyle,),)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: descriptionCtr,
                decoration: textFieldInputDecoration("Beskrivelse"),
                validator: _validatorUtil.validateName,
                maxLines: 10,
              ),
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
                    descriptionCtr.text
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

  void _submitForm(String description,) async {

    showDialog(context: context, builder: (BuildContext context){
      return const AlertDialog(
        content: LinearProgressIndicator(),
      );
    });

    ToothpasteIngredient toothpasteIngredient = ToothpasteIngredient(name: widget.toothpasteIngredient.name, description: description);

    await _ingredientsService.updateIngredient(toothpasteIngredient);
    Navigator.pop(context);
    Navigator.pop(context, toothpasteIngredient.name);
  }
}
