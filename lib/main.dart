import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ref = FirebaseFirestore.instance.collection("City");

  TextEditingController namecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  // ignore: non_constant_identifier_names


  // ScrollController controller = ScrollController();

  Map<String, dynamic> addToCity;

  addData() {
    addToCity = {
      'name': namecontroller.text,
      'desc': desccontroller.text,

    }; //day2
    ref.add(addToCity).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("CityApp"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

        child: StreamBuilder(
            stream: ref.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    ListView.builder(
                      //controller: controller,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.data.docs[index]['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(snapshot.data.docs[index]['desc']),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    height: 300,
                                                    width: 400,
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                          child: TextFormField(
                                                            controller:
                                                            namecontroller,
                                                            decoration:
                                                            InputDecoration(
                                                                labelText:
                                                                'Name',
                                                                hintText:
                                                                'Enter Name'),
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              color:
                                                              Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                          child: TextFormField(
                                                            controller:
                                                            desccontroller,
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                'Description',
                                                                hintText:
                                                                'Enter Description'),
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              color:
                                                              Colors.black,
                                                            ),
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 250,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              snapshot
                                                  .data.docs[index].reference
                                                  .delete();
                                            },
                                            child: Icon(Icons.delete)),
                                      ],
                                    ),

                                    //day2
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    Container(
                      color: Colors.red,
                      height: 40,
                      width: 400,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: SingleChildScrollView(
                                child: Container(
                                  height: 300,
                                  width: 400,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: namecontroller,
                                          decoration: InputDecoration(
                                              labelText: 'Name',
                                              hintText: 'Enter Name'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: desccontroller,
                                          decoration: InputDecoration(
                                              labelText: 'Description',
                                              hintText: 'Enter Description'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        height: 40,
                                        width: 100,
                                        color: Colors.red,
                                        child: TextButton(
                                          onPressed: () {
                                            addData();
                                          },
                                          child: Text(
                                            'submit',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text("Add",
                            style:
                            TextStyle(fontSize: 15, color: Colors.black)),
                      ),
                    ), //day2
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}