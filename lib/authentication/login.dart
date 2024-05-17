
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zomatosellers/authentication/register.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:zomatosellers/mainScreen/home_screen.dart';
import 'package:zomatosellers/provider/form_state.dart';
import 'package:zomatosellers/splashScreen/splash_screen.dart';
import 'package:zomatosellers/widgets/custom_text_field.dart';
import 'package:zomatosellers/widgets/error_dialog.dart';
import 'package:zomatosellers/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation(){
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      //login
      loginNow();
    }
    else{
      showDialog(context: context,
          builder: (c){
        return ErrorDialog(
          message: "Please write email and password",
        );
          });
    }
  }

  loginNow() async {
    showDialog(context: context,
        builder: (c){
      return LoadingDialog(
        message: "Checking credentials",
      );
        });

    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(email: emailController.text.trim(),
        password: passwordController.text.trim()
    ).then((auth){
      currentUser = auth.user!;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
          builder: (c){
            return LoadingDialog(
              message: error.message.toString(),
            );
          });
    });

    if(currentUser!= null){
      readDataAndSetLocally(currentUser!);
    }
  }

  Future readDataAndSetLocally (User currentUser) async {
    await FirebaseFirestore.instance.collection("sellers")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async{
           if(snapshot.exists){
             if(snapshot.data()!["status"]== "approved"){
               await sharedPreferences!.setString("uid", currentUser.uid);
               await sharedPreferences!.setString("email", snapshot.data()!["sellerEmail"]);
               await sharedPreferences!.setString("name", snapshot.data()!["sellerName"]);
               await sharedPreferences!.setString("photoUrl", snapshot.data()!["sellerAvatarUrl"]);

               // List<String> userCartList = snapshot.data()!["userCart"].cast<String>();
               //
               // await sharedPreferences!.setStringList("userCart", userCartList);

               Navigator.pop(context);
               Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
             }
             else{
               firebaseAuth.signOut();
               Navigator.pop(context);
               Fluttertoast.showToast(msg: "Admin has blocked your account.");
             }
           }
           else{
             firebaseAuth.signOut();
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));

             showDialog(context: context,
                 builder: (c){
                   return LoadingDialog(
                     message: "No record found",
                   );
                 });

           }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login Page",
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
              child: Consumer<LoginFormData>(
                  builder: (context, loginFormData, _) => TextButton(
                      onPressed: loginFormData.isButtonEnabled()
                          ? () {
                              //formValidation
                        formValidation();
                            }
                          : null,
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: loginFormData.isButtonEnabled() ? zomatocolor : Colors.grey,
                        ),
                      ))))
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

                Text("What's your credentials?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),),

               const SizedBox(height: 15,),

                const Text("We'll check if you have an account.",
                style: TextStyle(
                  fontSize: 15,
                ),
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //customTextField
                      CustomTextField(
                        data: Icons.email,
                        controller: emailController,
                        hintText: "Email",
                        isObsecre: false,
                        onChanged: (value){
                       Provider.of<LoginFormData>(context, listen: false).email = value;
                        },
                      ),
                    CustomTextField(
                        data: Icons.lock,
                        controller: passwordController,
                        hintText: "Password",
                        isObsecre: true,
                        onChanged: (value){
                          Provider.of<LoginFormData>(context, listen: false).password = value;
                        },
                      )
                    ],
                  )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Doesn't have an account?",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(width: 5,),
                     GestureDetector(
                       onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> RegisterScreen()));
                       },
                       child: Text("Register",
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
