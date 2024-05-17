import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:zomatosellers/splashScreen/splash_screen.dart';
import 'package:zomatosellers/widgets/simple_app_bar.dart';

import '../models/items.dart';

class ItemsDetailsScreen extends StatefulWidget {
  final Items? model;

  ItemsDetailsScreen({this.model});

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuID)
        .collection("items")
        .doc(itemID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection("items").doc(itemID).delete();
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => SplashScreen()));
      Fluttertoast.showToast(msg: "Item Deleted Successfully.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: sharedPreferences!.getString("name"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.model!.title.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      "Rs " + widget.model!.price.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                ),
                Text(
                  widget.model!.longDescription.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      deleteItem(widget.model!.itemID!);

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: zomatocolor,
                      ),
                      width: MediaQuery.of(context).size.width - 13,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Delete this item.",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
