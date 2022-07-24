import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/sellers.dart';
import '../widgets/sellers_design.dart';

class SearchScreen extends StatefulWidget {


  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Future<QuerySnapshot>? restaurantsDocumentsList;
  String sellerNameText = "";

  initSearchingRestaurant(String textEntered)
  {
    restaurantsDocumentsList = FirebaseFirestore.instance
        .collection("sellers")
        .where("sellerName", isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
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

          title: TextField(
          onChanged: (textEntered)
          {
            setState(() {
              sellerNameText = textEntered;
            });
            //init search
            initSearchingRestaurant(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search Services Here...",
            hintStyle: const TextStyle(color: Colors.black54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search,color: Colors.black,),
              color: Colors.white,
              onPressed: ()
              {
                initSearchingRestaurant(sellerNameText);
              },
            ),
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),


      ),
      body: FutureBuilder<QuerySnapshot>(
        future: restaurantsDocumentsList,
        builder: (context, snapshot)
        {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index)
            {
              Sellers model = Sellers.fromJson(
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>
              );

              return SellersDesignWidget(
                model: model,
                context: context,
              );
            },
          ) : const Center(child: Text("No Record Found"),);

        },
      ),
    );
  }
}
