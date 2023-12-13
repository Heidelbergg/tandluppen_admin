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
  late bool dataMissing = false;

  void _getImageUrl() async {
    ProductImageService()
        .getImageUrl(widget.toothpasteProduct.id)
        .then((value) {
      setState(() {
        imageUrl = value;
      });
    });
  }

  void _checkIfDataMissing() {
    if (widget.toothpasteProduct.brand.contains("Opdateres") ||
        widget.toothpasteProduct.manufacturer.contains("Opdateres") ||
        widget.toothpasteProduct.link.contains("Opdateres") ||
        widget.toothpasteProduct.description.contains("Opdateres") ||
        widget.toothpasteProduct.flouride.contains("Opdateres") ||
        widget.toothpasteProduct.usage.isEmpty ||
        widget.toothpasteProduct.ingredients.contains("Opdateres")) {
      setState(() {
        dataMissing = true;
      });
    }
  }

  @override
  void initState() {
    _getImageUrl();
    _checkIfDataMissing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(widget.toothpasteProduct.brand),
          dataMissing
              ? const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    semanticLabel: "Data mangler",
                  ),
                )
              : Container()
        ],
      ),
      subtitle: Text(widget.toothpasteProduct.manufacturer),
      trailing: IconButton(
          onPressed: () async {
            await ProductService()
                .deleteFirestoreProduct(widget.toothpasteProduct, imageUrl);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
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
  }
}
