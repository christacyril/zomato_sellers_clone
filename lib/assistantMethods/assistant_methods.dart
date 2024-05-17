
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zomatosellers/global/global.dart';

separateOrderItemsIDs(orderIDs) {
  List<String> separateOrderItemIDsList = [],
      defaultItemList = [];
  int i = 0;

  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    String getItemID = (pos != -1) ? item.substring(0, pos) : item;

    separateOrderItemIDsList.add(getItemID);
  }

  return separateOrderItemIDsList;
}




separateOrderItemQuantities(orderIDs) {
  List<String> separateOrderQuantitiesList = [],
      defaultItemList = [];
  int i = 1;

  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    List<String> listItemCharacters = item.split(":").toList();

    var quantityNumber = int.parse(listItemCharacters[1].toString());
    separateOrderQuantitiesList.add(quantityNumber.toString());
  }

  return separateOrderQuantitiesList;
}

