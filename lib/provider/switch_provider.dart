import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomatosellers/global/global.dart';


class SwitchProvider with ChangeNotifier{

  String _switchValue = "off"; // Default value is off
String get switchValue => _switchValue;

void toggleSwitch() async{
  _switchValue =(_switchValue =="on") ? "off" : "on";
  notifyListeners();


  //update the value in firestore

  try{
    await FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid")).update(
        {
          "restaurant_status": _switchValue,
        });

    //update shared preferences
    sharedPreferences!.setString(
        "restaurant_status",
        _switchValue);
  } catch (e){
    print("Error updating Firestore: $e");
  }
}

//Fetch the initial value from firestore

Future <void> fetchSwitchValue() async{
  try{
    var docSnapshot = await FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid")).get();
    _switchValue = docSnapshot["restaurant_status"] ?? "off";

    print("Initial switch value: "+ _switchValue);
    print("Switch value from shared prefs: "+ sharedPreferences!.getString("restaurant_status")!);

    //fetch from shared preferences
    _switchValue = sharedPreferences!.getString("restaurant_status") ?? _switchValue;
    notifyListeners();
  } catch (e) {
    print("Error fetching firestore data: $e");
  }
}
}
