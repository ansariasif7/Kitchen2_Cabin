import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kitchen2cabin_seller_app/uploadScreens/items_upload_screen.dart';

import '../global/global.dart';
import '../model/items.dart';
import '../model/menus.dart';
import '../uploadScreens/menus_upload_screen.dart';
import '../widgets/items_design.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        //  hr ek icon ka theme balck krne ke liye
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
            icon: Icon(Icons.library_add,color: Colors.black),

            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsUploadScreen(model: widget.model,)));
            },

          )

        ],

      ),
      drawer: MyDrawer(),

      body: CustomScrollView(
          slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "My " + widget.model!.menuTitle.toString() + "'s Items")),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("menus")
                  .doc(widget.model!.menuID)
                  .collection("items").orderBy("publishedDate",descending: true).snapshots(),
              builder: (context, snapshot)
              {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                  child: Center(child: circularProgress(),),
                )
                    : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context, index)
                  {
                    Items model = Items.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                    );
                    return ItemsDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
         ]

      )

    );
  }
}
