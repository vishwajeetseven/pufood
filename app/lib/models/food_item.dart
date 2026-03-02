class FoodItem {
  final String name;
  final double price;
  final double protein;
  final double carbs;
  final double fat;
  final String outlet;
  bool isFavorite;

  FoodItem({
    required this.name,
    required this.price,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.outlet,
    this.isFavorite = false,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      outlet: json['outlet'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'outlet': outlet,
    'isFavorite': isFavorite,
  };
}
