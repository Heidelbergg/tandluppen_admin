import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';
import 'package:tandluppen_web/core/model/toothpaste_product_link.dart';
import 'package:tandluppen_web/core/service/product/product_service.dart';

import '../../core/const/anvendelse_consts.dart';
import '../../core/service/product/product_image_service.dart';
import '../../core/util/validator/validator.dart';
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
  bool _linkVisible = false;
  bool _pictureRights = false;

  List<dynamic> _anvendelseList = [];
  List<String> _missingData = [];

  @override
  void initState() {
    _loadDataFromDatabase();
    _getMissingData();
    super.initState();
  }

  void _loadDataFromDatabase() async {
    ToothpasteProduct? product = await _productService.populateTextFields(
        widget.toothpasteProduct.id,
        brandController,
        manufacturerController,
        linkController,
        descriptionController,
        flourContentController,
        rdaController,
        effectController,
        resultController,
        ingredientsController,
        countryCodeController);
    _productImageService.getImageUrl(widget.toothpasteProduct.id).then((image) {
      _savedImage = image;
      _hasImage = true;
    });
    setState(() {
      if (product!.usage.isNotEmpty) {
        _anvendelseList = product.usage;
        _linkVisible = product.link.isVisible;
        _pictureRights = product.pictureRights;
      }
    });
  }

  Future getImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      if (image != null) {
        _savedImage = null;
        _image = image;
        _hasImage = true;
      }
    });
  }

  List<String> _getMissingData() {
    return _missingData =
        _productService.checkIfDataMissing(widget.toothpasteProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rediger tandpasta",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 3,
        backgroundColor: const Color(0xFFFF6624),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: _buildToothPasteScreen(),
    );
  }

  Widget _buildToothPasteScreen() {
    return FutureBuilder(
      future:
          ProductService().findToothpasteProduct(widget.toothpasteProduct.id),
      builder:
          (BuildContext context, AsyncSnapshot<ToothpasteProduct?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          return _buildToothPasteForm(snapshot.data!);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
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
          )),
    );
  }

  Widget _buildMissingDataColumn() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.25)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Manglende oplysninger",
                  style: mediumRedBoldTextStyle,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _missingData.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  _missingData[index],
                  style: const TextStyle(color: Colors.red),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildForm() {
    return [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Generelle oplysninger",
                    style: largeBlackTextStyle,
                  ),
                )),
            const SizedBox(height: 20),
            _missingData.isNotEmpty ? _buildMissingDataColumn() : Container(),
            const SizedBox(height: 40),
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: descriptionController,
                decoration: textFieldInputDecoration("Beskrivelse"),
                validator: _validatorUtil.validateName,
                maxLines: 5,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: linkController,
                      decoration: textFieldInputDecoration("Link"),
                      validator: _validatorUtil.validateName,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 10,
                  child: Checkbox(value: _linkVisible, onChanged: (bool? checked){
                    setState(() {
                      _linkVisible = checked!;
                    });
                  }),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text("Billedrettigheder", style: mediumBlackTextStyle)
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 10,
                  child: Checkbox(value: _pictureRights, onChanged: (bool? checked){
                    setState(() {
                      _pictureRights = checked!;
                    });
                  }),
                )
              ],
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Egenskaber",
                    style: largeBlackTextStyle,
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: flourContentController,
                      keyboardType: TextInputType.number,
                      decoration: textFieldInputDecoration("Flourindhold"),
                      validator: _validatorUtil.validateNumber,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validatorUtil.validateNullableNumber,
                      controller: rdaController,
                      decoration: textFieldNotRequiredInputDecoration("RDA"),
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
                      child: MultiSelectDialogField(
                        validator: _validatorUtil.validateUsageItems,
                        title: const Text("Anvendelse"),
                        confirmText: const Text("Ok"),
                        cancelText: const Text("Annuller"),
                        dialogHeight: MediaQuery.of(context).size.height / 2,
                        dialogWidth: MediaQuery.of(context).size.width / 2,
                        buttonText: const Text.rich(
                          TextSpan(
                              text: "Anvendelse",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ))
                              ]),
                        ),
                        buttonIcon: const Icon(Icons.keyboard_arrow_down),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: const Color(0xFFFF6624).withOpacity(0.05)),
                        selectedColor: const Color(0xFFFF6624),
                        items: AnvendelseConsts.anvendelseConsts
                            .map((e) => MultiSelectItem(e, e))
                            .toList(),
                        listType: MultiSelectListType.LIST,
                        initialValue: _anvendelseList,
                        onConfirm: (values) {
                          setState(() {
                            _anvendelseList = values;
                          });
                        },
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: effectController,
                      decoration: textFieldNotRequiredInputDecoration("Effekt"),
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
                      decoration:
                          textFieldNotRequiredInputDecoration("Virkning"),
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
                    _anvendelseList,
                    rdaController.text == "" ? "0" : rdaController.text,
                    effectController.text,
                    resultController.text,
                    ingredientsController.text,
                    countryCodeController.text,
                    _image);
              }
            },
            style: greenButtonStyle,
            child: const Text(
              'Opdater produkt',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
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
      List<dynamic> usage,
      String rda,
      String effect,
      String result,
      String ingredients,
      String countryCode,
      Uint8List? image) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: LinearProgressIndicator(),
          );
        });

    List ingredientsList = ingredients.trim().split(",");

    ToothpasteProduct toothpasteProduct = ToothpasteProduct(
        id: id,
        brand: brand,
        manufacturer: manufacturer,
        link: Link(url: link, isVisible: _linkVisible),
        description: description,
        flouride: int.parse(flourContent),
        usage: usage,
        rda: int.parse(rda),
        pictureRights: _pictureRights,
        effect: effect,
        effectDuration: result,
        countryCode: countryCode,
        ingredients: ingredientsList);

    await _productService.updateFirestoreProduct(toothpasteProduct);
    if (_image != null) {
      await _productImageService.storeProductImageToStorage(_image, id);
    }
    Navigator.pop(context);
    Navigator.pop(context, true);
  }
}
