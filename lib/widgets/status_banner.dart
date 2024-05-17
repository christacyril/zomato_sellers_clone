import 'package:flutter/material.dart';
import 'package:zomatosellers/global/global.dart';

class StatusBanner extends StatelessWidget {
bool? status;
String? orderStatus;

StatusBanner({
  this.status,
  this.orderStatus
});


  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successfully" : message = "Unsuccessful";

    return Container(
      decoration: BoxDecoration(
        color: zomatocolor
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            orderStatus == "ended" ? "Parcel Delivered $message" : "Order Placed $message",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(width: 10,),

          CircleAvatar(
            radius: 10,
              backgroundColor: Colors.white,
            child: Center(
              child: Icon(
                iconData,
                color: zomatocolor,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
