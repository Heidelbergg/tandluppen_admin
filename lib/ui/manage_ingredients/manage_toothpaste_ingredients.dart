import 'package:flutter/material.dart';

import '../styles/text_styles.dart';
import '../widget/navbar/side_navbar.dart';

class ManageToothPasteIngredientsScreen extends StatefulWidget {
  const ManageToothPasteIngredientsScreen({super.key});

  @override
  State<ManageToothPasteIngredientsScreen> createState() => _ManageToothPasteIngredientsScreenState();
}

class _ManageToothPasteIngredientsScreenState extends State<ManageToothPasteIngredientsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
      backgroundColor: const Color(0xFFFF6624),
      elevation: 3,
      leading: IconButton(
        icon: const Icon(Icons.menu_outlined, color: Colors.white,),
        onPressed: () => _key.currentState!.openDrawer(),
      ),
    ),
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
          child: Text("Ingredienser",
              style: largeBoldBlackTextStyle),
        ),
        FractionallySizedBox(
          widthFactor: MediaQuery.of(context).size.width > 1000 ? 0.75 : 0.95,
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.25)),
                  borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: StreamBuilder(
                stream: null,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        return widget;
                      });
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(child: Text("Ingen ingredienser"));
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error_outline);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
          ),
        ),
      ],
    );
 }
}
