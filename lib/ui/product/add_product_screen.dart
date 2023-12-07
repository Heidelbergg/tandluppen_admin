import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';
import 'package:tandluppen_web/core/service/product_image_service.dart';
import 'package:tandluppen_web/core/service/product_service.dart';
import 'package:tandluppen_web/core/util/validator/validator.dart';
import 'package:tandluppen_web/ui/home/home_screen.dart';
import 'package:uuid/uuid.dart';

import '../styles/button_style.dart';
import '../styles/text_styles.dart';
import '../styles/textfield_styles.dart';

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
  bool _hasImage = false;
  bool _isHovered = false;

  Future getImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      _image = image;
      _hasImage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tilføj produkt", style: whiteHeaderTextStyle),
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
      Padding(padding: EdgeInsets.all(8), child: Text("Generelle oplysninger", style: largeTextStyle,),),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: brandController,
                decoration: textFieldInputDecoration("Mærke"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: manufacturerController,
                decoration: textFieldInputDecoration("Producent"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: descriptionController,
          decoration: textFieldInputDecoration("Beskrivelse"),
          validator: _validatorUtil.validateName,
          maxLines: 5,
        ),
      ),
      const SizedBox(height: 10,),
      _hasImage ? SizedBox(
        height: 300,
        width: 150,
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
                  child: Image.memory(_image!), // Display your image here
                ),
              if (_isHovered && _hasImage)
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _image = null; // Remove image
                        _hasImage = false;
                      });
                    },
                    icon: const Icon(Icons.delete, color: Colors.red,),
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
      const SizedBox(height: 10,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: linkController,
          decoration: textFieldInputDecoration("Link"),
          validator: _validatorUtil.validateName,
        ),
      ),
      const SizedBox(height: 20,),
      Padding(padding: EdgeInsets.all(8), child: Text("Egenskaber", style: largeTextStyle,),),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: flourContentController,
                decoration: textFieldInputDecoration("Flourindhold"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: rdaController,
                decoration: textFieldInputDecoration("RDA"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: usageController,
                decoration: textFieldInputDecoration("Anvendelse"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: effectController,
                decoration: textFieldInputDecoration("Effekt"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: resultController,
                decoration: textFieldInputDecoration("Virkning"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: countryCodeController,
                decoration: textFieldInputDecoration("Country-code"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: ingredientsController,
          decoration: textFieldInputDecoration("Ingredienser"),
          validator: _validatorUtil.validateName,
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
            },
            style: greenButtonStyle,
            child: const Text('Opret produkt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
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
    List<String> ingredientsList = ingredients.split(",");

    ToothpasteProduct toothpasteProduct = ToothpasteProduct(
        id: uuid,
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

    await ProductService().storeProductToFirestore(toothpasteProduct);
    if (_image != null){
      await ProductImageService().storeProductImageToStorage(_image, uuid);
    }    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }
}
