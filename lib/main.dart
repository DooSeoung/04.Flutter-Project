
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'view/cctt.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // --> null type is not subtype error

  // runApp(const MyApp());
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Main Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        // home: iconTest()
        home: CcTt()
    );
  }
}

