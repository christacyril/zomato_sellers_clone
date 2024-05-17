
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:zomatosellers/splashScreen/splash_screen.dart';
import 'package:zomatosellers/uploadScreens/menus_upload_screen.dart';
import 'package:zomatosellers/widgets/my_drawer.dart';
import 'package:zomatosellers/widgets/progress_bar.dart';
import 'package:zomatosellers/widgets/text_widget_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/menus.dart';
import '../widgets/info_design.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
    Navigator.push(context, MaterialPageRoute(builder: (c)=> MenusUploadScreen()));

          },
              icon: Icon (Icons.add, color: Colors.white,))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              title: "My Menus"
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid")).collection("menus")
                  .orderBy("publishedDate", descending: true).snapshots(),
              builder: (context, snapshot){
                return !snapshot.hasData ?
                    SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    ):

                    SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index){
                         Menus model = Menus.fromJson(
                           snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                         );
                         return InfoDesignWidget(
                           model: model,
                           context: context,
                         );
                        },
                        itemCount: snapshot.data!.docs.length
                    );


              })
        ],
      ),
      // body: Center(child: ElevatedButton(
      //   onPressed: (){
      //     firebaseAuth.signOut().then((value){
      //       Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));
      //     });
      //   }, child: Text("Sign Out"),
      // )),
    );
  }
}
