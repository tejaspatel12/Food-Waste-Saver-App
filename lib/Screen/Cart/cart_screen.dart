// cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_service.dart';
import '../../model/Cart.dart';
import '../../model/Order.dart';
import '../Home/home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Future<void> showSuccessDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Placed Successfully'),
          content: Text('Thank you for your order!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                // Navigate to the home screen
                // Navigator.of(context).pushNamed('/home'); // Replace with your home screen route
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  final ApiService _apiService = ApiService(); // Create an instance of ApiService
  @override
  Widget build(BuildContext context) {
    List<Order> orders = Provider.of<Cart>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Order order = orders[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Restaurant ID: ${order.restaurantId}'),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order.meals.length,
                      itemBuilder: (context, index) {
                        MealQuantity mealQuantity = order.meals[index];
                        double totalPrice = mealQuantity.quantity * mealQuantity.meal.mealDiscountPrice;

                        return ListTile(
                          title: Text(mealQuantity.meal.mealName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${mealQuantity.quantity}'),
                              Text('Price: £${mealQuantity.meal.mealDiscountPrice.toStringAsFixed(2)}'),
                              Text('Total: £${totalPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  // Decrease the quantity
                                  setState(() {
                                    order.updateMealQuantity(mealQuantity.meal, mealQuantity.quantity - 1);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  // Increase the quantity
                                  setState(() {
                                    order.updateMealQuantity(mealQuantity.meal, mealQuantity.quantity + 1);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Call the placeOrder method using the instance of ApiService
                    // await _apiService.placeOrder(orders);
                    await _apiService.placeOrder(orders, showSuccessDialog);
                  },
                  child: Text('Place Order'),
                ),
                const SizedBox(height: 8),
                Text('Total Items: ${orders.fold(0, (total, order) => total + order.totalItems)}'),
                Text('Total Amount: £${orders.fold(0.0, (total, order) => total + order.totalAmount).toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

