import 'package:calculate_exchange_v2/pages/home_page/homepage_imports.dart';
import 'package:calculate_exchange_v2/pages/pages_to_import.dart';
import 'package:calculate_exchange_v2/pages/sheet_page/sheet_imports.dart';
import 'package:calculate_exchange_v2/services/push_notif.dart';
import 'package:calculate_exchange_v2/services/service_requirements.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// recive message when app on background
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
  print(message.notification!.body);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

const String routeHome = '/';
const String routeHomeEdit = '/edit';
const String routeSheet = '/sheet';
const String routeAddPayment = '/sheet/add';
const String routeEditPayment = '/sheet/edit';
const String routeChangeCurrency = '/sheet/change';
const String routeCalculateShare = '/sheet/calculate';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MaterialColor pageColor = MyColors.green;
  //Colors.amber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }

      LocalNotificationService.display(message);
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    // final routeFromMessage = message.data['route'];
    // Navigator.defaultGenerateInitialRoutes(Navigator.of(context), routeFromMessage);
    //  });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitsy',
      theme: ThemeData(
        primaryColor: pageColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: pageColor,
        ).copyWith(),
      ),
      // home: FutureBuilder(
      //   future: _fbApp,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError){
      //       print('there is a error: ${snapshot.error.toString()}');
      //       return Center(child: ImageIcon(AssetImage('assets/images/error.png'), size: 100,),);
      //     }
      //     else if (snapshot.hasData){
      //       print('we have data: ${snapshot.data.toString()}');
      //       return const HomePage();
      //     }
      //     else {
      //       return const Center(child: CircularProgressIndicator(),);
      //     }
      //   },
      //   ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case routeHome:
            return MaterialPageRoute<dynamic>(
              builder: (context) => const HomePage(),
              settings: settings,
            );
          case routeHomeEdit:
            return TransparentRoute(
                builder: (BuildContext context) => const EditMore(),
                settings: settings);
          case routeSheet:
            return ScaleRoute(
              settings,
              page: const SheetPage(),
            );
          case routeAddPayment:
            return SlideUpRoute(settings, page: const AddFunction());
          case routeEditPayment:
            return TransparentRoute(
                builder: (BuildContext context) => const Edit(),
                settings: settings);
          case routeChangeCurrency:
            return SlideUpRoute(settings, page: const ChangeCurrency());
          case routeCalculateShare:
            return SlideUpRoute(settings, page: const Calculate());
          default:
            return MaterialPageRoute<dynamic>(
              builder: (context) => const HomePage(),
              settings: settings,
            );
        }
      },
    );
  }
}
