import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;





class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  List <int> count=[];
  List <List<bool>> checkvalue=[];
  List <List>show=[];
  List docid=[];
  List time=[];

  List <int> count2=[];
  List <List<bool>> checkvalue2=[];
  List <List>show2=[];
  List docid2=[];
  List time2=[];
  List tno=[];

  String formattedDate(timeStamp){
    var dateFormTimeStamp=DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds*1000);
    return DateFormat('h:mm a').format(dateFormTimeStamp);
  }

int k=0;
int k2=0;
 getData()async{
   CollectionReference dat=FirebaseFirestore.instance.collection("delivery");
   QuerySnapshot db = await dat.where('finished',isEqualTo: '0').get();
    db.docs.forEach((element) {
      setState(() {
        checkvalue.add([]);
        show.add([]);
        count.add(0);
        docid.add(element.id);
        time.add(formattedDate(element.get('date')));
        for(int j=0;j<(element.get('order')).length;j++){
          if((element.get('order'))['order${j}'][3]=='0'){
            checkvalue[k].add(false);
           }
            else{
              checkvalue[k].add(true);
              count[k]++;
            }
            show[k].add((element.get('order'))['order${j}']);
          }
      });
      k++;
    });
   CollectionReference hall=FirebaseFirestore.instance.collection("In-Hall");
   QuerySnapshot dh = await hall.where('finished',isEqualTo: false).get();
   dh.docs.forEach((element) {
     setState(() {
       checkvalue2.add([]);
       show2.add([]);
       count2.add(0);
       docid2.add(element.id);
       tno.add(element.get('table'));
       time2.add(formattedDate(element.get('date')));
       for(int j=0;j<(element.get('order')).length;j++){
         if((element.get('order'))['order${j}'][3]=='0'){
           checkvalue2[k2].add(false);
         }
         else{
           checkvalue2[k2].add(true);
           count2[k2]++;
         }
         show2[k2].add((element.get('order'))['order${j}']);
       }
     });
     k2++;
   });
 }


 var serverToken="AAAAq241yYI:APA91bHo6UFGnCz242a_UVQCSV1_-Lrl63mpGCuCSPehHMkwHqsbBapF4h7JShO89ilk3aWkLz0lKE1zE_MMVhDGC67n_bOQohU5YOZt5akspPcH_cV0dzjeDO2JQyttcHs2uWv08Y4p";
