import 'package:multi_dropdown/models/value_item.dart';

enum SortOption{
  manufacturer, brand, countryCode, none
}

class SortValueOptions{
  static const List<ValueItem> sortOptions = [
  ValueItem(label: 'Manufacturer', value: SortOption.manufacturer),
  ValueItem(label: 'Brand', value: SortOption.brand),
  ValueItem(label: 'Country-code', value: SortOption.countryCode),
  ];
}