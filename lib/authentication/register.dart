import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatosellers/authentication/login.dart';
import 'package:zomatosellers/mainScreen/home_screen.dart';
import 'package:zomatosellers/provider/form_state.dart';
import 'package:zomatosellers/widgets/error_dialog.dart';
import 'package:zomatosellers/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = "";

  Position? position;
  List<Placemark>? placeMarks;

  String completeAddress = "";

  Future<void> _getImage() async{
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async{
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress = "${pMark.subThoroughfare}${pMark.subLocality}${pMark.locality}${pMark.subAdministrativeArea}${pMark.postalCode}${pMark.country}";

    locationController.text = completeAddress;
  }

  Future<void> formValidation() async{
    if(imageXFile == null) {
      showDialog(context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please select an image.",
            );
          });
    }
    else {
      if (passwordController.text == confirmPasswordController.text) {
        if (nameController.text.isNotEmpty && emailController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty && phoneController.text.isNotEmpty && locationController.text.isNotEmpty) {
          showDialog(context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Registering Account",
                );
              });
          String fileName = DateTime
              .now()
              .millisecondsSinceEpoch
              .toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref()
              .child("sellers")
              .child(fileName);
          fStorage.UploadTask uploadTask = reference.putFile(
              File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask
              .whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl= url;

            //save information to firestore
              authentication();
          });
        }
        else{
          showDialog(context: context,
              builder: (c){
             return ErrorDialog(
               message: "Please enter all the fields data.",
             );
              });
        }
      }
      else {
        showDialog(context: context,
            builder: (c){
              return ErrorDialog(
                message: "Password do not match.",
              );
            });
      }
    }
  }

  void authentication() async {
    User? currentUser;
    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
          builder: (c){
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if(currentUser!= null){
     // saveDataToFirestore
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
      });
    }
  }


  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set(
      {
       "sellerUID": currentUser.uid,
       "sellerEmail": currentUser.email,
      "sellerName" : nameController.text.trim(),
        "sellerAvatarUrl": sellerImageUrl,
        "phone": phoneController.text.trim(),
        "address" : completeAddress,
        "status" : "approved",
        "restaurant_status": "on",
        "earnings": 0.0,
        "lat" : position!.latitude,
        "lng": position!.longitude,
      }
    );

    // save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("phone", phoneController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Register Page",
            style: TextStyle(
              fontSize: 20,
              color: zomatocolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
                padding: EdgeInsets.all(10.0),
                child:Consumer<RegisterFormData>(
                  builder: (context, registerFormData, _) => TextButton(
                    onPressed: registerFormData.isButtonEnabled()
                        ? () {
                      // formValidation
                      formValidation();
                    } : null,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: registerFormData.isButtonEnabled() ? zomatocolor : Colors.grey,
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
        body:GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 10),
                      child: Icon(Icons.message_outlined,
                        color: zomatocolor,
                        size: 100,),),

                    const SizedBox(height: 15,),

                    Text("Enter your credentials",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),),

                    const SizedBox(height: 15,),

                    // const Text("We'll check if you have an account.",
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //   ),
                    // ),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          //_getImage();
                          _getImage();
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.2,
                          backgroundColor: Color(0xfff5e9ef),
                          backgroundImage: imageXFile== null? null : FileImage(File(imageXFile!.path)),
                          child: imageXFile == null ?
                          Icon(
                            Icons.add_photo_alternate,
                            size: MediaQuery.of(context).size.width *0.2,
                            color: zomatocolor,
                          ) : null,
                          ),
                        ),
                      ),

                    SizedBox(height: 10,),

                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //customTextField
                            CustomTextField(
                              data: Icons.person,
                              controller: nameController,
                              hintText: "Name",
                              isObsecre: false,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).name = value;
                              },
                            ),
                            CustomTextField(
                              data: Icons.email,
                              controller: emailController,
                              hintText: "Email",
                              isObsecre: false,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).email = value;
                              },
                            ),
                            CustomTextField(
                              data: Icons.lock,
                              controller: passwordController,
                              hintText: "Password",
                              isObsecre: true,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).password = value;
                              },
                            ),
                            CustomTextField(
                              data: Icons.lock,
                              controller: confirmPasswordController,
                              hintText: "Confirm Password",
                              isObsecre: true,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).confirmPassword = value;
                              },
                            ),
                            CustomTextField(
                              data: Icons.call,
                              controller: phoneController,
                              hintText: "Phone",
                              isObsecre: false,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).phone = value;
                              },
                            ),
                            CustomTextField(
                              data: Icons.my_location,
                              controller: locationController,
                              hintText: "Restaurant Address",
                              isObsecre: false,
                              // onChanged: (value){
                              //   Provider.of<RegisterFormData>(context, listen: false).location = value;
                              // },
                            ),

                            Container(
                              width: 400,
                                height: 40,
                              alignment: Alignment.center,
                              child: ElevatedButton.icon(
                                  onPressed: (){
                                    getCurrentLocation();
                                  },
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Get current location.",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                              style: ElevatedButton.styleFrom(backgroundColor: zomatocolor,
                              ),
                              ),
                            ),
                            SizedBox(height: 10,)
                          ],
                        )
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Already have an account?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                          },
                          child: Text("Login",
                            style: TextStyle(
                              color: zomatocolor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),)
            ],
          ),
        )
    );
  }
}