sendNotifi(String body)async{
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': 'The Kitchen'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done'
        },
        'to': await FirebaseMessaging.instance.getToken(),
      },
    ),
  );
}

  getMessage(){
  FirebaseMessaging.onMessage.listen((event){
print(event.notification?.body);
  });
}




  @override
  void initState(){
  getMessage();
    getData();
    Future.delayed(Duration(seconds: 20),(){
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>MyHomePage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('show=$show');
    print('docid=$docid');
    print('time: $time');
    print('cont $count');
    print('t/f $checkvalue');
    print('len sh=${show.length}');

    print('show2=$show2');
    print('docid2=$docid2');
    print('time2: $time2');
    print('cont2 $count2');
    print('t/f2 $checkvalue2');
    print('len sh2=${show2.length}');

    return Scaffold(
      appBar:AppBar(
        title: Text('The Kitchen',style: TextStyle(color: Colors.white,fontSize:30)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            Container(
              //padding: EdgeInsets.all(3),
                child: Text('Unprepared Orders :',style: TextStyle(color: Colors.black,fontSize:28)),
            ),
            //for(int i=0;i<show.length;i++)
              //if(show[i].isNotEmpty)
              Row(
                children: [
                  Expanded(child: Column(
                    children: [
                      for(int i=0;i<show.length;i++)
                      Card(
                        child: Container(
                          width:280,
                          height: 300,
                          child:
                          Column(
                            children: [
                              Container(
                                width:280,
                                height: 50,
                                color:(count[i]==0)? Colors.grey:((count[i]==show[i].length)?Colors.green:Colors.amber),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(time[i],style: TextStyle(color: Colors.white,fontSize:22)),
                                    Text("Delivery",style: TextStyle(color: Colors.white,fontSize:22)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 190,
                                child:SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Column(
                                    children:[
                                      for(int m=0;m<show[i].length;m++)
                                        CheckboxListTile(
                                          title: Text((show[i][m])[1]+'x '+(show[i][m])[0]),
                                          onChanged: (bool? value) async{
                                            setState(() {
                                              if (checkvalue[i][m] == true) {
                                                checkvalue[i][m] = false;
                                                count[i]--;
                                                (show[i][m])[3] = '0';
                                              }
                                              else {
                                                checkvalue[i][m] = true;
                                                count[i]++;
                                                (show[i][m])[3] = '1';
                                              }
                                            });
                                            CollectionReference data = FirebaseFirestore.instance.collection("delivery");
                                            await data.doc(docid[i]).update({"order.order${m}": show[i][m]});
                                          },
                                          value:checkvalue[i][m],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(padding:EdgeInsets.fromLTRB(0,0,0,8) ,
                                child:ElevatedButton(
                                  style:ButtonStyle(
                                      backgroundColor:MaterialStateProperty.all<Color>(count[i]==show[i].length ? Colors.green : Colors.grey),
                                      fixedSize:MaterialStateProperty.all(Size(150,45)),
                                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius:BorderRadius.circular(18)
                                      ))
                                  ),
                                  onPressed: ()  async{
                                    if(count[i]==show[i].length) {
                                      CollectionReference data = FirebaseFirestore.instance.collection("delivery");
                                      await data.doc(docid[i]).update({"finished": '1'});
                                    }
                                  },
                                  child: Text('Done',style:TextStyle(fontSize: 30)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                Expanded(child: Column(
                  children: [
                    for(int i=0;i<show2.length;i++)
                      Card(
                        child: Container(
                          width:280,
                          height: 300,
                          child: Column(
                            children: [
                              Container(
                                width:280,
                                height: 50,
                                color: (count2[i]==0)? Colors.grey:((count2[i]==show2[i].length)?Colors.green:Colors.amber),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(time2[i],style: TextStyle(color: Colors.white,fontSize:22)),
                                    Text("Table:${tno[i]}",style: TextStyle(color: Colors.white,fontSize:22)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 190,
                                child:SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Column(
                                    children:[
                                      for(int m=0;m<show2[i].length;m++)
                                        CheckboxListTile(
                                          title: Text((show2[i][m])[1]+'x '+(show2[i][m])[0]),
                                          onChanged: (bool? value) async{
                                            setState(() {
                                              if (checkvalue2[i][m] == true) {
                                                checkvalue2[i][m] = false;
                                                count2[i]--;
                                                (show2[i][m])[3] = '0';
                                              }
                                              else {
                                                checkvalue2[i][m] = true;
                                                count2[i]++;
                                                (show2[i][m])[3] = '1';
                                              }
                                            });
                                            CollectionReference data2 = FirebaseFirestore.instance.collection("In-Hall");
                                            await data2.doc(docid2[i]).update({"order.order${m}": show2[i][m]});
                                          },
                                          value:checkvalue2[i][m],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(padding:EdgeInsets.fromLTRB(0,0,0,8) ,
                                child:ElevatedButton(
                                  style:ButtonStyle(
                                      backgroundColor:MaterialStateProperty.all<Color>(count2[i]==show2[i].length ? Colors.green : Colors.grey),
                                      fixedSize:MaterialStateProperty.all(Size(150,45)),
                                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius:BorderRadius.circular(18)
                                      ))
                                  ),
                                  onPressed: ()  async{
                                    if(count2[i]==show2[i].length) {
                                      CollectionReference data2 = FirebaseFirestore.instance.collection("In-Hall");
                                      await data2.doc(docid2[i]).update({"finished": true});
                                      sendNotifi("Order on Talbe No. : ${tno[i]} is Done.");
                                    }
                                  },
                                  child: Text('Done',style:TextStyle(fontSize: 30)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
                ),
              ],
           )
          ],
        ),
      ),
    );
  }
}