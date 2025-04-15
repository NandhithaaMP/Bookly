import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

callNext(var context,var className){
  Navigator.push(context, MaterialPageRoute(builder: (context) => className,));
}

callNextPushReplacement(var context,var className){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => className,));
}