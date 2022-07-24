import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kitchen2cabin_user_app/mainScreens/save_address_screen.dart';
import 'package:kitchen2cabin_user_app/widgets/simple_app_bar.dart';
import 'package:provider/provider.dart';

import '../assistantMethods/address_changer.dart';
import '../global/global.dart';
import '../models/address.dart';
import '../widgets/address_design.dart';
import '../widgets/progress_bar.dart';

class AddressScreen extends StatefulWidget {


  final double? totalAmount;
  final String? sellerUID;

  AddressScreen({this.totalAmount, this.sellerUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: SimpleAppBar(title: "Kitchen2Cabin",),

      floatingActionButton: FloatingActionButton.extended(

        isExtended: true,
        label: const Text("Add New ",style: TextStyle(fontSize: 16,color: Colors.black),),
        backgroundColor: Colors.green.shade200,
        icon: const Icon(Icons.add_location, color: Colors.black,),
        onPressed: ()
        {
          //save address to user collection
          Navigator.push(context, MaterialPageRoute(builder: (c)=> SaveAddressScreen()));
        },

      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children:  [
        Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Select Address:",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),

          Consumer<AddressChanger>(builder: (context, address, c){
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("users")
                    .doc(sharedPreferences!.getString("uid"))
                    .collection("userAddress")
                    .snapshots(),
                builder: (context, snapshot)
                {
                  return !snapshot.hasData
                      ? Center(child: circularProgress(),)
                      : snapshot.data!.docs.length == 0
                      ? Container()
                      : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index)
                    {
                      return AddressDesign(
                        currentIndex: address.count,
                        value: index,
                        addressID: snapshot.data!.docs[index].id,
                        totalAmount: widget.totalAmount,
                        sellerUID: widget.sellerUID,
                        model: Address.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String, dynamic>
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }),
      ],


      ),



    );
  }
}
