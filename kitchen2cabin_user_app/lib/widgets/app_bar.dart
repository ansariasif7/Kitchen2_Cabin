import 'package:flutter/material.dart';

import '../mainScreens/cart_screen.dart';


// app bar for item and item details screen

class MyAppBar extends StatefulWidget with PreferredSizeWidget
{
  final PreferredSizeWidget? bottom;
  final String ? sellerUID;
  MyAppBar({this.bottom,this.sellerUID});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return  AppBar(

    //  hr ek icon ka theme black krne ke liye
    iconTheme: const IconThemeData(color: Colors.black),
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

    leading: IconButton(
    icon:  Icon(Icons.arrow_back,color: Colors.black,),
    onPressed: (){
    Navigator.pop(context);
    },
    ),

    title: const Text(

    "Kitchen2Cabin",
    style: TextStyle( fontSize: 35, fontFamily: "Signatra" ,color: Colors.black),
    ),
    centerTitle:  true,
    automaticallyImplyLeading: true,

    // right side me button generation  ke  liye

    actions: [
    Stack(
    children: [
    IconButton(
    icon: Icon(Icons.shopping_cart,color: Colors.black),

    onPressed: (){

    // sending user to cart screen
    Navigator.push(context, MaterialPageRoute(builder: (c)=>CartScreen(sellerUID : widget.sellerUID)));
    },

    ),
    // Positioned(
    // child: Stack(
    // children: const [
    // Icon(
    // Icons.brightness_1_rounded,
    // size : 15,
    // color: Colors.black,
    // ),
    //
    // Positioned(
    // top: 3,
    // right: 4,
    // child: Center(
    //
    // child: Text("0",style:TextStyle(color: Colors.white,fontSize: 12.0),),
    //
    // ),
    //
    // ),
    //
    // ],
    // ),
    //
    // ),
    ],

    ),
    ],

    );
  }
}
