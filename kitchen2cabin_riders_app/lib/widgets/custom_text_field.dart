import 'package:flutter/material.dart';

// this file basically make to enhance code re-usability just call this class
// and the new text feild is created
class CustomTextField extends StatelessWidget
{
  final TextEditingController ? controller;
  final IconData ? data;
  final String ? hinText;

  bool ? isObsecre = true;      // for making password text show in ***

  bool ? enabled = true;       // can we write down further on same field or not

  CustomTextField({

    this.controller,
    this.data,
    this.hinText,
    this.isObsecre,
    this.enabled,

});
  // const CustomTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: const BoxDecoration(

        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10))

      ),
      padding: const EdgeInsets.all(8.0),
      margin:  EdgeInsets.all(10),
      child: TextFormField (
      enabled: enabled ,
        controller: controller,
        obscureText: isObsecre!,            // check for not null using '!' symbol
        cursorColor: Theme.of(context ).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
              prefixIcon: Icon(
             data,
                color: Colors.cyan.shade100,

        ),
            focusColor: Theme.of(context ).primaryColor,
          hintText: hinText,


        ),
      ),

    );
  }
}
