import 'package:flutter/material.dart';

import 'Meal.dart';
import 'Order.dart';


class Cart extends ChangeNotifier {
  List<Order> _orders = [];
  int _totalItems = 0;

  List<Order> get orders => _orders;
  int get totalItems => _totalItems;


  void addToCart(Meal meal, int restaurantId) {
    Order existingOrder = _orders.firstWhere(
          (order) => order.restaurantId == restaurantId,
      orElse: () => Order(restaurantId),
    );

    existingOrder.addMealToOrder(meal, 1);

    if (_orders.contains(existingOrder)) {
      _orders[_orders.indexOf(existingOrder)] = existingOrder;
    } else {
      _orders.add(existingOrder);
    }

    _totalItems++;
    notifyListeners();
  }


  void removeFromCart(Meal meal, int restaurantId) {
    Order existingOrder = _orders.firstWhere(
          (order) => order.restaurantId == restaurantId,
      orElse: () => Order(restaurantId),
    );

    existingOrder.removeMealFromOrder(meal);

    if (existingOrder.meals.isNotEmpty) {
      if (_orders.contains(existingOrder)) {
        _orders[_orders.indexOf(existingOrder)] = existingOrder;
      } else {
        _orders.add(existingOrder);
      }
    } else {
      _orders.remove(existingOrder);
    }

    notifyListeners();
  }

  void updateQuantity(Meal meal, int restaurantId, int newQuantity) {
    Order existingOrder = _orders.firstWhere(
          (order) => order.restaurantId == restaurantId,
      orElse: () => Order(restaurantId),
    );

    existingOrder.updateMealQuantity(meal, newQuantity);

    if (existingOrder.meals.isNotEmpty) {
      if (_orders.contains(existingOrder)) {
        _orders[_orders.indexOf(existingOrder)] = existingOrder;
      } else {
        _orders.add(existingOrder);
      }
    } else {
      _orders.remove(existingOrder);
    }

    notifyListeners();
  }
}
