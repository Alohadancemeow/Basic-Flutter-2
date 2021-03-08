import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_app_covid/result.dart';
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
  //ตัวแปรฟิลด์
  Result _resultFromWebAPI;

  //init จะถูกเรียกใช้ครั้งแรกและครั้งเดียว เมื่อเปิดแอป.
  //ฉะนั้นจึงให้มันเรียกใช้งาน getData() ก่อนจะเข้าหน้าแอป.
  @override
  void initState() {
    super.initState();
    log("initState called");
    getData();
  }

  Future<void> getData() async {
    log("getData called");

    //get url. : covid-19
    var url = "https://covid19.th-stat.com/api/open/today";
    var response = await http.get(url);
    log(response.body);

    setState(() {
      //ส่งไปจำแนก
      //แล้วเก็บลงที่ตัวแปร
      _resultFromWebAPI = resultFromJson(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    log("Build called");
    return Scaffold(
        appBar: AppBar(
          title: Text("Covid-19 : Today"),
        ),
        //ListView
        body: ListView(
          children: [
            ListTile(
              title: Text(
                "ผู้ติดเชื้อสะสม",
                style: TextStyle(fontSize: 20, color: Colors.brown),
              ),
              subtitle: Text("${_resultFromWebAPI?.confirmed ?? "0"}"),
              // ?? = ถ้าหากข้อมูลเป็น null ให้แทนด้วย 0
            ),
            ListTile(
              title: Text("หายแล้ว"),
              subtitle: Text("${_resultFromWebAPI?.recovered ?? "0"}"),
            ),
            ListTile(
              title: Text("รักษาอยู่"),
              subtitle: Text("${_resultFromWebAPI?.hospitalized ?? "0"}"),
            ),
            ListTile(
              title: Text("เสียชีวิต"),
              subtitle: Text("${_resultFromWebAPI?.deaths ?? "0"}"),
            )
          ],
        ));
  }
}
