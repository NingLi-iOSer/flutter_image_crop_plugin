/*
 * @Author: your name
 * @Date: 2019-12-05 17:12:48
 * @LastEditTime: 2019-12-11 10:21:00
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_image_crop_plugin/example/lib/main.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_image_crop_plugin_example/target_page.dart';

void main() => runApp(
  MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  )
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  

  @override
  void initState() {
    super.initState();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Push'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return TargetPage();
                }
              )
            );
          },
        ),
      ),
    );
  }
}
