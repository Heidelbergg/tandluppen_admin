import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:tandluppen_web/core/const/excel_export_consts.dart';
import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/const/sort_selection_const.dart';
import 'package:tandluppen_web/core/service/product/product_service.dart';
import 'package:tandluppen_web/core/util/sorting/product_sorting/product_sort.dart';
import 'package:tandluppen_web/core/util/validator/validator.dart';
import 'package:tandluppen_web/ui/product/add_product_screen.dart';
import 'package:tandluppen_web/ui/styles/textfield_styles.dart';
import 'package:tandluppen_web/ui/widget/navbar/side_navbar.dart';
import 'package:validators/validators.dart';

import '../../core/const/sort_consts.dart';
import '../../core/model/toothpaste_product.dart';
import '../product/edit_product_screen.dart';
import '../styles/text_styles.dart';
import '../widget/product/toothpaste_card.dart';

import 'package:to_csv/to_csv.dart' as exportCSV;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SortOption? _selectedSortOption;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  final AutoScrollController _autoScrollController = AutoScrollController();
  List<ToothpasteProduct> _products = [];
  final ProductSort _productSort = ProductSort();
  late String _searchText = '';


  bool loading = true;

  // Export to CSV
  List<List<String>> listOfLists = [];

  @override
  void initState() {
    super.initState();
    _loadProductsAndSetSortOption(null);
    //_dosome();
  }

  _dosome() async {
    var ref = await FirestoreConsts.firestoreToothpasteCollection.get();
    for (var doc in ref.docs){
      if (doc.data()['effect_duration'] == ""){
        FirestoreConsts.firestoreToothpasteCollection.doc(doc.id).update({
          'effect_duration' : "Opdateres"
        });
      }
    }
  }

  _loadProductsAndSetSortOption(String? productId) async {
    _useGlobalSortParameter();
    _products = await ProductService().getToothpasteProductList();;
    if (_selectedSortOption != null) {
      _productSort.sortProducts(_products, _selectedSortOption);
    }
    _finishLoading(productId);
  }

  void _finishLoading(String? productId){
    setState(() {
      loading = false;
    });
    if (productId != null){
      scrollToProductIndex(productId);
    }
  }

  void handleSortChange(bool selected, SortOption option) {
    if (selected) {
      setState(() {
        _selectedSortOption = option;
        GlobalSortOption.globalSortOption = _selectedSortOption!;
        _productSort.sortProducts(_products, _selectedSortOption);
      });
    }
  }

  void scrollToProductIndex(String productId) {
    int index = _products.indexWhere((product) => product.id == productId);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Funktion udført!"), backgroundColor: Colors.green,));
    _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin,
      duration: const Duration(milliseconds: 500)
    );
  }

  _useGlobalSortParameter() {
    handleSortChange(true, GlobalSortOption.globalSortOption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6624),
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.menu_outlined, color: Colors.white),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
      ),

      body: _buildToothpasteList(),
      drawer: const HomeNavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const AddProductScreen()))
              .then((value) {
            setState(() {
             if (value != null){
               _loadProductsAndSetSortOption(value);
             }
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildToothpasteList() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text("Produkter", style: largeBoldBlackTextStyle),
              const Padding(padding: EdgeInsets.only(right: 10)),
              Container(
                height: 30,
                width: 75,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.35),
                  borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                child: Center(child: Text(_products.length.toString())),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        _buildHeader(),
        FractionallySizedBox(
          widthFactor: MediaQuery.of(context).size.width > 1000 ? 0.75 : 0.95,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.25)),
              color: Colors.grey.withOpacity(0.35)
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("PRODUKT", style: extraSmallGreyTextStyle,),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text("SLET", style: extraSmallGreyTextStyle,),
                ),
              ],
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: MediaQuery.of(context).size.width > 1000 ? 0.75 : 0.95,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.25))),
            child: loading? const Center(child: CircularProgressIndicator()) : ListView.separated(
              controller: _autoScrollController,
              itemCount: _products.length,
              itemBuilder: (context, index) {
                if (ValidatorUtil().validateSearchString(_searchText, _products[index])) {
                  return Container();
                }
                return AutoScrollTag(
                    key: ValueKey(index),
                    controller: _autoScrollController,
                    index: index,
                    highlightColor: Colors.black.withOpacity(0.1),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                            builder: (context) =>
                                EditProductScreen(_products[index])))
                            .then((value) async {
                              if (value != null){
                                await _loadProductsAndSetSortOption(_products[index].id);
                              }
                        });
                      },
                      child: ToothpasteCard(
                          key: ValueKey(_products[index].id),
                          toothpasteProduct: _products[index]),
                    ));
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container();
              },
            )
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return FractionallySizedBox(
      widthFactor: MediaQuery.of(context).size.width > 1000 ? 0.75 : 0.95,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.25)),
              right: BorderSide(color: Colors.grey.withOpacity(0.25)),
              left: BorderSide(color: Colors.grey.withOpacity(0.25)),
            ),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  height: 35,
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: searchFieldInputDecoration,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 35,
                  width: 150,
                  child: MultiSelectDropDown<dynamic>(
                    onOptionSelected: (List<ValueItem> selectedOptions) {
                      _selectedSortOption = selectedOptions.first.value;
                      handleSortChange(true, selectedOptions.first.value);
                    },
                    hint: 'Filter',
                    options: SortValueOptions.sortOptions,
                    selectionType: SelectionType.single,
                    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                    dropdownHeight: 150,
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(Icons.check_circle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextButton.icon(
                      onPressed: () async {
                        for (var product in _products) {
                          listOfLists.add(product.toCSV());
                        }
                        exportCSV.myCSV(ExcelExportConst.excelHeaders, listOfLists);
                      },
                      icon: const Icon(
                        Icons.download,
                        size: 20,
                      ),
                      label: const Text(
                        "Eskporter til CSV",
                        style: TextStyle(fontSize: 12),
                      )),
                )
              ],
            ),
          ),
      ),
    );
  }
}
