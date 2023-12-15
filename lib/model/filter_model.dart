

class Filter {
  final String brand;
  final bool sortByPrice;
  final double minPrice;
  final double maxPrice;
  final String gender;
  final List<String> colors;

  Filter({
    required this.brand,
    required this.sortByPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.gender,
    required this.colors,
  });
}