import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_app_covid/result.dart';
import 'package:flutter_app_covid/stat_box.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo 2',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //init จะถูกเรียกใช้ครั้งแรกและครั้งเดียว เมื่อเปิดแอป.
  //ฉะนั้นจึงให้มันเรียกใช้งาน getData() ก่อนจะเข้าหน้าแอป.
  @override
  void initState() {
    super.initState();
    log("initState called");

    //call getData
    getData();
  }

  Future<Result> getData() async {
    log("getData called");

    //get url. : covid-19
    var url = "https://covid19.th-stat.com/api/open/today";
    var response = await http.get(url);
    log(response.body);

    // setState(() {
    //   //ส่งไปจำแนก
    //   //แล้วเก็บลงที่ตัวแปร
    //   _resultFromWebAPI = resultFromJson(response.body);
    // });

    var result = resultFromJson(response.body);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    log("Build called");

    return Scaffold(
      appBar: AppBar(
        title: Text("Covid-19 : Today"),
      ),
      //รอรับข้อมูล Future
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
          //check connectionState
          if (snapshot.connectionState == ConnectionState.done) {
            log("Done");
            //get Data from snapshot
            var resultData = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //use statBox
                  StatBox(
                    title: "ผู้ติดเชื้อสะสม",
                    total: resultData?.confirmed,
                    backgroundColor: Colors.red,
                  ),
                  //กำหนดระยะห่างระหว่างกล่อง
                  SizedBox(
                    height: 10,
                  ),
                  StatBox(
                    title: "หายแล้ว",
                    total: resultData?.recovered,
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatBox(
                    title: "รักษาอยู่",
                    total: resultData?.hospitalized,
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatBox(
                    title: "เสียชีวิต",
                    total: resultData?.deaths,
                    backgroundColor: Colors.grey,
                  ),
                ],
              ),
            );
          } else {
            log("Waitting..");
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
