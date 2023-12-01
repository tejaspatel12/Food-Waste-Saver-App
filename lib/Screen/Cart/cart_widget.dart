import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/Cart.dart';

class CartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the Cart model using Provider.of
    Cart cart = Provider.of<Cart>(context);

    return Scaffold(
      body: Container(
        color: Color(0xFF8833ff),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${cart.totalItems} item added',
                    style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w900),
                  ),
                  SizedBox(width: 5,),
                  Icon(Icons.arrow_circle_right,color: Colors.white,size: 20,),
                ],
              ),
              Text(
                'Example ${cart.totalItems} item added.',
                style: TextStyle(fontSize: 12,color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
