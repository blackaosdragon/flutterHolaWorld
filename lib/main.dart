library socket_io_client;
//import 'package:socket_io_client/src/socket.dart';
//import 'package:socket_io/socket_io.dart';
//import 'package:socket_io_common/src/engine/parser/parser.dart' as parser;
//import 'package:socket_io_client/socket_io_client.dart' as IO;
//import 'package:socket_io_common/src/engine/parseqs.dart';
//import 'package:socket_io_common/src/manager.dart';
//export 'package:socket_io_client/src/socket.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';
//import 'package:rxdart/subjects.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'webSocketDemo';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: title,
        channel: IOWebSocketChannel.connect('ws://192.168.0.21:3002'),
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.channel}) : super(key: key);

  final String title;
  final WebSocketChannel channel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController _controller = TextEditingController();
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("ic_launcher");
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(
      initSettings, onSelectNotification: selectNotification
    );
  }

  Future selectNotification(String payload){
     debugPrint('Mensaje contenido: $payload');
     showDialog(context: context,builder:(_)=> AlertDialog(
       title: new Text('Notification'),
       content: new Text('$payload')
     )) ;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(child: Text('Click me'), onPressed: showNotification),
            /*
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          */
          StreamBuilder(
            stream: widget.channel.stream,
            builder: (context,snapshot){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(snapshot.hasData ? '${snapshot.data}':''),
                );
              }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
  showNotification() async {
    var android = new AndroidNotificationDetails(
      "channelId", "channelName", "channelDescription",
      priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();

    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
      0/*id*/, 'Notificacion' /*title*/, 'Informacion'/*body*/, platform /*notificationDetails*/,payload: 'Carga de la notificacion'
    );
  }
}
