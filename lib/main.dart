import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatosellers/mainScreen/home_screen.dart';
import 'package:zomatosellers/provider/form_state.dart';
import 'package:zomatosellers/provider/switch_provider.dart';
import 'package:zomatosellers/splashScreen/splash_screen.dart';

import 'firebase_options.dart';
import 'global/global.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c)=> LoginFormData()),
        ChangeNotifierProvider(create: (c)=> RegisterFormData()),
        ChangeNotifierProvider(create: (c)=> SwitchProvider()),
      ],
      child: MaterialApp(
        title: 'Zomato Sellers',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
