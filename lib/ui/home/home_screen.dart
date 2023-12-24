import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tandluppen_web/core/const/excel_export_consts.dart';
import 'package:tandluppen_web/core/const/firestore_consts.dart';
import 'package:tandluppen_web/core/const/sort_selection_const.dart';
import 'package:tandluppen_web/core/service/product_service.dart';
import 'package:tandluppen_web/core/util/sorting/product_sorting/product_sort.dart';
import 'package:tandluppen_web/ui/product/add_product_screen.dart';

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
  final AutoScrollController _autoScrollController = AutoScrollController();
  late Future<List<ToothpasteProduct>> _productListFuture;
  List<ToothpasteProduct> _products = [];
  final ProductSort _productSort = ProductSort();

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
    Map<String, dynamic> mapData = {
      'url': 'link',
      'isVisible': false,
    };
    var ref = await FirestoreConsts.firestoreToothpasteCollection.get();
    for (var doc in ref.docs){
      FirestoreConsts.firestoreToothpasteCollection.doc(doc.id).update({
        'link' : mapData
      });
    }
  }

  _loadProductsAndSetSortOption(String? productId) async {
    _useGlobalSortParameter();
    _productListFuture = ProductService().getToothpasteProductList();
    _products = await _productListFuture;
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
      appBar: AppBar(
        title: Text("Tandluppen Admin", style: whiteHeaderTextStyle),
        backgroundColor: const Color(0xFFFF6624),
        elevation: 3,
      ),
      body: _buildToothpasteList(),
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
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: ChoiceChip(
                  label: const Text("Manufacturer"),
                  selected: _selectedSortOption == SortOption.manufacturer,
                  onSelected: (selected) {
                    handleSortChange(selected, SortOption.manufacturer);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ChoiceChip(
                  label: const Text("Brand"),
                  selected: _selectedSortOption == SortOption.brand,
                  onSelected: (selected) {
                    handleSortChange(selected, SortOption.brand);
                  },
                ),
              ),
              ChoiceChip(
                label: const Text("Country Code"),
                selected: _selectedSortOption == SortOption.countryCode,
                onSelected: (selected) {
                  handleSortChange(selected, SortOption.countryCode);
                },
              ),
              const Spacer(),
              TextButton.icon(
                  onPressed: () async {
                    for (var product in await _productListFuture) {
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
                  ))
            ],
          ),
        ),
        FractionallySizedBox(
          widthFactor: MediaQuery.of(context).size.width > 1000 ? 0.65 : 0.95,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.25)),
                borderRadius: BorderRadius.circular(20)),
            child: loading? const Center(child: CircularProgressIndicator()) : ListView.separated(
              controller: _autoScrollController,
              itemCount: _products.length,
              itemBuilder: (context, index) {
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
                return Divider(
                  color: Colors.grey.withOpacity(0.25),
                );
              },
            )
          ),
        ),
      ],
    );
  }
}
