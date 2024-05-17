import 'package:flutter/material.dart';
import 'package:zomatosellers/global/global.dart';

import '../global/global.dart';


circularProgress(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        zomatocolor,
      ),
    ),
  );
}

linearProgress(){
  return Container(
    alignment: Alignment.center,
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        zomatocolor,
      ),
    ),
  );
}