import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomatosellers/assistantMethods/assistant_methods.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:zomatosellers/widgets/order_card.dart';
import 'package:zomatosellers/widgets/progress_bar.dart';
import 'package:zomatosellers/widgets/simple_app_bar.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({super.key});

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "New Orders",
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders")
        .where("status", isEqualTo: "normal")
        .where("sellerID", isEqualTo: sharedPreferences!.getString("uid"))
        .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("itemID",
                                whereIn: separateOrderItemsIDs(
                                    (snapshot.data!.docs[index].data()!
                                        as Map<String, dynamic>)["productIDs"]))
                            .where("sellerID",
                                whereIn: (snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>)["uid"])
                            .orderBy("publishedDate", descending: true)
                            .get(),
                        builder: (context, snap) {
                          return snap.hasData
                              ? Column(
                                  children: [
                                    OrderCard(
                                      itemCount: snap.data!.docs.length,
                                      data: snap.data!.docs,
                                      orderID: snapshot.data!.docs[index].id,
                                      separateQuantitiesList:
                                          separateOrderItemQuantities((snapshot
                                                      .data!.docs[index]
                                                      .data()!
                                                  as Map<String, dynamic>)[
                                              "productIDs"]),
                                    ),
                                    Container(
                                      height: 40,
                                      margin: EdgeInsets.symmetric(),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: zomatocolor),
                                      child: Center(
                                        child: Text(
                                          "Click to see details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Center(
                                  child: circularProgress(),
                                );
                        });
                  },
                )
              : Center(child: circularProgress());
        },
      ),
    );
  }
}
