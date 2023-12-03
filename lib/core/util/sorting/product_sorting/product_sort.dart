import '../../../const/sort_consts.dart';
import '../../../model/toothpaste_product.dart';

class ProductSort{

  void sortProducts(List<ToothpasteProduct> products, SortOption? selectedSortOption) {
    if (selectedSortOption == SortOption.manufacturer) {
      products.sort((a, b) => a.manufacturer.compareTo(b.manufacturer));
    } else if (selectedSortOption == SortOption.brand) {
      products.sort((a, b) => a.brand.compareTo(b.brand));
    }
  }
}