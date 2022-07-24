import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';

// function to separate the Items IDs received from Datastore
separateOrderItemIDs(orderIDs)
{
  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;

  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    // print("\nThis is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }

  // print("\nThis is Items List now = ");
  // print(separateItemIDsList);

  return separateItemIDsList;
}

// function to separate the items id from itemsID+counter in form of string
separateItemIDs()
{
  List<String> separateItemIDsList = [] , defaultItemList = [];
  int i=0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    // print("\nThis is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }

  // print("\nThis is Items List now = ");
  // print(separateItemIDsList);

  return separateItemIDsList;
}

// foodItemID ,context , that particular count of item
addItemToCart(String? foodItemId, BuildContext context, int itemCounter){

  // first  get the user cart then add new requested item to add
  List<String>? tempList = sharedPreferences!.getStringList("userCart");

  // we are adding item with their count so we concatenate them with : sign

  tempList!.add(foodItemId! + ":$itemCounter");      //12342221:7


  FirebaseFirestore.instance.collection("users")
      .doc(firebaseAuth.currentUser!.uid).update({
    "userCart": tempList,
  }).then((value)
  {
    Fluttertoast.showToast(msg: "Item Added Successfully.");

    // after items added Successfully update in local storage as well
    sharedPreferences!.setStringList("userCart", tempList);

    //update the badge for cart items counter
    // Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });


}

// separate quantities using order id
separateOrderItemQuantities(orderIDs)
{
  List<String> separateItemQuantityList=[];
  List<String> defaultItemList=[];
  int i=1;

  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();


    //0=:
    //1=7
    //:7
    List<String> listItemCharacters = item.split(":").toList();

    //7
    var quanNumber = int.parse(listItemCharacters[1].toString());

    // print("\nThis is Quantity Number = " + quanNumber.toString());

    separateItemQuantityList.add(quanNumber.toString());
  }

  // print("\nThis is Quantity List now = ");
  // print(separateItemQuantityList);

  return separateItemQuantityList;
}

// separate quantities
separateItemQuantities()
{
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i = 1;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();

    //0=:
    //1=7
    //:7
    List<String> listItemCharacters = item.split(":").toList();

    //7
    var quanNumber = int.parse(listItemCharacters[1].toString());

    // print("\nThis is Quantity Number = " + quanNumber.toString());

    separateItemQuantityList.add(quanNumber);
  }

  // print("\nThis is Quantity List now = ");
  // print(separateItemQuantityList);

  return separateItemQuantityList;
}

clearCartNow(context)
{
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": emptyList}).then((value)
  {
    sharedPreferences!.setStringList("userCart", emptyList!);

    // Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });
}