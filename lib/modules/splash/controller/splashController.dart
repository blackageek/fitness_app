import 'package:flutter/material.dart';
import 'package:gofitnext/main.dart';
import 'package:gofitnext/modules/base/base.dart';
import 'package:gofitnext/modules/base/base2.dart';
import 'package:gofitnext/new/home.dart';

import '../../after_splash/after_splash.dart';


void time (BuildContext context){
  Future.delayed(const Duration(seconds: 8),(){
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => isFirstCall?AfterSplash() : objectif=="vide"? Home() : Home(),));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => isFirstCall?AfterSplash() : /*objectif=="vide"? Base2() :*/ Base(),));
  });
}