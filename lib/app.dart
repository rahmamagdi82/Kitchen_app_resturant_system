import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

int k=0;
 getData()async{
   CollectionReference dat=FirebaseFirestore.instance.collection("delivery");
   QuerySnapshot db = await dat.where('finished',isEqualTo: '0').get();
    db.docs.forEach((element) {
      setState(() {
        checkvalue.add([]);
        show.add([]);
        count.add(0);
        docid.add(element.id);
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
  }

  @override
  void initState(){
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
    print('cont $count');
    print('t/f $checkvalue');
    print('len sh=${show.length}');
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
            for(int i=0;i<show.length;i++)
              if(show[i].isNotEmpty)
              Row(
                children: [
                  Card(
                    child: Container(
                      width:280,
                      height: 300,
                      child: Column(
                        children: [
                          Container(
                            width:280,
                            height: 50,
                            color: Colors.black,
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.spaceAround,
                              children: [
                                Text("Order#${i+1} ",style: TextStyle(color: Colors.white,fontSize:22)),
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
                                  backgroundColor:MaterialStateProperty.all<Color>(count[i]==show[i].length ? Colors.teal : Colors.black26),
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
                  SizedBox(width: 80),
                  /* if(i<order.length -1)
                      Card(
                        child: Container(
                          width:280,
                          height: 300,
                          child: Column(
                            children: [
                              Container(
                                width:280,
                                height: 50,
                                color: Colors.black,
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Order#20 ",style: TextStyle(color: Colors.white,fontSize:22)),
                                    Text("Table11 ",style: TextStyle(color: Colors.white,fontSize:22)),
                                    Text("In-Hall",style: TextStyle(color: Colors.white,fontSize:22)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 190,
                                child:SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child:Column(
                                    children:[
                                      //for(int j = 0; j < order[i+1].length; j++)
                                      for(var k in order[i+1].values)
                                        CheckboxListTile(
                                          title: Text(k[1]+'x '+k[0]),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (checkvalue[i+1][k] == true) {
                                                checkvalue[i+1][k] = false;
                                                count[i+1]--;
                                              }
                                              else {
                                                checkvalue[i+1][k] = true;
                                                count[i+1]++;
                                              }
                                            });
                                            print(count);
                                          },
                                          value: checkvalue[i+1][k],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(padding:EdgeInsets.fromLTRB(0,0,0,8) ,
                                child:ElevatedButton(
                                  style:ButtonStyle(
                                      backgroundColor:MaterialStateProperty.all<Color>(count[i+1]==order[i+1].length ? Colors.teal : Colors.black26),
                                      fixedSize:MaterialStateProperty.all(Size(150,45)),
                                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius:BorderRadius.circular(18)
                                      ))
                                  ),
                                  onPressed: () {},
                                  child: Text('Done',style:TextStyle(fontSize: 30)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),*/
              ],
            )
          ],
        ),
      ),
    );
  }
}