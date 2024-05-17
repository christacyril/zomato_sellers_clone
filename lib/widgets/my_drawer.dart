import 'package:flutter/material.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:zomatosellers/mainScreen/earnings_screen.dart';
import 'package:zomatosellers/mainScreen/history_screen.dart';
import 'package:zomatosellers/mainScreen/home_screen.dart';
import 'package:zomatosellers/mainScreen/new_orders_screen.dart';

import '../splashScreen/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            decoration: BoxDecoration(
              color: zomatocolor,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString("photoUrl")!),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => HomeScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "My Earnings",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> EarningsScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "New Orders",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrdersScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.access_time,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "History",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: zomatocolor,
                  ),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => SplashScreen()));
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
