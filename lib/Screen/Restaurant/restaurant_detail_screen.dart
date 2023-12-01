// restaurant_detail_screen.dart

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/api_service.dart';
import '../../model/Cart.dart';
import '../../model/Meal.dart';
import '../../model/Order.dart';
import '../../model/Restaurant.dart';
import '../Cart/cart_screen.dart';
import '../Cart/cart_widget.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final int restaurantId;

  RestaurantDetailScreen({required this.restaurantId});

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late Future<Restaurant> _restaurantFuture;
  List<Meal> meals = [];
  late String restaurant_id;

  @override
  void initState() {
    super.initState();
    _restaurantFuture = fetchRestaurantDetails();
    restaurant_id = widget.restaurantId.toString();
    // meals = [];
    fetchMeals();
    // fetchRestaurantDetails();
  }

  Future<void> fetchMeals() async {
    try {
      final response = await ApiService.fetchMeals(widget.restaurantId);
      setState(() {
        meals = response;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<Restaurant> fetchRestaurantDetails() async {
    try {
      return ApiService.fetchRestaurantDetails(widget.restaurantId);
    } catch (e) {
      // Handle error
      throw Exception('Failed to load restaurant details');
    }
  }


  // Future<void> fetchRestaurantDetails() async {
  //   try {
  //     final response = await ApiService.fetchRestaurantDetails(widget.restaurantId);
  //     setState(() {
  //       restaurant = response;
  //     });
  //   } catch (e) {
  //     // Handle error
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Restaurant Detail'),
      ),
      floatingActionButton: Provider.of<Cart>(context).orders.isNotEmpty
          ? FloatingActionButton(
        onPressed: () {
          // Redirect to Cart Screen
          // Navigator.pushNamed(context, '/cart');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CartScreen(),
            ),
          );
        },
        child: Icon(Icons.shopping_cart),
      )
          : null,

      body: FutureBuilder(
        future: _restaurantFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Restaurant restaurant = snapshot.data as Restaurant;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        restaurant.restaurantName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        restaurant.restaurantLocation,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex:2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(meals[index].mealName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900),),
                                        Row(
                                          children: [
                                            Text("£${meals[index].mealDiscountPrice.toString()}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900,color: Colors.green),),

                                            SizedBox(width: 4,),

                                            Text("£${meals[index].mealPrice.toString()}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w200,color: Colors.grey,decoration: TextDecoration.lineThrough, decorationColor: Colors.grey, decorationThickness: 1.5,),),
                                          ],
                                        ),
                                        Text(meals[index].mealDescription,overflow: TextOverflow.ellipsis,maxLines: 3, style: TextStyle(fontSize: 14),),
                                      ],
                                    ),
                                  ),
                                  Flexible(flex:1, child: Stack(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF8833ff).withOpacity(0.1),
                                            border: Border.all(color: Color(0xFF8833ff),width: 1.5),
                                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                          ),
                                          child: Image.network('https://activeit.in/admin/assets/images/meal/'+meals[index].mealImage,)
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 20,
                                        right: 20,
                                        child: Column(
                                          children: [

                                            GestureDetector(
                                              onTap: () {
                                                // Add meal to the cart
                                                Provider.of<Cart>(context, listen: false).addToCart(meals[index], widget.restaurantId);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFFFFF),
                                                  // color: Color(0xFF8833ff).withOpacity(0.2),
                                                  border: Border.all(color: Color(0xFF8833ff),width: 1.5),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                ),
                                                child: Center(child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text("Add".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900,color: Color(0xFF8833ff)),),
                                                )),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                                ],
                              ),
                            ),

                            SizedBox(height: 20,),

                            const DottedLine(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              lineLength: double.infinity,
                              lineThickness: 1.0,
                              dashLength: 4.0,
                              dashColor: Colors.grey,
                              dashRadius: 0.0,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                              dashGapRadius: 0.0,
                            ),

                            SizedBox(height: 10,),

                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: CartWidget(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
