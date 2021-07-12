import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'json_generator.dart';

import 'dart:html' as html;

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
  bool useNullSafety = true;
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
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
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CheckboxListTile(
                                      value: useNullSafety,
                                      title: Text("Use Null-Safety"),
                                      onChanged: (v) {
                                        setState(() {
                                          useNullSafety = v;
                                        });
                                      }),
                                ),
                                Expanded(flex: 1, child: SizedBox()),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
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
                            if (controller.text.isEmpty) {
                              showToast("Please input your json");
                              return;
                            }
                            try {
                              jsonGen.initJson(
                                controller.text,
                                useEquatable: hasEquatable,
                                hasConstructor: hasConstructor,
                                useNullSafety: useNullSafety,
                                hasCopyWith: hasHasCopyWith,
                                hasTryCatch: hasTryCatch,
                                pathLog: controllerLogPath.text,
                              );
                              jsonGen.convertSubClass(
                                  jsonGen.jsonMap,
                                  controllerClassName.text.isEmpty
                                      ? "FlutterClass"
                                      : controllerClassName.text);
                            } catch (e) {
                              showToast(e.toString());
                              return;
                            }

                            showToast("Convert Success");
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
                            showToast("COPY CLIPBOARD Success");
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
                          onPressed: () {
                            controller.clear();
                          },
                          child: Text(
                            "CLEAR",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                      padding: EdgeInsets.all(20),
                      color: Colors.blueAccent,
                      onPressed: () {
                        downloadLogUtil();
                      },
                      child: Text(
                        "Download LogUtil file",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Text('Make by Flutter'),
          TextButton(
            child: Text('Email contact: tranduy2610@gmail.com'),
            onPressed: () {
              launch("mailto:tranduy2610@gmail.com?subject=HelloFlutter");
            },
          ),
          TextButton(
            child: Text('Linked-in'),
            onPressed: () {
              launch("https://www.linkedin.com/in/duy-tran-4a0b9078/");
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    launch("https://github.com/intelligent2610/");
                  },
                  child: Text('GitHub')),
              TextButton(
                  onPressed: () {
                    launch("https://github.com/intelligent2610/jsonGenerator");
                  },
                  child: Text('jsonGenerator')),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    controllerClassName.dispose();
    controllerLogPath.dispose();
    super.dispose();
  }

  void downloadLogUtil() {
    final logUtilSource =
        "import 'package:flutter/foundation.dart'; class LogUtils { static void d( dynamic data, { String${useNullSafety?"?":""} stacktrace, bool fullStacktrace = false, }) { if (kReleaseMode) { return; } print(\'[\${DateTime.now().toUtc()}] \${data?.toString()}\'); if ((stacktrace?.isNotEmpty ?? false) && fullStacktrace) { final listLine = stacktrace?.split('\\n'); listLine${useNullSafety?"!":""} .forEach(print); } else if (stacktrace?.isNotEmpty ?? false) { final listLine = stacktrace?.split('\\n'); listLine${useNullSafety?"!":""} .isNotEmpty ? print(listLine[0]) : ''; } } }";
    final bytes = utf8.encode(logUtilSource);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'log_utils.dart';
    html.document.body.children.add(anchor);

// download
    anchor.click();

// cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  void showToast(
    String mess, {
    Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    double fontSize = 40,
  }) {
    Fluttertoast.showToast(
      msg: mess,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
