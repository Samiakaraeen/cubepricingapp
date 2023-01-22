import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cubepricingapp/item.dart';
import 'package:cubepricingapp/itemList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cube Software Tech',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Item cust = new Item();
  TextEditingController user = new TextEditingController();
  TextEditingController password = new TextEditingController();
  Widget mailTextBox() {
    return Container(
        child: TextField(
            autofocus: true,
            controller: user,
            autocorrect: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text('Enter User Name'),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                borderSide: BorderSide(
                  width: 2,
                  style: BorderStyle.none,
                ),
              ),
            )));
  }

  Widget passwordTextBox() {
    return TextField(
        controller: password,
        obscureText: true,
        decoration: InputDecoration(
          label: Text('Enter Password'),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              width: 2,
              style: BorderStyle.none,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Please Login to Continue',
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: mailTextBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: passwordTextBox(),
            ),
            Container(
              width: 200,
              height: 70,
              child: ElevatedButton(
                onPressed: () async {
                  String v = await cust.login(user.text, password.text);
                  if (v == "1") {
                    user.text = '';
                    password.text = '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemList()),
                    );
                  } else {
                    AwesomeDialog(
                        dismissOnBackKeyPress: false,
                        dismissOnTouchOutside: false,
                        context: context,
                        dialogType: DialogType.error,
                        body: Container(
                            width: double.infinity,
                            height: 250,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text('Invalid Username or password',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )),
                        title: 'This is Ignored',
                        desc: 'This is also Ignored',
                        btnOkOnPress: () {
                          user.text = '';
                          password.text = '';
                          setState(() {});
                        }).show();
                  }
                },
                child: Text('Login'),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
