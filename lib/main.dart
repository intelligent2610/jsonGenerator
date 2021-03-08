import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'json_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Json Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Json Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerClassName = TextEditingController();
  final TextEditingController controllerLogPath = TextEditingController();
  final JsonGen jsonGen = JsonGen();

  bool hasTryCatch = true;
  bool hasHasCopyWith = true;
  bool hasEquatable = true;
  bool hasConstructor = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: TextField(
                controller: controllerClassName,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Enter class name"),
              ),
            ),
            if (hasTryCatch)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: TextField(
                  controller: controllerLogPath,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Enter path Import LogUtils"),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                                value: hasTryCatch,
                                title: Text("Add Try Catch"),
                                onChanged: (v) {
                                  setState(() {
                                    hasTryCatch = v;
                                  });
                                }),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                                value: hasConstructor,
                                title: Text("Add Constructor"),
                                onChanged: (v) {
                                  setState(() {
                                    hasConstructor = v;
                                  });
                                }),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                                value: hasHasCopyWith,
                                title: Text("Add CopyWith"),
                                onChanged: (v) {
                                  setState(() {
                                    hasHasCopyWith = v;
                                  });
                                }),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                                value: hasEquatable,
                                title: Text("Add Equatable"),
                                onChanged: (v) {
                                  setState(() {
                                    hasEquatable = v;
                                  });
                                }),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    height: 300,
                    child: TextField(
                      controller: controller,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Enter json Data"),
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.blueAccent,
                    onPressed: () {
                      jsonGen.initJson(
                        controller.text,
                        useEquatable: hasEquatable,
                        hasConstructor: hasConstructor,
                        hasCopyWith: hasHasCopyWith,
                        hasTryCatch: hasTryCatch,
                        pathLog: controllerLogPath.text,
                      );
                      jsonGen.convertSubClass(
                          jsonGen.jsonMap,
                          controllerClassName.text.isEmpty
                              ? "FlutterClass"
                              : controllerClassName.text);
                    },
                    child: Text(
                      "CONVERT",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    )),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.lightGreen,
                    onPressed: () {
                      Clipboard.setData(
                          new ClipboardData(text: jsonGen.doGen()));
                    },
                    child: Text(
                      "COPY CLIPBOARD",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    )),
                MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.redAccent,
                    onPressed: () {},
                    child: Text(
                      "CLEAR",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Clipboard.setData(new ClipboardData(text: jsonGen.doGen()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    controller.dispose();
    controllerClassName.dispose();
    controllerLogPath.dispose();
    super.dispose();
  }

  void showToast(
    String mess, {
    Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    double fontSize = 16,
  }) {
    Fluttertoast.showToast(
      msg: mess,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
