import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReadScreen extends HookConsumerWidget{
  @override 
  Widget build(BuildContext context,WidgetRef ref){
    bool isReading = true;

    void showSheet()async{
      Get.bottomSheet(
        Container(
          height: 500,
          color:Colors.white,
          child:Text("Scan...",style:TextStyle(color:Colors.amber[900])),
        )
      );


    }
     
     useEffect((){
       showSheet();
     },[]);

    return Scaffold(
      appBar:AppBar(
        title:Text("Scan"),
        centerTitle: true,
      ),
      body:Center(
        child:Column(children: [
          SizedBox(height: 10,),
          Container(
            width: 280,
            height: 280,
            child:Image.network('https://newsatcl-pctr.c.yimg.jp/t/amd-img/20230125-00010022-ffield-000-1-view.jpg?pri=l&w=640&h=426&exp=10800')
          ),
          SizedBox(height: 5,),
          isReading ? Text("Reading・・・",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.green)) : Text("コード："+"092ocxucfdvcu") ,

         

        ],)
      )
    );
  }
}