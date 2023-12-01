import 'dart:ui';

class Restaurant {
  final int restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String restaurantNumber;
  final String restaurantMail;
  final String restaurantPassword;
  final String restaurantLocation;
  final int cityId;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.restaurantNumber,
    required this.restaurantMail,
    required this.restaurantPassword,
    required this.restaurantLocation,
    required this.cityId,
    required this.latitude,
    required this.longitude,
  });

  // Define a factory method to deserialize JSON data
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantId: json['restaurant_id'] as int,
      // restaurantId: int.parse(json['restaurant_id'] as String),
      restaurantName: json['restaurant_name'] != null ? json['restaurant_name'] as String : 'No Name',
      restaurantImage: json['restaurant_image'],
      restaurantNumber: json['restaurant_number'] != null ? json['restaurant_number'] as String : '',
      restaurantMail: json['restaurant_mail'] != null ? json['restaurant_mail'] as String : '',
      restaurantPassword: json['restaurant_password'] != null ? json['restaurant_password'] as String : '',
      restaurantLocation: json['restaurant_location'] != null ? json['restaurant_location'] as String : '',
      cityId: json['city_id'] as int,
      latitude: json['latitude'] != null ? double.parse(json['latitude'] as String) : 0.0,
      longitude: json['longitude'] != null ? double.parse(json['longitude'] as String) : 0.0,
    );
  }
}
