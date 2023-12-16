import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';
import 'package:tandluppen_web/core/service/product_image_service.dart';
import 'package:tandluppen_web/core/service/product_service.dart';

import '../../home/home_screen.dart';

class ToothpasteCard extends StatefulWidget {
  final ToothpasteProduct toothpasteProduct;

  const ToothpasteCard({super.key, required this.toothpasteProduct});

  @override
  State<ToothpasteCard> createState() => _ToothpasteCardState();
}

class _ToothpasteCardState extends State<ToothpasteCard> {
  String? imageUrl;
  bool? dataMissing;
  final ProductService _productService = ProductService();

  void _getImageUrl() async {
    ProductImageService()
        .getImageUrl(widget.toothpasteProduct.id)
        .then((value) {
      setState(() {
        if (value != null) {
          imageUrl = value;
        }
      });
    });
  }

  @override
  void initState() {
    _getImageUrl();
    super.initState();
  }

  Future<List<String>> _checkMissingProductInfo() async {
    List<String> missingData =
        _productService.checkIfDataMissing(widget.toothpasteProduct);
    setState(() {
      missingData.isNotEmpty ? dataMissing = true : dataMissing = false;
    });
    return missingData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkMissingProductInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              title: Row(
                children: [
                  Text(widget.toothpasteProduct.brand),
                  dataMissing!
                      ? const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        )
                      : Container()
                ],
              ),
              subtitle: Text("${widget.toothpasteProduct.manufacturer} - ${widget.toothpasteProduct.countryCode}"),
              trailing: IconButton(
                  onPressed: () async {
                    await _productService.deleteFirestoreProduct(
                        widget.toothpasteProduct, imageUrl);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              leading: SizedBox(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: imageUrl != null
                      ? Image.network(imageUrl!)
                      : Image.network("https://placehold.co/50x50"),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Icon(Icons.error_outline);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
