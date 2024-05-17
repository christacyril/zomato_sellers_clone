import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zomatosellers/uploadScreens/items_upload_screen.dart';
import 'package:zomatosellers/widgets/items_design.dart';
import 'package:zomatosellers/widgets/progress_bar.dart';
import 'package:zomatosellers/widgets/text_widget_header.dart';

import '../global/global.dart';
import '../models/items.dart';
import '../models/menus.dart';
import '../uploadScreens/menus_upload_screen.dart';

class ItemsScreen extends StatefulWidget {
final Menus? model;
ItemsScreen({this.model});



  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: zomatocolor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Zomato Sellers",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(onPressed: () {
           //Items upload screen
            Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsUploadScreen(model: widget.model,)));
          },
              icon: Icon (Icons.add, color: Colors.white,))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true,
          delegate: TextWidgetHeader(
            title: "My "+widget.model!.menuTitle.toString() + "'s items"
          ),),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid")).collection("menus")
              .doc(widget.model!.menuID).collection("items").snapshots(),
              builder: (context, snapshot){
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                ) :
                    SliverStaggeredGrid.countBuilder(crossAxisCount: 2,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index){
                       Items itemsModel = Items.fromJson(
                         snapshot.data!.docs[index].data()! as Map<String, dynamic>
                       );
                       return ItemsDesignWidget(
                         model: itemsModel,
                         context: context,
                       );
                        },
                        itemCount: snapshot.data!.docs.length,
                    );
              })
        ],
      ),
    );
  }
}
