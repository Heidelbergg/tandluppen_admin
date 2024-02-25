import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandluppen_web/ui/home/home_screen.dart';
import 'package:tandluppen_web/ui/styles/text_styles.dart';

import '../../manage_ingredients/manage_toothpaste_ingredients_screen.dart';
import '../../toothpaste_guides/manage_toothpaste_usage_screen.dart';

class HomeNavDrawer extends StatelessWidget {
  const HomeNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 35),
            decoration: const BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Center(
              child: ListTile(
                title: Text("Administrator-konto", style: boldLargeWhiteTextStyle,),
                subtitle: Text(FirebaseAuth.instance.currentUser!.email!, style: smallWhiteTextStyle,),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
            },
            title: const Text("Produkter"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const ManageToothpasteUsageScreen()), (route) => false);
            },
            title: const Text("Anvendelse af tandpasta"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const ManageToothPasteIngredientsScreen()), (route) => false);
            },
            title: const Text("Ingredienser"),
          ),
        ],
      ),
    );
  }
}
