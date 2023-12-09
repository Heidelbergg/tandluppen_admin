import 'package:flutter/material.dart';
import 'package:tandluppen_web/core/const/excel_export_consts.dart';
import 'package:tandluppen_web/core/const/sort_selection_const.dart';
import 'package:tandluppen_web/core/service/product_service.dart';
import 'package:tandluppen_web/core/util/sorting/product_sorting/product_sort.dart';
import 'package:tandluppen_web/ui/product/add_product_screen.dart';

import '../../core/const/sort_consts.dart';
import '../../core/model/toothpaste_product.dart';
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
  late Future<List<ToothpasteProduct>> _productListFuture;
  List<ToothpasteProduct> _products = [];
  final ProductSort _productSort = ProductSort();

  // Export to CSV
  List<List<String>> listOfLists = [];

  @override
  void initState() {
    super.initState();
    _useGlobalSortParameter();
    _productListFuture = ProductService().getToothpasteProductList();
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

  _useGlobalSortParameter(){
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
              .push(MaterialPageRoute(builder: (context) => const AddProductScreen()))
              .then((value) {
            setState(() {
              _productListFuture = ProductService().getToothpasteProductList();
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
                padding: const EdgeInsets.only(left: 5, right: 10),
                child: ChoiceChip(
                  label: const Text("Manufacturer"),
                  selected: _selectedSortOption == SortOption.manufacturer,
                  onSelected: (selected) {
                    handleSortChange(selected, SortOption.manufacturer);
                  },
                ),
              ),
              ChoiceChip(
                label: const Text("Brand"),
                selected: _selectedSortOption == SortOption.brand,
                onSelected: (selected) {
                  handleSortChange(selected, SortOption.brand);
                },
              ),
              const Spacer(),
              TextButton.icon(onPressed: () async {
                listOfLists.add(ExcelExportConst.excelHeaders);
                for (var product in await _productListFuture) {
                  listOfLists.add(product.toCSV());
                }
                exportCSV.myCSV(ExcelExportConst.excelHeaders, listOfLists);
              }, icon: const Icon(Icons.download, size: 20,), label: const Text("Eskporter til CSV", style: TextStyle(fontSize: 12),))
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.25,
          margin: const EdgeInsets.fromLTRB(300, 50, 300, 50),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.25)),
            borderRadius: BorderRadius.circular(20)
          ),
          child: FutureBuilder(
              future: _productListFuture,
              builder: (BuildContext context, AsyncSnapshot<List<ToothpasteProduct>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  _products = snapshot.data!;
                  if (_selectedSortOption != null) {
                    _productSort.sortProducts(_products, _selectedSortOption);
                  }
                  return ListView.separated(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return ToothpasteCard(toothpasteProduct: _products[index]);
                    }, separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.grey.withOpacity(0.25),
                      );
                  },
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}
