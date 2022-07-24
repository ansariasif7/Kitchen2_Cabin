import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kitchen2cabin_user_app/assistantMethods/assistant_methods.dart';
import 'package:kitchen2cabin_user_app/authentication/login.dart';
import 'package:kitchen2cabin_user_app/splashScreen/splash_screen.dart';

import '../authentication/auth_screen.dart';

import '../global/global.dart';
import '../models/sellers.dart';
import '../widgets/sellers_design.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // items for displaying the slider on home page
  final items = [

    "slider/1.jpg",
    "slider/2.jpg",
    "slider/3.jpg",
    "slider/4.jpg",
    "slider/5.jpg",
    "slider/6.jpg",
    "slider/7.jpg",
    "slider/8.jpg",
    "slider/9.jpg",
    "slider/10.jpg",
    "slider/11.jpg",
    "slider/12.jpg",
    "slider/13.jpg",
  ];

  RestrictBlockUserFromUsingApp() async
  {
    await FirebaseFirestore.instance.collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get().then((snapshot){

      if(snapshot.data()!["status"] != "approved")
        {
          Fluttertoast.showToast(msg: "You are blocked by Admin. \n\n Mail here : admin1@gmail.com ");
          firebaseAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      else
        {
          clearCartNow(context);

        }


    });
  }

@override
  void initState() {

  super.initState();


    RestrictBlockUserFromUsingApp();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
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

        title: const Text(

          "Kitchen2Cabin",
          style: TextStyle( fontSize: 35, fontFamily: "Signatra" ,color: Colors.black),

        ),
        centerTitle:  true,
        automaticallyImplyLeading: true,

      ),

      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .3,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration: const Duration(milliseconds: 500),
                    autoPlayCurve: Curves.decelerate,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: items.map((index) {
                    return Builder(builder: (BuildContext context){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            index,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),

          // here we are showing the info of all registered sellers
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                   Sellers sModel = Sellers.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>
                  );
                  //design for display sellers services org
                  return SellersDesignWidget(
                    model: sModel,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),

        ],




      ),






    );
  }
}


