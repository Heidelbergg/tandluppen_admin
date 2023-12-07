import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';
import 'package:tandluppen_web/core/service/product_service.dart';

import '../../core/service/product_image_service.dart';
import '../../core/util/validator/validator.dart';
import '../home/home_screen.dart';

class EditProductScreen extends StatefulWidget {
  final ToothpasteProduct toothpasteProduct;

  const EditProductScreen(this.toothpasteProduct, {super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  final ProductService _productService = ProductService();
  final ProductImageService _productImageService = ProductImageService();
  final ValidatorUtil _validatorUtil = ValidatorUtil();

  Uint8List? _image;
  String? savedImage;

  @override
  void initState() {
    _loadDataFromDatabase();
    super.initState();
  }

  void _loadDataFromDatabase() async {
    ToothpasteProduct? toothpasteProduct = await _productService.populateTextFields(
      widget.toothpasteProduct.id,
      brandController,
      manufacturerController,
      linkController,
      descriptionController,
      flourContentController,
      usageController,
      rdaController,
      effectController,
      resultController,
      ingredientsController,
      countryCodeController
    );
    _productImageService.getImageUrl(widget.toothpasteProduct.id).then((image) {
      setState(() {
        savedImage = image;
      });
    });
  }

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
        title: const Text("Rediger tandpasta", style: TextStyle(color: Colors.white),),
        elevation: 3,
        backgroundColor: const Color(0xFFFF6624),
        leading: const BackButton(color: Colors.white,),
      ),
      body: _buildToothPaste(),
    );
  }

  Widget _buildToothPaste() {
    return FutureBuilder(
        future:
            ProductService().findToothpasteProduct(widget.toothpasteProduct.id),
        builder:
            (BuildContext context, AsyncSnapshot<ToothpasteProduct?> snapshot) {
          if (snapshot.hasData) {
            return _buildToothPasteForm(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.data!.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildToothPasteForm(ToothpasteProduct toothpasteProduct) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(left: 150, right: 150),
      child: Form(
        key: _key,
        child: ListView(
          shrinkWrap: true,
          children: [
            savedImage != null ? SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(savedImage!)),
            ) : Container(),
            _image != null ? Image.memory(_image!) : Container(),
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
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  if (_key.currentState!.validate()) {
                    _submitForm(
                        widget.toothpasteProduct.id,
                        brandController.text,
                        manufacturerController.text,
                        linkController.text,
                        descriptionController.text,
                        flourContentController.text,
                        usageController.text,
                        rdaController.text,
                        effectController.text,
                        resultController.text,
                        ingredientsController.text,
                        countryCodeController.text,
                        _image);
                  }
                }
                on Exception catch (e){
                  print(e);
                }
              },
              child: const Text('Gem'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(
      String id,
      String brand,
      String manufacturer,
      String link,
      String description,
      String flourContent,
      String usage,
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

    List ingredientsList = ingredients.split(",");

    ToothpasteProduct toothpasteProduct = ToothpasteProduct(
        id: id,
        brand: brand,
        manufacturer: manufacturer,
        link: link,
        description: description,
        flouride: flourContent,
        usage: usage,
        rda: rda,
        effect: effect,
        effectDuration: result,
        countryCode: countryCode,
        ingredients: ingredientsList);

    await _productService.updateFirestoreProduct(toothpasteProduct);
    if (_image != null){
      await _productImageService.storeProductImageToStorage(_image, id);
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }
}
