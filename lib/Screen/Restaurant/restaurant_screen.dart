import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../data/api_service.dart';
import '../../model/restaurant.dart'; // Adjust the import path based on your project structure

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  List<Restaurant> nearbyRestaurants = [];
  LocationData? _currentLocation;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final location = Location();
    try {
      final locationData = await location.getLocation();
      setState(() {
        _currentLocation = locationData;
        _fetchNearbyRestaurants(); // Call nearby restaurants API here
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchNearbyRestaurants() async {
    if (_currentLocation != null) {
      setState(() {
        isLoading = true;
      });

      final latitude = _currentLocation!.latitude;
      final longitude = _currentLocation!.longitude;

      try {
        final List<Map<String, dynamic>> restaurantData = await ApiService().fetchNearbyRestaurants(
          latitude!,
          longitude!,
        );

        setState(() {
          nearbyRestaurants = restaurantData
              .map((restaurantJson) => Restaurant.fromJson(restaurantJson))
              .toList();
        });
      } catch (e) {
        print('Error fetching nearby restaurants: $e');
        // Handle errors and show a user-friendly message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: const Text('Failed to load nearby restaurants data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants'),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : nearbyRestaurants.isNotEmpty
          ? ListView.builder(
        itemCount: nearbyRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = nearbyRestaurants[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  child: Image.network("https://activeit.in/admin/assets/images/restaurant/655ced7438e65.jpg")),
                Text(restaurant.restaurantName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
                Text(restaurant.restaurantLocation),
              ],
            ),
          );
        },
      )
          : Center(
        child: Text('No nearby restaurants found.'),
      ),
    );
  }
}
