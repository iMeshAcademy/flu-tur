import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Scaffold demo home page!"),
          leading: IconButton(
            onPressed: () {
              debugPrint("Pressed menu!");
            },
            icon: Icon(Icons.menu),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.contacts),
              onPressed: () {
                debugPrint("Pressed contacts");
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                debugPrint("Pressed settings");
              },
            )
          ],
        ),
        body: Container(
          child: Center( child: Text("Home Page!") ),
        ),
        bottomNavigationBar: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                debugPrint("Pressed home page");
              },
            ),
            IconButton(
              icon: Icon(Icons.mail),
              onPressed: () {
                debugPrint("Pressed mail box");
              },
            ),
            IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
                debugPrint("Pressed shopping cart!");
            })
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
                debugPrint("Pressed Floating action button");
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
