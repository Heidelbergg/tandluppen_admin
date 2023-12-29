import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/service/toothpaste_guide/guide_service.dart';
import 'package:tandluppen_web/ui/widget/guide/guide_card.dart';

import '../../core/model/toothpaste_guide.dart';
import '../styles/text_styles.dart';
import '../widget/navbar/side_navbar.dart';
import 'manage_toothpaste_guide/add_guide.dart';
import 'manage_toothpaste_guide/edit_guide.dart';

class ManageToothpasteUsageScreen extends StatefulWidget {
  const ManageToothpasteUsageScreen({super.key});

  @override
  State<ManageToothpasteUsageScreen> createState() =>
      _ManageToothpasteUsageScreenState();
}

class _ManageToothpasteUsageScreenState
    extends State<ManageToothpasteUsageScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key


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
          icon: const Icon(Icons.menu_outlined, color: Colors.white,),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
      ),
      drawer: const HomeNavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const AddToothpasteGuideScreen()))
              .then((value) {
            setState(() {
              if (value != null) {}
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      body: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Guides til anvendelse af tandpasta",
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
                stream: FirestoreConsts.firestoreGuidesCollection.orderBy('order', descending: false).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ToothpasteGuide> guides = snapshot.data!.docs
                        .map((doc) => ToothpasteGuide.fromJson(doc.data()))
                        .toList();

                    return ReorderableListView.builder(
                      itemCount: guides.length,
                      itemBuilder: (BuildContext context, int index) {
                        ToothpasteGuide toothpasteGuide = guides[index];

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditToothpasteGuideScreen(toothpasteGuide: toothpasteGuide),
                            ));
                          },
                          key: ValueKey(toothpasteGuide.id),
                          child: ToothpasteGuideCard(
                            key: ValueKey(toothpasteGuide.id),
                            toothpasteGuide: toothpasteGuide,
                          ),
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final ToothpasteGuide item = guides.removeAt(oldIndex);
                          guides.insert(newIndex, item);

                          for (int i = 0; i < guides.length; i++) {
                            ToothpasteGuideService().updateOrder(i, guides[i].id);
                            //print("${guides[i].title} - $i");
                          }
                        });
                      },
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Ingen guides"));
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