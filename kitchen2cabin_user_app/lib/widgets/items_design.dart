import 'package:flutter/material.dart';
import 'package:kitchen2cabin_user_app/mainScreens/item_detail_screen.dart';
import 'package:kitchen2cabin_user_app/models/items.dart';
import 'package:kitchen2cabin_user_app/models/menus.dart';
import 'package:kitchen2cabin_user_app/models/sellers.dart';

class ItemsDesignWidget extends StatefulWidget {


  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model,this.context});

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {


  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailsScreen(model : widget.model) ));
      },

        splashColor: Colors.greenAccent,

        child: Padding(

          padding: EdgeInsets.all(10.0),

          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Divider(
                  height: 5,
                  thickness:3 ,
                  color: Colors.grey[300],
                ),
                Image.network(
                  widget.model!.thumbnailUrl!,
                  height: 210,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 4.0,),
                Text(
                  widget.model!.title!,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      fontFamily: "Kiwi"
                  ),
                ),
                Text(
                  widget.model!.price.toString() + " ₹",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontFamily: "Kiwi"
                  ),
                ),
                Divider(
                  height: 5 ,
                  thickness:3 ,
                  color: Colors.grey[300],
                ),

              ],
            ),

          ),


        )


    );
  }
}
