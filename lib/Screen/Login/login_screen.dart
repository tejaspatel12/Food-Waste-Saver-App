import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Color(0xFF8833ff),
      backgroundColor: Color(0xFFffffff),
      // appBar: AppBar(title: Text('Home')),
      body: Container(

        color: Color(0xFF8833ff).withOpacity(0.2),
        child: Stack(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.32,
                  color: Color(0xFF8833ff).withOpacity(0.4),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03,),

                      Text('Login',style: TextStyle(color: Colors.black54,fontSize: 20,fontWeight: FontWeight.w900),),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                      
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
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                              Icon(Icons.person,color:Color(0xFF8833ff),size: 30,),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.015,),
                              Text("Mobile Number",style: TextStyle(color: Colors.black54,fontSize: 18),),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

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
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                              Icon(Icons.lock,color:Color(0xFF8833ff),size: 30,),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.015,),
                              Text("Password",style: TextStyle(color: Colors.black54,fontSize: 18),),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.purple,
                            color: Color(0xFF8833ff),
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
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Center(child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 16),)),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),

            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                ),
                height: 90,
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
