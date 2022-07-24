import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'auth_screen.dart';

class LoginSreen extends StatefulWidget {
  const LoginSreen({Key? key}) : super(key: key);

  @override
  State<LoginSreen> createState() => _LoginSreenState();
}

class _LoginSreenState extends State<LoginSreen> {

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();


  // function to validate the user who try to login
  formValidation()
  {
    // both fields are non null
    if( emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty)
    {
      //login
      loginNow();
    }
    else        // show dialog box for filled up all fields
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "Please fill all fields.",
            );
          }
      );
    }
  }

  // func to logging in with user fetched data
  loginNow() async
  {
    showDialog(
        context: context,
        builder: (c)
        {
          return LoadingDialog(
            message: "Checking Credentials",
          );
        }
    );

    User? currentUser;
    // signInWithEmailAndPassword for firebase to check user correctness
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim(),
    ).then((auth){
      currentUser = auth.user!;    // assign the authenticated user  to curr user
    }).catchError((error){
      Navigator.pop(context);     // remove navigation bar and show the error
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );
    });
    if(currentUser != null)     //if authenticated successfully
    {
      readDataAndSetDataLocally(currentUser!);
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    // firestore se data retrieve kr rhe and locally save kr diya so that
    // we dont have to retrieve multiple times from firestore
     await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).get().then((snapshot) async {

       // sellers ke stored database me exist krta hoga to hm log sign in ho jaayenge
       if(snapshot.exists)
         {
           if(snapshot.data()!["status"] == "approved")
           {
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!
              .setString("email", snapshot.data()!["email"]);
          await sharedPreferences!.setString("name", snapshot.data()!["name"]);
          await sharedPreferences!
              .setString("photoUrl", snapshot.data()!["photoUrl"]);

          // retrieve the curr online user cart and save them locally as well
          List<String> userCartList =
              snapshot.data()!["userCart"].cast<String>();
          await sharedPreferences!.setStringList("userCart", userCartList);

          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        }
           else
             {
               firebaseAuth.signOut();       // pehle sign out kr denge Blocked seller ko
               Navigator.pop(context);
               Fluttertoast.showToast(msg: "You are blocked by Admin. \n\n mail here : admin1@gmail.com ");


             }
      }
       else        // sellers ke stored database me exist nhi krta hoga to hm log errorBox show kr denge
         {
           // why do need this because we store all sellers ,users and riders data under same project
           //  with different collection . So we want no rider or user can access account of seller etc..
          // so for simplifying query  we do this

           firebaseAuth.signOut();       // pehle sign out kr denge current seller ko
           Navigator.pop(context);        // then dialog box band kr denge then auth screen pe fwd kr denge
           Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

           showDialog(
               context: context,
               builder: (c)
               {
                 return ErrorDialog(
                   message: "No record found , kindly Register",
                 );
               }
           );
         }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),

              child: Image.asset(
                "images/welcome2.png",
                fit: BoxFit.fitWidth,
                height: 240,

              ),
            ),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email ,
                  controller:  emailcontroller ,
                  hinText: "e-mail" ,
                  isObsecre: false ,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller:  passwordcontroller,
                  hinText: "Password",
                  isObsecre: true ,
                ),
              ],
            ),
          ),

          ElevatedButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold, ),
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50 , vertical: 10)
            ),
            onPressed: (){

              formValidation();

            },
          ),
        ],
      ),

    );
  }
}
