import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

import 'models/alarm_hive_storage.dart';
import 'providers/alarm_provider.dart';
import 'providers/clock_type_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/modify_alarm_screen.dart';
import 'theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _setUpLocalNotification();
    _requestPermissions();
    super.initState();
  }

  void _requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _setUpLocalNotification() async {
    await _configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');


    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(title ?? ''),
              content: Text(body ?? ''),
            ),
          );
        });

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
        });
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    setLocalLocation(getLocation(timeZoneName!));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeModel()),
          ChangeNotifierProvider(create: (context) => ClockTypeModel()),
          ChangeNotifierProvider(
            create: (context) => AlarmModel(
              const AlarmsHiveLocalStorage(),
            ),
          ),
        ],
        child: Consumer<ThemeModel>(
          builder: (context, theme, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Analog Clock',
            theme: themeData(context),
            darkTheme: darkThemeData(context),
            themeMode: theme.isLightTheme ? ThemeMode.light : ThemeMode.dark,
            builder: (context, child) {
              return child ?? Container();
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  );
                case ModifyAlarmScreen.routeName:
                  return MaterialPageRoute(
                    builder: (context) => ModifyAlarmScreen(
                      arg: settings.arguments as ModifyAlarmScreenArg?,
                    ),
                  );
              }
              return null;
            },
          ),
        ));
  }
}
