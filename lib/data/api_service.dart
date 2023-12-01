import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

import '../Screen/Cart/cart_screen.dart';
import '../model/Meal.dart';
import '../model/Order.dart';
import '../model/Restaurant.dart';

class ApiService {
  static const String baseUrl = 'http://activeit.in/admin/api/';


  Future<List<Map<String, dynamic>>> fetchNearbyRestaurants(double latitude, double longitude) async {
    final endpoint = 'restaurent.php';
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );

    if (response.statusCode == 200) {
      final dynamic decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        // Check if the decoded response is a List
        return List<Map<String, dynamic>>.from(decodedResponse);
      } else {
        throw Exception('Invalid API response format');
      }
    } else {
      throw Exception('Failed to load nearby restaurants data');
    }
  }


  Future<Map<String, dynamic>> fetchBannerData() async {
    final endpoint = 'banners';
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load banner data');
    }
  }

  Future<LocationData> getLocation() async {
    final location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      throw Exception('Error getting location: $e');
    }
  }


  // Future<List<Meal>> fetchMeals(int restaurantId) async { // Accept restaurantId as a parameter
  //   try {
  //     final response =
  //     await http.get('your_api_url/meals?restaurant_id=$restaurantId' as Uri); // Adjust the URL
  //     final List<Map<String, dynamic>> mealData = json.decode(response.body);
  //
  //     return json.decode(response.body);
  //   } catch (e) {
  //     throw Exception('Failed to fetch meals: $e');
  //   }
  // }

  // static Future<List<Map<String, dynamic>>> fetchMeals(int restaurantId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/restaurant_meal.php?restaurant_id=$restaurantId'));
  //   if (response.statusCode == 200) {
  //     return List<Map<String, dynamic>>.from(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load meals');
  //   }
  // }

  static Future<Restaurant> fetchRestaurantDetails(int restaurantId) async {
    final response = await http.get(Uri.parse('$baseUrl/restaurant_detail.php?restaurantId=$restaurantId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Restaurant.fromJson(jsonData);
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }

  static Future<List<Meal>> fetchMeals(int restaurantId) async {
    final response = await http.get(Uri.parse('$baseUrl/restaurant_meal.php?restaurant_id=$restaurantId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<void> placeOrder(List<Order> orders, VoidCallback onSuccess) async {
    final url = '$baseUrl/place_order.php';

    final data = {
      'restaurant_id': orders.first.restaurantId.toString(),
      'meals': orders
          .map((order) => order.meals
          .map((mealQuantity) => {
        'id': mealQuantity.meal.mealId, // Assuming Meal has an 'id' property
        'quantity': mealQuantity.quantity,
        'discount_price': mealQuantity.meal.mealDiscountPrice,
      }).toList()).toList(),
      'order_total': orders.first.totalAmount.toString(),
    };


    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Order placed successfully
        print('Order placed successfully');
        onSuccess();
        // Show the success dialog using the context passed from _CartScreenState
      } else {
        // Handle error
        print('Error placing order: ${response.body}');
      }
    } catch (e) {
      // Handle network error
      print('Network error: $e');
    }
  }


  // Future<void> placeOrder(List<Order> orders) async {
  //   final url = 'YOUR_API_ENDPOINT_HERE';
  //
  //   // Prepare the data to be sent to the server
  //   // You may need to adjust this based on your API requirements
  //   final data = {
  //     'restaurant_id': orders.first.restaurantId.toString(),
  //     'meals': orders.map((order) => order.meals.map((meal) => {'id': meal.meal.id, 'quantity': meal.quantity}).toList()).toList(),
  //     'order_total': orders.first.totalAmount.toString(),
  //   };
  //
  //   try {
  //     final response = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
  //
  //     if (response.statusCode == 200) {
  //       // Order placed successfully
  //       print('Order placed successfully');
  //     } else {
  //       // Handle error
  //       print('Error placing order: ${response.body}');
  //     }
  //   } catch (e) {
  //     // Handle network error
  //     print('Network error: $e');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> fetchMeals(int restaurantId) async {
  //   final url = Uri.parse('$baseUrl/meal.php?restaurantId=$restaurantId');
  //
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.cast<Map<String, dynamic>>();
  //   } else {
  //     throw Exception('Failed to fetch meals for restaurant $restaurantId');
  //   }
  // }

}
