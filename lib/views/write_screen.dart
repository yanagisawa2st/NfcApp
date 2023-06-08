import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/controller.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';




class WriteScreen extends HookConsumerWidget{
  @override 
  Widget build(BuildContext context,WidgetRef ref){
    final scroll = ScrollController();
    List<String>li = <String>[];
    var editValue = useState<String>("Please Scan・・・");

    TextEditingController textController = TextEditingController();
    final xcontroller = Get.find<GetController>();
    print("値の確認");
   
    xcontroller.resetItem(xcontroller.box.toSet().toList());
     print(xcontroller.box);
    // var newbox = xcontroller.box.toSet().toList();
    // if(newbox.length > 0){
    //   newbox.forEach((box){
    //        li.add(box);
    //   });
    // }
    
    // print(newbox);

    Stream<String> WriteData(String editData,int index)async*{
      NfcManager.instance.startSession(onDiscovered:(NfcTag tag)async{
            var ndef =  Ndef.from(tag);
            if(ndef == null){
              print("nullデータ");
              print(ndef);
              NfcManager.instance.stopSession(errorMessage:'error');
              return;
            }else{
              //  xcontroller.replaceItem(index,editData);

              NdefMessage message = NdefMessage([
                 
                  NdefRecord.createUri(Uri.parse('https://www.${editData}')),
                  NdefRecord.createMime('text/plain',Uint8List.fromList(editData.codeUnits)),
                  // NdefRecord.createExternal('android.com', 'pkg', Uint8List.fromList(editData.codeUnits)),
              ]);
               try{
                 print("You finished sending message!!");
                 await ndef.write(message);
                 xcontroller.replaceItem(index,editData);
                 print("Completed!!");
                 NfcManager.instance.stopSession();
                 
               }catch(err){
                print(err);
                NfcManager.instance.stopSession();
                return;
               }
            }
      });
    
    }

    void showSheet(String editData,int index)async{
     Get.bottomSheet(Container(
        height:500,
        color:Colors.white,
        child:Column(
          children:[
            Container(
              width:220,
              height:220,
              decoration: BoxDecoration(
                image:DecorationImage(
                  image:NetworkImage("https://www.creativefabrica.com/wp-content/uploads/2022/10/14/Contactless-wireless-pay-sign-logo-NFC-Graphics-41571429-1-580x387.jpg")
                ),
              ), 
            ),
            SizedBox(height:5),
            StreamBuilder(
              initialData: editValue.value,
              stream:WriteData(editData, index),
              builder:(context,snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  return Text("Please Scan・・・",style:TextStyle(color:Colors.green,fontSize: 18,fontWeight: FontWeight.bold));
                  case ConnectionState.waiting:
                  return Text("Please Scan・・・",style:TextStyle(color:Colors.green,fontSize: 18,fontWeight: FontWeight.bold));
                  case ConnectionState.active:
                  return Text(snapshot.data.toString(),style:TextStyle(color:Colors.green,fontSize: 18,fontWeight: FontWeight.bold));
                  case ConnectionState.done:
                  return Text(snapshot.data.toString(),style:TextStyle(color:Colors.green,fontSize: 18,fontWeight: FontWeight.bold));
                }
              }
               )
          ]
        ),
      ));
    //  Future.delayed(Duration(seconds:5));
    //  WriteData(editData,index);
    }



    return Scaffold(
      appBar: AppBar(
        title: Text("Read Data"),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
          controller: scroll,
          child:GetBuilder<GetController>(
          init:GetController(),
          builder: (controller)=>Column(
            children:[
              SizedBox(height: 10,),
              for(int i=0;i<xcontroller.box.length;i++)
        
              // Container(
              //       margin:EdgeInsets.only(left:5) ,
              //       padding:EdgeInsets.only(bottom: 3),
              //       child:Align(
              //         alignment: Alignment.topLeft,
              //         child:Text("No."+ '${i+1}: ' + xcontroller.box[i],style:TextStyle(fontSize:18))
              //       )
              //      ),
              
              Card(
                shadowColor: Colors.grey,
                elevation:10,
                child:Padding(padding: EdgeInsets.only(left:3),
                child:Column( 
                  crossAxisAlignment: CrossAxisAlignment.start,       
                  children: [
                   Container(
                    child:Align(
                      alignment: Alignment.topLeft,
                      child:Text("NFCデータ："+controller.box[i],style:TextStyle(color:Colors.black))
                    )
                   ),
                  //  SizedBox(height: 3,),
                  //  Text("編集内容：　"),
                   TextField(
                    controller: textController,
                     decoration:InputDecoration(
                      labelText:"Edit",

                     )
                   ),
                   SizedBox(height: 3,),
                 
                  //  Container(
                  //   width: 40,
                  //   height: 20,
                  //   padding:EdgeInsets.all(0),
                  //  child:ElevatedButton(onPressed:(){}, child:Text("X",style:TextStyle(fontSize: 10),),style:ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent,shadowColor: Colors.black,elevation: 5,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(5)))),
                  //  ),
                  
                   Material(
                    color:Colors.purpleAccent,
              
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child:InkWell(
                      onTap: (){
                        print(textController.text); 
                        showSheet(textController.text,i);
                        
                      },
                      child: Container(
                        height: 20,
                        width:42,
                        child:Center(child: Text("Change",style:TextStyle(fontSize: 11,color:Colors.white)),)
                      ),
                    )
                   ),
                  
                ],),),
              )
            ]
          ),)
        ),
      // ),
    );
  }
}