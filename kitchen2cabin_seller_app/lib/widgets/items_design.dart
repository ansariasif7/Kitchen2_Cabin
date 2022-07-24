



import 'package:flutter/material.dart';
import 'package:kitchen2cabin_seller_app/model/items.dart';

import '../mainScreens/item_detail_screen.dart';
import '../mainScreens/itemsScreen.dart';
import '../model/menus.dart';



class ItemsDesignWidget extends StatefulWidget
{
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});

  @override
  _ItemsDesignWidgetState createState() => _ItemsDesignWidgetState();
}



class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {


    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailsScreen(model: widget.model)));
      },

      splashColor: Colors.amber,
      child: Padding(

        padding:  EdgeInsets.all(5.0),


        child: Container(

          height: 280,
          width: MediaQuery.of(context).size.width,

          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              SizedBox(height: 1,),
              Text(
                widget.model!.title!,
                style:  TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontFamily: "Train",
                ),
              ),
               SizedBox(height: 2,),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
               SizedBox(height: 2.0,),

              Text(
                widget.model!.shortInfo!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
               SizedBox(height: 1,),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

