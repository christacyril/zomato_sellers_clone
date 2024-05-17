import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? menuID;
  String? sellerID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDateInfo;
  String? longDescription;
  String? thumbnailUrl;
  String? status;
  int? price;


  Items({
    this.menuID,
    this.sellerID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDateInfo,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.price,
});


  Items.fromJson(Map<String, dynamic> json){
    menuID = json["menuID"];
    sellerID = json["sellerID"];
    itemID = json["itemID"];
    title = json["title"];
    shortInfo = json["shortInfo"];
    publishedDateInfo = json["publishedDateInfo"];
    thumbnailUrl = json["thumbnailUrl"];
    longDescription = json["longDescription"];
    status = json["status"];
    price = json["price"];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = Map<String,dynamic> ();
    data["menuID"]= menuID;
    data["sellerID"]= sellerID;
    data["itemID"]= itemID;
    data["title"]= title;
    data["shortInfo"]= shortInfo;
    data["publishedDateInfo"]= publishedDateInfo;
    data["thumbnailUrl"]= thumbnailUrl;
    data["longDescription"]= longDescription;
    data["status"]= status;
    data["price"]= price;
    return data;

  }
}