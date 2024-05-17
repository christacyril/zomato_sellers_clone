import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zomatosellers/global/global.dart';
import 'package:zomatosellers/provider/switch_provider.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
String? title;
TextWidgetHeader({this.title});


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    context.read<SwitchProvider>().fetchSwitchValue();

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: zomatocolor,
        ),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  title!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(right: 5),
                  child: Consumer<SwitchProvider>(
                    builder: (context, switchProvider, child){
                      return FlutterSwitch(
                        width: 60,
                        height: 30,
                        valueFontSize: 12,
                        toggleSize: 18,
                        borderRadius: 30,
                        padding: 4,
                        showOnOff: true,
                        toggleColor: zomatocolor!,
                        activeColor: Colors.white,
                        activeTextColor: zomatocolor!,
                        inactiveColor: Colors.white,
                        inactiveTextColor: zomatocolor!,
                        value: switchProvider.switchValue == "on",
                        onToggle: (value) {
                          switchProvider.toggleSwitch();
                          Fluttertoast.showToast(
                              msg: value? "Restaurant is ON" : "Restaurant is OFF");
                        }
                      );
                    }
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  void showToast(bool value){

  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
