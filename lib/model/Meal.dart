class Meal {
  final int mealId;
  final int restaurantId;
  final int mealType;
  final String hotCold;
  final String mealImage;
  final String mealName;
  final double mealPrice;
  final double mealDiscountPrice;
  // final String mealPrice;
  final String mealDescription;

  Meal({
    required this.mealId,
    required this.restaurantId,
    required this.mealType,
    required this.hotCold,
    required this.mealImage,
    required this.mealName,
    required this.mealPrice,
    required this.mealDiscountPrice,
    required this.mealDescription,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealId: json['meal_id'] as int,
      restaurantId: json['restaurant_id'] as int,
      mealType: json['meal_type'] as int,
      // mealId: int.parse(json['meal_id'] as String),
      // restaurantId: int.parse(json['restaurant_id'] as String),
      // mealType: int.parse(json['meal_type'] as String)
      hotCold: json['hot_cold'] as String,
      mealImage: json['meal_image'] as String,
      mealName: json['meal_name'] as String,
      // mealPrice: json['meal_price'] != null ? double.parse(json['meal_price'] as String) : 0.0, // Use double.parse
      // mealPrice: json['meal_price'] as String,
      // mealPrice: json['meal_price'] as double,
      mealPrice: (json['meal_price'] as num).toDouble(),
      mealDiscountPrice: (json['meal_discount_price'] as num).toDouble(),
      mealDescription: json['meal_description'] as String,
    );
  }
}
