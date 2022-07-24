import 'package:flutter/material.dart';
import 'package:kitchen2cabin_user_app/mainScreens/items_screen.dart';
import 'package:kitchen2cabin_user_app/models/menus.dart';
import 'package:kitchen2cabin_user_app/models/sellers.dart';

class MenusDesignWidget extends StatefulWidget {


  Menus? model;
  BuildContext? context;

  MenusDesignWidget({this.model,this.context});

  @override
  State<MenusDesignWidget> createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {


  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model:widget.model!) ));

      },

        splashColor: Colors.greenAccent ,

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
                  widget.model!.menuTitle!,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontFamily: "Kiwi"
                  ),
                ),

                Text(
                  widget.model!.menuInfo!,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
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
