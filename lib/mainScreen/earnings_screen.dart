import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:zomatosellers/splashScreen/splash_screen.dart';
import 'package:zomatosellers/widgets/simple_app_bar.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  double sellerTotalEarnings = 0;

  retrieveSellerEarnings() async {
    await FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid")).get().then((snap) {
      setState(() {
        sellerTotalEarnings = double.parse(snap.data()!["earnings"].toString());
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveSellerEarnings();
  }


    @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: SimpleAppBar(
        title: "Earnings Screen",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Rs " + sellerTotalEarnings.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: zomatocolor),
            ),
            Text(
              "Total Earnings ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: zomatocolor),
            ),

            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));
            },
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: zomatocolor
            ),)
          ],
        ),
      ),
    );
  }
}
