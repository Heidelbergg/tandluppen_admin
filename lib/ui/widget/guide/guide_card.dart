import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/model/toothpaste_guide.dart';
import 'package:tandluppen_web/core/service/toothpaste_guide/guide_service.dart';
import 'package:tandluppen_web/ui/toothpaste_guides/manage_toothpaste_usage_screen.dart';

class ToothpasteGuideCard extends StatefulWidget {
  final ToothpasteGuide toothpasteGuide;
  const ToothpasteGuideCard({super.key, required this.toothpasteGuide});

  @override
  State<ToothpasteGuideCard> createState() => _ToothpasteGuideCardState();
}

class _ToothpasteGuideCardState extends State<ToothpasteGuideCard> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.toothpasteGuide.title),
      trailing: IconButton(
          onPressed: () async {
            await ToothpasteGuideService().deleteGuide(widget.toothpasteGuide);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const ManageToothpasteUsageScreen()),
                    (route) => false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Guide slettet!"), backgroundColor: Colors.green,));
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          )),
    );
  }
}
