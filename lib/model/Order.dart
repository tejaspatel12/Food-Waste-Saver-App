import 'Meal.dart';

class MealQuantity {
  final Meal meal;
  int quantity;

  MealQuantity({
    required this.meal,
    required this.quantity,
  });
}

class Order {
  final int restaurantId;
  final List<MealQuantity> meals;

  Order(this.restaurantId, [List<MealQuantity>? meals])
      : this.meals = meals ?? [];

  void addMealToOrder(Meal meal, int quantity) {
    MealQuantity existingMeal = meals.firstWhere(
          (mealQuantity) => mealQuantity.meal == meal,
      orElse: () => MealQuantity(meal: meal, quantity: 0),
    );

    existingMeal.quantity += quantity;

    if (!meals.contains(existingMeal)) {
      meals.add(existingMeal);
    }
  }

  void removeMealFromOrder(Meal meal) {
    meals.removeWhere((mealQuantity) => mealQuantity.meal == meal);
  }

  void updateMealQuantity(Meal meal, int newQuantity) {
    MealQuantity existingMeal = meals.firstWhere(
          (mealQuantity) => mealQuantity.meal == meal,
      orElse: () => MealQuantity(meal: meal, quantity: 0),
    );
    existingMeal.quantity = newQuantity;

    if (existingMeal.quantity == 0) {
      meals.remove(existingMeal);
    }
  }

  int get totalItems {
    return meals.fold(0, (total, mealQuantity) => total + mealQuantity.quantity);
  }

  double get totalAmount {
    return meals.fold(0.0, (total, mealQuantity) => total + (mealQuantity.quantity * mealQuantity.meal.mealDiscountPrice));
  }
}



