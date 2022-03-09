import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List <List<List<String>>> order=[[['x2','pancack'],['x2','tea'],['x2','pancack'],['x2','tea'],['x2','pancack'],['x2','tea']],[['x1','english breakfast']]];
  List <int> count=[];
  List <List<bool>> checkvalue=[];

  List list = [];
  CollectionReference bff = FirebaseFirestore.instance.collection("menu");

  getData() async {
    QuerySnapshot dbf = await bff.where('type',isEqualTo:"Breakfast").get();
    dbf.docs.forEach((element) {
      setState(() {
        list.add(element.data());
      });
    });
    print(list);
  }

  void data(){
    setState((){
      for(int i=0;i<order.length;i++){
        count.add(0);
        checkvalue.add([]);
        for(int j=0;j<order[i].length;j++){
          checkvalue[i].add(false);
        }
      }
      print(count);
      print(checkvalue);
    });
  }
  Future<void> _refresh()async {
    order.add([['x3','waffel']]);
    data();
    return Future.delayed(Duration(seconds: 2));
  }
  void initState(){
    data();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('The Kitchen',style: TextStyle(color: Colors.white,fontSize:30)),
        backgroundColor: Colors.black,
      ),
      body:RefreshIndicator(
        color:Colors.teal,
        strokeWidth: 3,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child:Column(
            children: [
              Container(
                //padding: EdgeInsets.all(3),
                child: Text('Unprepared Orders :',style: TextStyle(color: Colors.black,fontSize:28)),
              ),
              for(int i=0;i<order.length;i=i+2)
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
                                child: Column(
                                  children:[
                                    for(int j = 0; j < order[i].length; j++)
                                      CheckboxListTile(
                                        title: Text('${order[i][j][0]+' '+order[i][j][1]}'),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (checkvalue[i][j] == true) {
                                              checkvalue[i][j] = false;
                                              count[i]--;
                                            }
                                            else {
                                              checkvalue[i][j] = true;
                                              count[i]++;
                                            }
                                          });
                                          print(count);
                                        },
                                        value: checkvalue[i][j],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(padding:EdgeInsets.fromLTRB(0,0,0,8) ,
                              child:ElevatedButton(
                                style:ButtonStyle(
                                    backgroundColor:MaterialStateProperty.all<Color>(count[i]==order[i].length ? Colors.teal : Colors.black26),
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
                    ),
                    SizedBox(width: 80),
                    if(i<order.length -1)
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
                                      for(int j = 0; j < order[i+1].length; j++)
                                        CheckboxListTile(
                                          title: Text('${order[i+1][j][0]+' '+order[i+1][j][1]}'),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (checkvalue[i+1][j] == true) {
                                                checkvalue[i+1][j] = false;
                                                count[i+1]--;
                                              }
                                              else {
                                                checkvalue[i+1][j] = true;
                                                count[i+1]++;
                                              }
                                            });
                                            print(count);
                                          },
                                          value: checkvalue[i+1][j],
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
                      ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
