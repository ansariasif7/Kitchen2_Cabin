
import 'package:flutter/material.dart';


class SimpleAppBar extends StatelessWidget with PreferredSizeWidget
{

  final PreferredSizeWidget? bottom;
  final String? title;

  SimpleAppBar({this.bottom,this.title});

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context)
  {
    return AppBar(
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
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
      centerTitle: true,
      title:  Text(
        title! ,
        style: TextStyle(fontSize: 28,color: Colors.black),
      ),
    );
  }
}
