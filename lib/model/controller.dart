import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetController extends GetxController{
  List<String>box = <String>[].obs;

  void addItem(String item){
    box.add(item);
    update();
  }

  void replaceItem(int i,String name){
    box[i] = name;
    update();
  }

  void resetItem(List<String>extra){
     box = extra;
     update();
  }
}