import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController Phonecontroller = TextEditingController();
  TextEditingController Locationcontroller = TextEditingController();


  XFile? imageXFile;  // var name for store image taken from seller on cloud

  final ImagePicker _picker = ImagePicker();
  List<Placemark>? placeMarks;
  Position? position;
  String completeAddress = "";
  String sellerImageUrl = "";

// function used to store image to imageXfile
  Future<void> _getImage() async
  {
     // here we are allowing to get the image from his/her gallery
      imageXFile = await  _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        imageXFile;
      });

  }

  // function used to get the location of seller
   getCurrentLocation() async {

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await  placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,

    );

    Placemark  pMark = placeMarks![0];

    // complete address by dependencies from pub.dev geocoding and geolocator
      completeAddress =  '${pMark.subThoroughfare} ${pMark.thoroughfare},${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea} ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    Locationcontroller.text = completeAddress;

  }

  // function used to validate
  Future<void> formValidation() async
  {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please select an image.",
            );
          }
      );
    }
    else
    {
      if(passwordcontroller.text == confirmPasswordController.text)
      {
        if(confirmPasswordController.text.isNotEmpty && emailcontroller.text.isNotEmpty && namecontroller.text.isNotEmpty && Phonecontroller.text.isNotEmpty && Locationcontroller.text.isNotEmpty)
        {
           // saving data to firebase

          showDialog(
              context: context,
              builder: (c)
              {
                return LoadingDialog(
                  message: "Registering... Account ",
                );
              }
          );
          // unique filename for images
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();

          // where seller data gonna store make folder for this "sellers"
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("riders").child(fileName);

          // imageXFile var me apni photo gyi hain na to store kra di
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));

          // downloaded link string me form me generate ho rha
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          // sellerImageUrl me store kra de rhe URl ko
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;

            //save info to firestore
            authenticateSellerAndSignUp();
          });


        }
        else
          {
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorDialog(
                    message: "Please fill all fields for Register.",
                  );
                }
            );
          }
      }
      else
        {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: "Password do not match.",
                );
              }
          );

        }


    }
  }


  void authenticateSellerAndSignUp() async
  {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim(),
    ).then((auth) {
      currentUser = auth.user;
    }).catchError((error){

      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString() ,
            );
          }
      );

    });

    if(currentUser != null)
    {
      Fluttertoast.showToast(msg: "Registered Successfully.");
      // seller authenticated hai and then store the data of seller to firestore and locally
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        //send current_user to homePage
        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  // function used to store data to firestore
  Future saveDataToFirestore(User currentUser) async
  {
    // sellers  folder me hr ek seller ko unique id se store kr rhe Authentication krne ke baad
    FirebaseFirestore.instance.collection("riders").doc(currentUser.uid).set({
      "riderUID": currentUser.uid,
      "riderEmail": currentUser.email,
      "riderName": namecontroller.text.trim(),
      "riderAvatarUrl": sellerImageUrl,
      "phone": Phonecontroller.text.trim(),
      "address": completeAddress,
      "status": "approved",     // by default allow all seller to sell
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", namecontroller.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:Container(
          child:  Column(
            mainAxisSize: MainAxisSize.max ,
            children: [

             const SizedBox(height: 10 ,) ,

              InkWell(

                onTap : ()
                 {
                   _getImage();
                 },

                child: CircleAvatar(
                  // this statment takes radius as 20% of screen size
                  radius: MediaQuery.of(context).size.width * 0.20 ,

                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null ? null : FileImage(File(imageXFile!.path)) ,
                  child: imageXFile == null
                      ?
                  Icon(

                    Icons.add_photo_alternate ,
                    size: MediaQuery.of(context).size.width * 0.20  ,
                    color: Colors.grey ,
                  ):null ,

                ),
              ),

              const SizedBox(height: 10 ,) ,

              Form(
                key:  _formkey,
                child: Column(
                  children: [

                    CustomTextField(
                      data: Icons.person,
                      controller:  namecontroller,
                      hinText: "Name",
                      isObsecre: false,

                    ),
                    CustomTextField(
                      data: Icons.email,
                      controller:  emailcontroller,
                      hinText: "e-mail",
                      isObsecre: false,

                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller:  passwordcontroller,
                      hinText: "Password",
                      isObsecre: true ,
                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller:  confirmPasswordController ,
                      hinText: "Confirm Password",
                      isObsecre: true,
                    ),
                    CustomTextField(
                      data: Icons.phone,
                      controller:  Phonecontroller,
                      hinText: "Phone",
                      isObsecre: false,

                    ),
                    CustomTextField(
                      data: Icons.my_location,
                      controller:  Locationcontroller,
                      hinText: "My Current Address",
                      isObsecre: false,
                      enabled: true,
                    ),

                    Container(
                      width: 400,
                      height:  40,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        label: const Text(

                          "Get My current location",
                          style: TextStyle(color: Colors.white),


                        ),
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          getCurrentLocation();
                        },

                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )
                        ),
                      ),
                    )

                  ],

                ),

              ),

              const SizedBox(height:30 ,),

              ElevatedButton(
                child: const Text(
                  "Sign-Up",
                  style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold, ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50 , vertical: 10)
                ),
                onPressed: (){
                  formValidation();
                }
                ,
              ),
              const SizedBox(height:30 ,),

            ],

          ),
        ) ,

    );
  }
}
