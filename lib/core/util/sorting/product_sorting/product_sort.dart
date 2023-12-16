import '../../../const/sort_consts.dart';
import '../../../model/toothpaste_product.dart';

class ProductSort{

  void sortProducts(List<ToothpasteProduct> products, SortOption? selectedSortOption) {
    switch (selectedSortOption) {
      case SortOption.manufacturer:
        products.sort((a, b) => a.manufacturer.compareTo(b.manufacturer));
        break;
      case SortOption.brand:
        products.sort((a, b) => a.brand.compareTo(b.brand));
        break;
      case SortOption.countryCode:
        products.sort((a, b) => a.countryCode.compareTo(b.countryCode));
        break;
      default:
        break;
    }

  }
}