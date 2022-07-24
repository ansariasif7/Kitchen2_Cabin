import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchen2cabin_seller_app/authentication/auth_screen.dart';
import 'package:kitchen2cabin_seller_app/global/global.dart';
import 'package:kitchen2cabin_seller_app/mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  // after how much time splash screen will turn into login and signup screen
  startTimer()
  {
    //Text("YY");
    Timer(const Duration(seconds:2),() async {

      // if seller is already logged in then take seller to home screen
      if(firebaseAuth.currentUser != null)
        {
          Navigator.push(context,MaterialPageRoute(builder: (c)=> const HomeScreen()));
        }
      else               // take it on Auth screen
        {
          Navigator.push(context,MaterialPageRoute(builder: (c)=> const AuthScreen()));
        }

      // auth screen ko call kr liya

    } );



  }

  // this function automatically call when user comes on this splash screen
  @override
  void initState() {
    // startTimer();
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("images/splash.jpg", ),
              ),

             const SizedBox(height: 10 , ),

              const Padding(
                padding:  EdgeInsets.all(18.0),
                child: Text(
                  "Kitchen2Cabin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:  Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",

                  ),


                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
