import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';
import 'package:tandluppen_web/core/service/product_service.dart';

import '../../core/service/product_image_service.dart';
import '../../core/util/validator/validator.dart';
import '../home/home_screen.dart';
import '../styles/button_style.dart';
import '../styles/text_styles.dart';
import '../styles/textfield_styles.dart';

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
  String? _savedImage;

  bool _hasImage = false;
  bool _isHovered = false;

  @override
  void initState() {
    _loadDataFromDatabase();
    super.initState();
  }

  void _loadDataFromDatabase() async {
    await _productService.populateTextFields(
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
        _savedImage = image;
        _hasImage = true;
      });
    });
  }

  Future getImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      if (_image != null){
        _image = image;
        _hasImage = true;
      }
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
          children: _buildForm(),
        )
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
            Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(8), child: Text("Generelle oplysninger", style: largeBlackTextStyle,),)),
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
              height: 250,
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
                        child: _savedImage != null ? Image.network(_savedImage!) : Image.memory(_image!),
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
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: linkController,
                decoration: textFieldInputDecoration("Link"),
                validator: _validatorUtil.validateName,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20,),
      Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white
        ),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(8), child: Text("Egenskaber", style: largeBlackTextStyle,),)),
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
            },
            style: greenButtonStyle,
            child: const Text('Opdater produkt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
    ];
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

    List ingredientsList = ingredients.trim().split(",");

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
