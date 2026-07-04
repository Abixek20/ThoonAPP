import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'components/push_notification_overlay.dart';
import 'package:firebase_core/firebase_core.dart';

void main()                          async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ThoonApp());
}

class ThoonApp extends StatelessWidget {
  const ThoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THOON - Premium Builder Services',
      debugShowCheckedModeBanner: false,
      theme: ThoonTheme.themeData,
      builder: (context, child) => PushNotificationOverlay(child: child ?? const SizedBox()),
      home: const SplashScreen(),
    );
  }
}
