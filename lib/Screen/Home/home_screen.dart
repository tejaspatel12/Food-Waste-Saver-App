
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:location/location.dart';
import '../../data/api_service.dart';
import '../../model/Restaurant.dart';
import '../Cart/cart_screen.dart';
import '../Restaurant/restaurant_home_screen.dart';
import '../Restaurant/restaurant_screen.dart';
import 'package:permission_handler/permission_handler.dart';  // Import permission_handler package

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ApiService _apiService = ApiService(); // List to store nearby restaurants

  List<Restaurant> nearbyRestaurants = [];
  LocationData? _currentLocation;
  bool isLoading = false;



  @override
  void initState() {
    // TODO: implement initState

    _getLocation();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
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
    try {
      // Assuming _currentLocation is initialized before this method is called
      final latitude = _currentLocation!.latitude;
      final longitude = _currentLocation!.longitude;

      if (latitude != null && longitude != null) {
        setState(() {
          isLoading = true;
        });

        final List<Map<String, dynamic>> restaurantData = await ApiService().fetchNearbyRestaurants(
          latitude,
          longitude,
        );

        setState(() {
          nearbyRestaurants = restaurantData
              .map((restaurantJson) => Restaurant.fromJson(restaurantJson))
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching nearby restaurants: $e');
      // Handle errors and show a user-friendly message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load nearby restaurants data.'),
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
      if (mounted) {
        // Check if the widget is still in the tree before calling setState
        setState(() {
          isLoading = false;
        });
      }
    }
  }



  int req = 1;

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Color(0xFFF3F0F0),
      backgroundColor: Color(0xFFFFFFFF),
      // appBar: AppBar(title: Text('Home')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: Color(0xFF8833ff).withOpacity(0.2),
            child: Column(
              children: [

                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

                //HOME
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on,color:Color(0xFF8833ff),size: 35,),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Home',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.keyboard_arrow_down,size: 30,),
                            ],
                          ),
                          Text(
                            'C - 703, Sagar Sankul Apt. Palanpur Canal',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/profile.gif',),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                //SEARCH
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.purple,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                        Icon(Icons.search,color:Color(0xFF8833ff),size: 30,),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.015,),
                        Text("Search",style: TextStyle(color: Colors.black54,fontSize: 18),),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                        Text('"Pav Bhaji"',style: TextStyle(color: Colors.black54,fontSize: 18),),
                      ],
                    ),
                  ),
                ),

                Lottie.asset('assets/animation/christmas.json',height: MediaQuery.of(context).size.width * 0.68),

                // Image.asset('assets/animation/christmas.json', height: MediaQuery.of(context).size.width * 0.5,),
              ],
            ),
          ),

          //FOR YOU

          // Stack(
          //   children: [
          //     const Positioned.fill(
          //       child: Divider(
          //         color: Colors.black12,
          //       ),
          //     ),
          //     Center(
          //         child: Container(
          //           color: Color(0xFFFFFFFF),
          //           child: const Padding(
          //             padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          //             child: Text('FOR YOU',style: TextStyle(fontSize: 16,color: Colors.black54, fontWeight: FontWeight.w400,letterSpacing: 2),),
          //           )
          //         )
          //     ),
          //
          //   ],
          // ),
          //
          // SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          //
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     GestureDetector(
          //       onTap: ()
          //       {
          //         setState(() {
          //           req = 1;
          //         });
          //       },
          //       child: Container(
          //           decoration: BoxDecoration(
          //             color: req==1?Color(0xFF8833ff).withOpacity(0.1):Color(0xFFFFFFFF),
          //             borderRadius: const BorderRadius.only(
          //               topLeft: Radius.circular(10.0),
          //               topRight: Radius.zero,
          //               bottomLeft: Radius.circular(10.0),
          //               bottomRight: Radius.zero,
          //             ),
          //             border: Border.all(
          //               color: req==1?Color(0xFF8833ff):Colors.black38,
          //             ),
          //           ),
          //
          //           child: const Padding(
          //             padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
          //             child: Text('Recommended',style: TextStyle(fontSize: 18),),
          //           )
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: ()
          //       {
          //         setState(() {
          //           req = 2;
          //         });
          //
          //         // GoRouter.of(context).push(Uri(path: '/restaurant').toString());
          //
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => const RestaurantScreen()),
          //         );
          //
          //         // context.go('/details');
          //         // RestaurantScreen
          //       },
          //       child: Container(
          //           decoration: BoxDecoration(
          //             color: req==2?Color(0xFF8833ff).withOpacity(0.1):Color(0xFFFFFFFF),
          //             borderRadius: const BorderRadius.only(
          //               topLeft: Radius.zero,
          //               topRight:  Radius.circular(10.0),
          //               bottomLeft: Radius.zero,
          //               bottomRight: Radius.circular(10.0),
          //             ),
          //             border: Border.all(
          //               // color: Color(0xFF8833ff),
          //               color: req==2?Color(0xFF8833ff):Colors.black38,
          //             ),
          //           ),
          //           child: Padding(
          //             padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
          //             child: Row(
          //               children: [
          //                 Icon(Icons.favorite_border,color:Color(0xFF8833ff),size: 20,),
          //                 SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
          //                 Text('Favourites',style: TextStyle(fontSize: 18),),
          //               ],
          //             ),
          //           )
          //       ),
          //     ),
          //   ],
          // ),
          //
          // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          //
          //
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: [
          //
          //         Column(
          //           children: [
          //             Container(
          //               width: MediaQuery.of(context).size.width * 0.6,
          //
          //               decoration: BoxDecoration(
          //                 color: Color(0xFFFFFFFF),
          //                 borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.black.withOpacity(0.1),
          //                     spreadRadius: 2,
          //                     blurRadius: 4,
          //                     offset: Offset(0, 0), // changes position of shadow
          //                   ),
          //                 ],
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Stack(
          //                     children: [
          //
          //                       ClipRRect(
          //                           borderRadius: const BorderRadius.only(
          //                             topLeft: Radius.circular(12),
          //                             bottomLeft: Radius.circular(12),
          //                           ),
          //                           child: Image.asset('assets/burger.jpg',width: MediaQuery.of(context).size.width * 0.2,)),
          //
          //                       Positioned.fill(
          //                         child: Container(
          //                           decoration: const BoxDecoration(
          //                               gradient: LinearGradient(
          //                                   begin: Alignment.topCenter,
          //                                   end: Alignment.bottomCenter,
          //                                   colors: [Colors.transparent, Colors.black12, Colors.black]),
          //                             borderRadius: BorderRadius.only(
          //                               bottomLeft: Radius.circular(12),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //
          //                       const Positioned(
          //                         bottom: 10,
          //                         left: 0,
          //                         right: 0,
          //                         child: Column(
          //                           children: [
          //                             Text('Unlimited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
          //                             Text('50% OFF',style: TextStyle(color: Colors.white,fontSize: 14),),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   SizedBox(width: 10,),
          //                   const Flexible(
          //                     flex: 1,
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                       children: [
          //                         Text('Taste Of Winges',style: TextStyle(fontSize: 18),),
          //                         Text('Beverages',style: TextStyle(fontSize: 14,color: Colors.black54),),
          //                         Row(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             Icon(Icons.timer,color:Color(0xFF8833ff),size: 20,),
          //                             SizedBox(width: 5,),
          //                             Text('40-45 min',style: TextStyle(fontSize: 14,color: Colors.black54),),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             SizedBox(height: 10,),
          //             Container(
          //               width: MediaQuery.of(context).size.width * 0.6,
          //
          //               decoration: BoxDecoration(
          //                 // color: Colors.purple,
          //                 // color: Color(0xFF8833ff),
          //                 color: Color(0xFFFFFFFF),
          //                 borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.black.withOpacity(0.1),
          //                     spreadRadius: 2,
          //                     blurRadius: 4,
          //                     offset: Offset(1, 2), // changes position of shadow
          //                   ),
          //                 ],
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Stack(
          //                     children: [
          //
          //                       ClipRRect(
          //                           borderRadius: const BorderRadius.only(
          //                             topLeft: Radius.circular(12),
          //                             bottomLeft: Radius.circular(12),
          //                           ),
          //                           child: Image.asset('assets/burger.jpg',width: MediaQuery.of(context).size.width * 0.2,)),
          //
          //                       Positioned.fill(
          //                         child: Container(
          //                           decoration: const BoxDecoration(
          //                             gradient: LinearGradient(
          //                                 begin: Alignment.topCenter,
          //                                 end: Alignment.bottomCenter,
          //                                 colors: [Colors.transparent, Colors.black12, Colors.black]),
          //                             borderRadius: BorderRadius.only(
          //                               bottomLeft: Radius.circular(12),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //
          //                       const Positioned(
          //                         bottom: 10,
          //                         left: 0,
          //                         right: 0,
          //                         child: Column(
          //                           children: [
          //                             Text('Unlimited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
          //                             Text('50% OFF',style: TextStyle(color: Colors.white,fontSize: 14),),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   SizedBox(width: 10,),
          //                   const Flexible(
          //                     flex: 1,
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                       children: [
          //                         Text('Taste Of Winges',style: TextStyle(fontSize: 18),),
          //                         Text('Beverages',style: TextStyle(fontSize: 14,color: Colors.black54),),
          //                         Row(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             Icon(Icons.timer,color:Color(0xFF8833ff),size: 20,),
          //                             SizedBox(width: 5,),
          //                             Text('40-45 min',style: TextStyle(fontSize: 14,color: Colors.black54),),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //
          //         SizedBox(width: 10,),
          //
          //         Column(
          //           children: [
          //             Container(
          //               width: MediaQuery.of(context).size.width * 0.6,
          //
          //               decoration: BoxDecoration(
          //                 // color: Colors.purple,
          //                 // color: Color(0xFF8833ff),
          //                 color: Color(0xFFFFFFFF),
          //                 borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.black.withOpacity(0.1),
          //                     spreadRadius: 2,
          //                     blurRadius: 4,
          //                     offset: Offset(1, 2), // changes position of shadow
          //                   ),
          //                 ],
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Stack(
          //                     children: [
          //
          //                       ClipRRect(
          //                           borderRadius: const BorderRadius.only(
          //                             topLeft: Radius.circular(12),
          //                             bottomLeft: Radius.circular(12),
          //                           ),
          //                           child: Image.asset('assets/burger.jpg',width: MediaQuery.of(context).size.width * 0.2,)),
          //
          //                       Positioned.fill(
          //                         child: Container(
          //                           decoration: const BoxDecoration(
          //                             gradient: LinearGradient(
          //                                 begin: Alignment.topCenter,
          //                                 end: Alignment.bottomCenter,
          //                                 colors: [Colors.transparent, Colors.black12, Colors.black]),
          //                             borderRadius: BorderRadius.only(
          //                               bottomLeft: Radius.circular(12),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //
          //                       const Positioned(
          //                         bottom: 10,
          //                         left: 0,
          //                         right: 0,
          //                         child: Column(
          //                           children: [
          //                             Text('Unlimited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
          //                             Text('50% OFF',style: TextStyle(color: Colors.white,fontSize: 14),),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   SizedBox(width: 10,),
          //                   const Flexible(
          //                     flex: 1,
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                       children: [
          //                         Text('Taste Of Winges',style: TextStyle(fontSize: 18),),
          //                         Text('Beverages',style: TextStyle(fontSize: 14,color: Colors.black54),),
          //                         Row(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             Icon(Icons.timer,color:Color(0xFF8833ff),size: 20,),
          //                             SizedBox(width: 5,),
          //                             Text('40-45 min',style: TextStyle(fontSize: 14,color: Colors.black54),),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             SizedBox(height: 10,),
          //             Container(
          //               width: MediaQuery.of(context).size.width * 0.6,
          //
          //               decoration: BoxDecoration(
          //                 // color: Colors.purple,
          //                 // color: Color(0xFF8833ff),
          //                 color: Color(0xFFFFFFFF),
          //                 borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.black.withOpacity(0.1),
          //                     spreadRadius: 2,
          //                     blurRadius: 4,
          //                     offset: Offset(1, 2), // changes position of shadow
          //                   ),
          //                 ],
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Stack(
          //                     children: [
          //
          //                       ClipRRect(
          //                           borderRadius: const BorderRadius.only(
          //                             topLeft: Radius.circular(12),
          //                             bottomLeft: Radius.circular(12),
          //                           ),
          //                           child: Image.asset('assets/burger.jpg',width: MediaQuery.of(context).size.width * 0.2,)),
          //
          //                       Positioned.fill(
          //                         child: Container(
          //                           decoration: const BoxDecoration(
          //                             gradient: LinearGradient(
          //                                 begin: Alignment.topCenter,
          //                                 end: Alignment.bottomCenter,
          //                                 colors: [Colors.transparent, Colors.black12, Colors.black]),
          //                             borderRadius: BorderRadius.only(
          //                               bottomLeft: Radius.circular(12),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //
          //                       const Positioned(
          //                         bottom: 10,
          //                         left: 0,
          //                         right: 0,
          //                         child: Column(
          //                           children: [
          //                             Text('Unlimited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
          //                             Text('50% OFF',style: TextStyle(color: Colors.white,fontSize: 14),),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   SizedBox(width: 10,),
          //                   const Flexible(
          //                     flex: 1,
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                       children: [
          //                         Text('Taste Of Winges',style: TextStyle(fontSize: 18),),
          //                         Text('Beverages',style: TextStyle(fontSize: 14,color: Colors.black54),),
          //                         Row(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             Icon(Icons.timer,color:Color(0xFF8833ff),size: 20,),
          //                             SizedBox(width: 5,),
          //                             Text('40-45 min',style: TextStyle(fontSize: 14,color: Colors.black54),),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //
          //       ],
          //     ),
          //   ),
          // ),
          //
          // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          //FOR YOU
          Stack(
            children: [
              const Positioned.fill(
                child: Divider(
                  color: Colors.black12,
                ),
              ),
              Center(
                  child: Container(
                      color: Color(0xFFFFFFFF),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text('EXPLORE',style: TextStyle(fontSize: 16,color: Colors.black54, fontWeight: FontWeight.w400,letterSpacing: 2),),
                      )
                  )
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),



          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CartScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // SvgPicture.asset('assets/discount.svg'),
                            Image.asset('assets/animation/offer.gif'),
                            const Text('Offers',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            const Text('Flat Discounts',style: TextStyle(fontSize: 12,color: Colors.black54),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset('assets/location.png'),
                          // SvgPicture.asset('assets/location.svg'),
                          // Image.asset('assets/animation/offer.gif'),
                          const Text('Top 10',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          const Text('Local Restaurant',style: TextStyle(fontSize: 11,color: Colors.black54),),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // SvgPicture.asset('assets/discount.svg'),
                          Image.asset('assets/football.png'),
                          // Image.asset('assets/animation/offer.gif'),
                          const Text('Play & Win',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          const Text('Exciting prizes',style: TextStyle(fontSize: 12,color: Colors.black54),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          //FOR YOU
          Stack(
            children: [
              const Positioned.fill(
                child: Divider(
                  color: Colors.black12,
                ),
              ),
              Center(
                  child: Container(
                      color: Color(0xFFFFFFFF),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text("WHAT'S ON YOUR MIND?",style: TextStyle(fontSize: 16,color: Colors.black54, fontWeight: FontWeight.w400,letterSpacing: 2),),
                      )
                  )
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,

                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [

                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: Image.asset('assets/burger.jpg',width: MediaQuery.of(context).size.width * 0.2,)),

                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.transparent, Colors.black12, Colors.black]),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                                const Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      Text('Unlimited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                      Text('50% OFF',style: TextStyle(color: Colors.white,fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            const Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Taste Of Winges',style: TextStyle(fontSize: 18),),
                                  Text('Beverages',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.timer,color:Color(0xFF8833ff),size: 20,),
                                      SizedBox(width: 5,),
                                      Text('40-45 min',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,

                        decoration: BoxDecoration(
                          // color: Colors.purple,
                          // color: Color(0xFF8833ff),
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(1, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [

                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: Image.asset('assets/burger.jpg',width: MediaQuery.of(context).size.width * 0.2,)),

                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.transparent, Colors.black12, Colors.black]),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                                const Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      Text('Unlimited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                      Text('50% OFF',style: TextStyle(color: Colors.white,fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            const Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Taste Of Winges',style: TextStyle(fontSize: 18),),
                                  Text('Beverages',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.timer,color:Color(0xFF8833ff),size: 20,),
                                      SizedBox(width: 5,),
                                      Text('40-45 min',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 10,),

                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,

                        decoration: BoxDecoration(
                          // color: Colors.purple,
                          // color: Color(0xFF8833ff),
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(1, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [

                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: Image.asset('assets/burger.jpg',width: MediaQuery.of(context).size.width * 0.2,)),

                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.transparent, Colors.black12, Colors.black]),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                                const Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      Text('Unlimited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                      Text('50% OFF',style: TextStyle(color: Colors.white,fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            const Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Taste Of Winges',style: TextStyle(fontSize: 18),),
                                  Text('Beverages',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.timer,color:Color(0xFF8833ff),size: 20,),
                                      SizedBox(width: 5,),
                                      Text('40-45 min',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,

                        decoration: BoxDecoration(
                          // color: Colors.purple,
                          // color: Color(0xFF8833ff),
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(1, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [

                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: Image.asset('assets/burger.jpg',width: MediaQuery.of(context).size.width * 0.2,)),

                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.transparent, Colors.black12, Colors.black]),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                                const Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      Text('Unlimited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                      Text('50% OFF',style: TextStyle(color: Colors.white,fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            const Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Taste Of Winges',style: TextStyle(fontSize: 18),),
                                  Text('Beverages',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.timer,color:Color(0xFF8833ff),size: 20,),
                                      SizedBox(width: 5,),
                                      Text('40-45 min',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          //FOR YOU
          Stack(
            children: [
              const Positioned.fill(
                child: Divider(
                  color: Colors.black12,
                ),
              ),
              Center(
                  child: Container(
                      color: Color(0xFFFFFFFF),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text("ALL RESTAURANTS",style: TextStyle(fontSize: 16,color: Colors.black54, fontWeight: FontWeight.w400,letterSpacing: 2),),
                      )
                  )
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          // Container(
          //   color: Colors.pink,
          //   height: 300,
          //   child: isLoading
          //       ? const Center(
          //     child: CircularProgressIndicator(),
          //   )
          //       : nearbyRestaurants.isNotEmpty
          //       ? ListView.builder(
          //     itemCount: nearbyRestaurants.length,
          //     itemBuilder: (context, index) {
          //       final restaurant = nearbyRestaurants[index];
          //       return Card(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Text(restaurant.restaurantName),
          //             Text(restaurant.restaurantLocation),
          //           ],
          //         ),
          //       );
          //     },
          //   )
          //       : Center(
          //     child: Text('No nearby restaurants found.'),
          //   ),
          // ),

          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.red,
            child: RestaurantHomeScreen(),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.9,),


        ],
      ),
    );
  }
}
