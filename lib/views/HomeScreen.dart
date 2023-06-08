import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nfc_manager/platform_tags.dart';
import '../model/controller.dart';

// class HomeScreen extends StatefulWidget{
//   HomeScreen(Key key):super(key:key);
//   @override 

//   _HomeScreen createState() => _HomeScreen();
// }

class HomeScreen extends HookConsumerWidget{
  @override 
  Widget build(BuildContext context,WidgetRef ref){
   var scdata = useState<String>("Please Scan・・・");
   var isScaning = useState(false);
   NfcF nfcf;
  String strs = "Reading・・・";
  final xcontroller = Get.put(GetController());

    Stream<String>getNfc()async*{
      print("スタート！！！");
      // await Future.delayed(Duration(seconds: 10));
      bool isAvailable = await NfcManager.instance.isAvailable();
      print(isAvailable);
      if(isAvailable){
      NfcManager.instance.startSession(onDiscovered:(NfcTag tag)async{
        print(tag);
        print(tag.data);
        print(tag.handle);
        print(tag.runtimeType);
        final ndef = Ndef.from(tag);
        print(ndef);
        if(ndef == null){  
          print("nullデータ") ;
          print(ndef);
          // NfcF nfcf = ndef as NfcF;
          // print(nfcf);
          await NfcManager.instance.stopSession(errorMessage: 'error');
          
        }else{
        print("値確認1");
        //  scdata.value = tag.data.toString();
         final msg = await  ndef.read();
         print("Readの中身");
         print(msg);
         print(msg.records);
         print(msg.records.first.payload);
         print(msg.records.first.type);
         final testValue = String.fromCharCodes(msg.records.first.payload).substring(1);
         final tagValue = String.fromCharCodes(msg.records.first.payload).substring(3);
        //  strs = tag.data.toString();
        // scdata.value = tagValue;
        scdata.value = testValue;
        xcontroller.addItem(testValue);

         print("値確認2");
         print(strs);
         print("testValue");
         print(testValue);
         print("tagValue");
         print(tagValue);

        //  NfcManager.instance.stopSession();
        await NfcManager.instance.stopSession();
        }
      },
    );
      print("テスト");
      print(strs);
      print(scdata.value);
      // yield strs;
      isScaning.value = true;
      
      yield scdata.value;
      }else{
        print("値無し");
        Get.defaultDialog(
          title:"Warning",
          middleText: "対象の物はNFCに対応しておりませんでした",
          textCancel: "OK",
        );
        return;
      }
    }
    // useEffect((){
    //   getNfc();
    // },[]);
    return Scaffold(
      // appBar: AppBar(title: Text('Home'),centerTitle: true,),
      body:PageView(
        children:[
          Opacity(
          opacity:0.6,
          child:Container(
            decoration:BoxDecoration(
              image:DecorationImage(
                image: NetworkImage("https://www.hitachi-solutions.co.jp/digitalmarketing/sp/shared/images/column/column_detail18.jpg"),
                fit: BoxFit.cover
                )
            ),
            child:Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                SizedBox(height: 48,),
                Text("PayNet",style: TextStyle(fontSize: 40,color:Colors.green,fontWeight: FontWeight.bold),),
                SizedBox(height: 580,),
                // Card(
                //   shadowColor: Colors.grey,
                //   elevation: 10,
                //   child: Text("スマホでタグを読み込んで今すぐ電子決済をしてみよう",style:TextStyle(fontSize: 28,color:Colors.black)),
                // ),
                Text("スマホでタグを読み込んで今すぐ電子決済をしてみよう",style:TextStyle(fontSize: 28,color:Colors.redAccent[400],backgroundColor: Colors.grey)),
                Text("Next→",style:TextStyle(color:Colors.purple,fontSize: 20,fontWeight: FontWeight.bold))
              ]
            )
          ),
          ),
          Opacity(
            opacity: 0.8,
            child:Container(
              decoration:BoxDecoration(
                image:DecorationImage(
                  image:NetworkImage("https://www.saisoncard.co.jp/credictionary/bussinesscard/d5d1ml0000001fxx-img/eyecatch.jpg"),
                  fit:BoxFit.cover
                ),
              ),
              child:Container(
                
                
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   Text("ボタンを押して目の前のタグをスキャンする",style:TextStyle(fontSize: 20,color:Colors.white,backgroundColor: Colors.grey)),
                   SizedBox(height: 10,),
                   Text("Next→",style:TextStyle(color:Colors.purple,fontSize: 20,fontWeight: FontWeight.bold)),
                   SizedBox(height: 80,)
                ],)
                ),
            ),
          ),
       Opacity(
        opacity: 0.8,
        child:Container(
          // color:Colors.purpleAccent,
          child:Column(
             children: [
             SizedBox(height: 150,),
             Text("Scan Data",style:TextStyle(fontSize:28)),
             SizedBox(height:10),
             Container(
              width:180,
              height:180,
              child:Image.network("https://www.sozailab.jp/db_img/sozai/75911/0db97903e166deb27d7c5a04662e0de1.jpg"),
              ),
              SizedBox(height: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                SizedBox(
                  width:180,
                  child:ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,),onPressed:()async{
                    // Get.toNamed('/read');
                     

                    Get.bottomSheet(Container(
                      height: 500,
                      color:Colors.white,
                      child:Column(children: [
                        SizedBox(height: 20,),
                        Container(
                          width:220,
                          height: 220,
                          child:Image.network("https://www.creativefabrica.com/wp-content/uploads/2022/10/14/Contactless-wireless-pay-sign-logo-NFC-Graphics-41571429-1-580x387.jpg")
                        ),
                        SizedBox(height: 5,),
                        StreamBuilder(
                          initialData: scdata.value,
                          stream:getNfc(),
                          builder: (context,snapshot){
                               
                               switch(snapshot.connectionState){
                                  case ConnectionState.waiting:
                                  return Center(
                                    child:Text("Reading・・・",style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.green)),
                                  );
                                  case ConnectionState.none:
                                  return Center(
                                    child:Text("Reading・・・",style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.green)),
                                  );
                                  case ConnectionState.active:
                                  return Center(child: Text(
                                    // snapshot.data.toString(),
                                    snapshot.data.toString(),
                                    style:TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.bold),
                                  ),);
                                  case ConnectionState.done:
                                  return Center(child: Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold) ,
                                  ),);
                               }
                          }
                          ),
                        //  Center(child: Text(
                        //             scdata.value,
                        //             style:isScaning.value ? TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold):TextStyle(fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold)   ,
                        //           ),),
                      ],)
                    ),
                     
                    );
                  
                    // await getNfc();
                  }, child: Text("Read")),
                ),
                SizedBox(
                  width:180,
                  child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),onPressed:(){
                    Get.toNamed("/write");
                  }, child: Text("Write")),
                ),
                SizedBox(
                  width:180,
                  child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),onPressed:(){
                    
                  }, child: Text("PayMoney")),

                )


              ],)
          ],),
        ),
       ),
        ]
      )
    );
  }
}