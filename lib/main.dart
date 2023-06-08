import 'package:flutter/material.dart';
import 'package:flutter_nfc_test01/views/write_screen.dart';
import 'package:get/get.dart';
import 'views/HomeScreen.dart';
import 'views/read_screen.dart';
import 'model/controller.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    home:HomeScreen(),getPages: [
     GetPage(name:'/',page:()=> HomeScreen()),
     GetPage(name:'/read',page:()=>ReadScreen(),transition:Transition.downToUp),
     GetPage(name:'/write',page:()=>WriteScreen(),transition:Transition.downToUp)
  ],debugShowCheckedModeBanner: false,));
}


