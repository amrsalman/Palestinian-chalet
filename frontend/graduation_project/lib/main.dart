import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/pages/Admin.dart';
import 'package:graduation_project/pages/Favorites.dart';
import 'package:graduation_project/pages/home.dart';
import 'package:graduation_project/pages/signup.dart';
import 'package:graduation_project/utils/User_preferneces.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'pages/login.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  await _initHive();
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
   // Initialize awesome_notifications
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: "basic_channel_group",
        channelKey: 'Basic Channel',
        channelName: 'Basic Channel name',
        channelDescription: 'Your Channel Description',
        defaultColor: Colors.teal,
        ledColor: Colors.teal,
      ),
    ], channelGroups: [
      NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic Group",
      )
      ]);
      bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowedToSendNotification) {
       AwesomeNotifications().requestPermissionToSendNotifications();
      }
  runApp(const MainApp());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    var setEnabledSystemUIMode =
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const Home(),
        "/login": (context) => const Login(),
        "/signup": (context) => const Signup(),
        "/Admin": (context) => const Admin(),
        '/favorites': (context) => FavoritesScreen(favoriteChalets: [],),
      },
        
    
    );
  }
}