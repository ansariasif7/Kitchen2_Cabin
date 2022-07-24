import 'package:flutter/material.dart';
import 'package:kitchen2cabin_user_app/mainScreens/menus_screen.dart';
import 'package:kitchen2cabin_user_app/models/sellers.dart';

class SellersDesignWidget extends StatefulWidget {


  Sellers? model;
  BuildContext? context;

   SellersDesignWidget({this.model,this.context});

  @override
  State<SellersDesignWidget> createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {


  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MenusScreen(model : widget.model)));
      },
      splashColor: Colors.greenAccent,

      child: Padding(

        padding: EdgeInsets.all(10.0),

        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 5,
                thickness:3 ,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.sellerAvatarUrl!,
                height: 210,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10.0,),

              Text(
                widget.model!.sellerName!,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
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
