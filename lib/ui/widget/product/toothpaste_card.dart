import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/model/toothpaste_product.dart';

import '../../product/edit_product_screen.dart';

class ToothpasteCard extends StatefulWidget {
  final ToothpasteProduct toothpasteProduct;
  const ToothpasteCard({super.key, required this.toothpasteProduct});

  @override
  State<ToothpasteCard> createState() => _ToothpasteCardState();
}

class _ToothpasteCardState extends State<ToothpasteCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.toothpasteProduct.brand),
        subtitle: Text(widget.toothpasteProduct.manufacturer),
        trailing: IconButton(icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProductScreen(widget.toothpasteProduct))).then((value) {setState(() {});});
            })
    );
  }
}
