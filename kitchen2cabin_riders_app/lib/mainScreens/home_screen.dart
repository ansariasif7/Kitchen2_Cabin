import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kitchen2cabin_riders_app/mainScreens/history_screen.dart';
import 'package:kitchen2cabin_riders_app/mainScreens/parcel_in_progress_screeen.dart';

import '../assistantMethods/get_current_location.dart';
import '../authentication/auth_screen.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import 'earnings_screen.dart';
import 'new_orders_screen.dart';
import 'not_yet_delivered_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  Card makeDashboardItem(String title, IconData iconData, int index)
  {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ?  BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan.shade100,
                Colors.green.shade200,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        )
            :  BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade200,
                Colors.cyan.shade100,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: InkWell(
          onTap: ()
          {
            if(index == 0)
            {
              //New Available Orders
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrdersScreen()));
            }
            if(index == 1)
            {
              //Parcels in Progress
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelInProgressScreen()));

            }
            if(index == 2)
            {
              //Not Yet Delivered
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NotYetDeliveredScreen()));

            }
            if(index == 3)
            {
              //History

              Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));

            }
            if(index == 4)
            {
              //Total Earnings

              Navigator.push(context, MaterialPageRoute(builder: (c)=> EarningsScreen()));


            }
            if(index == 5)
            {
              //Logout
              firebaseAuth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50.0),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RestrictBlockRiderFromUsingApp() async
  {
    await FirebaseFirestore.instance.collection("riders")
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
        UserLocation uLocation = UserLocation();
        uLocation.getCurrentLocation();
        getPerParcelDeliveryAmount();
        getRiderPreviousEarnings();


      }


    });
  }


  @override
  void initState() {
    super.initState();

    RestrictBlockRiderFromUsingApp();

  }

  getRiderPreviousEarnings()
  {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap)
    {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  getPerParcelDeliveryAmount()
  {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("Q4KwPczZRwWlgjj6BARR")
        .get().then((snap)
    {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
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

        title: Text(
            "Welcome " +
          // get the name from local storage to show upo quickly
          sharedPreferences!.getString("name")!.toUpperCase(),
          style: const TextStyle( fontSize: 25, fontFamily: "Lobster" ,color: Colors.black),
        ),
        centerTitle:  true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("New Available Orders", Icons.assignment, 0),
            makeDashboardItem("Parcels in Progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not Yet Delivered", Icons.location_history, 2),
            makeDashboardItem("History", Icons.done_all, 3),
            makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
            makeDashboardItem("Logout", Icons.logout, 5),
          ],
        ),
      ),

    );
  }
}


