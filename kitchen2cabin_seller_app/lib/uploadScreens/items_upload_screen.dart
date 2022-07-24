import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen2cabin_seller_app/mainScreens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

import '../global/global.dart';
import '../model/menus.dart';
import '../widgets/error_dialog.dart';
import '../widgets/progress_bar.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  ItemsUploadScreen({this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController  shortInfoController = TextEditingController();
  TextEditingController  titleController = TextEditingController();
  TextEditingController  descriptionController = TextEditingController();
  TextEditingController  priceController = TextEditingController();

  // for checking status of uploading menu items
  bool uploading = false;

  // unique id name for menus upload
  String uniqueIdName =  DateTime.now().microsecondsSinceEpoch.toString();


  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(

        iconTheme: const IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.shade100,
                  Colors.green,
                ],
                begin :  const FractionalOffset(0.0, 0.0),
                end:  const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),

        title: const Text(
          "Add New Item",
          style: const TextStyle( fontSize: 30, fontFamily: "Lobster" ,color:  Colors.black),
        ),
        centerTitle:  true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          },
        ),
      ),

      body: Container(

        decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan.shade100,
                Colors.green,
              ],
              begin :  const FractionalOffset(0.0, 0.0),
              end:  const FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            )
        ),

        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_two,color: Colors.black,size: 200.0,),
              ElevatedButton(

                child:  const Text(
                  "Add New Item",
                  style: TextStyle (

                    color: Colors.white,
                    fontSize: 18,
                  ),

                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: (){

                  takeImage(context);

                },
              )


            ],
          ),

        ),

      ),

    );
  }

  // Method for take the image from seller
  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (context)
      {
        return  SimpleDialog(
          title: Text("Menu Image", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),

          children: [

            SimpleDialogOption(
              child:  const Text(
                "Capture with camera",
                style: TextStyle(color: Colors.grey),

              ),

              onPressed: captureImageWithCamera,

            ),
            SimpleDialogOption(
              child:  const Text(
                "Select from gallery",
                style: TextStyle(color: Colors.grey),

              ),

              onPressed: pickImageFromGallery,

            ),

            SimpleDialogOption(
              child:  const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),

              ),


              onPressed:()=> Navigator.pop(context),

            ),

          ],


        );

      },
    );



  }

// Method for capture image for menu from camera
  captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.camera,

      maxHeight: 720 ,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });


  }
//   Method for the menu   for capture image for menu from gallery
  pickImageFromGallery() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.gallery,

      maxHeight: 720 ,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });


  }

  itemsUploadFormScreen()
  {
    return Scaffold(

      appBar: AppBar(

        iconTheme: const IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.shade100,
                  Colors.green,
                ],
                begin :  const FractionalOffset(0.0, 0.0),
                end:  const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),

        title: const Text(
          "Uploading New Item",
          style: const TextStyle( fontSize: 21, fontFamily: "Lobster" ,color:  Colors.black),
        ),
        centerTitle:  true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: (){

            clearMenusUploadForm();
            //Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

          },

        ),
        actions: [

          TextButton(
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "VarelaRound",
                letterSpacing: 2,
              ),
            ),
            onPressed: uploading ? null : ()=> validateUploadForm(),

          )

        ],
      ),

      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                          File(imageXFile!.path)
                        // File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.title,  color: Colors.black,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Item Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_information,  color: Colors.black,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "Items info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.description,  color: Colors.black,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description of Item",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_rounded,  color: Colors.black,),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number ,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "Price(per unit)",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),

    );
  }

  // Method for clear info  in case of cancel button
  clearMenusUploadForm()
  {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      descriptionController.clear();
      priceController.clear();
      imageXFile = null;
    });
  }

  // Method for Validating the menu and save the info
  validateUploadForm() async
  {


    if(imageXFile != null)      // if image is selected
        {
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && priceController.text.isNotEmpty )
      {
        setState(() {
          uploading = true;
        });

        //upload image & firebase me store krao using uploadImage and fn return the downloaded url of that
        // image from firebase
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        // save info to firestore
        saveInfo(downloadUrl);
        Fluttertoast.showToast(msg: "Item Added Successfully.");
      }
      else
      {
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please fill  All details.",
              );
            }
        );
      }
    }
    else
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "Please pick an image for menu.",
            );
          }
      );
    }
  }

  // A Method to upload the given image to fireStore
  // mImageFile is image uploaded by seller
  uploadImage (mImageFile) async
  {

    //"menus" folder me store kra rhe with unique id which is time
    storageRef.Reference reference = storageRef.FirebaseStorage.instance.ref().child("items");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    // return downloaded-able URL get from firebase for saving the info
    return downloadURL;

  }

  // mImageFile is image uploaded by seller
  saveInfo(String downloadUrl)
  {
    // seller ke collection me currentUser ke doc me ,  menu collection create hua then usme current menu ko upload kiya
    final ref = FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid")).collection("menus").doc(widget.model!.menuID).collection("items");

    // then for that document we set the variables
    ref.doc(uniqueIdName).set({
      "itemID": uniqueIdName,
      "menuID": widget.model!.menuID,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text),
      "title": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then((value){
      final itemsRef = FirebaseFirestore.instance.collection("items");
      itemsRef.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "menuID": widget.model!.menuID,
        "sellerUID": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "longDescription": descriptionController.text.toString(),
        "price": int.parse(priceController.text),
        "title": titleController.text.toString(),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
      });


    }).then((value){
      clearMenusUploadForm();

      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });

    /*
    // After uploading clear the menu upload form
    clearMenusUploadForm();

    // after that re-initialize the variables or controllers for menu form bcz same be used
    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return  imageXFile == null ? defaultScreen() : itemsUploadFormScreen() ;
  }
}
