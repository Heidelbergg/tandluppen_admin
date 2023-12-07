import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';
import 'package:tandluppen_web/core/service/product_image_service.dart';
import 'package:tandluppen_web/core/service/product_service.dart';

import '../../home/home_screen.dart';
import '../../product/edit_product_screen.dart';

class ToothpasteCard extends StatefulWidget {
  final ToothpasteProduct toothpasteProduct;
  const ToothpasteCard({super.key, required this.toothpasteProduct});

  @override
  State<ToothpasteCard> createState() => _ToothpasteCardState();
}

class _ToothpasteCardState extends State<ToothpasteCard> {
  String? imageUrl;

  void _getImageUrl() async {
    ProductImageService().getImageUrl(widget.toothpasteProduct.id).then((value) {
      setState(() {
        imageUrl = value;
      });
    });
  }

  @override
  void initState() {
    _getImageUrl();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProductScreen(widget.toothpasteProduct))).then((value) {setState(() {});});
      },
        title: Text(widget.toothpasteProduct.brand),
        subtitle: Text(widget.toothpasteProduct.manufacturer),
        trailing: IconButton(onPressed: () async {
          await ProductService().deleteFirestoreProduct(widget.toothpasteProduct, imageUrl);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
        }, icon: const Icon(Icons.delete, color: Colors.red,)),
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: imageUrl != null ? Image.network(imageUrl!) : Image.network("https://placehold.co/50x50"),
          ),
        ),
    );
  }
}
