import 'package:flutter/material.dart';
import 'package:kitchen2cabin_seller_app/authentication/login.dart';
import 'package:kitchen2cabin_seller_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length:2,
      child: Scaffold(
        appBar:  AppBar(
          flexibleSpace: Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.shade100,
                  Colors.green,
                ],
                begin :  const FractionalOffset(0.0, 0.0),
                end:  const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
              )
            ),
          ),

          automaticallyImplyLeading: false,      // for removing back button from screen

          title: const Text(
              "Kitchen2Cabin",
            style: TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontFamily: "Signatra",

            ),

          ),
          centerTitle: true,

          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock,color:Colors.black ,),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
                // text: ("Login")  ,

              ),
              Tab(
                icon: Icon(Icons.person,color:Colors.black ,),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )
                //text: "Register",
              )

            ],
            indicatorColor :Colors.white38 ,
            indicatorWeight: 6,
          ),

        ) ,

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.cyan.shade100,
                Colors.green
              ]
            )
          ),
          child: const TabBarView(
            children: [
              LoginSreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),


    );
  }
}
