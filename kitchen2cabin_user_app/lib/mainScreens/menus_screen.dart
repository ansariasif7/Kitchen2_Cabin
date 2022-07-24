import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kitchen2cabin_user_app/assistantMethods/assistant_methods.dart';
import 'package:kitchen2cabin_user_app/models/sellers.dart';
import 'package:kitchen2cabin_user_app/splashScreen/splash_screen.dart';
import 'package:kitchen2cabin_user_app/widgets/menus_design.dart';
import '../global/global.dart';
import '../models/menus.dart';
import '../widgets/sellers_design.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';


class MenusScreen extends StatefulWidget {


  final Sellers? model;
  MenusScreen({this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


        // drawer: MyDrawer(),

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

          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              clearCartNow(context);
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));

              // Fluttertoast.showToast(msg: "Cart cleared Successfully");
            },

          ),

          title: const Text(
            // get the name from local storage to show upo quickly
            "Kitchen2Cabin",
            style: TextStyle( fontSize: 35, fontFamily: "Signatra" ,color: Colors.black),
          ),
          centerTitle:  true,
          automaticallyImplyLeading: true,


        ),

        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: widget.model!.sellerName.toString() + " Menus")),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(widget.model!.sellerUID)
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
                    return MenusDesignWidget(
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


