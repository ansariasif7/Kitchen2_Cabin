import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kitchen2cabin_seller_app/global/global.dart';
import 'package:kitchen2cabin_seller_app/uploadScreens/menus_upload_screen.dart';
import 'package:kitchen2cabin_seller_app/widgets/my_drawer.dart';

import '../authentication/auth_screen.dart';
import '../model/menus.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/info_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  RestrictBlockSellerFromUsingApp() async
  {
    await FirebaseFirestore.instance.collection("sellers")
        .doc(firebaseAuth.currentUser!.uid)
        .get().then((snapshot){

      if(snapshot.data()!["status"] != "approved")
      {
        Fluttertoast.showToast(msg: "You are blocked by Admin. \n\n Mail here : admin1@gmail.com ");
        firebaseAuth.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
      }


    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RestrictBlockSellerFromUsingApp();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      drawer: MyDrawer(),

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
          // get the name from local storage to show upo quickly
          sharedPreferences!.getString("name")!,
          style: const TextStyle( fontSize: 30, fontFamily: "Lobster" ,color: Colors.black),
        ),
        centerTitle:  true,
        automaticallyImplyLeading: true,

        // right side me button generation  ke  liye

        actions: [

          IconButton(
            icon: Icon(Icons.post_add,color: Colors.black),

            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=>const MenusUploadScreen()));
            },

          )

        ],

      ),

      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "My Menus")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("menus").orderBy("publishedDate",descending: true).snapshots(),
            builder: (context, snapshot)
            {
              // if data is not found then show the circular progress bar otherwise show the content
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                child: Center(child: circularProgress(),),
              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                  Menus model = Menus.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return InfoDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ],
      )
    );
  }
}


