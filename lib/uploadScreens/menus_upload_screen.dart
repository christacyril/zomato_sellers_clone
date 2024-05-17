import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:zomatosellers/widgets/error_dialog.dart';
import 'package:zomatosellers/widgets/progress_bar.dart';

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({super.key});

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: zomatocolor,
      title: Text("Add New Menu",
      style:  TextStyle(
        color: Colors.white,
      ),),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shop_sharp, color: zomatocolor,size: 200,),
              ElevatedButton(
                  onPressed: (){
                    takeImage(context);
                  },
                  child: Text("Add new menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: zomatocolor
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext){
    return showDialog(
        context: mContext,
        builder: (context){
          return SimpleDialog(
           title: Text("Menu Image",
           style: TextStyle(
             color: zomatocolor,
             fontWeight: FontWeight.bold
           ),),
            children: [


              SimpleDialogOption(
                child: Text("Capture with camera",
                style: TextStyle(
                  color: Colors.grey,
                ),),
                onPressed: captureImageWithCamera,
              ),



              SimpleDialogOption(
                child: Text("Select from Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),),
                onPressed: pickImageFromGallery,
              ),


              SimpleDialogOption(
                child: Text("Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),),
                onPressed: ()=> Navigator.pop(context),
              ),
            ],
          );
        });
  }

  captureImageWithCamera() async{
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(source : ImageSource.camera,
    maxWidth: 1280,
      maxHeight: 720
    );
    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async{
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(source : ImageSource.gallery,
    maxWidth: 1280,
      maxHeight: 720
    );
    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: zomatocolor,
        title: Text("Uploading New Menu",
        style:  TextStyle(
          fontSize: 20,
          color: Colors.white
        ),),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          color: Colors.white,
          ), onPressed: () {
            clearMenusUploadForm();
        },
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(onPressed: uploading? null: () => validateUploadForm(),
              child: Text(
                "Add",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width *0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.title,
            color: zomatocolor,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(
                  color: Colors.black
                ),
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Menu Title",
                  hintStyle: TextStyle(
                    color: Colors.grey
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: zomatocolor,
          thickness: 2,),


          ListTile(
            leading: Icon(Icons.perm_device_information_outlined,
              color: zomatocolor,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(
                    color: Colors.black
                ),
                controller: shortInfoController,
                decoration: InputDecoration(
                  hintText: "Menu Info",
                  hintStyle: TextStyle(
                      color: Colors.grey
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: zomatocolor,
            thickness: 2,),
        ],
      ),
    );
  }

  clearMenusUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async{
    if(imageXFile != null){
     if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty){
  setState(() {
    uploading = true;
  });

  //upload image

       String downloadUrl = await uploadImage(File(imageXFile!.path));

       // save info to firestore
       saveInfoToFirestore(downloadUrl);
    }
     else{
       showDialog(context: context,
           builder: (context){
         return ErrorDialog(
           message: "Please write title and info for menu",
         );
           });
     }
    }
    else {
      showDialog(context: context,
          builder: (context){
        return ErrorDialog(
          message: "Please pick an image for menu",
        );
          });
    }
  }

  saveInfoToFirestore(String downloadUrl){
    final ref = FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid")).collection("menus");

    ref.doc(uniqueIdName).set({
      "menuID" : uniqueIdName,
      "sellerID": sharedPreferences!.getString("uid"),
      "menuInfo": shortInfoController.text.trim(),
      "menuTitle" : titleController.text.trim(),
      "publishedDate" : DateTime.now(),
      "status" : "available",
       "thumbnailUrl" : downloadUrl,
    });

    clearMenusUploadForm();

    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading= false;
    });
  }

uploadImage(mImageFile) async{
    storageRef.Reference reference = storageRef.FirebaseStorage.instance.ref().child("menus");
    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
}

  @override
  Widget build(BuildContext context) {
    return imageXFile == null? defaultScreen(): menusUploadFormScreen();
  }
}
