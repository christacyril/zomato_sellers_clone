import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomatosellers/mainScreen/order_details_screen.dart';

import '../models/items.dart';

class OrderCard extends StatelessWidget {
  int? itemCount;
  List<DocumentSnapshot>? data;
  String? orderID;
  List<String>? separateQuantitiesList;

  OrderCard({
    super.key,
    this.itemCount,
    this.data,
    this.orderID,
    this.separateQuantitiesList,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetailsScreen(orderID: orderID)));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: itemCount! * 100,
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            Items model =
                Items.fromJson(data![index].data()! as Map<String, dynamic>);
            return placeOrderDesignWidget(
                model, context, separateQuantitiesList![index]);
          },
        ),
      ),
    );
  }
}

Widget placeOrderDesignWidget(
    Items model, BuildContext context, separateQuantitiesList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 100,
    color: Colors.grey[200],
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Image.network(model.thumbnailUrl!, height: 80, width: 140),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.title!,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "x " + separateQuantitiesList,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rs " + model.price.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ))
      ],
    ),
    ]
    )
  );
}
