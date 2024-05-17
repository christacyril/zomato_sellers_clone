import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:zomatosellers/mainScreen/itemsScreen.dart';

import '../models/menus.dart';

class InfoDesignWidget extends StatefulWidget {
Menus? model;
BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {

  deleteMenu(String menuID){
    FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid"))
        .collection("menus").doc(menuID).delete();

    Fluttertoast.showToast(msg: "Menu deleted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      //ItemsScreen
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: widget.model,)));
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                child: Image.network(widget.model!.thumbnailUrl!,
                height: 220,
                fit: BoxFit.cover ,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.model!.menuTitle!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),

                  IconButton(onPressed: (){
                    deleteMenu(widget.model!.menuID!);
                  },
                      icon: Icon(Icons.delete, color: Colors.grey,))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
