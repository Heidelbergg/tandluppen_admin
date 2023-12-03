import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';
import 'package:tandluppen_web/core/service/product_image_service.dart';
import 'package:tandluppen_web/core/service/product_service.dart';
import 'package:tandluppen_web/core/util/validator/validator.dart';
import 'package:tandluppen_web/ui/home/home_screen.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController brandController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController flourContentController = TextEditingController();
  TextEditingController usageController = TextEditingController();
  TextEditingController rdaController = TextEditingController();
  TextEditingController effectController = TextEditingController();
  TextEditingController resultController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final ValidatorUtil _validatorUtil = ValidatorUtil();

  Uint8List? _image;
  late bool sls = false;

  Future getImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tilføj produkt"),
        elevation: 3,
        backgroundColor: const Color(0xFFFF6624),
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
      _image != null ? SizedBox(
          height: 150,
          width: 150,
          child: Image.memory(_image!)) : Container(),
      TextFormField(
        controller: brandController,
        decoration: InputDecoration(labelText: 'Mærke'),
        validator: _validatorUtil.validateName,
      ),
      TextFormField(
        controller: manufacturerController,
        decoration: InputDecoration(labelText: 'Producent'),
        validator: _validatorUtil.validateName,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: ElevatedButton(onPressed: getImage, child: Text("Vælg billede")),
      ),
      TextFormField(
        controller: linkController,
        decoration: InputDecoration(labelText: 'Link'),
        validator: _validatorUtil.validateName,
      ),
      TextFormField(
        controller: descriptionController,
        decoration: InputDecoration(labelText: 'Beskrivelse'),
        validator: _validatorUtil.validateName,
      ),
      TextFormField(
        controller: flourContentController,
        decoration: InputDecoration(labelText: 'Flourindhold'),
        validator: _validatorUtil.validateName,
      ),
      TextFormField(
        controller: usageController,
        decoration: InputDecoration(labelText: 'Anvendelse'),
        validator: _validatorUtil.validateName,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: CheckboxListTile(
            title: const Text("SLS"),
            value: sls,
            onChanged: (bool? value) {
              setState(() {
                sls = value!;
              });
            }),
      ),
      TextFormField(
        controller: rdaController,
        decoration: InputDecoration(labelText: 'RDA'),
        validator: _validatorUtil.validateName,
      ),
      TextFormField(
        controller: effectController,
        decoration: InputDecoration(labelText: 'Effekt'),
        validator: _validatorUtil.validateName,
      ),
      TextFormField(
        controller: resultController,
        decoration: InputDecoration(labelText: 'Virkning'),
        validator: _validatorUtil.validateName,
      ),
      TextFormField(
        controller: countryCodeController,
        decoration: InputDecoration(labelText: 'Country-code'),
        validator: _validatorUtil.validateName,
      ),
      TextFormField(
        controller: ingredientsController,
        decoration: InputDecoration(labelText: 'Ingredienser'),
        validator: _validatorUtil.validateName,
        maxLines: 7,
      ),
      const SizedBox(
        height: 40,
      ),
      ElevatedButton(
        onPressed: () {
          if (_key.currentState!.validate()) {
            _submitForm(
                brandController.text,
                manufacturerController.text,
                linkController.text,
                descriptionController.text,
                flourContentController.text,
                usageController.text,
                sls,
                rdaController.text,
                effectController.text,
                resultController.text,
                ingredientsController.text,
                countryCodeController.text,
                _image);
          }
        },
        child: const Text('Gem'),
      ),
    ];
  }

  void _submitForm(
      String brand,
      String manufacturer,
      String link,
      String description,
      String flourContent,
      String usage,
      bool sls,
      String rda,
      String effect,
      String result,
      String ingredients,
      String countryCode,
      Uint8List? image) async {

    showDialog(context: context, builder: (BuildContext context){
      return const AlertDialog(
        content: LinearProgressIndicator(),
      );
    });

    var uuid = const Uuid().v4();
    List<String> ingredientsList = ingredients.trim().split(",");

    ToothpasteProduct toothpasteProduct = ToothpasteProduct(
        id: uuid,
        brand: brand,
        manufacturer: manufacturer,
        link: link,
        description: description,
        flouride: flourContent,
        usage: usage,
        sls: sls,
        rda: rda,
        effect: effect,
        effectDuration: result,
        countryCode: countryCode,
        ingredients: ingredientsList);

    await ProductService().storeProductToFirestore(toothpasteProduct);
    if (_image != null){
      await ProductImageService().storeProductImageToStorage(_image, uuid);
    }    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }
}
