import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/model/ingredient.dart';

import '../../core/service/product/ingredients_service.dart';
import '../styles/text_styles.dart';
import '../widget/navbar/side_navbar.dart';
import 'edit_ingredient_screen.dart';

class ManageToothPasteIngredientsScreen extends StatefulWidget {
  const ManageToothPasteIngredientsScreen({super.key});

  @override
  State<ManageToothPasteIngredientsScreen> createState() =>
      _ManageToothPasteIngredientsScreenState();
}

class _ManageToothPasteIngredientsScreenState
    extends State<ManageToothPasteIngredientsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6624),
        elevation: 3,
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
            color: Colors.white,
          ),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        IngredientsService().checkUnusedIngredientsInProducts(context);
      }, child: const Icon(Icons.refresh),),
      drawer: const HomeNavDrawer(),
      body: _buildIngredientsView(),
    );
  }

  Widget _buildIngredientsView() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Ingredienser", style: largeBoldBlackTextStyle),
        ),
        FractionallySizedBox(
          widthFactor: MediaQuery.of(context).size.width > 1000 ? 0.75 : 0.95,
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.25)),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: FutureBuilder(
                future: IngredientsService().getAllIngredientsSorted(),
                builder: (context,
                    AsyncSnapshot<List<ToothpasteIngredient>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text("Ingen ingredienser"));
                    } else {
                      List<ToothpasteIngredient> ingredients =
                          snapshot.data ?? [];
                      return ListView.builder(
                          itemCount: ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            EditIngredientScreen(
                                                toothpasteIngredient:
                                                    ingredients[index])))
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {});
                                  }
                                });
                              },
                              title: Text(ingredients[index].name),
                              trailing:
                                  ingredients[index].description == "Opdateres"
                                      ? const Icon(
                                          Icons.warning_rounded,
                                          color: Colors.red,
                                        )
                                      : null,
                            );
                          });
                    }
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline),
                        Text("Fejl - ${snapshot.error.toString()}")
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
        ),
      ],
    );
  }
}
